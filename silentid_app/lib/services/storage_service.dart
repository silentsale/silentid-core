import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants/api_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // Save access token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: ApiConstants.accessTokenKey, value: token);
  }

  // Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: ApiConstants.accessTokenKey);
  }

  // Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: ApiConstants.refreshTokenKey, value: token);
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: ApiConstants.refreshTokenKey);
  }

  // Save user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: ApiConstants.userIdKey, value: userId);
  }

  // Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: ApiConstants.userIdKey);
  }

  // Save user email
  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: ApiConstants.userEmailKey, value: email);
  }

  // Get user email
  Future<String?> getUserEmail() async {
    return await _storage.read(key: ApiConstants.userEmailKey);
  }

  // Save username
  Future<void> saveUsername(String username) async {
    await _storage.write(key: ApiConstants.usernameKey, value: username);
  }

  // Get username
  Future<String?> getUsername() async {
    return await _storage.read(key: ApiConstants.usernameKey);
  }

  // Save all auth data
  Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String email,
    String? username,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
      saveUserId(userId),
      saveUserEmail(email),
      if (username != null) saveUsername(username),
    ]);
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  // Clear all auth data (logout)
  Future<void> clearAuthData() async {
    await Future.wait([
      _storage.delete(key: ApiConstants.accessTokenKey),
      _storage.delete(key: ApiConstants.refreshTokenKey),
      _storage.delete(key: ApiConstants.userIdKey),
      _storage.delete(key: ApiConstants.userEmailKey),
      _storage.delete(key: ApiConstants.usernameKey),
    ]);
  }

  // Clear all storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Demo mode - creates fake auth data for testing
  Future<void> enableDemoMode() async {
    await saveAuthData(
      accessToken: 'demo_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'demo_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'demo_user_12345',
      email: 'demo@silentid.app',
      username: 'DemoUser',
    );
  }

  // Check if in demo mode
  Future<bool> isDemoMode() async {
    final userId = await getUserId();
    return userId == 'demo_user_12345';
  }

  // Privacy Settings Keys
  static const String _trustScoreVisibilityKey = 'privacy_trustscore_visibility';
  static const String _showTransactionCountKey = 'privacy_show_transaction_count';
  static const String _showPlatformListKey = 'privacy_show_platform_list';
  static const String _showAccountAgeKey = 'privacy_show_account_age';

  // Save TrustScore visibility mode
  Future<void> saveTrustScoreVisibility(String mode) async {
    await _storage.write(key: _trustScoreVisibilityKey, value: mode);
  }

  // Get TrustScore visibility mode
  Future<String?> getTrustScoreVisibility() async {
    return await _storage.read(key: _trustScoreVisibilityKey);
  }

  // Save show transaction count setting
  Future<void> saveShowTransactionCount(bool value) async {
    await _storage.write(key: _showTransactionCountKey, value: value.toString());
  }

  // Get show transaction count setting
  Future<bool> getShowTransactionCount() async {
    final value = await _storage.read(key: _showTransactionCountKey);
    return value == null || value == 'true'; // Default to true
  }

  // Save show platform list setting
  Future<void> saveShowPlatformList(bool value) async {
    await _storage.write(key: _showPlatformListKey, value: value.toString());
  }

  // Get show platform list setting
  Future<bool> getShowPlatformList() async {
    final value = await _storage.read(key: _showPlatformListKey);
    return value == null || value == 'true'; // Default to true
  }

  // Save show account age setting
  Future<void> saveShowAccountAge(bool value) async {
    await _storage.write(key: _showAccountAgeKey, value: value.toString());
  }

  // Get show account age setting
  Future<bool> getShowAccountAge() async {
    final value = await _storage.read(key: _showAccountAgeKey);
    return value == null || value == 'true'; // Default to true
  }
}
