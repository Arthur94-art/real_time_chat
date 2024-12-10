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
