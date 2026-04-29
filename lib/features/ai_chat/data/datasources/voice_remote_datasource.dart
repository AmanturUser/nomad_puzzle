import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_constants.dart';

abstract class VoiceRemoteDataSource {
  Future<String> transcribe(String audioPath, {String language});
  Future<Uint8List> synthesize(String text, {String? voice});
}

@LazySingleton(as: VoiceRemoteDataSource)
class VoiceRemoteDataSourceImpl implements VoiceRemoteDataSource {
  VoiceRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<String> transcribe(String audioPath, {String language = 'auto'}) async {
    try {
      final form = FormData.fromMap({
        'audio': await MultipartFile.fromFile(audioPath, filename: 'audio.m4a'),
      });
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.voiceTranscribe,
        data: form,
        queryParameters: {'language': language},
      );
      final data = response.data ?? const {};
      // Backend returns {text: "..."} or similar; fall back to first string value.
      final text = data['text'] ?? data['transcription'] ?? data['result'];
      if (text is String) return text;
      for (final v in data.values) {
        if (v is String) return v;
      }
      return '';
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to transcribe audio');
    }
  }

  @override
  Future<Uint8List> synthesize(String text, {String? voice}) async {
    try {
      final response = await _dio.post<List<int>>(
        ApiConstants.voiceSynthesize,
        data: {'text': text, if (voice != null) 'voice': voice},
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data ?? const []);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to synthesize speech');
    }
  }
}
