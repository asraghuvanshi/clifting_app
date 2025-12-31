import 'package:clifting_app/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout:
                const Duration(milliseconds: ApiConstants.connectTimeout),
            receiveTimeout:
                const Duration(milliseconds: ApiConstants.receiveTimeout),
            headers: {
              'content-type': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  //  POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) {
    return _dio.post(
      path,
      data: data,
      options: Options(headers: headers),
    );
  }

  //  GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? query,
  }) {
    return _dio.get(path, queryParameters: query);
  }
}