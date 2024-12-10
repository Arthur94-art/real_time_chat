import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_time_chat/core/widgets/loader.dart';
import 'package:real_time_chat/features/auth/presentation/bloc/auth_bloc.dart';

class AuthRedirector extends StatefulWidget {
  const AuthRedirector({super.key});

  @override
  State<AuthRedirector> createState() => _AuthRedirectorState();
}

class _AuthRedirectorState extends State<AuthRedirector> {
  @override
  void initState() {
    context.read<AuthBloc>().add(const CheckAuthEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/chat');
        } else if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/auth');
        }
      },
      child: const Scaffold(
        body: CustomLoader(),
      ),
    );
  }
}
