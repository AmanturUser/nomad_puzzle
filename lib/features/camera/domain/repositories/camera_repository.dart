import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/captured_photo.dart';

abstract class CameraRepository {
  Future<Either<Failure, bool>> requestPermission();
  Future<Either<Failure, CapturedPhoto>> takePhoto({String? challengeId});
  Future<Either<Failure, CapturedPhoto>> pickFromGallery({String? challengeId});
}
