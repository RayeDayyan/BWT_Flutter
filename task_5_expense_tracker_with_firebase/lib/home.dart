import 'dart:async';

import 'package:flutter/material.dart';
import 'package:untitled/addExpense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:untitled/expense.dart';

class Home extends StatefulWidget {
  var name;
  Home(this.name);


  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final uid = FirebaseAuth.instance.currentUser!;
  final db = FirebaseDatabase.instance.ref().child('expenses');
  List<Expense> expenses = [];

  String username = '';



  @override
  void initState() {
    super.initState();
    fetchExpenses();
    fetchUsername();
  }

  void fetchUsername() {
    List<String> parts = widget.name.split('@');
    String username = parts[0];
    username = username.substring(0,1).toUpperCase() + username.substring(1).toLowerCase();

    setState(() {
      this.username=username;
    });

  }

  void fetchExpenses() async {
    Query userExpensesQuery = db.orderByChild('id').equalTo(uid.uid);

    userExpensesQuery.once().then((event) {
      List<Expense> fetchedExpenses = [];
      final datasnapshot = event.snapshot;

      for (var snapshot in datasnapshot.children) {
        if (snapshot.value != null) {
          final Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
          Expense expense = Expense(
            data['id'],
            data['description'],
            data['amount'],
            key: snapshot.key!,
          );
          fetchedExpenses.add(expense);
        }
      }
      setState(() {
        expenses = fetchedExpenses;
      });
    });
  }

  double getTotalAmount() {
    return expenses.fold(0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${username}'s Expense Manager",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.cyan[300],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.cyan[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  getTotalAmount().toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          expenses.isEmpty
              ? Center(
            child: Text('No data available'),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(expenses[index].description.toString()),
                  subtitle: Text(expenses[index].amount.toString()),
                  trailing: GestureDetector(
                    child: Icon(Icons.delete),
                    onTap: () {
                      deleteExpense(expenses[index].key);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddExpense.update('Update', expenses[index]),
                      ),
                    ).then((expense1) {
                      setState(() {
                        fetchExpenses();
                      });
                    });
                  },
                );
              },
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpense.add('Add')),
          ).then((expense1) {
            setState(() {
              fetchExpenses();
            });
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan[300],
      ),
    );
  }

  deleteExpense(String key) async {
    await db.child(key).remove();
    setState(() {
      fetchExpenses();
    });
  }
}
