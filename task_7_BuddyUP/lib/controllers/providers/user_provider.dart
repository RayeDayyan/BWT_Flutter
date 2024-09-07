import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_7_buddyup/controllers/services/user_controller.dart';
import 'package:task_7_buddyup/models/user_model.dart';

final userProvider = FutureProvider<UserModel>((ref) async {
  final controller = UserController();

  final result = await controller.getUserData();

  return result;
});
