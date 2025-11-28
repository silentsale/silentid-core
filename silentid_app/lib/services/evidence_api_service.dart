import '../core/constants/api_constants.dart';
import 'api_service.dart';

/// Evidence API Service
/// Handles evidence-related API calls (receipts, screenshots, profiles)
class EvidenceApiService {
  final ApiService _api = ApiService();

  /// Get evidence summary with counts
  Future<EvidenceSummary> getEvidenceSummary() async {
    // Fetch counts from multiple endpoints in parallel
    final results = await Future.wait([
      _getReceiptsCount(),
      _getScreenshotsCount(),
      _getProfileLinksCount(),
    ]);

    return EvidenceSummary(
      receiptsCount: results[0],
      screenshotsCount: results[1],
      profileLinksCount: results[2],
    );
  }

  Future<int> _getReceiptsCount() async {
    try {
      final response = await _api.get(
        '${ApiConstants.evidenceReceipts}?page=1&pageSize=1',
      );
      return response.data['totalCount'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<int> _getScreenshotsCount() async {
    try {
      // Screenshots endpoint may not have pagination, fetch all
      final response = await _api.get(ApiConstants.evidenceScreenshots);
      final screenshots = response.data['screenshots'] as List<dynamic>? ?? [];
      return screenshots.length;
    } catch (e) {
      return 0;
    }
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
  final int receiptsCount;
  final int screenshotsCount;
  final int profileLinksCount;

  EvidenceSummary({
    required this.receiptsCount,
    required this.screenshotsCount,
    required this.profileLinksCount,
  });

  int get totalCount => receiptsCount + screenshotsCount + profileLinksCount;
}
