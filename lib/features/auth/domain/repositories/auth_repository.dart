import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthSession>> register({
    required String email,
    required String password,
    required String fullName,
    required String nickName,
    required int countryId,
  });

  Future<void> signOut();

  Future<String?> currentToken();
}
