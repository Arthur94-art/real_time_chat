abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException(super.message);
}

class ChatException extends AppException {
  const ChatException(super.message);
}

class UnknownException extends AppException {
  const UnknownException(super.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class TimeoutException extends AppException {
  const TimeoutException(super.message);
}
