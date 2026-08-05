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

void main() {
  testWidgets('App shell renders the EduSupport mobile foundation', (
    WidgetTester tester,
  ) async {
    final store = FakeOnboardingStore(completed: false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingControllerProvider.overrideWith(
            (ref) => OnboardingController(store)..bootstrap(),
          ),
          authControllerProvider.overrideWith(
            (ref) => AuthController()..bootstrapSession(),
          ),
        ],
        child: const EduSupportApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Learn with EduSupport'), findsOneWidget);
  });
}
