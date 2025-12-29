
import 'package:clifting_app/core/constants/api_constants.dart';
import 'package:clifting_app/core/network/api_client.dart';

class AuthApi {
  final ApiClient api;
  AuthApi(this.api);

  Future<Map<String, dynamic>> login(Map<String, dynamic> params) async {
    final response =
        await api.post(ApiConstants.login, data: params);
    return response.data;
  }
}