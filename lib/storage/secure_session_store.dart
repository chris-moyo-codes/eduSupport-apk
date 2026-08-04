import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/constants/app_constants.dart';
import '../core/errors/app_exception.dart';

class SecureSessionStore {
  SecureSessionStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: AppConstants.tokenStorageKey, value: token);
    } catch (_) {
      throw const StorageException(
        'Unable to persist the access token securely.',
      );
    }
  }

  Future<String?> readAccessToken() async {
    try {
      return _storage.read(key: AppConstants.tokenStorageKey);
    } catch (_) {
      throw const StorageException('Unable to read the access token securely.');
    }
  }

  Future<void> clearSession() async {
    try {
      await _storage.delete(key: AppConstants.tokenStorageKey);
      await _storage.delete(key: AppConstants.refreshTokenStorageKey);
    } catch (_) {
      throw const StorageException('Unable to clear the stored session.');
    }
  }
}
