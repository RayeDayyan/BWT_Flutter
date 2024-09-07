import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_7_buddyup/controllers/providers/current_post_provider.dart';
import 'package:task_7_buddyup/controllers/providers/search_provider.dart';
import 'package:task_7_buddyup/controllers/providers/search_results_provider.dart';
import 'package:task_7_buddyup/controllers/services/post_controller.dart';
import 'package:task_7_buddyup/models/post_model.dart';
import 'package:task_7_buddyup/views/dashboard/post_details.dart';
import 'package:task_7_buddyup/views/widgets/bottom_nav.dart';
import 'package:task_7_buddyup/views/widgets/custom_app_bar.dart';

class SearchResults extends ConsumerStatefulWidget {
  const SearchResults({super.key});

  @override
  ConsumerState<SearchResults> createState() => SearchResultsState();
}

class SearchResultsState extends ConsumerState<SearchResults> {
  final postsController = PostController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? searchWord = ref.watch(searchProvider);
    var searchProvider1 = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          Center(
            child: Text(
              'Search results for \'$searchWord\'',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 16.sp),
            ),
          ),
          searchProvider1.when(data: (posts) {
            if (posts?.length != 0) {
              return Expanded(
                  child: ListView.builder(
                      itemCount: posts?.length,
                      itemBuilder: (context, index) {
                        Post post = posts![index];
                        // print('inside item builder');
                        return Container(
                            width: 100.w,
                            height: 33.h,
                            child: ListTile(
                              title: Image.network(post.image),
                              subtitle: Column(
                                children: [
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Text(
                                    '${post.title}     Type : ${post.type}',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontFamily: 'Poppins',
                                        letterSpacing: 2),
                                  ),
                                ],
                              ),
                              onTap: () {
                                ref.read(currentPost.state).state = post;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PostDetails()));
                              },
                            ));
                      }));
            } else {
              return Text(
                'Oops! Nothing found',
                style: TextStyle(fontSize: 16.sp, fontFamily: 'Poppins'),
              );
            }
          }, error: (error, stackTree) {
            return const Center(
              child: Text('Erorr occured while fetching posts'),
            );
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
