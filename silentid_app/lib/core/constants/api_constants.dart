import '../config/app_environment.dart';

class ApiConstants {
  // Base URL from environment configuration
  static String get baseUrl => AppEnvironment.apiBaseUrl;

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
  static String get userAvatar => '$apiBaseUrl/users/me/avatar';

  // TrustScore endpoints
  static String get trustScoreMe => '$apiBaseUrl/trustscore/me';
  static String get trustScoreBreakdown => '$apiBaseUrl/trustscore/me/breakdown';

  // Referral endpoints (Section 50.6.1)
  static String get referralMe => '$apiBaseUrl/referrals/me';
  static String get referralList => '$apiBaseUrl/referrals/me/referrals';
  static String referralValidate(String code) => '$apiBaseUrl/referrals/validate/$code';
  static String get referralApply => '$apiBaseUrl/referrals/apply';

  // Profile Link endpoints (Section 52)
  static String get profileLinks => '$apiBaseUrl/evidence/profile-links';
  static String profileLinkById(String id) => '$apiBaseUrl/evidence/profile-links/$id';
  static String profileLinkVisibility(String id) => '$apiBaseUrl/evidence/profile-links/$id/visibility';
  static String profileLinkGenerateToken(String id) => '$apiBaseUrl/evidence/profile-links/$id/generate-token';
  static String profileLinkConfirmToken(String id) => '$apiBaseUrl/evidence/profile-links/$id/confirm-token';

  // Subscription endpoints
  static String get subscriptionMe => '$apiBaseUrl/subscriptions/me';
  static String get subscriptionUpgrade => '$apiBaseUrl/subscriptions/upgrade';
  static String get subscriptionCancel => '$apiBaseUrl/subscriptions/cancel';

  // Privacy settings endpoints
  static String get privacySettings => '$apiBaseUrl/users/me/privacy';

  // Devices endpoints
  static String get devices => '$apiBaseUrl/auth/devices';
  static String deviceRevoke(String deviceId) => '$apiBaseUrl/auth/devices/$deviceId/revoke';

  // Data export endpoints
  static String get dataExportRequest => '$apiBaseUrl/users/me/data-export';
  static String get dataExportStatus => '$apiBaseUrl/users/me/data-export/status';

  // Account deletion endpoints
  static String get accountDelete => '$apiBaseUrl/users/me';

  // Security Center endpoints (Section 15)
  static String get securityOverview => '$apiBaseUrl/security/overview';
  static String get securityLoginHistory => '$apiBaseUrl/security/login-history';
  static String get securityRiskScore => '$apiBaseUrl/security/risk-score';
  static String get securityAlerts => '$apiBaseUrl/security/alerts';
  static String get securityAlertsCount => '$apiBaseUrl/security/alerts/count';
  static String securityAlertMarkRead(String alertId) => '$apiBaseUrl/security/alerts/$alertId/mark-read';
  static String get securityAlertsMarkAllRead => '$apiBaseUrl/security/alerts/mark-all-read';
  static String get securityIdentityStatus => '$apiBaseUrl/security/identity-status';
  static String get securityVaultHealth => '$apiBaseUrl/security/vault-health';
  static String get securityBreachCheck => '$apiBaseUrl/security/breach-check';

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
