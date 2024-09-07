import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task_4/addToList.dart';
import 'package:task_4/toDoList.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_value.dart';




Random random = Random();

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget{

  const MyApp ({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:'Task 4',
      home:ToDoList(),



    );

  }
}
