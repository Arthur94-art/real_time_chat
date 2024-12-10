import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/exeptions.dart';
import 'package:real_time_chat/core/error/failures.dart';
import 'package:real_time_chat/core/local_data/user_local_data.dart';
import 'package:real_time_chat/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:real_time_chat/features/auth/domain/entities/user_entitiy.dart';
import 'package:real_time_chat/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserLocalData localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login(String username) async {
    try {
      final user = await remoteDataSource.login(username);
      await localDataSource.saveUser(user.toEntity());
      return Right(user.toEntity());
    } on ServerException {
      return const Left(ServerFailure('Login failed'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = localDataSource.getCurrentUser();
      if (user != null) {
        return Right(user);
      } else {
        return const Left(ServerFailure('No user found'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
