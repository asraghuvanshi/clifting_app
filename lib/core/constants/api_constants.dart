abstract class ApiConstants {
  static const String baseUrl = 'http://10.172.185.191:8080/api';
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String validateToken = '/auth/validate';
  
  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
}