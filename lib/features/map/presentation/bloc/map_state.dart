part of 'map_bloc.dart';

enum MapStatus { initial, loading, success, failure }

final class MapState extends Equatable {
  const MapState({
    this.status = MapStatus.initial,
    this.challenges = const [],
    this.submittingChallengeId,
    this.justCompletedChallengeId,
    this.errorMessage,
  });

  final MapStatus status;
  final List<Challenge> challenges;
  final String? submittingChallengeId;
  final String? justCompletedChallengeId;
  final String? errorMessage;

  MapState copyWith({
    MapStatus? status,
    List<Challenge>? challenges,
    String? submittingChallengeId,
    String? justCompletedChallengeId,
    String? errorMessage,
  }) {
    return MapState(
      status: status ?? this.status,
      challenges: challenges ?? this.challenges,
      submittingChallengeId: submittingChallengeId,
      justCompletedChallengeId: justCompletedChallengeId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        challenges,
        submittingChallengeId,
        justCompletedChallengeId,
        errorMessage,
      ];
}
