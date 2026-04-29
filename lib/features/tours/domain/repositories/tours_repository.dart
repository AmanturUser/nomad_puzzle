import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/tour.dart';

abstract class ToursRepository {
  Future<Either<Failure, List<Tour>>> getTours();
  Future<Either<Failure, Tour>> getTour(String id);
  Future<Either<Failure, List<TourDeparture>>> getDepartures(String id);
}
