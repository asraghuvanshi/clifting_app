import 'dart:ffi';

import 'package:clifting_app/core/services/auth_service.dart';
import 'package:clifting_app/core/services/storage_service.dart';
import 'package:clifting_app/features/auth/data/model/forget_password_model.dart';
import 'package:clifting_app/features/auth/data/model/login_model.dart';
import 'package:clifting_app/core/exceptions/api_exceptions.dart';
import 'package:clifting_app/features/auth/data/model/user_profile_model.dart';
import 'package:clifting_app/features/auth/data/model/verify_reset_password_otp.dart';

class AuthRepository {
  final AuthService _authService;
  final StorageService _storageService;

  AuthRepository({
    required AuthService authService,
    required StorageService storageService,
  }) : _authService = authService,
       _storageService = storageService;

  Future<LoginModel> login(String email, String password) async {
    final request = LoginRequest(email: email, password: password);
    final response = await _authService.login(request);

    // Save tokens and user data
    await _storageService.saveTokens(
      response.data?.accessToken ?? "",
      response.data?.refreshToken ?? "",
    );
    return response;
  }

  Future<ForgotPasswordResponse> forgetPassword(String email) async {
    final request = ResetPasswordRequest(email: email);
    final response = await _authService.forgetPassword(request);
    return response;
  }

  Future<VerifyResetPasswordOtpResponse> verifyResetPasswordOtp(String email, String otp) async {
    final request = ResetPasswordOTPRequest(email: email, otp: otp);
    final response = await _authService.verifyResetOTP(request);
    return response;
  }

  Future<VerifyResetPasswordOtpResponse> changePassword(String token, String password) async {
    final request = ChangePasswordRequest(token: token, password: password);
    final response = await _authService.changePassword(request);
    return response;
  }

  Future<UserProfileModel> getUserProfile() async {
    final response = await _authService.getUserProfile();
    return response;
  }

  Future<void> logout() async {
    await _authService.logout();
    await _storageService.clearAll();
  }

  Future<UserProfileModel> validateToken() async {
    try {
      return await _authService.validateToken();
    } on UnauthorizedException {
      await _storageService.clearAll();
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = _storageService.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> refreshAuthToken() async {
    final refreshToken = _storageService.getRefreshToken();
    if (refreshToken == null) {
      throw const UnauthorizedException();
    }

    try {
      final response = await _authService.refreshToken(refreshToken);
      await _storageService.saveTokens(
        response.data?.accessToken ?? "",
        response.data?.refreshToken ?? "",
      );
    } on UnauthorizedException {
      await _storageService.clearAll();
      rethrow;
    }
  }
}