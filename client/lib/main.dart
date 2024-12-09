import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('ws://10.0.2.2:3000'),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('WebSocket Connection')),
        body: Center(
          child: StreamBuilder(
            stream: _channel.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                log(snapshot.data.toString());
                return const Text('Connected to WebSocket');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                log(snapshot.data.toString());

                return const Text('Connecting...');
              } else if (snapshot.connectionState == ConnectionState.done) {
                log(snapshot.data.toString());

                return const Text('Connection closed');
              } else {
                log(snapshot.data.toString());

                return const Text('Failed to connect');
              }
            },
          ),
        ),
      ),
    );
  }
}
