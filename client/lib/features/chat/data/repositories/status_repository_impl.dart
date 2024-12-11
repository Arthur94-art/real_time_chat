import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/failures.dart';
import 'package:real_time_chat/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:real_time_chat/features/chat/domain/repositories/online_status_repository.dart';

class StatusRepositoryImpl implements StatusRepository {
  final ChatRemoteDataSource remoteDataSource;

  StatusRepositoryImpl(this.remoteDataSource);

  @override
  Either<Failure, Stream<bool>> getStatusStream() {
    try {
      final stream = remoteDataSource.socketStream.where((event) {
        return event is Map && event.containsKey('status');
      }).map((event) {
        final status = event['status'] as String;
        return status.toLowerCase() == 'online';
      });

      return Right(stream);
    } catch (e) {
      return Left(ChatFailure(e.toString()));
    }
  }
}