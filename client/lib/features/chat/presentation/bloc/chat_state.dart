part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
  @override
  List<Object> get props => [];
}

class UserOnline extends ChatState {
  const UserOnline();
  @override
  List<Object> get props => [];
}

class UserOffline extends ChatState {
  const UserOffline();
  @override
  List<Object> get props => [];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);
}
