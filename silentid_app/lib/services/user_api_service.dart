import '../core/constants/api_constants.dart';
import 'api_service.dart';
import 'trustscore_api_service.dart';
import 'evidence_api_service.dart';

/// User API Service
/// Handles user profile data from multiple endpoints
class UserApiService {
  final ApiService _api = ApiService();
  final TrustScoreApiService _trustScoreApi = TrustScoreApiService();
  final EvidenceApiService _evidenceApi = EvidenceApiService();

  /// Get full user profile with TrustScore and evidence counts
  Future<UserProfile> getUserProfile() async {
    // Fetch data from multiple endpoints in parallel
    final results = await Future.wait([
      _getUserData(),
      _trustScoreApi.getTrustScore(),
      _evidenceApi.getEvidenceSummary(),
    ]);

    final userData = results[0] as UserData;
    final trustScore = results[1] as TrustScoreSummary;
    final evidence = results[2] as EvidenceSummary;

    return UserProfile(
      id: userData.id,
      email: userData.email,
      username: userData.username,
      displayName: userData.displayName,
      phoneNumber: userData.phoneNumber,
      isEmailVerified: userData.isEmailVerified,
      isPhoneVerified: userData.isPhoneVerified,
      isPasskeyEnabled: userData.isPasskeyEnabled,
      accountStatus: userData.accountStatus,
      accountType: userData.accountType,
      createdAt: userData.createdAt,
      trustScore: trustScore.totalScore,
      trustLevel: trustScore.label,
      evidenceCount: evidence.totalCount,
      // These require additional endpoints not yet implemented
      riskScore: 0,
    );
  }

  Future<UserData> _getUserData() async {
    final response = await _api.get(ApiConstants.userMe);
    return UserData.fromJson(response.data);
  }

  /// Update user profile (displayName and/or username)
  Future<UserData> updateUserProfile({
    String? displayName,
    String? username,
  }) async {
    final response = await _api.patch(
      ApiConstants.userMe,
      data: {
        if (displayName != null) 'displayName': displayName,
        if (username != null) 'username': username,
      },
    );
    return UserData.fromJson(response.data);
  }
}

/// Basic user data from /users/me endpoint
class UserData {
  final String id;
  final String email;
  final String? username;
  final String? displayName;
  final String? phoneNumber;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isPasskeyEnabled;
  final String accountStatus;
  final String accountType;
  final DateTime createdAt;

  UserData({
    required this.id,
    required this.email,
    this.username,
    this.displayName,
    this.phoneNumber,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isPasskeyEnabled,
    required this.accountStatus,
    required this.accountType,
    required this.createdAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      username: json['username'],
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      isPasskeyEnabled: json['isPasskeyEnabled'] ?? false,
      accountStatus: json['accountStatus'] ?? 'Active',
      accountType: json['accountType'] ?? 'Free',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

/// Full user profile with TrustScore and evidence data
class UserProfile {
  final String id;
  final String email;
  final String? username;
  final String? displayName;
  final String? phoneNumber;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isPasskeyEnabled;
  final String accountStatus;
  final String accountType;
  final DateTime createdAt;
  final int trustScore;
  final String trustLevel;
  final int riskScore;
  final int evidenceCount;

  UserProfile({
    required this.id,
    required this.email,
    this.username,
    this.displayName,
    this.phoneNumber,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isPasskeyEnabled,
    required this.accountStatus,
    required this.accountType,
    required this.createdAt,
    required this.trustScore,
    required this.trustLevel,
    required this.riskScore,
    required this.evidenceCount,
  });

  /// Get display name or fallback to username or email
  String get displayNameOrFallback {
    if (displayName != null && displayName!.isNotEmpty) return displayName!;
    if (username != null && username!.isNotEmpty) return username!;
    return email.split('@').first;
  }

  /// Get formatted username with @ prefix
  String get formattedUsername {
    if (username == null || username!.isEmpty) return '@user';
    return username!.startsWith('@') ? username! : '@$username';
  }

  /// Check if identity is verified (has passkey or phone verified)
  bool get isIdentityVerified => isPasskeyEnabled || isPhoneVerified;

  /// Check if this is a premium account
  bool get isPremium => accountType.toLowerCase() == 'premium';
}
