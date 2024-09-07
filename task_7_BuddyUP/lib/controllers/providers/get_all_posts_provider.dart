import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_7_buddyup/controllers/services/post_controller.dart';
import 'package:task_7_buddyup/models/post_model.dart';

final postsController = PostController();

final getAllPostsProvider = FutureProvider<List<Post>?>((ref) async {
  final result = await postsController.getAllPosts();
  return result;
});
