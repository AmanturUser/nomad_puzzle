import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/captured_photo.dart';
import '../../domain/repositories/camera_repository.dart';
import '../datasources/camera_datasource.dart';

@LazySingleton(as: CameraRepository)
class CameraRepositoryImpl implements CameraRepository {
  CameraRepositoryImpl(this._dataSource);

  final CameraDataSource _dataSource;

  @override
  Future<Either<Failure, bool>> requestPermission() async {
    try {
      final granted = await _dataSource.requestPermission();
      return Right(granted);
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CapturedPhoto>> takePhoto({String? challengeId}) =>
      _capture(_dataSource.takePhoto, challengeId);

  @override
  Future<Either<Failure, CapturedPhoto>> pickFromGallery({
    String? challengeId,
  }) =>
      _capture(_dataSource.pickFromGallery, challengeId);

  Future<Either<Failure, CapturedPhoto>> _capture(
    Future<String?> Function() fn,
    String? challengeId,
  ) async {
    try {
      final path = await fn();
      if (path == null) return const Left(UnknownFailure('Cancelled'));
      return Right(
        CapturedPhoto(
          path: path,
          takenAt: DateTime.now(),
          challengeId: challengeId,
        ),
      );
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
