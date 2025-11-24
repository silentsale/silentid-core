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

      // Backend returns: { incoming: [...], count: X }
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('incoming')) {
        final incoming = data['incoming'] as List;
        return incoming
            .map((json) => _parseIncomingVerification(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load incoming verifications: ${e.toString()}');
    }
  }

  /// Parse incoming verification response format
  MutualVerification _parseIncomingVerification(Map<String, dynamic> json) {
    final from = json['from'] as Map<String, dynamic>;

    return MutualVerification(
      id: json['id'] as String,
      userAId: '', // UserA is the requester
      userBId: '', // UserB is current user
      item: json['item'] as String,
      amount: (json['amount'] as num).toDouble(),
      roleA: json['theirRole'] as String,
      roleB: json['yourRole'] as String,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      fraudFlag: false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      otherUserName: from['displayName'] as String?,
      otherUserUsername: from['username'] as String?,
    );
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

      // Backend returns: { verifications: [...], count: X }
      final data = response.data;
      if (data is Map<String, dynamic> &&
          data.containsKey('verifications')) {
        final verifications = data['verifications'] as List;
        return verifications
            .map((json) => _parseVerification(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load verifications: ${e.toString()}');
    }
  }

  /// Parse verification response format from /v1/mutual-verifications
  MutualVerification _parseVerification(Map<String, dynamic> json) {
    final participants = json['participants'] as Map<String, dynamic>;
    final them = participants['them'] as Map<String, dynamic>;
    final yourRole = participants['you'] as String;
    final theirRole = them['role'] as String;

    return MutualVerification(
      id: json['id'] as String,
      userAId: json['initiatedByYou'] == true ? '' : '',
      userBId: '',
      item: json['item'] as String,
      amount: (json['amount'] as num).toDouble(),
      roleA: yourRole,
      roleB: theirRole,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      fraudFlag: false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      otherUserName: them['displayName'] as String?,
      otherUserUsername: them['username'] as String?,
    );
  }

  /// Get specific verification by ID
  Future<MutualVerification> getById(String id) async {
    try {
      final response = await _apiService.get('/v1/mutual-verifications/$id');

      // Backend returns full nested structure
      final json = response.data as Map<String, dynamic>;
      final participants = json['participants'] as Map<String, dynamic>;
      final userA = participants['userA'] as Map<String, dynamic>;
      final userB = participants['userB'] as Map<String, dynamic>;

      return MutualVerification(
        id: json['id'] as String,
        userAId: '',
        userBId: '',
        item: json['item'] as String,
        amount: (json['amount'] as num).toDouble(),
        roleA: userA['role'] as String,
        roleB: userB['role'] as String,
        date: DateTime.parse(json['date'] as String),
        status: json['status'] as String,
        fraudFlag: false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        otherUserName: userB['displayName'] as String?,
        otherUserUsername: userB['username'] as String?,
      );
    } catch (e) {
      throw Exception('Failed to load verification details: ${e.toString()}');
    }
  }
}
