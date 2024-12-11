import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:web_socket_channel/web_socket_channel.dart';

abstract class ChatRemoteDataSource {
  Stream<dynamic> get socketStream;
  void dispose();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final WebSocketChannel _channel;
  final StreamController<dynamic> _socketController =
      StreamController<dynamic>.broadcast();

  ChatRemoteDataSourceImpl(String url)
      : _channel = WebSocketChannel.connect(Uri.parse(url)) {
    _channel.stream.listen(
      _handleMessage,
      onError: _handleError,
      onDone: _handleDone,
    );
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
  void dispose() {
    log('Disposing WebSocket');
    _socketController.close();
    _channel.sink.close();
  }
}
