import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/voice_repository.dart';
import '../datasources/voice_remote_datasource.dart';

@LazySingleton(as: VoiceRepository)
class VoiceRepositoryImpl implements VoiceRepository {
  VoiceRepositoryImpl(this._remote);

  final VoiceRemoteDataSource _remote;

  @override
  Future<Either<Failure, String>> transcribe(String audioPath,
      {String language = 'auto'}) async {
    try {
      final text = await _remote.transcribe(audioPath, language: language);
      return Right(text);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Uint8List>> synthesize(String text, {String? voice}) async {
    try {
      final bytes = await _remote.synthesize(text, voice: voice);
      return Right(bytes);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
