import '../models/mutual_verification.dart';
import 'api_service.dart';

class MutualVerificationService {
  final ApiService _apiService;

  MutualVerificationService(this._apiService);

  /// Create a new mutual verification request
  Future<String> createVerification(CreateVerificationRequest request) async {
    try {
      final response = await _apiService.post(
        '/v1/mutual-verifications',
        data: request.toJson(),
      );
      return response.data['id'] as String;
    } catch (e) {
      throw Exception('Failed to create verification: ${e.toString()}');
    }
  }

  /// Get incoming verification requests (where current user is User B)
  Future<List<MutualVerification>> getIncoming() async {
    try {
      final response =
          await _apiService.get('/v1/mutual-verifications/incoming');

      if (response.data is List) {
        return (response.data as List)
            .map((json) => MutualVerification.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load incoming verifications: ${e.toString()}');
    }
  }

  /// Respond to a verification request (confirm or reject)
  Future<void> respond(
    String id,
    String status, {
    String? reason,
  }) async {
    try {
      await _apiService.post(
        '/v1/mutual-verifications/$id/respond',
        data: {
          'status': status,
          if (reason != null) 'reason': reason,
        },
      );
    } catch (e) {
      throw Exception('Failed to respond to verification: ${e.toString()}');
    }
  }

  /// Get all mutual verifications for current user
  Future<List<MutualVerification>> getAll() async {
    try {
      final response = await _apiService.get('/v1/mutual-verifications');

      if (response.data is List) {
        return (response.data as List)
            .map((json) => MutualVerification.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load verifications: ${e.toString()}');
    }
  }

  /// Get specific verification by ID
  Future<MutualVerification> getById(String id) async {
    try {
      final response = await _apiService.get('/v1/mutual-verifications/$id');
      return MutualVerification.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load verification details: ${e.toString()}');
    }
  }
}
