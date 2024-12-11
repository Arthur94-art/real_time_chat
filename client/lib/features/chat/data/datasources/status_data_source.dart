import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:real_time_chat/core/error/exeptions.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class StatusDataSource {
  Stream<bool> get userStatusStream;
  void dispose();
}

class StatusDataSourceImpl implements StatusDataSource {
  final WebSocketChannel _channel;
  final StreamController<bool> _statusController =
      StreamController<bool>.broadcast();

  StatusDataSourceImpl(this._channel) {
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
          _statusController.add(status.toLowerCase() == 'online');
        }
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Never _handleError(Object error) {
    throw ChatException(error.toString());
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
