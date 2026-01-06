/// Base Exception class for Data Layer.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException({required this.message, this.statusCode});

  @override
  String toString() => 'AppException: $message (Code: $statusCode)';
}

/// Server Exception (API / Network errors).
class ServerException extends AppException {
  ServerException({required super.message, super.statusCode});
}

/// Cache Exception (Local Storage errors).
class CacheException extends AppException {
  CacheException({required super.message});
}

/// Auth Exception (Token expired, unauthorized).
class AuthException extends AppException {
  AuthException({required super.message, super.statusCode});
}
