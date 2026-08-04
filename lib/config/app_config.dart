enum AppEnvironment { development, staging, production }

class AppConfig {
  AppConfig._();

  static const AppEnvironment environment = AppEnvironment.development;

  static String get apiBaseUrl {
    switch (environment) {
      case AppEnvironment.development:
        return 'https://api.edusupport.local';
      case AppEnvironment.staging:
        return 'https://staging-api.edusupport.local';
      case AppEnvironment.production:
        return 'https://api.edusupport.com';
    }
  }

  static bool get useSecureStorage => true;
}
