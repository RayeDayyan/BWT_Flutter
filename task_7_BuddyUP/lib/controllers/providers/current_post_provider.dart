import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_7_buddyup/models/post_model.dart';

final currentPost = StateProvider<Post?>((ref) => null);
