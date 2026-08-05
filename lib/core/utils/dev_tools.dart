import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/onboarding/application/onboarding_controller.dart';

/// Development-only utilities.
///
/// All methods in this class are no-ops in release builds.
/// They are guarded by [kDebugMode] and will be tree-shaken in production.
class DevTools {
  DevTools._();

  /// Clears onboarding completion so the next launch shows onboarding again.
  /// Trigger: long-press on the EduSupport wordmark on the login screen.
  static Future<void> resetOnboarding(WidgetRef ref) async {
    if (!kDebugMode) return;
    await ref.read(onboardingControllerProvider.notifier).resetForDev();
    debugPrint('[DevTools] Onboarding state reset — next launch will show onboarding.');
  }
}
