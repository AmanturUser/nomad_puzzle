part of 'camera_bloc.dart';

sealed class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => const [];
}

final class CameraPermissionRequested extends CameraEvent {
  const CameraPermissionRequested();
}

final class CameraPhotoTaken extends CameraEvent {
  const CameraPhotoTaken({this.challengeId});
  final String? challengeId;

  @override
  List<Object?> get props => [challengeId];
}

final class CameraPhotoPicked extends CameraEvent {
  const CameraPhotoPicked({this.challengeId});
  final String? challengeId;

  @override
  List<Object?> get props => [challengeId];
}
