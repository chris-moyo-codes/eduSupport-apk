import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edusupport_mobile/app/app.dart';
import 'package:edusupport_mobile/features/auth/application/auth_controller.dart';
import 'package:edusupport_mobile/features/auth/data/mock_auth_service.dart';
import 'package:edusupport_mobile/features/onboarding/application/onboarding_controller.dart';
import 'package:edusupport_mobile/storage/onboarding_store.dart';

class FakeOnboardingStore implements OnboardingStore {
  FakeOnboardingStore({this.completed = false});

  bool completed;

  @override
  Future<bool> isOnboardingCompleted() async => completed;

  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    this.completed = completed;
  }
}

class FakeUserStore implements MockUserStore {
  @override
  Future<void> clearSession() async {}

  @override
  Future<EduUser?> loadSession() async => null;

  @override
  Future<void> saveSession(EduUser user) async {}
}

void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    bool onboardingComplete = true,
  }) async {
    final fakeStore = FakeOnboardingStore(completed: onboardingComplete);
    final fakeAuthService = MockAuthService(FakeUserStore());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingControllerProvider.overrideWith(
            (ref) => OnboardingController(fakeStore)..bootstrap(),
          ),
          authControllerProvider.overrideWith(
            (ref) => AuthController(fakeAuthService)..login('student@edusupport.demo', 'Student@123'),
          ),
        ],
        child: const EduSupportApp(),
      ),
    );

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  testWidgets('dashboard renders welcome and sections', (tester) async {
    await pumpApp(tester);

    expect(find.text('Overview'), findsOneWidget); // AppBar title
    expect(find.text('Good morning, Student.'), findsOneWidget);
    expect(find.text('Study Activity'), findsOneWidget);
    expect(find.text('Upcoming Session'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Offline Library'), findsOneWidget);
  });

  testWidgets('library renders search and filter chips', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Library').last); // Bottom nav
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Textbooks'), findsOneWidget); // A filter chip
    expect(find.text('Featured Resources'), findsOneWidget);
    expect(find.text('All Resources'), findsOneWidget);
  });

  testWidgets('study view renders up next hero', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Study').last); // Bottom nav
    await tester.pumpAndSettle();

    expect(find.text('Active Study'), findsOneWidget);
    expect(find.text('UP NEXT FOR YOU'), findsOneWidget);
    expect(find.text('Suggested Activities'), findsOneWidget);
  });

  testWidgets('tutors view renders with search and featured', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Tutors').last); // Bottom nav
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Top-Rated Tutors'), findsOneWidget);
  });

  testWidgets('profile renders identity and sections', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Profile').last); // Bottom nav
    await tester.pumpAndSettle();

    expect(find.text('Jonathan Doe'), findsOneWidget);
    expect(find.text('Learning Preferences'), findsOneWidget);
    expect(find.text('Offline & Storage'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
  });

  testWidgets('sessions view renders upcoming and past', (tester) async {
    await pumpApp(tester);

    // Sessions is a FAB on the dashboard now
    await tester.tap(find.byIcon(Icons.calendar_month_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Your Sessions'), findsOneWidget); // AppBar
    expect(find.text('Upcoming'), findsWidgets);
    expect(find.text('Past Sessions'), findsOneWidget);
  });
}
