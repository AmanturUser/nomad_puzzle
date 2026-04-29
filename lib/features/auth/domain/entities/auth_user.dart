import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.nickName,
    this.avatarUrl,
    this.bio,
    this.role,
  });

  final int id;
  final String email;
  final String fullName;
  final String nickName;
  final String? avatarUrl;
  final String? bio;
  final String? role;

  @override
  List<Object?> get props => [id, email, fullName, nickName, avatarUrl, bio, role];
}

class AuthSession extends Equatable {
  const AuthSession({required this.token, required this.user});

  final String token;
  final AuthUser user;

  @override
  List<Object?> get props => [token, user];
}
