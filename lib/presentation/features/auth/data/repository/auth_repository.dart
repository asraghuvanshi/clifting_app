import 'package:clifting_app/core/storage/token_storage.dart';
import 'package:clifting_app/presentation/features/auth/data/repository/auth_api.dart';
import 'package:clifting_app/presentation/features/auth/data/model/change_password_response.dart';
import 'package:clifting_app/presentation/features/auth/data/model/forget_password_model.dart';
import 'package:clifting_app/presentation/features/auth/data/model/login_model.dart';
import 'package:clifting_app/presentation/features/auth/data/model/verify_reset_password_otp.dart';

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

  Future<VerifyResetOtpResponse> resetPasswordWithOTP(String email, String otp) async {
    try {
      final response = await _api.verifyResetOtp(email, otp);
      final verifyOtpResponse = VerifyResetOtpResponse.fromJson(response);
      return verifyOtpResponse;
    } catch (e) {
      throw Exception('Failed to verify otp: ${e.toString()}');
    }
  }

  //  Reset Password Api
  Future<ChangePasswordResponse> resetPassword(String token ,String password) async {
    try {
      final response = await _api.resetPassword(token,password);
      final changePasswordResponse = ChangePasswordResponse.fromJson(response);
      return changePasswordResponse;
    } catch (e) {
      throw Exception('Failed to Reset Password: ${e.toString()}');
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