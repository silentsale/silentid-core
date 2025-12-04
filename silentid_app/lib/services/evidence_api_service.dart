import '../core/constants/api_constants.dart';
import 'api_service.dart';

/// Evidence API Service
/// Handles profile linking API calls
class EvidenceApiService {
  final ApiService _api = ApiService();

  /// Get evidence summary with counts
  Future<EvidenceSummary> getEvidenceSummary() async {
    final profileLinksCount = await _getProfileLinksCount();

    return EvidenceSummary(
      profileLinksCount: profileLinksCount,
    );
  }

  Future<int> _getProfileLinksCount() async {
    try {
      final response = await _api.get(ApiConstants.profileLinks);
      return response.data['count'] ?? 0;
    } catch (e) {
      return 0;
    }
  }
}

/// Evidence summary model
class EvidenceSummary {
  final int profileLinksCount;

  EvidenceSummary({
    required this.profileLinksCount,
  });

  int get totalCount => profileLinksCount;
}
