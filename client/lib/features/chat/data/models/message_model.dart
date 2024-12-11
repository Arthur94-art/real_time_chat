import 'package:real_time_chat/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  final DateTime timestamp;

  MessageModel({
    required super.type,
    required super.text,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      type: json['type'] as String,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
