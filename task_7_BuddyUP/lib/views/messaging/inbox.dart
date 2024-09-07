import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_7_buddyup/controllers/providers/creator_id_provider.dart';
import 'package:task_7_buddyup/controllers/providers/inbox_provider.dart';
import 'package:task_7_buddyup/views/messaging/chat.dart';

class Inbox extends ConsumerStatefulWidget {
  @override
  ConsumerState<Inbox> createState() => InboxState();
}

class InboxState extends ConsumerState<Inbox> {
  final auth = FirebaseAuth.instance;
  String? uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF31473A),
        centerTitle: true,
        title: Text('Inbox',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20.sp,
                letterSpacing: 3,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      body: ref.watch(inboxProvider).when(data: (users) {
        return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 0.2.w,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.Profile != null
                        ? NetworkImage(user.Profile!)
                        : null,
                    radius: 10.w,
                  ),
                  title: Text(
                    user.Name,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.sp,
                    ),
                  ),
                  onTap: () {
                    ref.read(creatorID.state).state = user.UserID;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Chat()));
                  },
                ),
              );
            });
      }, error: (error, stackTree) {
        return const Text('error while fetching users');
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
