import 'package:flutter/material.dart';
import 'package:real_time_chat/features/chat/presentation/pages/chat_page.dart';

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
