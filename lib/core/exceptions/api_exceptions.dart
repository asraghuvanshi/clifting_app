sealed class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  const ApiException(this.message, {this.statusCode});
  
  @override
  String toString() => 'ApiException: $message';
}

class NetworkException extends ApiException {
  const NetworkException(super.message);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException() 
      : super('Your session has expired. Please login again.', statusCode: 401);
}

class BadRequestException extends ApiException {
  const BadRequestException(super.message) : super(statusCode: 400);
}

class NotFoundException extends ApiException {
  const NotFoundException() : super('Resource not found', statusCode: 404);
}

class ServerException extends ApiException {
  const ServerException() : super('Server error. Please try again later.', statusCode: 500);
}

class TimeoutException extends ApiException {
  const TimeoutException() : super('Request timed out. Please check your connection.');
}

class UnknownException extends ApiException {
  const UnknownException(super.message);
}