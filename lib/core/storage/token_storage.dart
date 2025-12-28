import 'package:shared_preferences/shared_preferences.dart';


class TokenStorage {
  static const _accessToken = 'access_token';
  static const _refreshToken = 'refresh_token';

  Future<void> saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessToken, access);
    await prefs.setString(_refreshToken, refresh);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessToken);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
