import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/challenge.dart';

abstract class ChallengesRepository {
  Future<Either<Failure, List<Challenge>>> getChallenges();
  Future<Either<Failure, Challenge>> getChallenge(String id);
  Future<Either<Failure, Unit>> completeChallenge(
    String id,
    List<String> photoPaths,
  );
}
