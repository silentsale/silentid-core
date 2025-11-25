import '../models/evidence_models.dart';
import 'api_service.dart';

class EvidenceService {
  final ApiService _api;

  EvidenceService({ApiService? apiService}) : _api = apiService ?? ApiService();

  /// Get all receipts for the current user (paginated)
  Future<List<Receipt>> getReceipts({int page = 1, int pageSize = 20}) async {
    try {
      final response = await _api.get(
        '/v1/evidence/receipts',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );

      final receipts = (response.data['receipts'] as List)
          .map((json) => Receipt.fromJson(json))
          .toList();

      return receipts;
    } catch (e) {
      throw Exception('Failed to load receipts: $e');
    }
  }

  /// Get total count of receipts
  Future<int> getTotalReceiptsCount() async {
    try {
      final response = await _api.get('/v1/evidence/receipts');
      return response.data['pagination']['totalCount'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Upload a manual receipt
  Future<void> uploadReceipt({
    required String platform,
    required String item,
    required double amount,
    required String currency,
    required String role,
    required DateTime date,
    String? orderId,
  }) async {
    try {
      await _api.post(
        '/v1/evidence/receipts/manual',
        data: {
          'platform': platform,
          'item': item,
          'amount': amount,
          'currency': currency,
          'role': role,
          'date': date.toIso8601String(),
          'orderId': orderId,
        },
      );
    } catch (e) {
      throw Exception('Failed to upload receipt: $e');
    }
  }

  /// Get upload URL for screenshot
  Future<Map<String, dynamic>> getScreenshotUploadUrl() async {
    try {
      final response = await _api.post('/v1/evidence/screenshots/upload-url');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get upload URL: $e');
    }
  }

  /// Upload screenshot metadata (after file upload)
  Future<void> uploadScreenshot({
    required String fileUrl,
    required String platform,
    String? ocrText,
  }) async {
    try {
      await _api.post(
        '/v1/evidence/screenshots',
        data: {
          'fileUrl': fileUrl,
          'platform': platform,
          'ocrText': ocrText,
        },
      );
    } catch (e) {
      throw Exception('Failed to upload screenshot: $e');
    }
  }

  /// Get screenshot details
  Future<Screenshot> getScreenshot(String id) async {
    try {
      final response = await _api.get('/v1/evidence/screenshots/$id');
      return Screenshot.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load screenshot: $e');
    }
  }

  /// Get all screenshots for the current user
  Future<List<Screenshot>> getScreenshots() async {
    try {
      // Note: Backend doesn't have a list endpoint yet, so we'll return empty for now
      // TODO: Add GET /v1/evidence/screenshots endpoint in backend
      return [];
    } catch (e) {
      throw Exception('Failed to load screenshots: $e');
    }
  }

  /// Add a profile link
  Future<void> addProfileLink({
    required String url,
    required String platform,
  }) async {
    try {
      await _api.post(
        '/v1/evidence/profile-links',
        data: {
          'url': url,
          'platform': platform,
        },
      );
    } catch (e) {
      throw Exception('Failed to add profile link: $e');
    }
  }

  /// Get profile link details
  Future<ProfileLink> getProfileLink(String id) async {
    try {
      final response = await _api.get('/v1/evidence/profile-links/$id');
      return ProfileLink.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load profile link: $e');
    }
  }

  /// Get all profile links for the current user
  Future<List<ProfileLink>> getProfileLinks() async {
    try {
      // Note: Backend doesn't have a list endpoint yet, so we'll return empty for now
      // TODO: Add GET /v1/evidence/profile-links endpoint in backend
      return [];
    } catch (e) {
      throw Exception('Failed to load profile links: $e');
    }
  }

  /// Get evidence summary (counts for each type)
  Future<EvidenceSummary> getEvidenceSummary() async {
    try {
      // Get counts from receipts endpoint (has pagination data)
      final receiptsResponse = await _api.get('/v1/evidence/receipts');
      final receiptsCount = receiptsResponse.data['pagination']['totalCount'] ?? 0;

      // For screenshots and profile links, we'll use 0 for now since list endpoints don't exist
      return EvidenceSummary(
        receiptsCount: receiptsCount,
        screenshotsCount: 0,
        profileLinksCount: 0,
      );
    } catch (e) {
      return EvidenceSummary(
        receiptsCount: 0,
        screenshotsCount: 0,
        profileLinksCount: 0,
      );
    }
  }
}
