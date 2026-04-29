// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  id: (json['id'] as num).toInt(),
  fullName: json['full_name'] as String? ?? '',
  nickName: json['nick_name'] as String? ?? '',
  email: json['email'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  avatarUrl: json['avatar_url'] as String?,
  bio: json['bio'] as String? ?? '',
  birthDate: json['birth_date'] as String?,
  countryId: (json['country_id'] as num?)?.toInt(),
  languages: json['languages'] as String? ?? '',
  isLocal: json['is_local'] as bool? ?? false,
  role: json['role'] as String? ?? 'user',
  latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
  longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'nick_name': instance.nickName,
      'email': instance.email,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'bio': instance.bio,
      'birth_date': instance.birthDate,
      'country_id': instance.countryId,
      'languages': instance.languages,
      'is_local': instance.isLocal,
      'role': instance.role,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
