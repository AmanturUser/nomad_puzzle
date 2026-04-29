part of 'tour_details_bloc.dart';

sealed class TourDetailsEvent extends Equatable {
  const TourDetailsEvent();

  @override
  List<Object?> get props => const [];
}

final class TourDetailsRequested extends TourDetailsEvent {
  const TourDetailsRequested(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}
