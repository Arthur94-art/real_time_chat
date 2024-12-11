import 'package:real_time_chat/features/chat/domain/entities/status_entity.dart';

class StatusModel extends StatusEntity {
  final DateTime timestamp;

  StatusModel({
    required super.status,
    required this.timestamp,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      status: json['status'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
