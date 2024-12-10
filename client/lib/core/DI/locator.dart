import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:real_time_chat/core/http/http_client_impl.dart';
import 'package:real_time_chat/core/local_data/user_local_data.dart';
import 'package:real_time_chat/core/services/ws_service.dart';
import 'package:real_time_chat/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:real_time_chat/features/auth/data/models/user_model.dart';
import 'package:real_time_chat/features/auth/data/repositories/auth_repository.dart';
import 'package:real_time_chat/features/auth/domain/repositories/auth_repository.dart';
import 'package:real_time_chat/features/auth/domain/usecases/login_usecase.dart';
import 'package:real_time_chat/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

void initLocator() {
  sl.registerLazySingleton(() => UserLocalData(Hive.box<UserModel>('users')));

  sl.registerLazySingleton<HttpClient>(() => HttpClientImpl(http.Client()));

  sl.registerSingleton(() {
    final wsService = WSService('ws://10.0.2.2:3000');
    wsService.connect();
    return wsService;
  });

  sl.registerFactory(() => AuthBloc(sl()));

  sl.registerLazySingleton(() => LoginUsecase(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton(() => http.Client());
}
