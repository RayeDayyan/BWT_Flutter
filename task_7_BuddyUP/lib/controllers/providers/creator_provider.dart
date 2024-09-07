import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_7_buddyup/controllers/providers/creator_id_provider.dart';
import 'package:task_7_buddyup/controllers/services/user_controller.dart';
import 'package:task_7_buddyup/models/user_model.dart';

final userController = UserController();

final creatorProvider = FutureProvider<UserModel?>((ref) async {
  final creator = ref.read(creatorID.state).state;
  final result = await userController.getCreator(creator!);
  return result;
});
