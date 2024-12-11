import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/failures.dart';
import 'package:real_time_chat/features/chat/domain/repositories/chat_repository.dart';

class GetStatusUseCase {
  final StatusRepository _repository;

  GetStatusUseCase(this._repository);
  Either<Failure, Stream<bool>> call() {
    return _repository.getStatusStream();
  }

  void dispose() {
    _repository.dispose();
  }
}
