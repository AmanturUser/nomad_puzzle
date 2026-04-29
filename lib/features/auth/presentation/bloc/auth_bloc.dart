import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@singleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._login,
    this._register,
    this._signOut,
    this._repository,
  ) : super(const AuthState.initial()) {
    on<AuthBootstrapRequested>(_onBootstrap);
    on<AuthLoginSubmitted>(_onLogin);
    on<AuthRegisterSubmitted>(_onRegister);
    on<AuthSignOutRequested>(_onSignOut);
  }

  final Login _login;
  final Register _register;
  final SignOutUser _signOut;
  final AuthRepository _repository;

  Future<void> _onBootstrap(
    AuthBootstrapRequested event,
    Emitter<AuthState> emit,
  ) async {
    final token = await _repository.currentToken();
    if (token != null && token.isNotEmpty) {
      emit(const AuthState.authenticated());
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLogin(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _login(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (f) => emit(AuthState.failure(f.message)),
      (session) => emit(AuthState.authenticated(user: session.user)),
    );
  }

  Future<void> _onRegister(
    AuthRegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _register(
      RegisterParams(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        nickName: event.nickName,
        countryId: event.countryId,
      ),
    );
    result.fold(
      (f) => emit(AuthState.failure(f.message)),
      (session) => emit(AuthState.authenticated(user: session.user)),
    );
  }

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _signOut(const NoParams());
    emit(const AuthState.unauthenticated());
  }
}
