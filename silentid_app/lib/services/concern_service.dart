import 'api_service.dart';

/// Service for profile concerns (safety flags on public profiles).
/// Uses neutral, safe language as per SilentID spec.
class ConcernService {
  final ApiService _apiService;

  ConcernService(this._apiService);

  /// Submit a concern about a public profile.
  Future<ConcernResult> submitConcern({
    required String reportedUserId,
    required ConcernReason reason,
    String? notes,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/concern',
        data: {
          'reportedUserId': reportedUserId,
          'reason': reason.value,
          'notes': notes,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return ConcernResult(
          success: data['success'] ?? true,
          message: data['message'] ?? 'Thanks — our team will privately review this concern.',
          concernId: data['concernId'],
        );
      } else if (response.statusCode == 429) {
        final data = response.data as Map<String, dynamic>;
        return ConcernResult(
          success: false,
          message: data['error'] ?? 'You have reached the limit for reporting concerns.',
        );
      } else {
        final data = response.data as Map<String, dynamic>;
        return ConcernResult(
          success: false,
          message: data['error'] ?? 'Failed to submit concern',
        );
      }
    } catch (e) {
      return ConcernResult(
        success: false,
        message: 'Network error. Please try again.',
      );
    }
  }
}

/// Concern reason categories using neutral, safe language.
/// NEVER use words like: scam, scammer, fraud, fake.
enum ConcernReason {
  /// "Profile might not belong to this person"
  profileOwnership(1, 'Profile might not belong to this person'),

  /// "Suspicious or inconsistent information"
  inconsistentInformation(2, 'Suspicious or inconsistent information'),

  /// "Something feels unsafe"
  unsafeFeeling(3, 'Something feels unsafe'),

  /// "Other safety concern"
  otherSafetyConcern(4, 'Other safety concern');

  const ConcernReason(this.value, this.displayText);
  final int value;
  final String displayText;
}

/// Result of submitting a concern.
class ConcernResult {
  final bool success;
  final String message;
  final String? concernId;

  ConcernResult({
    required this.success,
    required this.message,
    this.concernId,
  });
}
