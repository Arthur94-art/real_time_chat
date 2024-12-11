import 'package:dartz/dartz.dart';
import 'package:real_time_chat/core/error/failures.dart';

abstract class StatusRepository {
  Either<Failure, Stream<bool>> getStatusStream();
}
