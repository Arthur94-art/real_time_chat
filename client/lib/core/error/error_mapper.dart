import 'package:real_time_chat/core/error/exeptions.dart';

import 'failures.dart';

class ErrorMapper {
  static Failure mapExceptionToFailure(Exception exception) {
    if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is ChatException) {
      return ChatFailure(exception.message);
    } else if (exception is UnknownException) {
      return UnknownFailure(exception.message);
    } else {
      return const UnknownFailure('Unknown error...');
    }
  }

  static String mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
