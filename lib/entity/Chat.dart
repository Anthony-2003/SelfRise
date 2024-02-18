import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String senderId;
  final String content;
  final DateTime timestamp;

  Chat({
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      senderId: map['senderId'],
      content: map['content'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
