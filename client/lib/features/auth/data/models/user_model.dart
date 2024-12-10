import 'package:hive_flutter/hive_flutter.dart';
import 'package:real_time_chat/features/auth/domain/entities/user_entitiy.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String token;

  UserModel({
    required this.id,
    required this.username,
    required this.token,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      token: token,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      token: json['token'],
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      username: entity.username,
      token: entity.token,
    );
  }
}
