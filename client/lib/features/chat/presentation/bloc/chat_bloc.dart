import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:real_time_chat/core/error/error_mapper.dart';
import 'package:real_time_chat/features/chat/domain/usecases/online_status_case.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetStatusUseCase _getStatusUseCase;
  final StreamController<bool> _statusController =
      StreamController<bool>.broadcast();

  Stream<bool> get statusStream => _statusController.stream;

  ChatBloc(this._getStatusUseCase) : super(const ChatInitial()) {
    on<ListenToOnlineStatus>(_onListenToOnlineStatus);
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
            emit(status ? const UserOnline() : const UserOffline());
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
