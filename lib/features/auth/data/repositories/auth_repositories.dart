import 'package:clifting_app/features/auth/data/model/login_model.dart';
import 'package:clifting_app/utility/local_storage_service/local_storage_service.dart';
import 'package:clifting_app/utility/network_services/api_services.dart';

class AuthRepository {
  final ApiService _apiService;
  final LocalStorageService _localStorage;

  AuthRepository(this._apiService, this._localStorage);

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);
        
        // Save tokens and user data
        await _localStorage.saveAuthData(authResponse.data);
        _apiService.setAuthToken(authResponse.data.refreshToken);
        
        return authResponse;
      } else {
        final errorMessage = response.data is Map && response.data.containsKey('message')
            ? response.data['message']
            : 'Login Error';
        throw ApiException(errorMessage, response.statusCode ?? 500);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout');
    } catch (e) {
      //  logout API fails
    } finally {
      await _localStorage.clearAuthData();
      _apiService.clearAuthToken();
    }
  }

  Future<AuthResponse> refreshToken() async {
    try {
      final refreshToken = await _localStorage.getRefreshToken();
      if (refreshToken == null) {
        throw UnauthorizedException('No refresh token available');
      }

      final response = await _apiService.post(
        '/auth/refresh-token',
        data: {'refresh_token': refreshToken},
      );

      final authResponse = AuthResponse.fromJson(response.data);
      
      // Update tokens
      await _localStorage.saveAuthData(authResponse.data);
      _apiService.setAuthToken(authResponse.data.refreshToken);
      
      return authResponse;
    } catch (e) {
      await _localStorage.clearAuthData();
      _apiService.clearAuthToken();
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _localStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<User?> getCurrentUser() async {
    return await _localStorage.getUser();
  }
}