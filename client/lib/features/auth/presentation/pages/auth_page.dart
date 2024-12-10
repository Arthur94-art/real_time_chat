import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_time_chat/core/router/navigation_helper.dart';
import 'package:real_time_chat/core/router/routes_paths.dart';
import 'package:real_time_chat/core/widgets/loader.dart';
import 'package:real_time_chat/core/widgets/text_field.dart';
import 'package:real_time_chat/features/auth/presentation/bloc/auth_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final TextEditingController _controller;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    _controller = TextEditingController();
    _authBloc = context.read<AuthBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.withOpacity(0.1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to Chat App',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 30),
            CustomTextField(
              controller: _controller,
              hintText: 'Enter your name',
              fillColor: Colors.white.withOpacity(0.1),
              hintStyle: const TextStyle(
                color: Colors.white30,
              ),
              borderRadius: 20,
              textStyle: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  NavigationHelper.pushAndRemoveUntil(
                      context, RoutesPaths.chat);
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.grey.withOpacity(.1),
                      content: Text(
                        state.message,
                        style: TextStyle(
                          color: Colors.red[200],
                        ),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const CustomLoader();
                }
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    _authBloc.add(LoginEvent(_controller.text));
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
