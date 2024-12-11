import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:web_socket_channel/web_socket_channel.dart';

abstract class ChatRemoteDataSource {
  Stream<dynamic> get socketStream;
  void sendMessage(String message);
  void dispose();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  static ChatRemoteDataSourceImpl? _instance;
  final WebSocketChannel _channel;
  final StreamController<dynamic> _socketController =
      StreamController<dynamic>.broadcast();

  ChatRemoteDataSourceImpl._internal(String url)
      : _channel = WebSocketChannel.connect(Uri.parse(url)) {
    _channel.stream.listen(
      _handleMessage,
      onError: _handleError,
      onDone: _handleDone,
    );
  }

  factory ChatRemoteDataSourceImpl(String url) {
    if (_instance == null) {
      _instance = ChatRemoteDataSourceImpl._internal(url);
    } else {
      log('Reusing existing ChatRemoteDataSourceImpl instance');
    }
    return _instance!;
  }

  void _handleMessage(dynamic message) {
    log('Received WebSocket message: $message');
    try {
      _socketController.add(jsonDecode(message));
    } catch (e) {
      log('Error decoding message: $e');
    }
  }

  void _handleError(dynamic error) {
    log('WebSocket error: $error');
    _socketController.addError(error);
  }

  void _handleDone() {
    log('WebSocket closed');
    _socketController.close();
  }

  @override
  Stream<dynamic> get socketStream => _socketController.stream;

  @override
  void sendMessage(String message) {
    try {
      log('Sending message: $message');
      _channel.sink.add(jsonEncode({'message': message}));
    } catch (e) {
      log('Failed to send message: $e');
    }
  }

  @override
  void dispose() {
    log('Disposing WebSocket');
    _socketController.close();
    _channel.sink.close();
    _instance = null;
  }
}
