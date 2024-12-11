import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_time_chat/core/DI/locator.dart';
import 'package:real_time_chat/core/router/navigation_helper.dart';
import 'package:real_time_chat/core/router/routes_paths.dart';
import 'package:real_time_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:real_time_chat/features/chat/domain/entities/status_entity.dart';
import 'package:real_time_chat/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:real_time_chat/features/chat/presentation/widgets/chat_input.dart';
import 'package:real_time_chat/features/chat/presentation/widgets/chat_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatBloc>()
        ..add(const ListenToOnlineStatus())
        ..add(const ListenMessages()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            NavigationHelper.pushAndRemoveUntil(context, RoutesPaths.auth);
          }
        },
        child: const ChatWidget(),
      ),
    );
  }
}

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            StreamBuilder<StatusEntity>(
              stream: context.read<ChatBloc>().statusStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'Loading...',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  );
                }

                if (snapshot.hasError) {
                  return const Text(
                    'Error fetching status',
                    style: TextStyle(fontSize: 14, color: Colors.redAccent),
                  );
                }

                if (snapshot.hasData) {
                  final isOnline = snapshot.data?.status == 'online';
                  if (isOnline) {
                    return const Text(
                      'Writting...',
                      style: TextStyle(fontSize: 14, color: Colors.greenAccent),
                    );
                  } else {
                    return const Text(
                      'Last seen just now',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    );
                  }
                }

                return const Text(
                  'Unknown status',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                );
              },
            ),
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
          ),
        ],
      ),
      body: const Column(
        children: [
          ChatList(),
          ChatInput(),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;

  ChatMessage({required this.text, required this.isMe});
}

final List<ChatMessage> messages = [];
