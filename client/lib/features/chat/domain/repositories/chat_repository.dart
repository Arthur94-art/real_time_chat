import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/failures.dart';

abstract class StatusRepository {
  Either<Failure, Stream<bool>> getStatusStream();
  void dispose();
}

abstract class MessageRepository {
  Either<Failure, Stream<String>> getMessageStream();
  void sendMessage(String message);
  void dispose();
}
