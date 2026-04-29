import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class VoiceRepository {
  /// Sends an audio file (wav/mp3/m4a/ogg/webm) to the backend Whisper proxy.
  /// Returns the recognised text.
  Future<Either<Failure, String>> transcribe(String audioPath, {String language = 'auto'});

  /// Sends text to the backend Piper proxy and gets back wav bytes.
  Future<Either<Failure, Uint8List>> synthesize(String text, {String? voice});
}
