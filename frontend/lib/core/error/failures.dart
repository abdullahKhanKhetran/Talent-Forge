import 'package:equatable/equatable.dart';

/// Base Failure class for Domain Layer.
/// Used with dartz Either<Failure, Success> pattern.
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Server Failure (API / Network errors).
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Cache Failure (Local Storage errors).
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Auth Failure (Token expired, unauthorized).
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.statusCode});
}

/// Validation Failure (Input validation).
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Network Failure (No internet connection).
class NetworkFailure extends Failure {
  const NetworkFailure() : super(message: 'No internet connection');
}
