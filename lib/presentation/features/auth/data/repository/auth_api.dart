import 'package:clifting_app/core/constants/api_constants.dart';
import 'package:clifting_app/core/network/api_client.dart';

class AuthApi {
  final ApiClient _apiClient;

  AuthApi(this._apiClient);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  
  Future<Map<String, dynamic>> forgetPassword(String email) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.forgetPassword,
        data: {
          'email': email
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

    
  Future<Map<String, dynamic>> verifyResetOtp(String email, String otp) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.verifyResetOtp,
        data: {
          'email': email,
          'otp' : otp
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

//  Reset password after otp verification
  Future<Map<String, dynamic>> resetPassword(String token,String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.resetPassword,
        data: {
          'reset_token': token,
          'new_password': password,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

}