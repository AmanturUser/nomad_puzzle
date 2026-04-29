import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

@injectable
class GetProfile implements UseCase<Profile, NoParams> {
  GetProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, Profile>> call(NoParams params) =>
      _repository.getProfile();
}

@injectable
class UpdateProfile {
  UpdateProfile(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, Profile>> call(ProfileUpdate patch) =>
      _repository.updateProfile(patch);
}

@injectable
class UploadAvatar {
  UploadAvatar(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, String>> call(String filePath) =>
      _repository.uploadAvatar(filePath);
}

@injectable
class GetProfileStats {
  GetProfileStats(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, ({int submissions, int bookings, int reviews})>>
      call() => _repository.getStats();
}

@injectable
class SignOut implements UseCase<Unit, NoParams> {
  SignOut(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) => _repository.signOut();
}
