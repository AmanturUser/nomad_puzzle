part of 'tour_details_bloc.dart';

enum TourDetailsStatus { initial, loading, success, failure }

final class TourDetailsState extends Equatable {
  const TourDetailsState({
    this.status = TourDetailsStatus.initial,
    this.tour,
    this.departuresLoading = false,
    this.errorMessage,
  });

  final TourDetailsStatus status;
  final Tour? tour;
  final bool departuresLoading;
  final String? errorMessage;

  TourDetailsState copyWith({
    TourDetailsStatus? status,
    Tour? tour,
    bool? departuresLoading,
    String? errorMessage,
  }) {
    return TourDetailsState(
      status: status ?? this.status,
      tour: tour ?? this.tour,
      departuresLoading: departuresLoading ?? this.departuresLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, tour, departuresLoading, errorMessage];
}
