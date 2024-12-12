import 'dart:io';

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
    } else if (exception is SocketException) {
      return const NetworkFailure("No Internet connection");
    } else if (exception is TimeoutException) {
      return const TimeoutFailure("Request timed out");
    } else {
      return const UnknownFailure("An unknown error occurred");
    }
  }

  static String mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
