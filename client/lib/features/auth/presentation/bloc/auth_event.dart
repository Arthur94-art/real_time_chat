part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String username;

  const LoginEvent(this.username);

  @override
  List<Object> get props => [username];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthEvent extends AuthEvent {
  const CheckAuthEvent();

  @override
  List<Object> get props => [];
}
