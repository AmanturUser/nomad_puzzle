part of 'tours_bloc.dart';

sealed class ToursEvent extends Equatable {
  const ToursEvent();

  @override
  List<Object?> get props => const [];
}

final class ToursRequested extends ToursEvent {
  const ToursRequested();
}
