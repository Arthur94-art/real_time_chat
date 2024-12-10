import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/failures.dart';
import 'package:real_time_chat/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:real_time_chat/features/auth/domain/entities/user_entitiy.dart';
import 'package:real_time_chat/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> login(String username) async {
    try {
      final authModel = await remoteDataSource.login(username);
      return Right(
        UserEntity(
          id: authModel.id,
          username: authModel.username,
          token: authModel.token,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
