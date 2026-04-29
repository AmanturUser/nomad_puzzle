import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/auth/auth_token_storage.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_models.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._tokenStorage);

  final AuthRemoteDataSource _remote;
  final AuthTokenStorage _tokenStorage;

  @override
  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remote.login(
        LoginRequestModel(email: email, password: password),
      );
      await _tokenStorage.write(response.token);
      return Right(
        AuthSession(token: response.token, user: response.user.toEntity()),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> register({
    required String email,
    required String password,
    required String fullName,
    required String nickName,
    required int countryId,
  }) async {
    try {
      final response = await _remote.register(
        RegisterRequestModel(
          email: email,
          password: password,
          fullName: fullName,
          nickName: nickName,
          countryId: countryId,
        ),
      );
      await _tokenStorage.write(response.token);
      return Right(
        AuthSession(token: response.token, user: response.user.toEntity()),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<void> signOut() => _tokenStorage.clear();

  @override
  Future<String?> currentToken() => _tokenStorage.read();
}
