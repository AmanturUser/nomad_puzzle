import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../challenges/domain/entities/challenge.dart';
import '../../../challenges/domain/usecases/get_challenges.dart';
import '../../../submissions/domain/entities/submission_event.dart';
import '../../../submissions/domain/repositories/submissions_stream_repository.dart';

part 'map_event.dart';
part 'map_state.dart';

@injectable
class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc(
    this._getChallenges,
    this._completeChallenge,
    this._streamRepo,
  ) : super(const MapState()) {
    on<MapChallengesRequested>(_onRequested);
    on<MapChallengeVisitSubmitted>(_onVisitSubmitted);
    on<_MapStreamEventReceived>(_onStreamEvent);

    _streamSub = _streamRepo.watch().listen(
      (event) => add(_MapStreamEventReceived(event)),
      onError: (_) {},
    );
  }

  final GetChallenges _getChallenges;
  final CompleteChallenge _completeChallenge;
  final SubmissionsStreamRepository _streamRepo;
  late final StreamSubscription<SubmissionEvent> _streamSub;

  /// challenge_id (int from API) → user-visible challenge id (String).
  /// Stored when the user submits a photo so SSE events can be routed back.
  final Map<int, String> _activeSubmissions = {};

  @override
  Future<void> close() async {
    await _streamSub.cancel();
    return super.close();
  }

  Future<void> _onRequested(
    MapChallengesRequested event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(status: MapStatus.loading));
    final result = await _getChallenges(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(
        status: MapStatus.failure,
        errorMessage: f.message,
      )),
      (challenges) => emit(state.copyWith(
        status: MapStatus.success,
        challenges: challenges,
      )),
    );
  }

  Future<void> _onVisitSubmitted(
    MapChallengeVisitSubmitted event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(
      challenges: _patchStatus(
        state.challenges,
        event.challengeId,
        ChallengeStatus.inProgress,
      ),
      submittingChallengeId: event.challengeId,
    ));

    final intId = int.tryParse(event.challengeId);
    if (intId != null) _activeSubmissions[intId] = event.challengeId;

    final result = await _completeChallenge(
      CompleteChallengeParams(
        id: event.challengeId,
        photoPaths: event.photoPaths,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(
        challenges: _patchStatus(
          state.challenges,
          event.challengeId,
          ChallengeStatus.available,
        ),
        submittingChallengeId: null,
        errorMessage: f.message,
      )),
      // Server accepted the upload (201). The AI verdict will arrive via SSE
      // — we keep status = inProgress here and flip to completed/available
      // once `result` event lands.
      (_) => emit(state.copyWith(submittingChallengeId: null)),
    );
  }

  Future<void> _onStreamEvent(
    _MapStreamEventReceived event,
    Emitter<MapState> emit,
  ) async {
    final raw = event.event;
    developer.log('${raw.runtimeType}', name: 'map.sse');
    if (raw is SubmissionResultReceived) {
      final challengeId = _activeSubmissions[raw.challengeId] ??
          raw.challengeId.toString();
      developer.log(
        'result for challenge=$challengeId status=${raw.status.name} confidence=${raw.confidence}',
        name: 'map.sse',
      );
      if (raw.isApproved) {
        emit(state.copyWith(
          challenges: _patchStatus(
            state.challenges,
            challengeId,
            ChallengeStatus.completed,
          ),
          justCompletedChallengeId: challengeId,
        ));
      } else {
        emit(state.copyWith(
          challenges: _patchStatus(
            state.challenges,
            challengeId,
            ChallengeStatus.available,
          ),
          errorMessage: raw.reasoning ?? 'Фото не подтверждает визит',
        ));
      }
      _activeSubmissions.remove(raw.challengeId);
    } else if (raw is SubmissionFailed) {
      developer.log('failed: ${raw.error}', name: 'map.sse');
      emit(state.copyWith(errorMessage: raw.error));
    }
  }

  List<Challenge> _patchStatus(
    List<Challenge> list,
    String id,
    ChallengeStatus newStatus,
  ) =>
      list
          .map((c) => c.id == id ? c.copyWith(status: newStatus) : c)
          .toList(growable: false);
}
