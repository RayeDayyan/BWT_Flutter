import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:task_4/note.dart';
import 'package:task_4/database_helper.dart';
import 'package:intl/intl.dart';

import 'main.dart';


//TextEditingController noteController = TextEditingController();


class AddToList extends StatefulWidget{




  Note? note;

  AddToList({super.key,this.note});

  @override
  State<AddToList> createState() => AddToList1();

}

class AddToList1 extends State<AddToList>{



  //Note note;
  //String _status = ['pending','completed'];
  String _current = 'pending';


  @override
  void initState() {

    if(widget.note!=null) {
      noteController.text = widget.note!.note!;
      _current = widget.note!.status!;



    }

    super.initState();
  }


  //AddToList1();

  DatabaseHelper databaseHelper = DatabaseHelper();

  final noteController = TextEditingController();


  @override
  Widget build(BuildContext context){

    //noteController.text = note.note!;


    // if(note.status!=''){
    //   _current=note.status!;
    // }

    return Scaffold(
        appBar: AppBar(
          leading:IconButton(
            icon:Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title:const Text("Add/edit a note",
              style:TextStyle(
                letterSpacing: 2.0,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )
          ),
          backgroundColor: Colors.red[300],
        ),

        body:Padding(
            padding:EdgeInsets.only(top:15,left:10,right:10),
            child:ListView(
                children:[
                  ListTile(
                    title:DropdownButton<String>(
                      value: _current,
                      onChanged: (String? newValue) {
                        setState(() {
                          _current = newValue!;
                        });
                      },
                      items: <String>['completed', 'pending']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),

                  ),

                  Padding(
                    padding:EdgeInsets.only(top:15,bottom:15),
                    child:TextField(
                      controller:noteController,
                      style:const TextStyle(
                        fontSize: 20,
                      ),

                      onChanged: (value){
                        //note.note=noteController.text;
                      },

                      decoration: InputDecoration(
                          labelText: 'Task',
                          labelStyle: TextStyle(
                            fontSize: 20,
                          ),
                          border:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          )
                      ),

                    ),
                  ),

                  Padding(
                      padding:EdgeInsets.only(top:15,bottom:15),
                      child:Row(
                        children: [
                          Expanded(

                              child:ElevatedButton(
                                onPressed: (){
                                  debugPrint('User pressed Save Button');

                                  var id = random.nextInt(10000);

                                  Note note = Note(
                                    id: id,
                                    note: noteController.text.trim(),
                                    status: _current,
                                    date:DateTime.now().toString(),

                                  );
                                  _save(note);
                                },

                                //: Colors.red[300],

                                child:Text('Save',
                                    style:TextStyle(
                                      fontSize: 25,
                                    )),
                              )

                          ),

                          Container(width: 10),

                          Expanded(

                              child:ElevatedButton(
                                //heroTag: null,
                                onPressed: (){
                                  debugPrint('User pressed Delete Button');
                                  _delete(widget.note!);
                                },

                               // backgroundColor: Colors.red[300],

                                child:Text('Delete',
                                    style:TextStyle(
                                      fontSize: 25,
                                    )),
                              )

                          )

                        ],
                      )
                  )
                ]
            )


        )


    );
  }

  void _save(Note note) async{

    Navigator.pop(context,true);


    if(widget.note!=null){
      await databaseHelper.updateNote(note);
    }

    else{
      await databaseHelper.insertNote(note);
    }

  }

  void _delete(Note note) async{

    Navigator.pop(context,true);

    if(note.id==null){
      return;
    }

    await databaseHelper.deleteNote(note.id!);


  }



}


