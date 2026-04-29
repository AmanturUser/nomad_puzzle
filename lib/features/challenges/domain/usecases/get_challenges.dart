import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/challenge.dart';
import '../repositories/challenges_repository.dart';

@injectable
class GetChallenges implements UseCase<List<Challenge>, NoParams> {
  GetChallenges(this._repository);

  final ChallengesRepository _repository;

  @override
  Future<Either<Failure, List<Challenge>>> call(NoParams params) =>
      _repository.getChallenges();
}

@injectable
class GetChallenge implements UseCase<Challenge, String> {
  GetChallenge(this._repository);

  final ChallengesRepository _repository;

  @override
  Future<Either<Failure, Challenge>> call(String id) =>
      _repository.getChallenge(id);
}

class CompleteChallengeParams {
  const CompleteChallengeParams({
    required this.id,
    this.photoPaths = const [],
  });

  final String id;
  final List<String> photoPaths;
}

@injectable
class CompleteChallenge implements UseCase<Unit, CompleteChallengeParams> {
  CompleteChallenge(this._repository);

  final ChallengesRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(CompleteChallengeParams params) =>
      _repository.completeChallenge(params.id, params.photoPaths);
}
