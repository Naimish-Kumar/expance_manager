import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/expence_item.dart';

class ExpenseManager extends StatefulWidget {
  @override
  _ExpenseManagerState createState() => _ExpenseManagerState();
}

class _ExpenseManagerState extends State<ExpenseManager> {
  TextEditingController priceController = TextEditingController();
  TextEditingController expenseController = TextEditingController();
  List<ExpenseItem> expenses = [];

  @override
  void initState() {
    super.initState();
    loadExpenses();
    calculateTotalExpenses();
  }

  

  void loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      expenses = (prefs.getStringList('expenses') ?? [])
          .map((item) => ExpenseItem.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }
 double calculateTotalExpenses() {
    double total = 0.0;
    for (var expense in expenses) {
      total += double.parse(expense.price);
    }
    return total;
  }

  void saveExpense(ExpenseItem expense) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    expenses.add(expense);
    prefs.setStringList('expenses',
        expenses.map((item) => item.toJson()).cast<String>().toList());
  }

  void updateExpense(int index, ExpenseItem updatedExpense) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      expenses[index] = updatedExpense;
    });
    prefs.setStringList('expenses',
        expenses.map((item) => item.toJson()).cast<String>().toList());
  }

  void deleteExpense(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      expenses.removeAt(index);
    });
    prefs.setStringList('expenses',
        expenses.map((item) => item.toJson()).cast<String>().toList());
  }

  void deleteAllExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      expenses.clear();
    });
    prefs.remove('expenses');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.indigo],
            ),
          ),
          child: AppBar(
            foregroundColor: Colors.white,
            title: Text(
              'Expense App',
              style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
            ),
            forceMaterialTransparency: true,
            actions: [
               Padding(
                 padding: const EdgeInsets.only(right: 10),
                 child: Center(child: Text('Total:-  ₹${calculateTotalExpenses().ceil()}',style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),)),
               )
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/saving.png',
                  height: 100,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Exp',
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 25)),
                      TextSpan(
                          text: 'ense',
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 25)),
                      TextSpan(
                          text: ' Mana',
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 25)),
                      TextSpan(
                          text: 'ger',
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                              fontSize: 25)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.currency_rupee),
                    labelText: 'Enter Price',
                    labelStyle: GoogleFonts.lato(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: expenseController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.shopping_bag),
                    labelStyle: GoogleFonts.lato(fontWeight: FontWeight.bold),
                    labelText: 'Enter Expense',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String price = priceController.text;
              String expense = expenseController.text;
              if (price.isNotEmpty && expense.isNotEmpty) {
                DateTime now = DateTime.now();
                String formattedDate =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                ExpenseItem newExpense =
                    ExpenseItem(price, expense, formattedDate);
                saveExpense(newExpense);
                priceController.clear();
                expenseController.clear();
                setState(() {
                  expenses = expenses;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Add Expense',
                style:
                    GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Delete all expenses
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Delete All Expenses',
                      style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      'Are you sure you want to delete all expenses?',
                      style: GoogleFonts.actor(fontWeight: FontWeight.w500),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          deleteAllExpenses();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Delete All',
                          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              'Delete All Expances',
              style: GoogleFonts.lato(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (BuildContext context, int index) {
                ExpenseItem expense = expenses[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        '₹${NumberFormat.currency(locale: 'en_IN', symbol: '').format(double.parse(expense.price))} - ${expense.expense}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'Date:- ${expense.dateTime}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // Show a dialog to edit the expense
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  TextEditingController updatedPriceController =
                                      TextEditingController(
                                          text: expense.price);
                                  TextEditingController
                                      updatedExpenseController =
                                      TextEditingController(
                                          text: expense.expense);
                                  return AlertDialog(
                                    title: Text('Edit Expense',
                                        style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w500)),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: updatedPriceController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(Icons.currency_rupee),
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            labelText: 'Enter Expense',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextField(
                                          controller: updatedExpenseController,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                                Icons.shopping_bag_rounded),
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            labelText: 'Enter Expense',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          String updatedPrice =
                                              updatedPriceController.text;
                                          String updatedExpense =
                                              updatedExpenseController.text;
                                          if (updatedPrice.isNotEmpty &&
                                              updatedExpense.isNotEmpty) {
                                            DateTime now = DateTime.now();
                                            String formattedDate = DateFormat(
                                                    'yyyy-MM-dd HH:mm:ss')
                                                .format(now);
                                            ExpenseItem updatedItem =
                                                ExpenseItem(
                                                    updatedPrice,
                                                    updatedExpense,
                                                    formattedDate);
                                            updateExpense(index, updatedItem);
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text('Save',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              // Confirm and delete the expense
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Delete Expense',
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete this expense?',
                                      style: GoogleFonts.lato(),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteExpense(index);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Delete',
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
