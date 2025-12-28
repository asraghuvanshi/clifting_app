import 'package:clifting_app/core/router/app_navigator.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      AppNavigator.toLogin(clearStack: true);
    }
    super.onError(err, handler);
  }
}
