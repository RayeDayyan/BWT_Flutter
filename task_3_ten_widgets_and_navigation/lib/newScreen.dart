import 'package:flutter/material.dart';

class NewScreen extends StatelessWidget{
  var name;
  var email;
  var number;

  NewScreen({super.key, required this.name,required this.email,required this.number});




  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar : AppBar(
          title: const Text(
            'New Screen',
            style: TextStyle(
              fontSize: 25,
              letterSpacing: 2.0,

            ),
          ),
          backgroundColor: Colors.red[300],
        ),

        body:Container(
          child:Padding(
          padding:EdgeInsets.all(10),
          child:Column(
            children: [
              Row(children: [
                Text(
                    '''Entered Name :  
$name''',
                    style:TextStyle(
                    fontSize: 30,

                    )
                ),

              ],),

              Row(children: [
                Text(
                    maxLines: 3,
                    '''Entered Email : 
$email''',
                    style:TextStyle(
                      fontSize: 30,

                    )
                ),
              ],),

              Row(children: [
                Text(
                    '''Entered Phone Number :  
$number''',
                    style:TextStyle(
                      fontSize: 30,

                    )
                ),

              ],)

            ],
          ),
        )
        )
    );
  }
}