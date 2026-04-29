import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();
  Future<Either<Failure, Profile>> updateProfile(ProfileUpdate patch);
  Future<Either<Failure, String>> uploadAvatar(String filePath);
  Future<Either<Failure, ({int submissions, int bookings, int reviews})>>
      getStats();
  Future<Either<Failure, Unit>> signOut();
}
