class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException({required this.message, this.statusCode});

  @override
  String toString() => 'NetworkException: $message (Status: $statusCode)';
}

class ConnectionException extends NetworkException {
  const ConnectionException() : super(message: 'No internet connection');
}

class TimeoutException extends NetworkException {
  const TimeoutException() : super(message: 'Request timeout');
}

class ServerException extends NetworkException {
  const ServerException({
    required super.message,
    required int super.statusCode,
  });
}

class UnauthorizedException extends NetworkException {
  const UnauthorizedException()
    : super(message: 'Unauthorized', statusCode: 401);
}

class NotFoundException extends NetworkException {
  const NotFoundException()
    : super(message: 'Resource not found', statusCode: 404);
}
