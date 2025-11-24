import 'package:dio/dio.dart';
import '../models/public_profile.dart';
import 'api_service.dart';

/// Public Profile Service
///
/// Handles public profile operations (NO authentication required).
/// Endpoints: GET /v1/public/profile/{username}, GET /v1/public/availability/{username}
class PublicProfileService {
  final ApiService _apiService;

  PublicProfileService(this._apiService);

  /// Get public profile by username
  ///
  /// Endpoint: GET /v1/public/profile/{username}
  /// NO authentication required - publicly accessible
  ///
  /// Throws:
  /// - DioException: Network or server errors
  /// - FormatException: Invalid response format
  Future<PublicProfile> getPublicProfile(String username) async {
    try {
      // Clean username (remove @ if present)
      final cleanUsername = username.startsWith('@') ? username.substring(1) : username;

      // Call public endpoint (no auth token)
      final response = await _apiService.get(
        '/v1/public/profile/$cleanUsername',
      );

      if (response.statusCode == 200) {
        return PublicProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to load public profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Username not found');
      } else if (e.response?.statusCode == 400) {
        final error = e.response?.data['message'] ?? 'Invalid username format';
        throw Exception(error);
      }
      rethrow;
    }
  }

  /// Check if username is available
  ///
  /// Endpoint: GET /v1/public/availability/{username}
  /// NO authentication required
  ///
  /// Returns:
  /// - UsernameAvailability with available status and suggestions if taken
  Future<UsernameAvailability> checkUsernameAvailability(String username) async {
    try {
      // Clean username
      final cleanUsername = username.startsWith('@') ? username.substring(1) : username;

      final response = await _apiService.get(
        '/v1/public/availability/$cleanUsername',
      );

      if (response.statusCode == 200) {
        return UsernameAvailability.fromJson(response.data);
      } else {
        throw Exception('Failed to check availability: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final error = e.response?.data['message'] ?? 'Invalid username format';
        throw Exception(error);
      }
      rethrow;
    }
  }

  /// Generate QR code data for profile URL
  ///
  /// Returns the full profile URL for QR code generation:
  /// https://silentid.co.uk/u/username
  String generateProfileQR(String username) {
    final cleanUsername = username.startsWith('@') ? username.substring(1) : username;
    return 'https://silentid.co.uk/u/$cleanUsername';
  }

  /// Get share text for profile
  ///
  /// Returns formatted share message
  String getShareText(String username, String displayName) {
    final cleanUsername = username.startsWith('@') ? username.substring(1) : username;
    return 'Check out $displayName\'s SilentID profile: https://silentid.co.uk/u/$cleanUsername';
  }
}
