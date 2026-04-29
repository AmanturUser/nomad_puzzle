import 'package:equatable/equatable.dart';

enum SubmissionVerdict { processing, approved, rejected, failed }

sealed class SubmissionEvent extends Equatable {
  const SubmissionEvent();
}

class SubmissionConnected extends SubmissionEvent {
  const SubmissionConnected({required this.userId});
  final int userId;

  @override
  List<Object?> get props => [userId];
}

class SubmissionStatusChanged extends SubmissionEvent {
  const SubmissionStatusChanged({
    required this.submissionId,
    required this.status,
  });

  final int submissionId;
  final SubmissionVerdict status;

  @override
  List<Object?> get props => [submissionId, status];
}

class SubmissionResultReceived extends SubmissionEvent {
  const SubmissionResultReceived({
    required this.submissionId,
    required this.challengeId,
    required this.status,
    this.confidence,
    this.reasoning,
  });

  final int submissionId;
  final int challengeId;
  final SubmissionVerdict status;
  final double? confidence;
  final String? reasoning;

  bool get isApproved => status == SubmissionVerdict.approved;

  @override
  List<Object?> get props =>
      [submissionId, challengeId, status, confidence, reasoning];
}

class SubmissionFailed extends SubmissionEvent {
  const SubmissionFailed({required this.submissionId, required this.error});

  final int submissionId;
  final String error;

  @override
  List<Object?> get props => [submissionId, error];
}
