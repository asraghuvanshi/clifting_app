import 'package:clifting_app/core/constants/api_constants.dart';
import 'package:clifting_app/core/network/api_client.dart';

class UserProfileApi {
  final ApiClient _apiClient;

  UserProfileApi(this._apiClient);

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.userProfile
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}