part of 'tours_bloc.dart';

enum ToursStatus { initial, loading, success, failure }

final class ToursState extends Equatable {
  const ToursState({
    this.status = ToursStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  final ToursStatus status;
  final List<Tour> items;
  final String? errorMessage;

  ToursState copyWith({
    ToursStatus? status,
    List<Tour>? items,
    String? errorMessage,
  }) {
    return ToursState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
