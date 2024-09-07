import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_7_buddyup/controllers/providers/search_provider.dart';
import 'package:task_7_buddyup/controllers/services/post_controller.dart';
import 'package:task_7_buddyup/views/dashboard/search_results.dart';

class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<CustomAppBar> createState() => CustomAppBarState();
}

class CustomAppBarState extends ConsumerState<CustomAppBar> {
  TextEditingController searchController = TextEditingController();
  final postsController = PostController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 2.w,
            ),
            Expanded(
                child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontFamily: 'Ember',
                  ),
                  border: InputBorder.none),
            )),
            IconButton(
              onPressed: () {
                ref.read(searchProvider.state).state =
                    searchController.text.toString();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchResults()));
              },
              icon: const Icon(Icons.search),
            ),
            SizedBox(
              width: 1.w,
            ),
          ],
        ),
      ),
      centerTitle: true,
      backgroundColor: Color(0xFF31473A),
      automaticallyImplyLeading: false,
    );
  }
}
