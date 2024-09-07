import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_7_buddyup/views/authentication/login_page.dart';
import 'package:task_7_buddyup/views/dashboard/my_posts.dart';
import 'package:task_7_buddyup/views/messaging/inbox.dart';
import 'package:task_7_buddyup/views/widgets/bottom_nav.dart';
import 'package:task_7_buddyup/views/widgets/custom_app_bar.dart';

class UserSettings extends StatefulWidget {
  @override
  State<UserSettings> createState() => SettingsState();
}

class SettingsState extends State<UserSettings> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(color: Colors.black, width: 1)),
            ),
            padding: EdgeInsets.all(10),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Inbox()));
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'Inbox',
                      style: TextStyle(fontSize: 16.sp, fontFamily: 'Poppins'),
                    ),
                    SizedBox(
                      width: 70.w,
                    ),
                    Icon(Icons.message),
                  ],
                )),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(color: Colors.black, width: 1)),
            ),
            padding: EdgeInsets.all(10),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyPosts()));
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'My Posts',
                      style: TextStyle(fontSize: 16.sp, fontFamily: 'Poppins'),
                    ),
                    SizedBox(
                      width: 65.w,
                    ),
                    Icon(Icons.send),
                  ],
                )),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(color: Colors.black, width: 1)),
            ),
            padding: EdgeInsets.all(10),
            child: GestureDetector(
                onTap: () {
                  auth.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(fontSize: 16.sp, fontFamily: 'Poppins'),
                    ),
                    SizedBox(
                      width: 68.w,
                    ),
                    Icon(Icons.logout),
                  ],
                )),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
