part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure }

final class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.saving = false,
    this.uploadingAvatar = false,
    this.errorMessage,
  });

  final ProfileStatus status;
  final Profile? profile;
  final bool saving;
  final bool uploadingAvatar;
  final String? errorMessage;

  ProfileState copyWith({
    ProfileStatus? status,
    Profile? profile,
    bool? saving,
    bool? uploadingAvatar,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      saving: saving ?? this.saving,
      uploadingAvatar: uploadingAvatar ?? this.uploadingAvatar,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, profile, saving, uploadingAvatar, errorMessage];
}
