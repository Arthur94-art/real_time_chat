class AppException implements Exception {
  final String message;

  const AppException(this.message);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

class AuthenticationException extends AppException {
  const AuthenticationException([super.message = 'Authentication failed']);
}

class UnknownException extends AppException {
  const UnknownException([super.message = 'Unknown error occurred']);
}
