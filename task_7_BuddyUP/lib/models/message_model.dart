import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String content;
  final DateTime timeStamp;

  Message(
      {required this.senderID, required this.content, required this.timeStamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        senderID: json['senderID'],
        content: json['content'],
        timeStamp: (json['timeStamp'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'senderID': senderID,
      'content': content,
      'timeStamp': FieldValue.serverTimestamp(),
    };
  }
}
