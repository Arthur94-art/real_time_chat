abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ChatFailure extends Failure {
  const ChatFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
