import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_7_buddyup/controllers/services/message_controller.dart';
import 'package:task_7_buddyup/models/message_model.dart';

final _messageController = MessageController();

final getChatsProvider =
    StreamProvider.family<List<Message>, String>((ref, chatID) {
  return _messageController.getMessages(chatID);
});
