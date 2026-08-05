import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edusupport_mobile/app/app.dart';
import 'package:edusupport_mobile/features/auth/application/auth_controller.dart';
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
  testWidgets('new user sees onboarding', (tester) async {
    final fakeStore = FakeOnboardingStore(completed: false);
    final fakeAuthService = MockAuthService(FakeUserStore());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingControllerProvider.overrideWith(
            (ref) => OnboardingController(fakeStore)..bootstrap(),
          ),
          authControllerProvider.overrideWith(
            (ref) => AuthController(fakeAuthService)..bootstrapSession(),
          ),
        ],
        child: const EduSupportApp(),
      ),
    );

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Learn with\nEduSupport'), findsOneWidget);
  });

  testWidgets('continue advances onboarding and skip persists completion', (
    tester,
  ) async {
    final fakeStore = FakeOnboardingStore(completed: false);
    final fakeAuthService = MockAuthService(FakeUserStore());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingControllerProvider.overrideWith(
            (ref) => OnboardingController(fakeStore)..bootstrap(),
          ),
          authControllerProvider.overrideWith(
            (ref) => AuthController(fakeAuthService)..bootstrapSession(),
          ),
        ],
        child: const EduSupportApp(),
      ),
    );

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Stay focused'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(fakeStore.completed, isTrue);
    expect(find.text('Your workspace awaits.'), findsOneWidget);
  });

  testWidgets('returning user skips onboarding', (tester) async {
    final fakeStore = FakeOnboardingStore(completed: true);
    final fakeAuthService = MockAuthService(FakeUserStore());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingControllerProvider.overrideWith(
            (ref) => OnboardingController(fakeStore)..bootstrap(),
          ),
          authControllerProvider.overrideWith(
            (ref) => AuthController(fakeAuthService)..bootstrapSession(),
          ),
        ],
        child: const EduSupportApp(),
      ),
    );

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Learn with\nEduSupport'), findsNothing);
    expect(find.text('Your workspace awaits.'), findsOneWidget);
  });
}
