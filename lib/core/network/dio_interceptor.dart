import 'package:dio/dio.dart';
import 'package:clifting_app/core/constants/api_constants.dart';
import 'package:clifting_app/core/exceptions/api_exceptions.dart';
import 'package:clifting_app/core/services/storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class DioInterceptor extends Interceptor {
  final StorageService storageService;
  final Dio dio;
  
  DioInterceptor({required this.storageService, required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
  

    final token = await storageService.getAccessToken();
      // Add auth token to headers
        debugPrint('=== REQUEST INTERCEPTOR ===');
    debugPrint('URL: ${options.baseUrl}${options.path}');
    debugPrint('Method: ${options.method}');
    
    // Add auth token to headers
    debugPrint('Token from storage: ${token ?? "NULL"}');
    debugPrint('Token length: ${token?.length ?? 0}');
    
    if (token != null) {
      options.headers[ApiConstants.authorization] = 'Bearer $token';
    }
    
    options.headers['Content-Type'] = ApiConstants.contentType;
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;
    
    ApiException apiException;
    if (kDebugMode) {
      print("${err}");
    }
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        apiException = const TimeoutException();
        break;
        
      case DioExceptionType.connectionError:
        apiException = const NetworkException('No internet connection');
        break;
        
      case DioExceptionType.badResponse:
        switch (statusCode) {
          case 400:
            final message = _getErrorMessage(data) ?? 'Bad request';
            apiException = BadRequestException(message);
            break;
          case 401:
            apiException = const UnauthorizedException();
            break;
          case 404:
            apiException = const NotFoundException();
            break;
          case 500:
            apiException = const ServerException();
            break;
          default:
            final message = _getErrorMessage(data) ?? 'Unknown error occurred';
            apiException = UnknownException(message);
        }
        break;
        
      default:
        apiException = UnknownException(err.message ?? 'Unknown error');
    }
    
    handler.reject(err.copyWith(error: apiException));
  }
  
  String? _getErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'];
    } else if (data is String) {
      return data;
    }
    return null;
  }
}