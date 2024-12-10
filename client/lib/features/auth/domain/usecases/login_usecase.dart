import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/failures.dart';
import 'package:real_time_chat/features/auth/domain/entities/user_entitiy.dart';
import 'package:real_time_chat/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call(String username) async {
    final a = await repository.login(username);
    return a;
  }
}
