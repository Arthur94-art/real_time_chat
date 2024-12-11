import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/failures.dart';
import 'package:real_time_chat/features/chat/data/datasources/chat_remote_data_source.dart';

abstract class MessageRepository {
  Either<Failure, Stream<String>> getMessageStream();
}

class MessageRepositoryImpl implements MessageRepository {
  final ChatRemoteDataSource remoteDataSource;

  MessageRepositoryImpl(this.remoteDataSource);

  @override
  Either<Failure, Stream<String>> getMessageStream() {
    try {
      final stream = remoteDataSource.socketStream.where((event) {
        return event is Map && event.containsKey('text');
      }).map((event) {
        log(event['text'] as String);
        return event['text'] as String;
      });

      return Right(stream);
    } catch (e) {
      return Left(ChatFailure(e.toString()));
    }
  }
}
