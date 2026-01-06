part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final User user;

  const Authenticated({required this.user});

  bool get isAdmin => user.role == 'admin';
  bool get isEmployee => user.role == 'employee';

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
