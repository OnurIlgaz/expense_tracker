import 'package:flutter/material.dart';

import '../../models/expense.dart';
import 'expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(this._removeExpense, {super.key, required this.expenses});

  final List<Expense> expenses;

  final void Function(Expense) _removeExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]), 
        onDismissed: (dismissDirection){
          _removeExpense(expenses[index]);
        },
        child: ExpenseItem(expenses[index])
      ),
    );
  }
}
