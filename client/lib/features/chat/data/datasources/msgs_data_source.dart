import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

abstract class MsgsRemoteDataSource {
  Stream<String> get messagesStream;
  void dispose();
}

class MsgsRemoteDataSourceImpl implements MsgsRemoteDataSource {
  final WebSocketChannel _channel;
  final StreamController<String> _messagesController =
      StreamController<String>.broadcast();

  MsgsRemoteDataSourceImpl(this._channel) {
    _channel.stream.listen((data) {
      final message = jsonDecode(data);
      if (message['text'] != null) {
        _messagesController.add(message['text']);
      }
    });
  }
  @override
  Stream<String> get messagesStream => _messagesController.stream;

  @override
  void dispose() {
    _messagesController.close();
  }
}
