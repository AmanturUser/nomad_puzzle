import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/captured_photo.dart';
import '../repositories/camera_repository.dart';

class TakePhotoParams {
  const TakePhotoParams({this.challengeId});
  final String? challengeId;
}

@injectable
class TakePhoto implements UseCase<CapturedPhoto, TakePhotoParams> {
  TakePhoto(this._repository);

  final CameraRepository _repository;

  @override
  Future<Either<Failure, CapturedPhoto>> call(TakePhotoParams params) =>
      _repository.takePhoto(challengeId: params.challengeId);
}

@injectable
class PickFromGallery implements UseCase<CapturedPhoto, TakePhotoParams> {
  PickFromGallery(this._repository);

  final CameraRepository _repository;

  @override
  Future<Either<Failure, CapturedPhoto>> call(TakePhotoParams params) =>
      _repository.pickFromGallery(challengeId: params.challengeId);
}

@injectable
class RequestCameraPermission implements UseCase<bool, NoParams> {
  RequestCameraPermission(this._repository);

  final CameraRepository _repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) =>
      _repository.requestPermission();
}
