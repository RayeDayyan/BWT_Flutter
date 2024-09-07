import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_7_buddyup/views/dashboard/home_page.dart';
import 'package:task_7_buddyup/views/authentication/signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final auth = FirebaseAuth.instance;

  bool visibility = true;

  void setVisibility() {
    setState(() {
      visibility = !visibility;
    });
  }

  void login() async {
    if (emailController.text.isNotEmpty && passController.text.isNotEmpty) {
      try {
        await auth.signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passController.text.toString());

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        print('error occured');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:  Center(
            child: Text('Incomplete credentials'),
          ),
        ),
      );
       }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'BuddyUP',
            style: TextStyle(
              fontFamily: 'LemonMilk',
              fontSize: 45,
              color: Color(
                0XFF31473A,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 50, left: 30),
          child: ListView(
            children: [
              Text('Login',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22.sp,
                  )),
              SizedBox(
                height: 10.h,
              ),
              Text('Email',
                  style: TextStyle(
                    fontFamily: 'Poppins-Light',
                    fontSize: 18.sp,
                  )),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: TextField(
                  controller: emailController,
                  style: TextStyle(
                    fontFamily: 'Poppins-Light',
                  ),
                  decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle:
                          TextStyle(fontFamily: 'Ember Light', fontSize: 14.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
              ),
              Row(
                children: [
                  Text('Password',
                      style: TextStyle(
                        fontFamily: 'Poppins-Light',
                        fontSize: 18.sp,
                      )),
                  SizedBox(
                    width: 55.w,
                  ),
                  GestureDetector(
                    onTap: setVisibility,
                    child: Icon(Icons.remove_red_eye),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: TextField(
                  obscureText: visibility,
                  controller: passController,
                  style: const TextStyle(
                    fontFamily: 'Poppins-Light',
                  ),
                  decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle:
                          TextStyle(fontFamily: 'Ember Light', fontSize: 14.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, right: 30),
                child: Container(
                    width: 85.w,
                    height: 6.5.h,
                    child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF31473A),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'Poppins-Light',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Color(0XFFEDF4F2),
                          ),
                        ))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 16.sp),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (() => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupPage()))
                        }),
                    child: Text(
                      'Crate one now !',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.sp,
                          color: Color(0xFF31473A)),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
