part of 'challenges_bloc.dart';

enum ChallengesStatus { initial, loading, success, failure }

final class ChallengesState extends Equatable {
  const ChallengesState({
    this.status = ChallengesStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  final ChallengesStatus status;
  final List<Challenge> items;
  final String? errorMessage;

  ChallengesState copyWith({
    ChallengesStatus? status,
    List<Challenge>? items,
    String? errorMessage,
  }) {
    return ChallengesState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
