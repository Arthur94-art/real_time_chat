import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:real_time_chat/core/error/error_mapper.dart';
import 'package:real_time_chat/core/error/failures.dart';
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
    on<SendMessage>(_onSendMessage);
    on<ListenMessages>(_onListenMessages);
  }

  Future<void> _onListenToStream<T>(
    Either<Failure, Stream<T>> result,
    StreamController<T> controller,
    Emitter<ChatState> emit, {
    String? successMessage,
  }) async {
    await result.fold(
      (failure) {
        _handleFailure(failure, emit, controller);
      },
      (stream) async {
        await for (final item in stream) {
          controller.add(item);
          if (successMessage != null) {
            log(successMessage);
          }
        }
      },
    );
  }

  Future<void> _onListenToOnlineStatus(
      ListenToOnlineStatus event, Emitter<ChatState> emit) async {
    final result = _getStatusUseCase();
    await _onListenToStream(result, _statusController, emit);
  }

  Future<void> _onListenMessages(
      ListenMessages event, Emitter<ChatState> emit) async {
    final result = _msgUseCase.getMessageStream();
    await _onListenToStream(result, _msgsController, emit);
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    try {
      _msgUseCase.sendMessage(event.message);
    } catch (exception, stackTrace) {
      _handleException(exception, stackTrace, emit, _msgsController);
    }
  }

  void _handleFailure(
    Failure failure,
    Emitter<ChatState> emit,
    StreamController<dynamic> controller,
  ) {
    final errorMessage = ErrorMapper.mapFailureToMessage(failure);
    controller.addError(errorMessage);
    emit(ChatError(errorMessage));
  }

  void _handleException(
    Object exception,
    StackTrace stackTrace,
    Emitter<ChatState> emit,
    StreamController<dynamic> controller,
  ) {
    log('Exception occurred: $exception', stackTrace: stackTrace);

    final failure = exception is Exception
        ? ErrorMapper.mapExceptionToFailure(exception)
        : UnknownFailure(exception.toString());
    _handleFailure(failure, emit, controller);
  }

  @override
  Future<void> close() {
    _statusController.close();
    _msgsController.close();
    _getStatusUseCase.dispose();
    _msgUseCase.dispose();
    return super.close();
  }
}
