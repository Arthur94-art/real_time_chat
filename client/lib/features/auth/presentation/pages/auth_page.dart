import 'package:flutter/material.dart';
import 'package:real_time_chat/core/widgets/text_field.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: usernameController,
              hintText: 'Enter your name',
              fillColor: Colors.white70,
              isOutlined: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final username = usernameController.text;
                if (username.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a username')),
                  );
                } else {
                  Navigator.pushNamed(context, '/chat', arguments: username);
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
