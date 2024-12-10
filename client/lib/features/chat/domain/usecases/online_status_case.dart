import 'package:real_time_chat/features/chat/domain/repositories/online_status_repository.dart';

class GetOnlineStatusUseCase {
  final OnlineStatusRepository repository;

  GetOnlineStatusUseCase(this.repository);
  Stream<bool> call() {
    return repository.getUserStatusStream();
  }
}
