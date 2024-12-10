class AppException implements Exception {
  final String message;

  const AppException(this.message);
}

class ServerException extends AppException {
  const ServerException(super.message);

  @override
  String toString() {
    return message;
  }
}

class UnknownException extends AppException {
  const UnknownException(super.message);

  @override
  String toString() {
    return message;
  }
}
