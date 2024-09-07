import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_7_buddyup/controllers/services/post_controller.dart';
import 'package:task_7_buddyup/models/post_model.dart';

final myPosts = FutureProvider<List<Post>?>((ref) async {
  final controller = PostController();
  final result = controller.getMyPosts();
  return result;
});
