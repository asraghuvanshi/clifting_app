// lib/presentation/features/auth/data/auth_repository.dart

import 'package:clifting_app/core/storage/token_storage.dart';
import 'package:clifting_app/presentation/features/auth/data/auth_api.dart';
import 'package:clifting_app/presentation/features/auth/data/model/forget_password_model.dart';
import 'package:clifting_app/presentation/features/auth/data/model/login_model.dart';

class AuthRepository {
  final AuthApi _api;
  final TokenStorage _storage;

  AuthRepository(this._api, this._storage);

  Future<LoginModel> login(String email, String password) async {
    try {
      final response = await _api.login(email, password);
      final loginResponse = LoginModel.fromJson(response);

      if (loginResponse.success ?? false) {
        // Save tokens
        if (loginResponse.data?.accessToken != null) {
          await _storage.saveTokens(
            loginResponse.data!.accessToken!,
            loginResponse.data?.refreshToken ?? '',
          );
        }
      }

      return loginResponse;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<ForgotPasswordResponse> forgetPassword(String email) async {
    try {
      final response = await _api.forgetPassword(email);
      final forgetPasswordResponse = ForgotPasswordResponse.fromJson(response);
      return forgetPasswordResponse;
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  // If you have reset password with OTP
  Future<Map<String, dynamic>> resetPasswordWithOTP(String email, String otp) async {
    try {
      final response = await _api.resetPassword(email);
      return response;
    } catch (e) {
      throw Exception('Reset password failed: ${e.toString()}');
    }
  }



  Future<void> logout() async {
    try {
      // await _storage.clearTokens();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await _storage.getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.getAccessToken();
  }
}