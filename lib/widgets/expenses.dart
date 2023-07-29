import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';
import 'chart/chart.dart';
import 'new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Flutter Course",
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Dinner",
        amount: 39.99,
        date: DateTime.now(),
        category: Category.food),
  ];

  void addExpense(Expense newExpense){
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void _removeExpense(Expense deleteExpense){
    final index = _registeredExpenses.indexOf(deleteExpense);
    setState(() {
      _registeredExpenses.remove(deleteExpense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        action: SnackBarAction(label: "Undo", onPressed: (){
          setState(() {
            _registeredExpenses.insert(index , deleteExpense);
          });
        }),
        content: const Text("Expense Deleted"),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(addExpense);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(child: Text("No expenses found. Start adding some!"),);

    if(_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(_removeExpense, expenses: _registeredExpenses);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
            iconSize: 40,
          )
        ],
        title: const Text(
          "Flutter Expense Tracker",
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: Column(
        children: [
          Chart(_registeredExpenses),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
