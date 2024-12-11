import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/exeptions.dart';
import 'package:real_time_chat/core/error/failures.dart';
import 'package:real_time_chat/features/chat/data/datasources/status_data_source.dart';
import 'package:real_time_chat/features/chat/domain/repositories/online_status_repository.dart';

class StatusRepositoryImpl implements StatusRepository {
  final StatusDataSource remoteDataSource;

  StatusRepositoryImpl(this.remoteDataSource);

  @override
  Either<Failure, Stream<bool>> getLastSeenStatusStream() {
    try {
      return Right(remoteDataSource.userStatusStream);
    } on ChatException catch (e) {
      return Left(ChatFailure(e.toString()));
    }
  }
}
