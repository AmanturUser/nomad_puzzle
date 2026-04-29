import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({required this.email, required this.password});
  final String email;
  final String password;
}

class RegisterParams {
  const RegisterParams({
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
}

@injectable
class Login implements UseCase<AuthSession, LoginParams> {
  Login(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthSession>> call(LoginParams params) =>
      _repository.login(email: params.email, password: params.password);
}

@injectable
class Register implements UseCase<AuthSession, RegisterParams> {
  Register(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthSession>> call(RegisterParams params) =>
      _repository.register(
        email: params.email,
        password: params.password,
        fullName: params.fullName,
        nickName: params.nickName,
        countryId: params.countryId,
      );
}

@injectable
class SignOutUser implements UseCase<void, NoParams> {
  SignOutUser(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    await _repository.signOut();
    return const Right(null);
  }
}
