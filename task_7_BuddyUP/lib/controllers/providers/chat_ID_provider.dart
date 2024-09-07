import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_7_buddyup/controllers/services/message_controller.dart';

final _messageController = MessageController();

final chatIDProvider =
    FutureProvider.family<String, String?>((ref, otherUserID) async {
  final result = await _messageController.getChatRoomID(otherUserID);
  return result;
});
