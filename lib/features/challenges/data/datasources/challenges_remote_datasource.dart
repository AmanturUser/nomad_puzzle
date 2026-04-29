import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../models/challenge_model.dart';

abstract class ChallengesRemoteDataSource {
  Future<List<ChallengeModel>> getChallenges();
  Future<ChallengeModel> getChallenge(String id);
  Future<void> completeChallenge(String id, List<String> photoPaths);
}

@LazySingleton(as: ChallengesRemoteDataSource, env: ['prod'])
class ChallengesRemoteDataSourceImpl implements ChallengesRemoteDataSource {
  ChallengesRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ChallengeModel>> getChallenges() async {
    try {
      final response = await _dio.get<dynamic>(ApiConstants.challenges);
      final data = response.data;
      // Server returns either `[...]` or `{ "items": [...] }`. Handle both.
      final raw = data is List
          ? data
          : (data is Map && data['items'] is List
              ? data['items'] as List
              : <dynamic>[]);
      return raw
          .cast<Map<String, dynamic>>()
          .map(ChallengeModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load challenges');
    }
  }

  @override
  Future<ChallengeModel> getChallenge(String id) async {
    try {
      final intId = int.tryParse(id);
      if (intId == null) throw const ServerException('Invalid challenge id');
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.challengeById(intId),
      );
      return ChallengeModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load challenge');
    }
  }

  @override
  Future<void> completeChallenge(
    String id,
    List<String> photoPaths,
  ) async {
    final intId = int.tryParse(id);
    if (intId == null) throw const ServerException('Invalid challenge id');
    if (photoPaths.isEmpty) {
      throw const ServerException(
        'Нужно прикрепить хотя бы одно фото — подтвердите визит через карту',
      );
    }
    try {
      final form = FormData();
      for (final path in photoPaths) {
        form.files.add(
          MapEntry('photos', await MultipartFile.fromFile(path)),
        );
      }
      await _dio.post<dynamic>(
        ApiConstants.submitChallenge(intId),
        data: form,
        options: Options(contentType: 'multipart/form-data'),
      );
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e) ?? 'Failed to submit challenge');
    }
  }

  String? _extractMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['error'] is String) return data['error'] as String;
    if (data is Map && data['message'] is String) return data['message'] as String;
    return e.message;
  }
}
