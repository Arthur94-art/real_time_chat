import 'dart:developer';
import 'dart:io';

import 'package:real_time_chat/core/error/exeptions.dart';
import 'package:real_time_chat/core/error/failures.dart';

class ErrorMapper {
  static Failure mapExceptionToFailure(Object exception) {
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
      log('Unhandled exception: $exception');
      return UnknownFailure(
          "An unknown error occurred: ${exception.toString()}");
    }
  }

  static String mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
