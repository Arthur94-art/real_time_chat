import 'package:flutter/material.dart';
import 'package:real_time_chat/core/styles/colors.dart';
import 'package:real_time_chat/core/widgets/gradient_background.dart';
import 'package:real_time_chat/features/auth/presentation/pages/auth_page.dart';
import 'package:real_time_chat/features/chat/presentation/pages/chat_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: MainColors.transparent,
      ),
      home: const GradientAppWrapper(child: AuthPage()),
      routes: {
        '/auth': (context) => const GradientAppWrapper(child: AuthPage()),
        '/chat': (context) => const GradientAppWrapper(child: ChatPage()),
      },
    );
  }
}
