import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/failures.dart';
import 'package:real_time_chat/features/chat/domain/entities/message_entity.dart';
import 'package:real_time_chat/features/chat/domain/entities/status_entity.dart';

abstract class StatusRepository {
  Either<Failure, Stream<StatusEntity>> getStatusStream();
  void dispose();
}

abstract class MessageRepository {
  Either<Failure, Stream<MessageEntity>> getMessageStream();
  void sendMessage(String message);
  void dispose();
}
