part of 'challenge_details_bloc.dart';

enum ChallengeDetailsStatus { initial, loading, success, failure }

final class ChallengeDetailsState extends Equatable {
  const ChallengeDetailsState({
    this.status = ChallengeDetailsStatus.initial,
    this.challenge,
    this.errorMessage,
  });

  final ChallengeDetailsStatus status;
  final Challenge? challenge;
  final String? errorMessage;

  ChallengeDetailsState copyWith({
    ChallengeDetailsStatus? status,
    Challenge? challenge,
    String? errorMessage,
  }) {
    return ChallengeDetailsState(
      status: status ?? this.status,
      challenge: challenge ?? this.challenge,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, challenge, errorMessage];
}
