import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../models/tour_model.dart';

abstract class ToursRemoteDataSource {
  Future<List<TourModel>> getTours();
  Future<TourModel> getTour(String id);
  Future<List<TourDepartureModel>> getDepartures(String id);
}

@LazySingleton(as: ToursRemoteDataSource)
class ToursRemoteDataSourceImpl implements ToursRemoteDataSource {
  ToursRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<TourModel>> getTours() async {
    try {
      final response =
          await _dio.get<List<dynamic>>(ApiConstants.catalogTours);
      return (response.data ?? [])
          .cast<Map<String, dynamic>>()
          .map(TourModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load tours');
    }
  }

  @override
  Future<TourModel> getTour(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.catalogTourById(_parseId(id)),
      );
      return TourModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load tour');
    }
  }

  @override
  Future<List<TourDepartureModel>> getDepartures(String id) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiConstants.catalogTourDepartures(_parseId(id)),
      );
      return (response.data ?? [])
          .cast<Map<String, dynamic>>()
          .map(TourDepartureModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load tour departures');
    }
  }

  static int _parseId(String id) =>
      int.tryParse(id) ??
      (throw ServerException('Invalid tour id: "$id"'));
}
