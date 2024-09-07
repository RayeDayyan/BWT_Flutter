import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_7_buddyup/controllers/providers/search_provider.dart';
import 'package:task_7_buddyup/controllers/services/post_controller.dart';
import 'package:task_7_buddyup/models/post_model.dart';

final postsController = PostController();

final searchResultsProvider = FutureProvider<List<Post>?>((ref) async {
  var searchWord = ref.watch(searchProvider);
  final result = await postsController.getSearchResults(searchWord!);
  return result;
});
