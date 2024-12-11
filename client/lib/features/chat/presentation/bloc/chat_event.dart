part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ListenToOnlineStatus extends ChatEvent {
  const ListenToOnlineStatus();
  @override
  List<Object> get props => [];
}

class ListenMessages extends ChatEvent {
  const ListenMessages();
  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvent {
  final String message;
  const SendMessage({required this.message});
  @override
  List<Object> get props => [message];
}
