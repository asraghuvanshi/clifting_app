import 'package:clifting_app/features/auth/data/model/forget_password_model.dart';
import 'package:clifting_app/features/auth/data/model/login_model.dart';
import 'package:clifting_app/features/auth/data/model/user_model.dart';
import 'package:clifting_app/features/auth/data/model/verify_reset_password_otp.dart';
import 'package:dio/dio.dart';
import 'package:clifting_app/core/network/api_client.dart';
import 'package:clifting_app/core/exceptions/api_exceptions.dart';

class AuthService {
  final ApiClient _apiClient;
  
  AuthService(this._apiClient);
  
  // MARK: - Validate Token
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
  

  // Refresh Token API
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

  //  Verify Reset Password OTP
  Future<VerifyResetPasswordOtpResponse> verifyResetOTP(ResetPasswordOTPRequest request) async {
    try {
      final response = await _apiClient.post(
        '/auth/verify-reset-otp',
        data: request.toJson(),
      );
      return VerifyResetPasswordOtpResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.error ?? UnknownException('Something went wrong failed');
    }
  }

  // Change Password api 
  Future<VerifyResetPasswordOtpResponse> changePassword(ChangePasswordRequest request) async {
      try {
      final response = await _apiClient.post(
        '/auth/reset-password',
        data: request.toJson(),
      );
      return VerifyResetPasswordOtpResponse.fromJson(response.data);
     
    } on DioException catch (e) {
      throw e.error ?? UnknownException('Something went wrong failed');
    }
  }

  // Get User Profile
  Future<UserModel> getUserProfile() async {
      try {
      final response = await _apiClient.get(
        '/user/profile'
      );
      return UserModel.fromJson(response.data);
     
    } on DioException catch (e) {
      throw e.error ?? UnknownException('Something went wrong failed');
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (e) {
      // Silent fail for logout
    }
  }
}