import 'dart:async';
import 'dart:developer';

import 'package:web_socket_channel/web_socket_channel.dart';

abstract class OnlineStatusDataSource {
  Stream<bool> get userStatusStream;
}

class OnlineStatusDataSourceImpl implements OnlineStatusDataSource {
  final WebSocketChannel _channel;
  final StreamController<bool> _statusController = StreamController<bool>();

  OnlineStatusDataSourceImpl(this._channel) {
    log('Initializing OnlineStatusDataSourceImpl');
    try {
      _channel.stream.listen(
        (event) {
          final message = event.toString();
          log(message.toString());
          if (message.contains('online')) {
            _statusController.add(true);
          } else if (message.contains('offline')) {
            _statusController.add(false);
          }
        },
        onError: (error) {
          log('Error in WebSocket: $error');
          _statusController.addError('Failed to fetch status: $error');
        },
        onDone: () {
          log('WebSocket stream closed');
          _statusController.close();
        },
      );
    } catch (e) {
      log('Error initializing OnlineStatusDataSourceImpl: $e');
    }
  }

  @override
  Stream<bool> get userStatusStream => _statusController.stream;

  void dispose() {
    _statusController.close();
    _channel.sink.close();
  }
}
