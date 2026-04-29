import 'package:equatable/equatable.dart';

class CapturedPhoto extends Equatable {
  const CapturedPhoto({
    required this.path,
    required this.takenAt,
    this.challengeId,
  });

  final String path;
  final DateTime takenAt;
  final String? challengeId;

  @override
  List<Object?> get props => [path, takenAt, challengeId];
}
