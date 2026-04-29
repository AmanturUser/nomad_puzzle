part of 'challenges_bloc.dart';

sealed class ChallengesEvent extends Equatable {
  const ChallengesEvent();

  @override
  List<Object?> get props => const [];
}

final class ChallengesRequested extends ChallengesEvent {
  const ChallengesRequested();
}

final class ChallengeCompleted extends ChallengesEvent {
  const ChallengeCompleted(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}
