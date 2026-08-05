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

/// Pumps the app to a fully settled initial state.
/// [pump(1s)] advances past the async bootstrap Future; [pumpAndSettle]
/// then drains the routing transition animation to completion.
Future<void> _pumpApp(WidgetTester tester, ProviderScope scope) async {
  await tester.pumpWidget(scope);
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('new user sees onboarding', (tester) async {
    final fakeStore = FakeOnboardingStore(completed: false);
    final fakeAuthService = MockAuthService(FakeUserStore());

    await _pumpApp(
      tester,
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

    expect(find.text('Premium learning support.'), findsOneWidget);
  });

  testWidgets('next advances onboarding and skip persists completion', (
    tester,
  ) async {
    final fakeStore = FakeOnboardingStore(completed: false);
    final fakeAuthService = MockAuthService(FakeUserStore());

    await _pumpApp(
      tester,
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

    // Tap Next — starts 600ms PageController animation + 300ms AnimatedContainer.
    // pump() flushes the tap's synchronous effects, pumpAndSettle() runs all
    // animation frames until stable. This works now because the router no longer
    // rebuilds on currentPage changes (uses .select() for isLoading/isCompleted).
    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Focus on what matters.'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(fakeStore.completed, isTrue);
    expect(find.text('Your workspace awaits.'), findsOneWidget);
  });

  testWidgets('returning user skips onboarding', (tester) async {
    final fakeStore = FakeOnboardingStore(completed: true);
    final fakeAuthService = MockAuthService(FakeUserStore());

    await _pumpApp(
      tester,
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

    expect(find.text('Premium learning support.'), findsNothing);
    expect(find.text('Your workspace awaits.'), findsOneWidget);
  });
}
