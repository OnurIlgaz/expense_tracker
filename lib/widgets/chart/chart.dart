import 'dart:math';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart_bar.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget{
  const Chart(this.expenses, {super.key});

  final List <Expense> expenses;

  @override
  Widget build(BuildContext context) {
    double maxTotalExpense = 0.0;

    var buckets = [
      ...Category.values.map(
        (category){
          var expenseBucket = ExpenseBucket.forCategory(expenses: expenses, category: category);
          maxTotalExpense = max(maxTotalExpense, expenseBucket.sum);
          return expenseBucket;
        }),
    ];

    if(maxTotalExpense == 0) {
      maxTotalExpense = 1;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: buckets.map((bucket) => ChartBar(fill: bucket.sum / maxTotalExpense)).toList(),
            ),
          ),
          const SizedBox(height: 2,),
          Row(
            children: buckets.map((bucket) => 
              Expanded(
                child: Icon(categoryIcons[bucket.category]),
              )
            ).toList(),
          ),
          const SizedBox(height: 3,),
        ]
      ),
    );
  }
}