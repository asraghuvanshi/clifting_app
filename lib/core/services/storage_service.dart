import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  
  final SharedPreferences _prefs;
  
  StorageService(this._prefs);
  
  // Token management
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }
  
  String? getAccessToken() => _prefs.getString(_accessTokenKey);
  String? getRefreshToken() => _prefs.getString(_refreshTokenKey);
  
  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userDataKey);
  }
  
  // User data
  Future<void> saveUserData(String userData) async {
    await _prefs.setString(_userDataKey, userData);
  }
  
  String? getUserData() => _prefs.getString(_userDataKey);
  
  // Clear all data
  Future<void> clearAll() async {
    await clearTokens();
  }
}