import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:real_time_chat/core/http/http_client_impl.dart';
import 'package:real_time_chat/core/local_data/user_local_data.dart';
import 'package:real_time_chat/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:real_time_chat/features/auth/data/models/user_model.dart';
import 'package:real_time_chat/features/auth/data/repositories/auth_repository.dart';
import 'package:real_time_chat/features/auth/domain/repositories/auth_repository.dart';
import 'package:real_time_chat/features/auth/domain/usecases/login_usecase.dart';
import 'package:real_time_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:real_time_chat/features/chat/data/datasources/online_status_data_source.dart';
import 'package:real_time_chat/features/chat/data/repositories/online_status_repository_impl.dart';
import 'package:real_time_chat/features/chat/domain/repositories/online_status_repository.dart';
import 'package:real_time_chat/features/chat/domain/usecases/online_status_case.dart';
import 'package:real_time_chat/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final sl = GetIt.instance;

void initLocator() {
  //  Hive
  sl.registerLazySingleton(() => UserLocalData(Hive.box<UserModel>('users')));

  // HTTP
  sl.registerLazySingleton<HttpClient>(() => HttpClientImpl(http.Client()));
  sl.registerLazySingleton(() => http.Client());

  // WebSocket
  sl.registerLazySingleton<WebSocketChannel>(
    () => WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:3000')),
  );

  // Remote Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<OnlineStatusDataSource>(
    () => OnlineStatusDataSourceImpl(sl<WebSocketChannel>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<OnlineStatusRepository>(
    () => OnlineStatusRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => GetOnlineStatusUseCase(sl()));

  // BLoC
  sl.registerFactory(() => AuthBloc(sl(), sl()));
  sl.registerFactory(() => ChatBloc(sl()));
}
