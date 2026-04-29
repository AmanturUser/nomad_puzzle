import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/challenge.dart';
import '../../domain/repositories/challenges_repository.dart';
import '../datasources/challenges_remote_datasource.dart';

@LazySingleton(as: ChallengesRepository)
class ChallengesRepositoryImpl implements ChallengesRepository {
  ChallengesRepositoryImpl(this._remote);

  final ChallengesRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<Challenge>>> getChallenges() async {
    try {
      final models = await _remote.getChallenges();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Challenge>> getChallenge(String id) async {
    try {
      final model = await _remote.getChallenge(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> completeChallenge(
    String id,
    List<String> photoPaths,
  ) async {
    try {
      await _remote.completeChallenge(id, photoPaths);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
