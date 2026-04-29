import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/profile_usecases.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
    this._getProfile,
    this._updateProfile,
    this._uploadAvatar,
    this._getStats,
    this._signOut,
  ) : super(const ProfileState()) {
    on<ProfileRequested>(_onRequested);
    on<ProfileUpdateRequested>(_onUpdate);
    on<ProfileAvatarUploadRequested>(_onAvatar);
    on<ProfileSignOutRequested>(_onSignOut);
  }

  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;
  final UploadAvatar _uploadAvatar;
  final GetProfileStats _getStats;
  final SignOut _signOut;

  Future<void> _onRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading, errorMessage: null));
    final result = await _getProfile(const NoParams());
    await result.fold(
      (f) async => emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: f.message,
      )),
      (profile) async {
        emit(state.copyWith(
          status: ProfileStatus.success,
          profile: profile,
        ));
        // Best-effort stats; don't block the UI on failure.
        final statsRes = await _getStats();
        statsRes.fold((_) {}, (s) {
          final p = state.profile;
          if (p == null) return;
          emit(state.copyWith(
            profile: p.copyWith(
              completedChallenges: s.submissions,
              bookedTours: s.bookings,
              reviewsCount: s.reviews,
            ),
          ));
        });
      },
    );
  }

  Future<void> _onUpdate(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(saving: true, errorMessage: null));
    final result = await _updateProfile(event.patch);
    result.fold(
      (f) => emit(state.copyWith(saving: false, errorMessage: f.message)),
      (profile) {
        // Preserve stats from previous state.
        final prev = state.profile;
        emit(state.copyWith(
          saving: false,
          profile: profile.copyWith(
            completedChallenges: prev?.completedChallenges ?? 0,
            bookedTours: prev?.bookedTours ?? 0,
            reviewsCount: prev?.reviewsCount ?? 0,
          ),
        ));
      },
    );
  }

  Future<void> _onAvatar(
    ProfileAvatarUploadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(uploadingAvatar: true, errorMessage: null));
    final result = await _uploadAvatar(event.filePath);
    await result.fold(
      (f) async => emit(state.copyWith(
        uploadingAvatar: false,
        errorMessage: f.message,
      )),
      (_) async {
        // Refetch profile to get the new avatar URL.
        final fresh = await _getProfile(const NoParams());
        fresh.fold(
          (f) => emit(state.copyWith(
            uploadingAvatar: false,
            errorMessage: f.message,
          )),
          (profile) {
            final prev = state.profile;
            emit(state.copyWith(
              uploadingAvatar: false,
              profile: profile.copyWith(
                completedChallenges: prev?.completedChallenges ?? 0,
                bookedTours: prev?.bookedTours ?? 0,
                reviewsCount: prev?.reviewsCount ?? 0,
              ),
            ));
          },
        );
      },
    );
  }

  Future<void> _onSignOut(
    ProfileSignOutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await _signOut(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (_) => emit(const ProfileState()),
    );
  }
}
