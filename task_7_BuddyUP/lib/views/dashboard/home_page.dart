import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_7_buddyup/controllers/providers/current_post_provider.dart';
import 'package:task_7_buddyup/controllers/services/post_controller.dart';
import 'package:task_7_buddyup/controllers/services/user_controller.dart';
import 'package:task_7_buddyup/models/post_model.dart';
import 'package:task_7_buddyup/views/dashboard/post_details.dart';
import 'package:task_7_buddyup/views/widgets/bottom_nav.dart';
import 'package:task_7_buddyup/controllers/providers/get_all_posts_provider.dart';
import 'package:task_7_buddyup/views/widgets/custom_app_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final postsController = PostController();
  final userController = UserController();

  @override
  void initState() {
    super.initState();
    userController.requestNotificationPermission();
    userController.firebaseInit(context);
    userController.updateFCMToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ref.watch(getAllPostsProvider).when(
        data: (posts) {
          return ListView.builder(
            itemCount: posts?.length,
            itemBuilder: (context, index) {
              Post post = posts![index];
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 1.h, horizontal: 2.w), // Adds margin
                child: Container(
                  width: 100.w,
                  height: 33.h,
                  child: ListTile(
                    title: Image.network(post.image),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the start
                      children: [
                        SizedBox(height: 1.h),
                        Text(
                          '${post.title} Type : ${post.type}',
                          maxLines: 5,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Poppins',
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                    onTap: () {
                      ref.read(currentPost.state).state = post;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostDetails()),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTree) {
          return const Center(
            child: Text('Error occurred while fetching posts'),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
