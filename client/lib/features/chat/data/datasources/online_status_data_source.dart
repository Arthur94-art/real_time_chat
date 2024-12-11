import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:web_socket_channel/web_socket_channel.dart';

abstract class OnlineStatusDataSource {
  Stream<bool> get userStatusStream;
  void dispose();
}

class OnlineStatusDataSourceImpl implements OnlineStatusDataSource {
  final WebSocketChannel _channel;
  final StreamController<bool> _statusController =
      StreamController<bool>.broadcast();

  OnlineStatusDataSourceImpl(this._channel) {
    _channel.stream.listen(
      _handleMessage,
      onError: _handleError,
      onDone: _handleDone,
    );
  }

  void _handleMessage(dynamic message) {
    try {
      final decodedMessage = jsonDecode(message);

      if (decodedMessage is Map && decodedMessage.containsKey('status')) {
        final status = decodedMessage['status'];
        if (status is String) {
          log('Raw message: $message');
          _statusController.add(status.toLowerCase() == 'online');
        }
      }
    } catch (e) {
      log('Failed to decode message: $e');
    }
  }

  void _handleError(Object error) {
    log('Error in WebSocket: $error');
    _statusController.addError('Failed to fetch status: $error');
  }

  void _handleDone() {
    log('WebSocket stream closed');
    _statusController.close();
  }

  @override
  Stream<bool> get userStatusStream => _statusController.stream;

  @override
  void dispose() {
    _statusController.close();
    _channel.sink.close();
  }
}
