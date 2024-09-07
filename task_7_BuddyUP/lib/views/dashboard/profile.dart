import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_7_buddyup/controllers/providers/user_provider.dart';
import 'package:task_7_buddyup/views/widgets/bottom_nav.dart';
import 'package:task_7_buddyup/views/widgets/custom_app_bar.dart';
import 'package:task_7_buddyup/views/dashboard/edit_profile.dart';

class Profile extends ConsumerStatefulWidget {
  @override
  ConsumerState<Profile> createState() => ProfileState();
}

class ProfileState extends ConsumerState<Profile> {
  final auth = FirebaseAuth.instance;

  final user = FirebaseAuth.instance.currentUser?.uid;

  final fireStore = FirebaseFirestore.instance;

  final image_picker = ImagePicker();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ref.watch(userProvider).when(
          data: (userModel) {
            String? profile = userModel.Profile;
            return ListView(
              padding: EdgeInsets.all(30),
              children: [
                CircleAvatar(
                  radius: 15.w,
                  backgroundImage:
                      userModel.Profile != null ? NetworkImage(profile!) : null,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  'Email',
                  style:
                      TextStyle(fontSize: 18.sp, fontFamily: 'Poppins-Light'),
                ),
                Text(
                  userModel.Email ?? 'dummyemail@gmail.com',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Poppins-Light',
                  ),
                ),
                Text(
                  'Full Name',
                  style:
                      TextStyle(fontSize: 18.sp, fontFamily: 'Poppins-Light'),
                ),
                Text(
                  userModel.Name ?? 'dummy name',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Poppins-Light',
                  ),
                ),
                Text(
                  'Age',
                  style:
                      TextStyle(fontSize: 18.sp, fontFamily: 'Poppins-Light'),
                ),
                Text(
                  userModel.Age.toString() ?? 'dummyage',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Poppins-Light',
                  ),
                ),
                Text(
                  'Bio',
                  style:
                      TextStyle(fontSize: 18.sp, fontFamily: 'Poppins-Light'),
                ),
                Text(
                  userModel.Bio ?? 'dummybio',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Poppins-Light',
                  ),
                ),
                Text(
                  'Phone Number',
                  style:
                      TextStyle(fontSize: 18.sp, fontFamily: 'Poppins-Light'),
                ),
                Text(
                  userModel.Contact ?? 'dummyemail@gmail.com',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Poppins-Light',
                  ),
                ),
                Text(
                  'Emergency Contact',
                  style:
                      TextStyle(fontSize: 18.sp, fontFamily: 'Poppins-Light'),
                ),
                Text(
                  userModel.Emergency ?? 'dummyemail@gmail.com',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Poppins-Light',
                  ),
                ),
                Text(
                  'Password',
                  style:
                      TextStyle(fontSize: 18.sp, fontFamily: 'Poppins-Light'),
                ),
                Text(
                  userModel.Password ?? '*********',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Poppins-Light',
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                    height: 6.5.h,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color((0xFF31473A)),
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            fontFamily: 'Ember Light',
                            fontSize: 16.sp,
                            wordSpacing: 2,
                            fontWeight: FontWeight.bold,
                            color: Color(0XFFEDF4F2),
                          ),
                        )))
              ],
            );
          },
          error: (error, stackTree) {
            return const Text("error occured");
          },
          loading: () => const Center(
                child: CircularProgressIndicator(),
              )),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
