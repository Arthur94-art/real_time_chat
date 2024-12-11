import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:real_time_chat/core/error/error_mapper.dart';
import 'package:real_time_chat/features/chat/domain/entities/message_entity.dart';
import 'package:real_time_chat/features/chat/domain/entities/status_entity.dart';
import 'package:real_time_chat/features/chat/domain/usecases/msg_use_case.dart';
import 'package:real_time_chat/features/chat/domain/usecases/online_status_case.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetStatusUseCase _getStatusUseCase;
  final MessengerUseCase _msgUseCase;
  final StreamController<StatusEntity> _statusController =
      StreamController<StatusEntity>.broadcast();
  final StreamController<MessageEntity> _msgsController =
      StreamController<MessageEntity>.broadcast();

  Stream<StatusEntity> get statusStream => _statusController.stream;
  Stream<MessageEntity> get msgsController => _msgsController.stream;

  ChatBloc(this._getStatusUseCase, this._msgUseCase)
      : super(const ChatInitial()) {
    on<ListenToOnlineStatus>(_onListenToOnlineStatus);
    on<SendMessage>((event, emit) async {
      _msgUseCase.sendMessage(event.message);
    });
    on<ListenMessages>((event, emit) async {
      final result = _msgUseCase.getMessageStream();
      await result.fold(
        (failure) {
          final errorMessage = ErrorMapper.mapFailureToMessage(failure);
          _msgsController.addError(errorMessage);
        },
        (stream) async {
          await for (final message in stream) {
            _msgsController.add(message);
          }
        },
      );
    });
  }

  Future<void> _onListenToOnlineStatus(
      ListenToOnlineStatus event, Emitter<ChatState> emit) async {
    try {
      final result = _getStatusUseCase();
      await result.fold(
        (failure) {
          final errorMessage = ErrorMapper.mapFailureToMessage(failure);
          _statusController.addError(errorMessage);
          emit(UserStatusError(errorMessage));
        },
        (stream) async {
          await for (final status in stream) {
            _statusController.add(status);
            emit(
              status.status == 'online'
                  ? const UserOnline()
                  : const UserOffline(),
            );
          }
        },
      );
    } catch (exception) {
      final failure = ErrorMapper.mapExceptionToFailure(exception as Exception);
      final errorMessage = ErrorMapper.mapFailureToMessage(failure);
      _statusController.addError(errorMessage);
      emit(UserStatusError(errorMessage));
    }
  }

  @override
  Future<void> close() {
    _statusController.close();
    _getStatusUseCase.dispose();

    return super.close();
  }
}
