import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/failures.dart';
import 'package:real_time_chat/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:real_time_chat/features/chat/domain/entities/message_entity.dart';
import 'package:real_time_chat/features/chat/domain/repositories/chat_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final ChatRemoteDataSource _remoteDataSource;

  MessageRepositoryImpl(this._remoteDataSource);

  @override
  Either<Failure, Stream<MessageEntity>> getMessageStream() {
    try {
      final stream = _remoteDataSource.socketStream.where((event) {
        return event is Map && event.containsKey('text');
      }).map((event) {
        log(event['text'] as String);
        return MessageEntity(
          text: event['text'] as String,
          type: event['type'] as String,
        );
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

  @override
  void sendMessage(String message) {
    _remoteDataSource.sendMessage(message);
  }
}
