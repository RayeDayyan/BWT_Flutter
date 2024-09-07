import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_7_buddyup/views/dashboard/add_post.dart';
import 'package:task_7_buddyup/views/dashboard/home_page.dart';
import 'package:task_7_buddyup/views/dashboard/profile.dart';
import 'package:task_7_buddyup/views/dashboard/settings.dart';

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 6.5.h,
      color: Color(0xFF31473A),
      child: Row(
        children: [
          SizedBox(
            width: 10.w,
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              icon: Icon(
                Icons.home,
                color: Color(0XFFE5E5E5),
                size: 4.h,
              )),
          SizedBox(
            width: 10.w,
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              icon: Icon(
                Icons.person,
                color: Color(0XFFE5E5E5),
                size: 4.h,
              )),
          SizedBox(
            width: 10.w,
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPost()));
              },
              icon: Icon(
                Icons.add_box,
                color: Color(0XFFE5E5E5),
                size: 4.h,
              )),
          SizedBox(
            width: 10.w,
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserSettings()));
              },
              icon: Icon(
                Icons.menu,
                color: Color(0XFFE5E5E5),
                size: 4.h,
              )),
        ],
      ),
    );
  }
}
