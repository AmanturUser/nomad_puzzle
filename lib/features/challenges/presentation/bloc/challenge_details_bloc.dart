import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/challenge.dart';
import '../../domain/usecases/get_challenges.dart';

part 'challenge_details_event.dart';
part 'challenge_details_state.dart';

@injectable
class ChallengeDetailsBloc
    extends Bloc<ChallengeDetailsEvent, ChallengeDetailsState> {
  ChallengeDetailsBloc(this._getChallenge, this._completeChallenge)
      : super(const ChallengeDetailsState()) {
    on<ChallengeDetailsRequested>(_onRequested);
    on<ChallengeDetailsCompleted>(_onCompleted);
  }

  final GetChallenge _getChallenge;
  final CompleteChallenge _completeChallenge;

  Future<void> _onRequested(
    ChallengeDetailsRequested event,
    Emitter<ChallengeDetailsState> emit,
  ) async {
    emit(state.copyWith(status: ChallengeDetailsStatus.loading));
    final result = await _getChallenge(event.id);
    result.fold(
      (f) => emit(state.copyWith(
        status: ChallengeDetailsStatus.failure,
        errorMessage: f.message,
      )),
      (item) => emit(state.copyWith(
        status: ChallengeDetailsStatus.success,
        challenge: item,
      )),
    );
  }

  Future<void> _onCompleted(
    ChallengeDetailsCompleted event,
    Emitter<ChallengeDetailsState> emit,
  ) async {
    final result = await _completeChallenge(
      CompleteChallengeParams(id: event.id),
    );
    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (_) => add(ChallengeDetailsRequested(event.id)),
    );
  }
}
