import '../models/evidence_models.dart';
import 'api_service.dart';

class EvidenceService {
  final ApiService _api;

  EvidenceService({ApiService? apiService}) : _api = apiService ?? ApiService();

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
      final response = await _api.get('/v1/evidence/profile-links');

      final profileLinks = (response.data['profileLinks'] as List)
          .map((json) => ProfileLink.fromJson(json))
          .toList();

      return profileLinks;
    } catch (e) {
      throw Exception('Failed to load profile links: $e');
    }
  }

  /// Get profile links count and breakdown
  Future<Map<String, int>> getProfileLinksCounts() async {
    try {
      final response = await _api.get('/v1/evidence/profile-links');
      return {
        'total': response.data['count'] ?? 0,
        'linked': response.data['linkedCount'] ?? 0,
        'verified': response.data['verifiedCount'] ?? 0,
      };
    } catch (e) {
      return {'total': 0, 'linked': 0, 'verified': 0};
    }
  }

  /// Get evidence summary (counts for profile links only)
  Future<EvidenceSummary> getEvidenceSummary() async {
    try {
      final response = await _api.get('/v1/evidence/profile-links');
      final profileLinksCount = response.data['count'] ?? 0;

      return EvidenceSummary(
        profileLinksCount: profileLinksCount,
      );
    } catch (e) {
      return EvidenceSummary(
        profileLinksCount: 0,
      );
    }
  }
}
