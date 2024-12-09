import 'package:real_time_chat/features/auth/domain/entities/user_entitiy.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String username);
}
