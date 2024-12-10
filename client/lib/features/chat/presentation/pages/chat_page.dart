import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_time_chat/core/router/navigation_helper.dart';
import 'package:real_time_chat/core/router/routes_paths.dart';
import 'package:real_time_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:real_time_chat/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:real_time_chat/features/chat/presentation/widgets/chat_input.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          NavigationHelper.pushAndRemoveUntil(context, RoutesPaths.auth);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(
            size: 40,
            Icons.supervised_user_circle_sharp,
          ),
          titleSpacing: 6,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.teal.withOpacity(.1),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              StreamBuilder<bool>(
                  stream: context.read<ChatBloc>().statusStream,
                  builder: (context, snapshot) {
                    return const Text(
                      'Last seen',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    );
                  }),
            ],
          ),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(const LogoutEvent());
              },
              icon: const Icon(
                Icons.exit_to_app_sharp,
                color: Colors.greenAccent,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ChatBubble(message: message);
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

class ChatMessage {
  final String text;
  final bool isMe;

  ChatMessage({required this.text, required this.isMe});
}

final List<ChatMessage> messages = [
  ChatMessage(text: "Hello!", isMe: false),
  ChatMessage(text: "Hi there!", isMe: true),
  ChatMessage(text: "How are you?", isMe: false),
  ChatMessage(text: "How are you?", isMe: false),
  ChatMessage(text: "I'm good, thanks! How about you?", isMe: true),
  ChatMessage(text: "I'm good, thanks! How about you?", isMe: true),
  ChatMessage(text: "Doing great, thanks!", isMe: false),
  ChatMessage(text: "That's awesome to hear!", isMe: true),
];

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isMe
              ? Colors.greenAccent.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMe ? 12 : 0),
            topRight: Radius.circular(isMe ? 0 : 12),
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isMe ? Colors.greenAccent : Colors.white70,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
