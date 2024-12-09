import 'package:real_time_chat/features/auth/domain/entities/user_entitiy.dart';

class AuthModel extends UserEntity {
  const AuthModel({
    required super.id,
    required super.username,
    required super.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'],
      username: json['username'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'token': token,
    };
  }
}
