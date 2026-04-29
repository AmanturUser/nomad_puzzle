import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/tour.dart';
import '../../domain/usecases/tours_usecases.dart';

part 'tour_details_event.dart';
part 'tour_details_state.dart';

@injectable
class TourDetailsBloc extends Bloc<TourDetailsEvent, TourDetailsState> {
  TourDetailsBloc(this._getTour, this._getDepartures)
      : super(const TourDetailsState()) {
    on<TourDetailsRequested>(_onRequested);
  }

  final GetTour _getTour;
  final GetTourDepartures _getDepartures;

  Future<void> _onRequested(
    TourDetailsRequested event,
    Emitter<TourDetailsState> emit,
  ) async {
    emit(state.copyWith(status: TourDetailsStatus.loading));
    final result = await _getTour(event.id);
    await result.fold(
      (f) async => emit(state.copyWith(
        status: TourDetailsStatus.failure,
        errorMessage: f.message,
      )),
      (tour) async {
        emit(state.copyWith(
          status: TourDetailsStatus.success,
          tour: tour,
          departuresLoading: tour.departures.isEmpty,
        ));
        if (tour.departures.isEmpty) {
          final departuresRes = await _getDepartures(event.id);
          departuresRes.fold(
            (f) => emit(state.copyWith(
              departuresLoading: false,
              errorMessage: f.message,
            )),
            (departures) {
              final current = state.tour;
              if (current == null) return;
              emit(state.copyWith(
                tour: current.copyWith(departures: departures),
                departuresLoading: false,
              ));
            },
          );
        }
      },
    );
  }
}
