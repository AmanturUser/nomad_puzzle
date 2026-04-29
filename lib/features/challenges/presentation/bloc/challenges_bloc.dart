import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/challenge.dart';
import '../../domain/usecases/get_challenges.dart';

part 'challenges_event.dart';
part 'challenges_state.dart';

@injectable
class ChallengesBloc extends Bloc<ChallengesEvent, ChallengesState> {
  ChallengesBloc(this._getChallenges, this._completeChallenge)
      : super(const ChallengesState()) {
    on<ChallengesRequested>(_onRequested);
    on<ChallengeCompleted>(_onCompleted);
  }

  final GetChallenges _getChallenges;
  final CompleteChallenge _completeChallenge;

  Future<void> _onRequested(
    ChallengesRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    emit(state.copyWith(status: ChallengesStatus.loading));
    final result = await _getChallenges(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(
        status: ChallengesStatus.failure,
        errorMessage: f.message,
      )),
      (items) => emit(state.copyWith(
        status: ChallengesStatus.success,
        items: items,
      )),
    );
  }

  Future<void> _onCompleted(
    ChallengeCompleted event,
    Emitter<ChallengesState> emit,
  ) async {
    final result = await _completeChallenge(
      CompleteChallengeParams(id: event.id),
    );
    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (_) => add(const ChallengesRequested()),
    );
  }
}
