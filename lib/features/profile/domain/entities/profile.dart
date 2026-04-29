import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.fullName,
    required this.nickName,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.bio,
    required this.birthDate,
    required this.countryId,
    required this.languages,
    required this.isLocal,
    required this.role,
    required this.latitude,
    required this.longitude,
    this.completedChallenges = 0,
    this.bookedTours = 0,
    this.reviewsCount = 0,
  });

  final int id;
  final String fullName;
  final String nickName;
  final String email;
  final String phone;
  final String avatarUrl;
  final String bio;
  final DateTime? birthDate;
  final int? countryId;
  final String languages;
  final bool isLocal;
  final String role;
  final double latitude;
  final double longitude;

  // Derived stats (loaded from /me/submissions + /me/bookings + /me/reviews).
  final int completedChallenges;
  final int bookedTours;
  final int reviewsCount;

  String get displayName {
    if (nickName.isNotEmpty) return nickName;
    if (fullName.isNotEmpty) return fullName;
    if (email.isNotEmpty) return email.split('@').first;
    return 'Кочевник';
  }

  Profile copyWith({
    String? fullName,
    String? nickName,
    String? phone,
    String? bio,
    String? avatarUrl,
    DateTime? birthDate,
    int? countryId,
    String? languages,
    double? latitude,
    double? longitude,
    int? completedChallenges,
    int? bookedTours,
    int? reviewsCount,
  }) =>
      Profile(
        id: id,
        fullName: fullName ?? this.fullName,
        nickName: nickName ?? this.nickName,
        email: email,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        bio: bio ?? this.bio,
        birthDate: birthDate ?? this.birthDate,
        countryId: countryId ?? this.countryId,
        languages: languages ?? this.languages,
        isLocal: isLocal,
        role: role,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        completedChallenges: completedChallenges ?? this.completedChallenges,
        bookedTours: bookedTours ?? this.bookedTours,
        reviewsCount: reviewsCount ?? this.reviewsCount,
      );

  @override
  List<Object?> get props => [
        id,
        fullName,
        nickName,
        email,
        phone,
        avatarUrl,
        bio,
        birthDate,
        countryId,
        languages,
        isLocal,
        role,
        latitude,
        longitude,
        completedChallenges,
        bookedTours,
        reviewsCount,
      ];
}

class ProfileUpdate extends Equatable {
  const ProfileUpdate({
    this.fullName,
    this.nickName,
    this.phone,
    this.bio,
    this.birthDate,
    this.countryId,
    this.languages,
    this.latitude,
    this.longitude,
  });

  final String? fullName;
  final String? nickName;
  final String? phone;
  final String? bio;
  final DateTime? birthDate;
  final int? countryId;
  final String? languages;
  final double? latitude;
  final double? longitude;

  @override
  List<Object?> get props => [
        fullName,
        nickName,
        phone,
        bio,
        birthDate,
        countryId,
        languages,
        latitude,
        longitude,
      ];
}
