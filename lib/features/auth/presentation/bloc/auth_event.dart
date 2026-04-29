part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => const [];
}

final class AuthBootstrapRequested extends AuthEvent {
  const AuthBootstrapRequested();
}

final class AuthLoginSubmitted extends AuthEvent {
  const AuthLoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

final class AuthRegisterSubmitted extends AuthEvent {
  const AuthRegisterSubmitted({
    required this.email,
    required this.password,
    required this.fullName,
    required this.nickName,
    required this.countryId,
  });

  final String email;
  final String password;
  final String fullName;
  final String nickName;
  final int countryId;

  @override
  List<Object?> get props => [email, password, fullName, nickName, countryId];
}

final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}
