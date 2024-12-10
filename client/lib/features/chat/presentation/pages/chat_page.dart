import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_time_chat/core/styles/colors.dart';
import 'package:real_time_chat/core/widgets/text_field.dart';
import 'package:real_time_chat/features/auth/presentation/bloc/auth_bloc.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/auth',
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: MainColors.teal.withOpacity(.1),
          title: const Text('Test User'),
          centerTitle: true,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(const LogoutEvent());
              },
              icon: const Icon(
                Icons.exit_to_app_sharp,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Message $index',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                },
              ),
            ),
            const ChatInput(),
          ],
        ),
      ),
    );
  }
}

class ChatInput extends StatelessWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: messageController,
              hintText: 'Message...',
              fillColor: Colors.grey.shade200,
              isOutlined: false,
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              final message = messageController.text.trim();
              if (message.isNotEmpty) {
                log('Send message: $message');
                messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
