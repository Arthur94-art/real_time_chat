import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:real_time_chat/core/error/error_mapper.dart';
import 'package:real_time_chat/core/local_data/user_local_data.dart';
import 'package:real_time_chat/features/auth/domain/entities/user_entitiy.dart';
import 'package:real_time_chat/features/auth/domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase _loginUsecase;
  final UserLocalData _userLocalData;

  AuthBloc(this._loginUsecase, this._userLocalData) : super(AuthInitial()) {
    on<CheckAuthEvent>((event, emit) async {
      final user = _userLocalData.getCurrentUser();
      await Future.delayed(const Duration(milliseconds: 500));
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await _loginUsecase(event.username);
      result.fold(
        (failure) {
          final message = ErrorMapper.mapFailureToMessage(failure);
          emit(AuthError(message));
        },
        (user) {
          emit(AuthAuthenticated(user));
        },
      );
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      await _userLocalData.clearUser();
      emit(const AuthUnauthenticated());
    });
  }
}
