import 'package:dio/dio.dart';
import 'package:clifting_app/core/constants/api_constants.dart';
import 'package:clifting_app/core/network/dio_interceptor.dart';
import 'package:clifting_app/core/services/storage_service.dart';

class ApiClient {
  late final Dio _dio;
  final StorageService storageService;
  
  ApiClient({required this.storageService}) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
    ));
    
    _dio.interceptors.add(DioInterceptor(
      storageService: storageService,
      dio: _dio,
    ));
  }
  
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(path, queryParameters: queryParams);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      rethrow;
    }
  }
}