import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/constants/app_constants.dart';

abstract class OnboardingStore {
  Future<bool> isOnboardingCompleted();
  Future<void> setOnboardingCompleted(bool completed);
}

class SecureOnboardingStore implements OnboardingStore {
  SecureOnboardingStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<bool> isOnboardingCompleted() async {
    final value = await _storage.read(key: AppConstants.onboardingCompletedKey);
    return value == 'true';
  }

  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    await _storage.write(
      key: AppConstants.onboardingCompletedKey,
      value: completed ? 'true' : 'false',
    );
  }
}
