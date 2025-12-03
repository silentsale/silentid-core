// App Environment Configuration
//
// This class manages environment-specific settings for the SilentID app.
// To switch environments:
// - Development: flutter run --dart-define=ENVIRONMENT=development
// - Staging: flutter run --dart-define=ENVIRONMENT=staging
// - Production: flutter run --dart-define=ENVIRONMENT=production
//
// Default is development if no environment is specified.

enum Environment {
  development,
  staging,
  production,
}

class AppEnvironment {
  static const String _envKey = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static Environment get current {
    switch (_envKey.toLowerCase()) {
      case 'production':
      case 'prod':
        return Environment.production;
      case 'staging':
      case 'stage':
        return Environment.staging;
      default:
        return Environment.development;
    }
  }

  static bool get isDevelopment => current == Environment.development;
  static bool get isStaging => current == Environment.staging;
  static bool get isProduction => current == Environment.production;

  /// API Base URLs for each environment
  static String get apiBaseUrl {
    switch (current) {
      case Environment.production:
        return 'https://api.silentid.co.uk';
      case Environment.staging:
        return 'https://staging-api.silentid.co.uk';
      case Environment.development:
        return 'http://localhost:5249';
    }
  }

  /// Web Base URLs for each environment
  static String get webBaseUrl {
    switch (current) {
      case Environment.production:
        return 'https://silentid.co.uk';
      case Environment.staging:
        return 'https://staging.silentid.co.uk';
      case Environment.development:
        return 'http://localhost:3000';
    }
  }

  /// Whether to enable debug logging
  static bool get enableDebugLogging {
    return current != Environment.production;
  }

  /// Whether to enable crash reporting
  static bool get enableCrashReporting {
    return current == Environment.production;
  }

  /// Whether to enable analytics
  static bool get enableAnalytics {
    return current == Environment.production;
  }

  /// Environment name for display
  static String get name {
    switch (current) {
      case Environment.production:
        return 'Production';
      case Environment.staging:
        return 'Staging';
      case Environment.development:
        return 'Development';
    }
  }

  /// Short environment indicator for debug display
  static String get shortName {
    switch (current) {
      case Environment.production:
        return 'PROD';
      case Environment.staging:
        return 'STG';
      case Environment.development:
        return 'DEV';
    }
  }
}
