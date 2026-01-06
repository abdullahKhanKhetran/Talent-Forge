part of 'auth_bloc.dart';

/// Base class for all auth events.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to trigger login.
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event to trigger registration.
class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String? role;
  final int? departmentId;
  final String? designation;
  final String? phone;

  const RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
    this.role,
    this.departmentId,
    this.designation,
    this.phone,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    role,
    departmentId,
    designation,
    phone,
  ];
}

/// Event to trigger logout.
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

/// Event to check existing auth status.
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}
