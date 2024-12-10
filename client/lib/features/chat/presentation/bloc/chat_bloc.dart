import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:real_time_chat/features/chat/domain/usecases/online_status_case.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetOnlineStatusUseCase _getOnlineStatusUseCase;
  final StreamController<bool> _statusController = StreamController<bool>();

  Stream<bool> get statusStream => _statusController.stream;
  ChatBloc(this._getOnlineStatusUseCase) : super(const ChatInitial()) {
    on<ListenToOnlineStatus>((event, emit) async {
      try {
        await for (final status in _getOnlineStatusUseCase()) {
          _statusController.add(status);
          emit(status ? const UserOnline() : const UserOffline());
        }
      } catch (error) {
        _statusController.addError('Failed to listen to status: $error');
        emit(UserStatusError(error.toString()));
      }
    });
  }
  @override
  Future<void> close() {
    _statusController.close();
    return super.close();
  }
}
