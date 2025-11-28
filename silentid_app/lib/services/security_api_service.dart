import '../core/constants/api_constants.dart';
import 'api_service.dart';

/// Security Center API Service (Section 15)
/// Handles login history, risk status, alerts, identity status, and vault health
class SecurityApiService {
  final ApiService _api = ApiService();

  /// Get complete security overview in a single call
  Future<SecurityOverview> getSecurityOverview() async {
    final response = await _api.get(ApiConstants.securityOverview);
    return SecurityOverview.fromJson(response.data);
  }

  /// Get login activity history
  Future<LoginHistoryResponse> getLoginHistory({int limit = 50}) async {
    final response = await _api.get(
      '${ApiConstants.securityLoginHistory}?limit=$limit',
    );
    return LoginHistoryResponse.fromJson(response.data);
  }

  /// Get user's risk status and active signals
  Future<RiskStatusResponse> getRiskStatus() async {
    final response = await _api.get(ApiConstants.securityRiskScore);
    return RiskStatusResponse.fromJson(response.data);
  }

  /// Get security alerts
  Future<SecurityAlertsResponse> getAlerts({bool includeRead = false}) async {
    final response = await _api.get(
      '${ApiConstants.securityAlerts}?includeRead=$includeRead',
    );
    return SecurityAlertsResponse.fromJson(response.data);
  }

  /// Get unread alert count for badge
  Future<int> getUnreadAlertCount() async {
    final response = await _api.get(ApiConstants.securityAlertsCount);
    return response.data['unreadCount'] ?? 0;
  }

  /// Mark a specific alert as read
  Future<void> markAlertAsRead(String alertId) async {
    await _api.post(ApiConstants.securityAlertMarkRead(alertId));
  }

  /// Mark all alerts as read
  Future<void> markAllAlertsAsRead() async {
    await _api.post(ApiConstants.securityAlertsMarkAllRead);
  }

  /// Get identity verification status
  Future<IdentityStatusResponse> getIdentityStatus() async {
    final response = await _api.get(ApiConstants.securityIdentityStatus);
    return IdentityStatusResponse.fromJson(response.data);
  }

  /// Get evidence vault health
  Future<VaultHealthResponse> getVaultHealth() async {
    final response = await _api.get(ApiConstants.securityVaultHealth);
    return VaultHealthResponse.fromJson(response.data);
  }

  /// Check email for data breaches (requires HaveIBeenPwned API)
  Future<BreachCheckResponse> checkEmailBreach({String? email}) async {
    final response = await _api.post(
      ApiConstants.securityBreachCheck,
      data: email != null ? {'email': email} : {},
    );
    return BreachCheckResponse.fromJson(response.data);
  }
}

// ============================================================================
// Response Models
// ============================================================================

/// Complete security overview
class SecurityOverview {
  final IdentityStatusResponse identityStatus;
  final RiskStatusResponse riskStatus;
  final int unreadAlertCount;
  final VaultHealthResponse vaultHealth;
  final List<LoginEntry> recentLogins;

  SecurityOverview({
    required this.identityStatus,
    required this.riskStatus,
    required this.unreadAlertCount,
    required this.vaultHealth,
    required this.recentLogins,
  });

  factory SecurityOverview.fromJson(Map<String, dynamic> json) {
    return SecurityOverview(
      identityStatus: IdentityStatusResponse.fromJson(json['identityStatus'] ?? {}),
      riskStatus: RiskStatusResponse.fromJson(json['riskStatus'] ?? {}),
      unreadAlertCount: json['unreadAlertCount'] ?? 0,
      vaultHealth: VaultHealthResponse.fromJson(json['vaultHealth'] ?? {}),
      recentLogins: (json['recentLogins'] as List<dynamic>?)
              ?.map((e) => LoginEntry.fromJson(e))
              .toList() ??
          [],
    );
  }
}

/// Login history response
class LoginHistoryResponse {
  final List<LoginEntry> logins;
  final int totalCount;

  LoginHistoryResponse({
    required this.logins,
    required this.totalCount,
  });

  factory LoginHistoryResponse.fromJson(Map<String, dynamic> json) {
    return LoginHistoryResponse(
      logins: (json['logins'] as List<dynamic>?)
              ?.map((e) => LoginEntry.fromJson(e))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
    );
  }
}

/// Individual login entry
class LoginEntry {
  final String id;
  final DateTime timestamp;
  final String? ipAddress;
  final String? deviceId;
  final String? deviceModel;
  final String? os;
  final String? browser;
  final bool isTrusted;
  final DateTime expiresAt;
  final bool isActive;

  LoginEntry({
    required this.id,
    required this.timestamp,
    this.ipAddress,
    this.deviceId,
    this.deviceModel,
    this.os,
    this.browser,
    required this.isTrusted,
    required this.expiresAt,
    required this.isActive,
  });

  factory LoginEntry.fromJson(Map<String, dynamic> json) {
    return LoginEntry(
      id: json['id'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      ipAddress: json['ipAddress'],
      deviceId: json['deviceId'],
      deviceModel: json['deviceModel'],
      os: json['os'],
      browser: json['browser'],
      isTrusted: json['isTrusted'] ?? false,
      expiresAt: DateTime.tryParse(json['expiresAt'] ?? '') ?? DateTime.now(),
      isActive: json['isActive'] ?? false,
    );
  }

  /// User-friendly device description
  String get deviceDescription {
    if (deviceModel != null && os != null) {
      return '$deviceModel ($os)';
    } else if (deviceModel != null) {
      return deviceModel!;
    } else if (os != null) {
      return os!;
    }
    return 'Unknown Device';
  }
}

/// Risk status response
class RiskStatusResponse {
  final int riskScore;
  final String riskLevel;
  final List<RiskSignal> activeSignals;
  final int signalCount;
  final DateTime lastUpdated;

  RiskStatusResponse({
    required this.riskScore,
    required this.riskLevel,
    required this.activeSignals,
    required this.signalCount,
    required this.lastUpdated,
  });

  factory RiskStatusResponse.fromJson(Map<String, dynamic> json) {
    return RiskStatusResponse(
      riskScore: json['riskScore'] ?? 0,
      riskLevel: json['riskLevel'] ?? 'None',
      activeSignals: (json['activeSignals'] as List<dynamic>?)
              ?.map((e) => RiskSignal.fromJson(e))
              .toList() ??
          [],
      signalCount: json['signalCount'] ?? 0,
      lastUpdated: DateTime.tryParse(json['lastUpdated'] ?? '') ?? DateTime.now(),
    );
  }

  /// Check if user has any risk
  bool get hasRisk => riskScore > 0;

  /// Get risk color based on level
  String get riskColorHex {
    switch (riskLevel.toLowerCase()) {
      case 'none':
        return '#1FBF71'; // Success green
      case 'low':
        return '#1FBF71';
      case 'moderate':
        return '#FFC043'; // Warning amber
      case 'high':
        return '#D04C4C'; // Danger red
      case 'critical':
        return '#D04C4C';
      default:
        return '#4C4C4C'; // Gray
    }
  }
}

/// Individual risk signal
class RiskSignal {
  final String id;
  final String type;
  final int severity;
  final String message;
  final DateTime createdAt;
  final bool isResolved;

  RiskSignal({
    required this.id,
    required this.type,
    required this.severity,
    required this.message,
    required this.createdAt,
    required this.isResolved,
  });

  factory RiskSignal.fromJson(Map<String, dynamic> json) {
    return RiskSignal(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      severity: json['severity'] ?? 5,
      message: json['message'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isResolved: json['isResolved'] ?? false,
    );
  }
}

/// Security alerts response
class SecurityAlertsResponse {
  final List<SecurityAlert> alerts;
  final int unreadCount;
  final int totalCount;

  SecurityAlertsResponse({
    required this.alerts,
    required this.unreadCount,
    required this.totalCount,
  });

  factory SecurityAlertsResponse.fromJson(Map<String, dynamic> json) {
    return SecurityAlertsResponse(
      alerts: (json['alerts'] as List<dynamic>?)
              ?.map((e) => SecurityAlert.fromJson(e))
              .toList() ??
          [],
      unreadCount: json['unreadCount'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
    );
  }
}

/// Individual security alert
class SecurityAlert {
  final String id;
  final String type;
  final String title;
  final String message;
  final int severity;
  final bool isRead;
  final DateTime createdAt;

  SecurityAlert({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.severity,
    required this.isRead,
    required this.createdAt,
  });

  factory SecurityAlert.fromJson(Map<String, dynamic> json) {
    return SecurityAlert(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      severity: json['severity'] ?? 5,
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Get alert icon based on type
  String get iconName {
    switch (type.toLowerCase()) {
      case 'breach':
        return 'warning';
      case 'suspiciouslogin':
        return 'person_alert';
      case 'deviceissue':
        return 'smartphone';
      case 'risksignal':
        return 'shield';
      case 'identityexpiring':
        return 'badge';
      case 'newdevice':
        return 'devices';
      case 'evidenceissue':
        return 'folder';
      default:
        return 'notifications';
    }
  }
}

/// Identity status response
class IdentityStatusResponse {
  final bool identityVerified;
  final DateTime? identityVerificationDate;
  final String? identityProvider;
  final bool emailVerified;
  final String email;
  final bool passkeyEnabled;
  final int passkeyCount;
  final DateTime accountCreatedAt;
  final DateTime? lastLoginAt;
  final int verificationScore;

  IdentityStatusResponse({
    required this.identityVerified,
    this.identityVerificationDate,
    this.identityProvider,
    required this.emailVerified,
    required this.email,
    required this.passkeyEnabled,
    required this.passkeyCount,
    required this.accountCreatedAt,
    this.lastLoginAt,
    required this.verificationScore,
  });

  factory IdentityStatusResponse.fromJson(Map<String, dynamic> json) {
    return IdentityStatusResponse(
      identityVerified: json['identityVerified'] ?? false,
      identityVerificationDate: json['identityVerificationDate'] != null
          ? DateTime.tryParse(json['identityVerificationDate'])
          : null,
      identityProvider: json['identityProvider'],
      emailVerified: json['emailVerified'] ?? false,
      email: json['email'] ?? '',
      passkeyEnabled: json['passkeyEnabled'] ?? false,
      passkeyCount: json['passkeyCount'] ?? 0,
      accountCreatedAt:
          DateTime.tryParse(json['accountCreatedAt'] ?? '') ?? DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'])
          : null,
      verificationScore: json['verificationScore'] ?? 0,
    );
  }

  /// Overall status text
  String get statusText {
    if (verificationScore >= 100) return 'Fully Verified';
    if (verificationScore >= 75) return 'Well Verified';
    if (verificationScore >= 50) return 'Partially Verified';
    return 'Needs Verification';
  }
}

/// Vault health response
class VaultHealthResponse {
  final bool isHealthy;
  final int receiptsCount;
  final int screenshotsCount;
  final int profileLinksCount;
  final int totalEvidenceCount;
  final DateTime lastCheckedAt;
  final List<String> issues;

  VaultHealthResponse({
    required this.isHealthy,
    required this.receiptsCount,
    required this.screenshotsCount,
    required this.profileLinksCount,
    required this.totalEvidenceCount,
    required this.lastCheckedAt,
    required this.issues,
  });

  factory VaultHealthResponse.fromJson(Map<String, dynamic> json) {
    return VaultHealthResponse(
      isHealthy: json['isHealthy'] ?? true,
      receiptsCount: json['receiptsCount'] ?? 0,
      screenshotsCount: json['screenshotsCount'] ?? 0,
      profileLinksCount: json['profileLinksCount'] ?? 0,
      totalEvidenceCount: json['totalEvidenceCount'] ?? 0,
      lastCheckedAt:
          DateTime.tryParse(json['lastCheckedAt'] ?? '') ?? DateTime.now(),
      issues: (json['issues'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  /// Check if vault has any evidence
  bool get hasEvidence => totalEvidenceCount > 0;
}

/// Breach check response
class BreachCheckResponse {
  final String email;
  final bool checked;
  final String? message;
  final List<BreachInfo> breaches;
  final int breachCount;
  final bool requiresExternalService;

  BreachCheckResponse({
    required this.email,
    required this.checked,
    this.message,
    required this.breaches,
    required this.breachCount,
    required this.requiresExternalService,
  });

  factory BreachCheckResponse.fromJson(Map<String, dynamic> json) {
    return BreachCheckResponse(
      email: json['email'] ?? '',
      checked: json['checked'] ?? false,
      message: json['message'],
      breaches: (json['breaches'] as List<dynamic>?)
              ?.map((e) => BreachInfo.fromJson(e))
              .toList() ??
          [],
      breachCount: json['breachCount'] ?? 0,
      requiresExternalService: json['requiresExternalService'] ?? false,
    );
  }

  /// Check if email has been breached
  bool get hasBreaches => breachCount > 0;
}

/// Individual breach info
class BreachInfo {
  final String name;
  final DateTime date;
  final List<String> compromisedData;
  final bool isVerified;

  BreachInfo({
    required this.name,
    required this.date,
    required this.compromisedData,
    required this.isVerified,
  });

  factory BreachInfo.fromJson(Map<String, dynamic> json) {
    return BreachInfo(
      name: json['name'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      compromisedData:
          (json['compromisedData'] as List<dynamic>?)?.cast<String>() ?? [],
      isVerified: json['isVerified'] ?? false,
    );
  }
}
