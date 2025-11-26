class ApiConstants {
  // Base URL for local development
  static const String baseUrl = 'http://localhost:5249';

  // API version
  static const String apiVersion = 'v1';

  // Full API base URL
  static String get apiBaseUrl => '$baseUrl/$apiVersion';

  // Auth endpoints
  static String get requestOtp => '$apiBaseUrl/auth/request-otp';
  static String get verifyOtp => '$apiBaseUrl/auth/verify-otp';
  static String get refresh => '$apiBaseUrl/auth/refresh';
  static String get logout => '$apiBaseUrl/auth/logout';
  static String get appleSignIn => '$apiBaseUrl/auth/apple';
  static String get googleSignIn => '$apiBaseUrl/auth/google';

  // Identity endpoints
  static String get identitySession => '$apiBaseUrl/identity/stripe/session';
  static String get identityStatus => '$apiBaseUrl/identity/status';

  // User endpoints
  static String get userMe => '$apiBaseUrl/users/me';

  // TrustScore endpoints
  static String get trustScoreMe => '$apiBaseUrl/trustscore/me';
  static String get trustScoreBreakdown => '$apiBaseUrl/trustscore/me/breakdown';

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String usernameKey = 'username';

  // Request timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
