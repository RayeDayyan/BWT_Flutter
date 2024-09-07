import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_7_buddyup/models/user_model.dart';
import 'package:task_7_buddyup/views/authentication/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emergencyController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  bool visibility = true;

  void signUp() async {
    if (emailController.text.isNotEmpty && passController.text.isNotEmpty) {
      await auth.createUserWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passController.text.toString());

      String uid = auth.currentUser!.uid;

      UserModel user = UserModel(
          UserID: uid,
          Name: nameController.text.toString(),
          Age: int.parse(ageController.text.toString()),
          Email: emailController.text.toString(),
          Contact: phoneController.text.toString(),
          Emergency: emergencyController.text.toString(),
          Password: passController.text.toString());

      await fireStore
          .collection('users')
          .doc(auth.currentUser?.uid)
          .set(user.toJson());

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  void setVisibility() {
    setState(() {
      visibility = !visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'BuddyUP',
          style: TextStyle(
              fontFamily: 'LemonMilk', fontSize: 45, color: Color(0XFF31473A)),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 30, right: 20),
        children: [
          Text(
            'Signup',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22.sp,
            ),
          ),
          Text(
            'Email',
            style: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 18.sp,
            ),
          ),
          TextField(
            controller: emailController,
            style: const TextStyle(
              fontFamily: 'Ember Light',
            ),
            decoration: InputDecoration(
                hintText: 'Email',
                hintStyle:
                    TextStyle(fontFamily: 'Poppins-Light', fontSize: 14.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
          ),
          Text(
            'Full Name',
            style: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 18.sp,
            ),
          ),
          TextField(
            controller: nameController,
            style: const TextStyle(
              fontFamily: 'Ember Light',
            ),
            decoration: InputDecoration(
                hintText: 'Full Name',
                hintStyle:
                    TextStyle(fontFamily: 'Poppins-Light', fontSize: 14.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
          ),
          Text(
            'Phone Number',
            style: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 18.sp,
            ),
          ),
          TextField(
            controller: phoneController,
            style: const TextStyle(
              fontFamily: 'Ember Light',
            ),
            decoration: InputDecoration(
                hintText: 'Phone Number',
                hintStyle:
                    TextStyle(fontFamily: 'Poppins-Light', fontSize: 14.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
          ),
          Text(
            'Emergency Contact',
            style: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 18.sp,
            ),
          ),
          TextField(
            controller: emergencyController,
            style: const TextStyle(
              fontFamily: 'Ember Light',
            ),
            decoration: InputDecoration(
                hintText: 'Emergency Contact',
                hintStyle:
                    TextStyle(fontFamily: 'Poppins-Light', fontSize: 14.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
          ),
          Text(
            'Age',
            style: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 18.sp,
            ),
          ),
          TextField(
            controller: ageController,
            style: const TextStyle(
              fontFamily: 'Ember Light',
            ),
            decoration: InputDecoration(
                hintText: 'Age',
                hintStyle:
                    TextStyle(fontFamily: 'Poppins-Light', fontSize: 14.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
          ),
          Row(
            children: [
              Text(
                'Password',
                style: TextStyle(
                  fontFamily: 'Poppins-Light',
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(
                width: 55.w,
              ),
              GestureDetector(
                onTap: setVisibility,
                child: Icon(Icons.remove_red_eye),
              )
            ],
          ),
          TextField(
            obscureText: visibility,
            controller: passController,
            style: const TextStyle(
              fontFamily: 'Ember Light',
            ),
            decoration: InputDecoration(
                hintText: 'Password',
                hintStyle:
                    TextStyle(fontFamily: 'Poppins-Light', fontSize: 14.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            '*Password must be atleast 6 characters long',
            style: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 14.sp,
            ),
          ),
          Text(
            'Confirm Password',
            style: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 18.sp,
            ),
          ),
          TextField(
            obscureText: visibility,
            controller: confirmController,
            style: const TextStyle(
              fontFamily: 'Ember Light',
            ),
            decoration: InputDecoration(
                hintText: 'Confirm Password',
                hintStyle:
                    TextStyle(fontFamily: 'Poppins-Light', fontSize: 14.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
          ),
          SizedBox(
            height: 5.h,
          ),
          Container(
              height: 8.h,
              child: ElevatedButton(
                  onPressed: signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color((0XFF31473A)),
                  ),
                  child: Text(
                    'Signup',
                    style: TextStyle(
                      fontFamily: 'Poppins-Light',
                      fontSize: 18.sp,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFFEDF4F2),
                    ),
                  ))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14.sp),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (() => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()))
                    }),
                child: Text(
                  'Login Now !',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                      color: Color(0xFF31473A)),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
