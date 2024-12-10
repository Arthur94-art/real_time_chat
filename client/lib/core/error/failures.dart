abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  @override
  String toString() {
    return message;
  }
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);

  @override
  String toString() {
    return message;
  }
}
