import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/failures.dart';
import 'package:real_time_chat/features/chat/domain/entities/message_entity.dart';
import 'package:real_time_chat/features/chat/domain/repositories/chat_repository.dart';

class MessengerUseCase {
  final MessageRepository _repository;

  MessengerUseCase(this._repository);

  Either<Failure, void> sendMessage(String message) {
    return _repository.sendMessage(message);
  }

  Either<Failure, Stream<MessageEntity>> getMessageStream() {
    return _repository.getMessageStream();
  }

  void dispose() {
    _repository.dispose();
  }
}
