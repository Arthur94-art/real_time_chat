import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  late WebSocketChannel _channel;

  bool isConnected = false;

  WebSocketService(this.url) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      isConnected = true;
    } catch (e) {
      isConnected = false;
    }
  }

  Stream<dynamic> get messages => _channel.stream;

  void sendMessage(String message) {
    if (isConnected) {
      _channel.sink.add(message);
    }
  }

  void closeConnection() {
    _channel.sink.close();
    isConnected = false;
  }
}
