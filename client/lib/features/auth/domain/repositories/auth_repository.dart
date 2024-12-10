import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/failures.dart';
import 'package:real_time_chat/features/auth/domain/entities/user_entitiy.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String username);
  Future<Either<Failure, UserEntity>> getCurrentUser();
}
