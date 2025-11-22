import '../core/constants/api_constants.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _api = ApiService();
  final _storage = StorageService();

  // Request OTP
  Future<Map<String, dynamic>> requestOtp(String email) async {
    try {
      final response = await _api.post(
        ApiConstants.requestOtp,
        data: {'email': email},
      );

      return {
        'success': true,
        'message': response.data['message'] ?? 'OTP sent successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString().replaceAll('Exception: ', ''),
      };
    }
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp(String email, String code) async {
    try {
      final response = await _api.post(
        ApiConstants.verifyOtp,
        data: {
          'email': email,
          'code': code,
        },
      );

      final data = response.data;

      // Save auth data
      await _storage.saveAuthData(
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
        userId: data['userId'],
        email: email,
      );

      return {
        'success': true,
        'message': 'Login successful',
        'user': data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString().replaceAll('Exception: ', ''),
      };
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _api.post(
        ApiConstants.refresh,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data;

      await _storage.saveAccessToken(data['accessToken']);
      await _storage.saveRefreshToken(data['refreshToken']);

      return true;
    } catch (e) {
      await _storage.clearAuthData();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _api.post(ApiConstants.logout);
    } catch (e) {
      // Ignore errors on logout
    } finally {
      await _storage.clearAuthData();
    }
  }

  // Check if authenticated
  Future<bool> isAuthenticated() async {
    return await _storage.isAuthenticated();
  }

  // Get current user email
  Future<String?> getCurrentUserEmail() async {
    return await _storage.getUserEmail();
  }

  // Get current user ID
  Future<String?> getCurrentUserId() async {
    return await _storage.getUserId();
  }

  // Apple Sign-In
  Future<Map<String, dynamic>> appleSignIn(String identityToken, String? authorizationCode) async {
    try {
      final response = await _api.post(
        ApiConstants.appleSignIn,
        data: {
          'identityToken': identityToken,
          'authorizationCode': authorizationCode,
        },
      );

      final data = response.data;

      // Save auth data
      await _storage.saveAuthData(
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
        userId: data['userId'],
        email: data['email'] ?? '',
      );

      return {
        'success': true,
        'message': 'Login successful',
        'user': data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString().replaceAll('Exception: ', ''),
      };
    }
  }

  // Google Sign-In
  Future<Map<String, dynamic>> googleSignIn(String idToken, String? accessToken) async {
    try {
      final response = await _api.post(
        ApiConstants.googleSignIn,
        data: {
          'idToken': idToken,
          'accessToken': accessToken,
        },
      );

      final data = response.data;

      // Save auth data
      await _storage.saveAuthData(
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
        userId: data['userId'],
        email: data['email'] ?? '',
      );

      return {
        'success': true,
        'message': 'Login successful',
        'user': data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString().replaceAll('Exception: ', ''),
      };
    }
  }
}
