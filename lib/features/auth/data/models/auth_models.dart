import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/auth_user.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class LoginRequestModel {
  const LoginRequestModel({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);
}

@JsonSerializable()
class RegisterRequestModel {
  const RegisterRequestModel({
    required this.email,
    required this.password,
    required this.fullName,
    required this.nickName,
    required this.countryId,
    this.role = 'tourist',
  });

  final String email;
  final String password;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'nick_name')
  final String nickName;
  @JsonKey(name: 'country_id')
  final int countryId;
  final String role;

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.nickName,
    this.avatarUrl,
    this.bio,
    this.role,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  final int id;
  final String email;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'nick_name')
  final String nickName;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final String? bio;
  final String? role;

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);

  AuthUser toEntity() => AuthUser(
        id: id,
        email: email,
        fullName: fullName,
        nickName: nickName,
        avatarUrl: avatarUrl,
        bio: bio,
        role: role,
      );
}

@JsonSerializable(explicitToJson: true)
class AuthResponseModel {
  const AuthResponseModel({required this.token, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  final String token;
  final AuthUserModel user;

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
