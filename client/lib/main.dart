import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:real_time_chat/core/DI/locator.dart';
import 'package:real_time_chat/core/local_data/user_local_data.dart';
import 'package:real_time_chat/core/styles/colors.dart';
import 'package:real_time_chat/core/widgets/gradient_background.dart';
import 'package:real_time_chat/features/auth/data/models/user_model.dart';
import 'package:real_time_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:real_time_chat/features/auth/presentation/pages/auth_page.dart';
import 'package:real_time_chat/features/auth/presentation/pages/auth_redirect.dart';
import 'package:real_time_chat/features/chat/presentation/pages/chat_page.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: MainColors.transparent,
        ),
        home: const GradientAppWrapper(child: AuthRedirector()),
        routes: {
          '/auth': (context) => const GradientAppWrapper(child: AuthPage()),
          '/chat': (context) => const GradientAppWrapper(child: ChatPage()),
        },
      ),
    );
  }
}
