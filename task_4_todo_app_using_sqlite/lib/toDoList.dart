import 'package:flutter/material.dart';
import 'package:task_4/note.dart';
import 'dart:async';
import 'package:task_4/database_helper.dart';
import 'package:task_4/addToList.dart';
import 'package:sqflite/sqflite.dart';


class ToDoList extends StatefulWidget{




  @override
  State<ToDoList> createState () => ToDoList1();

}

class ToDoList1 extends State<ToDoList>{



  DatabaseHelper databaseHelper = DatabaseHelper();

  late List<Note> noteList;

  @override
  void initState() {
    super.initState();
    updateListView();
    noteList = []; // Initialize the noteList here
  }

  int count = 0;

  @override
  Widget build(BuildContext context){

    if(noteList==null){
      noteList = <Note>[];
      updateListView();
    }


    return Scaffold(
      appBar: AppBar(
        title:const Text(
          "My To-do list" ,
          style:TextStyle(
            letterSpacing: 2.0,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),),

        backgroundColor: Colors.red[300],
      ),

      body:getTasks(),

      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.add),
        heroTag: null,
        tooltip:"Add a todo",
        backgroundColor: Colors.red[300],
        onPressed: () async {


          bool val = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddToList()),
          );

          if(val==true){
            setState(() {
              updateListView();
            });

          }
        },
      ),
    );
  }

  ListView getTasks(){
    return ListView.builder(
      itemCount: count,
      itemBuilder:(BuildContext context ,int position){
        return Card(

          color:Colors.white,
          elevation: 2,
          child: ListTile(
            title: Text(noteList[position].note!),
            subtitle: Text(noteList[position].status!),

            trailing:GestureDetector(
              child:Icon(Icons.delete,color: Colors.grey,),
              onTap: (){
                _delete(context, this.noteList[position]);
              },
            ),


            onTap: () async {
              bool val = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddToList(note:noteList[position])),
              );

              if(val==true) {
                setState(() {
                  updateListView();
                });
              }
        debugPrint('User pressed the task');
            },
          ),



        );
      },

    );

  }

  void _delete(BuildContext context,Note note) async{
    int result = await databaseHelper.deleteNote(note.id!);

    if(result!=0){
      debugPrint('Note Deleted successfully');
      setState(() {
        updateListView();
      });

    }

  }

  void updateListView () async{
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){

      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
     // print(noteListFuture.length);

      noteListFuture.then((noteList){
        setState(() {

          this.noteList=noteList;
          this.count=noteList.length;
          print(count);
          //print(noteList[0].note);

        });
      });

    });
  }


}



