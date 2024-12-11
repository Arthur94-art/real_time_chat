import 'package:real_time_chat/features/chat/domain/repositories/chat_repository.dart';

class MessengerUseCase {
  final MessageRepository _repository;

  MessengerUseCase(this._repository);

  void call(String message) {
    _repository.sendMessage(message);
  }

  void dispose() {
    _repository.dispose();
  }
}
