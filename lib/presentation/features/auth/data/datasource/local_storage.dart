import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  
  factory LocalStorage() => _instance;
  
  LocalStorage._internal();
  
  Future<SharedPreferences> get _prefs async => 
      await SharedPreferences.getInstance();
  
  // Auth tokens
  Future<void> saveToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString('auth_token', token);
  }
  
  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString('auth_token');
  }
  
  Future<void> clearToken() async {
    final prefs = await _prefs;
    await prefs.remove('auth_token');
  }
  
  // User data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await _prefs;
    await prefs.setString('user_data', json.encode(userData));
  }
  
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await _prefs;
    final data = prefs.getString('user_data');
    return data != null ? json.decode(data) : null;
  }
  
  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}