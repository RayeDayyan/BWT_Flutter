import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_7_buddyup/controllers/services/message_controller.dart';
import 'package:task_7_buddyup/models/user_model.dart';

final inboxProvider = StreamProvider<List<UserModel>>((ref) {
  final controller = MessageController();
  return controller.getInboxUsers();
});
