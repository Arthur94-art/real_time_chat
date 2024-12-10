import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:real_time_chat/core/styles/colors.dart';
import 'package:real_time_chat/core/widgets/text_field.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();

    return Column(
      children: [
        Container(height: .5, color: Colors.greenAccent),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          color: MainColors.teal.withOpacity(.1),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CustomTextField(
                    borderRadius: 20,
                    controller: messageController,
                    hintText: 'Message...',
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    fillColor: MainColors.teal.withOpacity(.4),
                    isOutlined: false,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.greenAccent),
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
        ),
      ],
    );
  }
}
