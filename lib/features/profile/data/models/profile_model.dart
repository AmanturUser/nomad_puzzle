import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/api_constants.dart';
import '../../domain/entities/profile.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  const ProfileModel({
    required this.id,
    this.fullName = '',
    this.nickName = '',
    this.email = '',
    this.phone = '',
    this.avatarUrl,
    this.bio = '',
    this.birthDate,
    this.countryId,
    this.languages = '',
    this.isLocal = false,
    this.role = 'user',
    this.latitude = 0,
    this.longitude = 0,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  final int id;
  @JsonKey(name: 'full_name', defaultValue: '')
  final String fullName;
  @JsonKey(name: 'nick_name', defaultValue: '')
  final String nickName;
  @JsonKey(defaultValue: '')
  final String email;
  @JsonKey(defaultValue: '')
  final String phone;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(defaultValue: '')
  final String bio;
  @JsonKey(name: 'birth_date')
  final String? birthDate;
  @JsonKey(name: 'country_id')
  final int? countryId;
  @JsonKey(defaultValue: '')
  final String languages;
  @JsonKey(name: 'is_local', defaultValue: false)
  final bool isLocal;
  @JsonKey(defaultValue: 'user')
  final String role;
  @JsonKey(defaultValue: 0)
  final double latitude;
  @JsonKey(defaultValue: 0)
  final double longitude;

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  Profile toEntity() => Profile(
        id: id,
        fullName: fullName,
        nickName: nickName,
        email: email,
        phone: phone,
        avatarUrl: _rewriteHost(avatarUrl ?? ''),
        bio: bio,
        birthDate: _parseDate(birthDate),
        countryId: countryId,
        languages: languages,
        isLocal: isLocal,
        role: role,
        latitude: latitude,
        longitude: longitude,
      );

  static DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  static String _rewriteHost(String url) {
    if (url.isEmpty) return url;
    if (url.startsWith('/')) return '${ApiConstants.baseUrl}$url';
    if (url.startsWith('http://localhost:8080')) {
      return url.replaceFirst('http://localhost:8080', ApiConstants.baseUrl);
    }
    if (url.startsWith('https://localhost:8080')) {
      return url.replaceFirst('https://localhost:8080', ApiConstants.baseUrl);
    }
    return url;
  }
}
