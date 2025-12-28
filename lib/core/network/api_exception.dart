class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  bool get isNoInternet => message == 'NO_INTERNET';
  bool get isTokenExpired => statusCode == 401;
}
