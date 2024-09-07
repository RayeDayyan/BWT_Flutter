import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/login.dart';
import 'package:untitled/home.dart';

class Signup extends StatefulWidget{

@override
State<Signup> createState() => SignupState();
}

class SignupState extends State<Signup>
{

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome!',
          style: TextStyle(
            fontSize: 25,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.cyan[300],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'E-Mail',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.only(top:10),

              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextField(
                controller: passController,
                decoration: InputDecoration(
                  labelText: '* * * * *',
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            Padding(padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                child:Row(
                    children:[Expanded(child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder:(context) => Login()));
                      },
                      child: Text('Login',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan[300],
                      ),

                    ))
                    ]
                )
            ),

            Padding(padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                child:Row(
                    children:[Expanded(child: ElevatedButton(
                      onPressed: () async {
                         await signup(emailController.text,passController.text);
                         Navigator.push(context,MaterialPageRoute(builder: (context) => Home(auth.currentUser?.email.toString())));

                      },
                      child: Text('Sign-up',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan[300],
                      ),

                    ))
                    ]
                )
            )


          ],
        ),
      ),
    );
  }

  signup (String email,String password) async{

    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    }on FirebaseAuthException catch(e){
      debugPrint(e.toString());
    }


  }


}
