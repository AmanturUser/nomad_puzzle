import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/tour.dart';
import '../../domain/usecases/tours_usecases.dart';

part 'tours_event.dart';
part 'tours_state.dart';

@injectable
class ToursBloc extends Bloc<ToursEvent, ToursState> {
  ToursBloc(this._getTours) : super(const ToursState()) {
    on<ToursRequested>(_onRequested);
  }

  final GetTours _getTours;

  Future<void> _onRequested(
    ToursRequested event,
    Emitter<ToursState> emit,
  ) async {
    emit(state.copyWith(status: ToursStatus.loading));
    final result = await _getTours(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(
        status: ToursStatus.failure,
        errorMessage: f.message,
      )),
      (items) => emit(state.copyWith(
        status: ToursStatus.success,
        items: items,
      )),
    );
  }
}
