import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:real_time_chat/core/DI/locator.dart';
import 'package:real_time_chat/core/local_data/user_local_data.dart';
import 'package:real_time_chat/core/router/router_config.dart';
import 'package:real_time_chat/core/styles/colors.dart';
import 'package:real_time_chat/features/auth/data/models/user_model.dart';
import 'package:real_time_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:real_time_chat/features/chat/presentation/bloc/chat_bloc.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('users');
  initLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void reassemble() {
    logHiveData<UserModel>('users');
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<ChatBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: MainColors.transparent,
        ),
        routerConfig: NavigationConfig.router,
      ),
    );
  }
}
