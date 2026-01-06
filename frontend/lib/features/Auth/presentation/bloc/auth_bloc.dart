import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/common/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// AuthBloc handles authentication state management.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    // on<RegisterEvent>(_onRegister); // Todo: Implement Register in Repository if needed
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  /// Handle login event.
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _authRepository.signInWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  /// Handle logout event.
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    await _authRepository.signOut();
    emit(const Unauthenticated());
  }

  /// Check existing auth status on app start.
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authRepository.getCurrentUser();

    result.fold(
      (failure) => emit(const Unauthenticated()),
      (user) => emit(Authenticated(user: user)),
    );
  }
}
