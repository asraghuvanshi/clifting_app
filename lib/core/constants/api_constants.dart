abstract class ApiConstants {
  static const String baseUrl = 'http://10.43.211.191:8080/api';

  static const String login = '/auth/login';
  static const String forgetPassword = "/auth/forgot-password";
  static const String verifyResetOtp = "/auth/verify-reset-otp";
  static const String resetPassword = '/auth/reset-password';
  static const String userProfile = '/api/user/profile';

  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String validateToken = '/auth/validate';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
}
