part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => const [];
}

final class MapChallengesRequested extends MapEvent {
  const MapChallengesRequested();
}

final class MapChallengeVisitSubmitted extends MapEvent {
  const MapChallengeVisitSubmitted({
    required this.challengeId,
    required this.photoPaths,
  });

  final String challengeId;
  final List<String> photoPaths;

  @override
  List<Object?> get props => [challengeId, photoPaths];
}

final class _MapStreamEventReceived extends MapEvent {
  const _MapStreamEventReceived(this.event);

  final SubmissionEvent event;

  @override
  List<Object?> get props => [event];
}
