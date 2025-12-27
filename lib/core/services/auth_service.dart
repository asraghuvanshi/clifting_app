import 'package:clifting_app/features/auth/data/model/forget_password_model.dart';
import 'package:clifting_app/features/auth/data/model/login_model.dart';
import 'package:clifting_app/features/auth/data/model/user_profile_model.dart';
import 'package:clifting_app/features/auth/data/model/verify_reset_password_otp.dart';
import 'package:dio/dio.dart';
import 'package:clifting_app/core/network/api_client.dart';
import 'package:clifting_app/core/exceptions/api_exceptions.dart';

class AuthService {
  final ApiClient _apiClient;
  
  AuthService(this._apiClient);
  
  // MARK: - Validate Token
  Future<UserProfileModel> validateToken() async {
    try {
      final response = await _apiClient.get('/auth/validate');
      return UserProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is UnauthorizedException) {
        throw const UnauthorizedException();
      }
      rethrow;
    }
  }
  

  // Refresh Token API
  Future<LoginModel> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      
      return LoginModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.error ?? UnknownException('Token refresh failed');
    }
  }

  Future<LoginModel> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: request.toJson(),
      );
      return LoginModel.fromJson(response.data);
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

  Future<LoginModel> verifyOTP(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        '/auth/verifyOtp',
        data: request.toJson(),
      );
      return LoginModel.fromJson(response.data);
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
  Future<UserProfileModel> getUserProfile() async {
      try {
      final response = await _apiClient.get(
        '/user/profile'
      );
      return UserProfileModel.fromJson(response.data);
     
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