import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:real_time_chat/core/error/exeptions.dart';
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
  bool _isConnected = true;

  ChatRemoteDataSourceImpl._internal(String url)
      : _channel = WebSocketChannel.connect(Uri.parse(url)) {
    _channel.stream.listen(
      _handleMessage,
      onError: _handleError,
      onDone: _handleDone,
    );
  }

  factory ChatRemoteDataSourceImpl(String url) {
    _instance ??= ChatRemoteDataSourceImpl._internal(url);
    return _instance!;
  }

  void _handleMessage(dynamic message) {
    try {
      _socketController.add(jsonDecode(message));
    } catch (e, stackTrace) {
      final exception = ChatException("Invalid message format: $message");
      log(exception.toString(), stackTrace: stackTrace);
      _socketController.addError(exception);
    }
  }

  void _handleError(dynamic error, [StackTrace? stackTrace]) {
    log('WebSocket error: $error', stackTrace: stackTrace);
    _isConnected = false;
    final exception = ChatException("Connection error: ${error.toString()}");
    _socketController.addError(exception);
  }

  void _handleDone() {
    log('WebSocket connection closed.');
    _isConnected = false;
    const exception =
        ChatException("WebSocket connection closed unexpectedly.");
    _socketController.addError(exception);
    _socketController.close();
  }

  @override
  Stream<dynamic> get socketStream => _socketController.stream;

  @override
  void sendMessage(String message) {
    if (!_isConnected) {
      throw const ChatException("Failed to send message");
    }
    try {
      _channel.sink.add(jsonEncode({'message': message}));
    } catch (e) {
      throw const ChatException("Failed to send message");
    }
  }

  @override
  void dispose() {
    _isConnected = false;
    _socketController.close();
    _channel.sink.close();
    _instance = null;
  }
}
