import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../../domain/entities/profile.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(ProfileUpdate patch);
  Future<String> uploadAvatar(String filePath);

  /// Counts approved submissions, paid bookings and reviews for the stats card.
  Future<({int submissions, int bookings, int reviews})> getStats();

  Future<void> signOut();
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>(ApiConstants.me);
      return ProfileModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load profile');
    }
  }

  @override
  Future<ProfileModel> updateProfile(ProfileUpdate patch) async {
    try {
      final body = <String, dynamic>{};
      if (patch.fullName != null) body['full_name'] = patch.fullName;
      if (patch.nickName != null) body['nick_name'] = patch.nickName;
      if (patch.phone != null) body['phone'] = patch.phone;
      if (patch.bio != null) body['bio'] = patch.bio;
      if (patch.birthDate != null) {
        body['birth_date'] =
            patch.birthDate!.toIso8601String().split('T').first;
      }
      if (patch.countryId != null) body['country_id'] = patch.countryId;
      if (patch.languages != null) body['languages'] = patch.languages;
      if (patch.latitude != null) body['latitude'] = patch.latitude;
      if (patch.longitude != null) body['longitude'] = patch.longitude;

      final response = await _dio.patch<Map<String, dynamic>>(
        ApiConstants.me,
        data: body,
      );
      return ProfileModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to update profile');
    }
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    try {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.meAvatar,
        data: form,
      );
      final data = response.data ?? const <String, dynamic>{};
      final url = data['avatar_url'] ?? data['url'] ?? '';
      return url is String ? url : '';
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to upload avatar');
    }
  }

  @override
  Future<({int submissions, int bookings, int reviews})> getStats() async {
    Future<int> countList(String path, {Map<String, dynamic>? query}) async {
      try {
        final res = await _dio.get<List<dynamic>>(
          path,
          queryParameters: query,
        );
        return (res.data ?? const []).length;
      } on DioException {
        return 0;
      }
    }

    final results = await Future.wait([
      countList(ApiConstants.meSubmissions, query: {'status': 'approved'}),
      countList(ApiConstants.meBookings),
      countList(ApiConstants.meReviews),
    ]);
    return (
      submissions: results[0],
      bookings: results[1],
      reviews: results[2],
    );
  }

  @override
  Future<void> signOut() async {
    // The /auth/logout endpoint requires a refresh token; we currently only
    // store the access token, so just no-op here. The repository clears the
    // local access token after this returns.
  }
}
