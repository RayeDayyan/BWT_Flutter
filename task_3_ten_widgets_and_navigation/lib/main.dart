import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_3/newScreen.dart';

var nameController = TextEditingController();
var emailController = TextEditingController();
var numberController = TextEditingController();
var countryController = TextEditingController();


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home:MyHome(),
      routes: {
        '/homePage' : (context) => const MyHome(),
        '/newScreen': (context) =>  NewScreen(
            name:nameController.text,
            email:emailController.text,
            number:numberController.text),
      },
    );
  }

}

class MyHome extends StatefulWidget{
  const MyHome({super.key});

  @override
  State<MyHome> createState() => MyHomePage();




}

class MyHomePage extends State<MyHome>{




var val1 = 'Pakistan';

@override
  Widget build(BuildContext context){
    return Scaffold(
      appBar : AppBar(
        title: const Text(
            'Third Task',
             style: TextStyle(
               fontSize: 25,
               letterSpacing: 2.0,

             ),
        ),
        backgroundColor: Colors.red[300],
      ),

      body:Container(
        child: Padding(
          padding:EdgeInsets.all(10),
          child:Column(
          children : [Row(
          children:[
              Text(
                  'Name:',
                  style:TextStyle(
                    fontSize: 30,

                  )
              ),

          ]
        ),
          Row(
              children:[
                Expanded(
                child:TextField(
                  controller:nameController,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                )
              ]
          ),

            Row(
                children:[
                  Text(
                      'Email:',
                      style:TextStyle(
                        fontSize: 30,

                      )
                  ),

                ]
            ),
            Row(
                children:[
                  Expanded(
                    child:TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller:emailController,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  )
                ]
            ),

            Row(
                children:[
                  Text(
                      'Phone Number:',
                      style:TextStyle(
                        fontSize: 30,

                      )
                  ),

                ]
            ),
            Row(
                children:[
                  Expanded(
                    child:TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller:numberController,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  )
                ]
            ),


            Container(
            margin:EdgeInsets.only(top:20),
            child:ElevatedButton(
                onPressed: ((){
                  Navigator.pushNamed(context, '/newScreen');
                }),
                style:ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[300],
                  padding: EdgeInsets.all(20),

                ),
                child: const Text(
                    'Submit',
                    style:TextStyle(fontSize: 30,color:Colors.black),

                ))
            )
            // Row(
            //     children:[
            //       Text(
            //           'Country:',
            //           style:TextStyle(
            //             fontSize: 30,
            //
            //           )
            //       ),
            //
            //     ]
            // ),
            // SizedBox(
            //   width: double.infinity,
            //   child: DropdownButton<String>(
            //     items: const [
            //       DropdownMenuItem<String>(
            //         child: Text('Dubai'),
            //         value: 'Dubai',
            //       ),
            //       DropdownMenuItem<String>(
            //         child: Text('Australia'),
            //         value: 'Australia',
            //       ),
            //     ],
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         val1 = newValue!;
            //       });
            //     },
            //     icon: const Icon(Icons.menu),
            //     style: const TextStyle(fontSize: 30),
            //     value: val1,
            //     isExpanded: true,
            //   ),
            // ),



          ]
        ),
        )


      ),

    );
  }


}