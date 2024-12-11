import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/failures.dart';
import 'package:real_time_chat/features/chat/domain/repositories/online_status_repository.dart';

class GetStatusUseCase {
  final StatusRepository repository;

  GetStatusUseCase(this.repository);
  Either<Failure, Stream<bool>> call() {
    return repository.getStatusStream();
  }
}
