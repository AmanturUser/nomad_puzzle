part of 'camera_bloc.dart';

enum CameraStatus {
  initial,
  ready,
  permissionDenied,
  capturing,
  captured,
  failure,
}

final class CameraState extends Equatable {
  const CameraState({
    this.status = CameraStatus.initial,
    this.photo,
    this.errorMessage,
  });

  final CameraStatus status;
  final CapturedPhoto? photo;
  final String? errorMessage;

  CameraState copyWith({
    CameraStatus? status,
    CapturedPhoto? photo,
    String? errorMessage,
  }) {
    return CameraState(
      status: status ?? this.status,
      photo: photo ?? this.photo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, photo, errorMessage];
}
