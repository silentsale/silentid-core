import '../core/constants/api_constants.dart';
import 'api_service.dart';

/// Referral API Service (Section 50.6.1)
/// Handles all referral-related API calls
class ReferralApiService {
  final ApiService _api = ApiService();

  /// Get current user's referral summary (code, link, stats)
  Future<ReferralSummaryResponse> getReferralSummary() async {
    final response = await _api.get(ApiConstants.referralMe);
    return ReferralSummaryResponse.fromJson(response.data);
  }

  /// Get list of referrals made by current user
  Future<List<ReferralItemResponse>> getReferralList() async {
    final response = await _api.get(ApiConstants.referralList);
    final data = response.data as Map<String, dynamic>;
    final referrals = data['referrals'] as List<dynamic>;
    return referrals
        .map((r) => ReferralItemResponse.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  /// Validate a referral code (public - no auth required)
  Future<bool> validateReferralCode(String code) async {
    try {
      final response = await _api.get(ApiConstants.referralValidate(code));
      return response.data['isValid'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Apply a referral code to current user's account
  Future<ApplyReferralResponse> applyReferralCode(String code) async {
    final response = await _api.post(
      ApiConstants.referralApply,
      data: {'referralCode': code},
    );
    return ApplyReferralResponse.fromJson(response.data);
  }
}

/// Response model for referral summary
class ReferralSummaryResponse {
  final String referralCode;
  final String referralLink;
  final int totalReferrals;
  final int completedReferrals;
  final int pendingReferrals;
  final int totalPointsEarned;

  ReferralSummaryResponse({
    required this.referralCode,
    required this.referralLink,
    required this.totalReferrals,
    required this.completedReferrals,
    required this.pendingReferrals,
    required this.totalPointsEarned,
  });

  factory ReferralSummaryResponse.fromJson(Map<String, dynamic> json) {
    return ReferralSummaryResponse(
      referralCode: json['referralCode'] ?? '',
      referralLink: json['referralLink'] ?? '',
      totalReferrals: json['totalReferrals'] ?? 0,
      completedReferrals: json['completedReferrals'] ?? 0,
      pendingReferrals: json['pendingReferrals'] ?? 0,
      totalPointsEarned: json['totalPointsEarned'] ?? 0,
    );
  }
}

/// Response model for individual referral item
class ReferralItemResponse {
  final String id;
  final String name;
  final String initials;
  final String status;
  final int pointsEarned;
  final DateTime invitedAt;
  final DateTime? signedUpAt;
  final DateTime? completedAt;

  ReferralItemResponse({
    required this.id,
    required this.name,
    required this.initials,
    required this.status,
    required this.pointsEarned,
    required this.invitedAt,
    this.signedUpAt,
    this.completedAt,
  });

  factory ReferralItemResponse.fromJson(Map<String, dynamic> json) {
    return ReferralItemResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      initials: json['initials'] ?? '??',
      status: json['status'] ?? 'pending',
      pointsEarned: json['pointsEarned'] ?? 0,
      invitedAt: DateTime.tryParse(json['invitedAt'] ?? '') ?? DateTime.now(),
      signedUpAt: json['signedUpAt'] != null
          ? DateTime.tryParse(json['signedUpAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'])
          : null,
    );
  }

  /// Convert API status to ReferralState enum
  ReferralState get referralState {
    switch (status.toLowerCase()) {
      case 'completed':
        return ReferralState.completed;
      case 'signedup':
        return ReferralState.pending;
      case 'expired':
        return ReferralState.expired;
      default:
        return ReferralState.pending;
    }
  }
}

/// Response model for apply referral result
class ApplyReferralResponse {
  final bool success;
  final String message;

  ApplyReferralResponse({
    required this.success,
    required this.message,
  });

  factory ApplyReferralResponse.fromJson(Map<String, dynamic> json) {
    return ApplyReferralResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

/// Referral status enum (matches backend)
enum ReferralState {
  pending,
  completed,
  expired,
}
