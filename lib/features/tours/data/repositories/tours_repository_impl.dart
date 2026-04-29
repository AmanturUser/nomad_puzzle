import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/tour.dart';
import '../../domain/repositories/tours_repository.dart';
import '../datasources/tours_remote_datasource.dart';

@LazySingleton(as: ToursRepository)
class ToursRepositoryImpl implements ToursRepository {
  ToursRepositoryImpl(this._remote);

  final ToursRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<Tour>>> getTours() async {
    try {
      final models = await _remote.getTours();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Tour>> getTour(String id) async {
    try {
      final model = await _remote.getTour(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TourDeparture>>> getDepartures(String id) async {
    try {
      final models = await _remote.getDepartures(id);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
