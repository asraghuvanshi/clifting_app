
import 'package:clifting_app/presentation/features/auth/data/datasource/api_client.dart';
import 'package:clifting_app/presentation/features/auth/data/datasource/local_storage.dart';
import 'package:clifting_app/presentation/features/auth/data/model/login_model.dart';
import 'package:clifting_app/presentation/features/auth/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient = ApiClient();
  final LocalStorage _localStorage = LocalStorage();
  
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        '/api/auth/login',
        data: request.toJson(),
      );
      
      final loginResponse = LoginResponse.fromJson(response.data);
      
      // Save token and user data
      await _localStorage.saveToken(loginResponse.accessToken ?? "");
      await _localStorage.saveUserData(loginResponse.user!.toJson());
      
      return loginResponse;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  @override
  Future<void> signup(Map<String, dynamic> userData) async {
    try {
      await _apiClient.post(
        '/api/auth/signup',
        data: userData,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  @override
  Future<void> logout() async {
    await _localStorage.clearToken();
    await _localStorage.clearAll();
  }
  
  @override
  Future<bool> isLoggedIn() async {
    final token = await _localStorage.getToken();
    return token != null;
  }
  
  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please check your internet.';
        case DioExceptionType.badResponse:
          return error.response?.data['message'] ?? 'Something went wrong';
        case DioExceptionType.cancel:
          return 'Request was cancelled';
        default:
          return 'Network error. Please try again.';
      }
    }
    return error.toString();
  }
}