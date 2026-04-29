import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/captured_photo.dart';
import '../../domain/usecases/take_photo.dart';

part 'camera_event.dart';
part 'camera_state.dart';

@injectable
class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc(
    this._requestPermission,
    this._takePhoto,
    this._pickFromGallery,
  ) : super(const CameraState()) {
    on<CameraPermissionRequested>(_onPermission);
    on<CameraPhotoTaken>(_onTakePhoto);
    on<CameraPhotoPicked>(_onPickFromGallery);
  }

  final RequestCameraPermission _requestPermission;
  final TakePhoto _takePhoto;
  final PickFromGallery _pickFromGallery;

  Future<void> _onPermission(
    CameraPermissionRequested event,
    Emitter<CameraState> emit,
  ) async {
    final result = await _requestPermission(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(
        status: CameraStatus.permissionDenied,
        errorMessage: f.message,
      )),
      (granted) => emit(state.copyWith(
        status: granted ? CameraStatus.ready : CameraStatus.permissionDenied,
      )),
    );
  }

  Future<void> _onTakePhoto(
    CameraPhotoTaken event,
    Emitter<CameraState> emit,
  ) async {
    emit(state.copyWith(status: CameraStatus.capturing));
    final result = await _takePhoto(
      TakePhotoParams(challengeId: event.challengeId),
    );
    result.fold(
      (f) => emit(state.copyWith(
        status: CameraStatus.failure,
        errorMessage: f.message,
      )),
      (photo) => emit(state.copyWith(
        status: CameraStatus.captured,
        photo: photo,
      )),
    );
  }

  Future<void> _onPickFromGallery(
    CameraPhotoPicked event,
    Emitter<CameraState> emit,
  ) async {
    emit(state.copyWith(status: CameraStatus.capturing));
    final result = await _pickFromGallery(
      TakePhotoParams(challengeId: event.challengeId),
    );
    result.fold(
      (f) => emit(state.copyWith(
        status: CameraStatus.failure,
        errorMessage: f.message,
      )),
      (photo) => emit(state.copyWith(
        status: CameraStatus.captured,
        photo: photo,
      )),
    );
  }
}
