// import 'dart:developer';

// import 'package:web_socket_channel/web_socket_channel.dart';

// class WSService {
//   final String url;
//   late WebSocketChannel _channel;
//   bool isConnected = false;

//   WSService(this.url);

//   WebSocketChannel get channel => _channel;

//   void connect() {
//     try {
//       _channel = WebSocketChannel.connect(Uri.parse(url));
//       isConnected = true;

//       log('WebSocket connected to $url');
//     } catch (e) {
//       isConnected = false;
//       log('Failed to connect to WebSocket: $e');
//     }
//   }

//   Stream<dynamic> get messages => _channel.stream;

//   void sendMessage(String message) {
//     if (isConnected) {
//       _channel.sink.add(message);
//     } else {
//       log('Cannot send message, WebSocket is not connected');
//     }
//   }

//   void closeConnection() {
//     _channel.sink.close();
//     isConnected = false;
//     log('WebSocket connection closed');
//   }
// }
