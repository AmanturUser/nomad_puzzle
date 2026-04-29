part of 'challenge_details_bloc.dart';

sealed class ChallengeDetailsEvent extends Equatable {
  const ChallengeDetailsEvent();

  @override
  List<Object?> get props => const [];
}

final class ChallengeDetailsRequested extends ChallengeDetailsEvent {
  const ChallengeDetailsRequested(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

final class ChallengeDetailsCompleted extends ChallengeDetailsEvent {
  const ChallengeDetailsCompleted(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}
