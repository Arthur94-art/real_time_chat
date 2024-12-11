import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_time_chat/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:real_time_chat/features/chat/presentation/pages/chat_page.dart';
import 'package:real_time_chat/features/chat/presentation/widgets/chat_bubble.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<String>(
        stream: context.read<ChatBloc>().msgsController,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No messages yet.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final newMessage = snapshot.data!;
          messages.add(ChatMessage(
            text: newMessage,
            isMe: false,
          ));
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return ChatBubble(message: message);
            },
          );
        },
      ),
    );
  }
}
