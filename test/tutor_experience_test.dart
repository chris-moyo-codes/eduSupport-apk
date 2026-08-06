import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edusupport_mobile/app/app.dart';
import 'package:edusupport_mobile/features/auth/application/auth_controller.dart';
import 'package:edusupport_mobile/features/auth/data/mock_auth_service.dart';
import 'package:edusupport_mobile/features/onboarding/application/onboarding_controller.dart';
import 'package:edusupport_mobile/storage/onboarding_store.dart';
import 'package:edusupport_mobile/features/tutor/presentation/screens/tutor_home_screen.dart';
import 'package:edusupport_mobile/features/tutor/presentation/screens/tutor_sessions_screen.dart';
import 'package:edusupport_mobile/features/tutor/presentation/screens/tutor_students_screen.dart';
import 'package:edusupport_mobile/features/tutor/presentation/screens/tutor_resources_screen.dart';
import 'package:edusupport_mobile/features/tutor/presentation/screens/tutor_profile_screen.dart';

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
            (ref) => AuthController(fakeAuthService)..login('tutor@edusupport.demo', 'Tutor@123'),
          ),
        ],
        child: const EduSupportApp(),
      ),
    );

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  testWidgets('Tutor experience navigation and screens', (WidgetTester tester) async {
    await pumpApp(tester);

    // Should be on TutorHomeScreen inside TutorShellScreen
    expect(find.byType(TutorHomeScreen), findsOneWidget);
    
    // Tap Students tab
    await tester.tap(find.text('Students').last);
    await tester.pumpAndSettle();
    expect(find.byType(TutorStudentsScreen), findsOneWidget);

    // Tap Sessions tab
    await tester.tap(find.text('Sessions').last);
    await tester.pumpAndSettle();
    expect(find.byType(TutorSessionsScreen), findsOneWidget);

    // Tap Resources tab
    // Resources was removed from bottom nav (accessed via home/profile).
    // Tap Profile tab
    // Profile was removed from bottom nav (accessed via AppBar avatar).
    // Navigation is now: Home, Tasks, Students, Sessions.
  });
}
