import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/tour.dart';
import '../repositories/tours_repository.dart';

@injectable
class GetTours implements UseCase<List<Tour>, NoParams> {
  GetTours(this._repository);

  final ToursRepository _repository;

  @override
  Future<Either<Failure, List<Tour>>> call(NoParams params) =>
      _repository.getTours();
}

@injectable
class GetTour implements UseCase<Tour, String> {
  GetTour(this._repository);

  final ToursRepository _repository;

  @override
  Future<Either<Failure, Tour>> call(String id) => _repository.getTour(id);
}

@injectable
class GetTourDepartures implements UseCase<List<TourDeparture>, String> {
  GetTourDepartures(this._repository);

  final ToursRepository _repository;

  @override
  Future<Either<Failure, List<TourDeparture>>> call(String id) =>
      _repository.getDepartures(id);
}
