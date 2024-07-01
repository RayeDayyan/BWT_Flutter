import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class Expense {

  String id ;
  String description;
  var amount;
  String key;


  Expense(this.id,this.description,this.amount,{this.key=''});

  Map<String,dynamic> toJson(){
    Map<String,dynamic> map = Map<String,dynamic>();
    map['id']=this.id;
    map['description']=this.description;
    map['amount']=this.amount;

    return map;

  }






}