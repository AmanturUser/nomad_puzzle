import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/voice_repository.dart';

@injectable
class TranscribeAudio {
  TranscribeAudio(this._repo);
  final VoiceRepository _repo;
  Future<Either<Failure, String>> call(String audioPath, {String language = 'auto'}) =>
      _repo.transcribe(audioPath, language: language);
}

@injectable
class SynthesizeSpeech {
  SynthesizeSpeech(this._repo);
  final VoiceRepository _repo;
  Future<Either<Failure, Uint8List>> call(String text, {String? voice}) =>
      _repo.synthesize(text, voice: voice);
}
