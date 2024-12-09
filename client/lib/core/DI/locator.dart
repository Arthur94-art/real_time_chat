import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:real_time_chat/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:real_time_chat/features/auth/data/repositories/auth_repository.dart';
import 'package:real_time_chat/features/auth/domain/repositories/auth_repository.dart';
import 'package:real_time_chat/features/auth/domain/usecases/login_usecase.dart';
import 'package:real_time_chat/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

void initLocator() {
  sl.registerFactory(() => AuthBloc(sl()));

  sl.registerLazySingleton(() => LoginUsecase(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton(() => http.Client());
}
