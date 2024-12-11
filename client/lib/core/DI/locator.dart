import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:real_time_chat/core/config/api_config.dart';
import 'package:real_time_chat/core/http/http_client_impl.dart';
import 'package:real_time_chat/core/local_data/user_local_data.dart';
import 'package:real_time_chat/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:real_time_chat/features/auth/data/models/user_model.dart';
import 'package:real_time_chat/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:real_time_chat/features/auth/domain/repositories/auth_repository.dart';
import 'package:real_time_chat/features/auth/domain/usecases/login_usecase.dart';
import 'package:real_time_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:real_time_chat/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:real_time_chat/features/chat/data/repositories/status_repository_impl.dart';
import 'package:real_time_chat/features/chat/domain/repositories/chat_repository.dart';
import 'package:real_time_chat/features/chat/domain/usecases/online_status_case.dart';
import 'package:real_time_chat/features/chat/presentation/bloc/chat_bloc.dart';

final sl = GetIt.instance;

void initLocator() {
  //Api Config
  sl.registerLazySingleton(() => ApiConfig());

  //  Hive
  sl.registerLazySingleton(() => UserLocalData(Hive.box<UserModel>('users')));

  // HTTP
  sl.registerLazySingleton<HttpClient>(() => HttpClientImpl(http.Client()));
  sl.registerLazySingleton(() => http.Client());

  // Remote Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(ApiConfig.ws),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerFactory<StatusRepository>(
    () => StatusRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerFactory(() => GetStatusUseCase(sl()));

  // BLoC
  sl.registerFactory(() => AuthBloc(sl(), sl()));
  sl.registerFactory(() => ChatBloc(sl()));
}
