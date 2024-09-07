import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:untitled/expense.dart';


class AddExpense extends StatefulWidget{

  String option ;
  Expense? expense;

  AddExpense.add(this.option);

  AddExpense.update(this.option,this.expense);


 // AddExpense({this.option,this.expense});


  @override
  State<AddExpense> createState() => AddExpenseState();


}

class AddExpenseState extends State<AddExpense>{

  var uid = FirebaseAuth.instance.currentUser?.uid;

  var db = FirebaseDatabase.instance.ref().child('expenses');





  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();


  @override

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: Text('${widget.option} an expense'),
          backgroundColor: Colors.cyan[300],),
        body:Padding(
            padding:EdgeInsets.only(top:15,left:10,right:10),
            child:ListView(
                children:[
                  Padding(
                    padding: EdgeInsets.only(top: 15,bottom: 15,left: 20,right: 20),
                    child: Text(
                      'Enter Expense Description',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: widget.expense?.description,
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
                    padding: EdgeInsets.only(top: 15,bottom: 15,left: 20,right: 20),
                    child: Text(
                      'Enter Total Amount',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: widget.expense?.amount.toString(),
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
                      padding:EdgeInsets.only(top:15,left:20,right:20,bottom:15),
                      child:Row(
                        children: [
                          Expanded(

                              child:ElevatedButton(
                                onPressed: () async{

                                 if(widget.option=='Add') {
                                   await addExpense(uid!);
                                   Navigator.pop(context);
                                 }

                                 else if(widget.option=="Update"){
                                   await updateExpense(uid!);
                                   Navigator.pop(context);
                                 }

                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyan[300],
                                ),

                                //: Colors.red[300],

                                child:Text('Save',
                                    style:TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                    )),
                              )

                          ),

                          Container(width: 10),

                          Expanded(

                              child:ElevatedButton(
                                //heroTag: null,
                                onPressed: () async{

                                  if(widget.expense?.key!=null)  {
                                    await deleteExpense();
                                    Navigator.pop(context);
                                  }
                             //     _delete(widget.note!);
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyan[300],
                                ),


                                // backgroundColor: Colors.red[300],

                                child:Text('Delete',
                                    style:TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
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

  addExpense(String userid) async{
    String description = descriptionController.text.trim();
    double amount = double.parse(amountController.text);

    Expense newExpense = Expense(userid,description,amount);

    await db.push().set(newExpense.toJson());

  }

  updateExpense(String userid) async{
    String description = descriptionController.text.trim();
    double amount = double.parse(amountController.text);

    await db.child(widget.expense!.key).update({
      'description':description,
      'amount':amount,
    });
  }

  deleteExpense() async{
    await db.child(widget.expense!.key).remove();

  }

}
