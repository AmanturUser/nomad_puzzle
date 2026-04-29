part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => const [];
}

final class ProfileRequested extends ProfileEvent {
  const ProfileRequested();
}

final class ProfileUpdateRequested extends ProfileEvent {
  const ProfileUpdateRequested(this.patch);
  final ProfileUpdate patch;

  @override
  List<Object?> get props => [patch];
}

final class ProfileAvatarUploadRequested extends ProfileEvent {
  const ProfileAvatarUploadRequested(this.filePath);
  final String filePath;

  @override
  List<Object?> get props => [filePath];
}

final class ProfileSignOutRequested extends ProfileEvent {
  const ProfileSignOutRequested();
}
