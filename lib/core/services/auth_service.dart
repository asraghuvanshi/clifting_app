import 'package:clifting_app/features/auth/data/model/forget_password_model.dart';
import 'package:clifting_app/features/auth/data/model/login_model.dart';
import 'package:dio/dio.dart';
import 'package:clifting_app/core/network/api_client.dart';
import 'package:clifting_app/core/exceptions/api_exceptions.dart';

class AuthService {
  final ApiClient _apiClient;
  
  AuthService(this._apiClient);
  
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.error ?? UnknownException('Login failed');
    }
  }
  

  Future<ForgotPasswordResponse> forgetPassword(ResetPasswordRequest request) async {
    try {
      final response = await _apiClient.post(
        '/auth/forgot-password',
        data: request.toJson(),
      );
      return ForgotPasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.error ?? UnknownException('Something went wrong');
    }
  }

  Future<AuthResponse> verifyOTP(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        '/auth/verifyOtp',
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.error ?? UnknownException('Login failed');
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (e) {
      // Silent fail for logout
    }
  }
  
  Future<User> validateToken() async {
    try {
      final response = await _apiClient.get('/auth/validate');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is UnauthorizedException) {
        throw const UnauthorizedException();
      }
      rethrow;
    }
  }
  
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.error ?? UnknownException('Token refresh failed');
    }
  }
}