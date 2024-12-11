import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/failures.dart';
import 'package:real_time_chat/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:real_time_chat/features/chat/domain/entities/status_entity.dart';
import 'package:real_time_chat/features/chat/domain/repositories/chat_repository.dart';

class StatusRepositoryImpl implements StatusRepository {
  final ChatRemoteDataSource _remoteDataSource;

  StatusRepositoryImpl(this._remoteDataSource);

  @override
  Either<Failure, Stream<StatusEntity>> getStatusStream() {
    try {
      final stream = _remoteDataSource.socketStream.where((event) {
        return event is Map && event.containsKey('status');
      }).map((event) {
        final status = event['status'] as String;
        return StatusEntity(status: status);
      });

      return Right(stream);
    } catch (e) {
      return Left(ChatFailure(e.toString()));
    }
  }

  @override
  void dispose() {
    _remoteDataSource.dispose();
  }
}
