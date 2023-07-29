import 'package:flutter/material.dart';

import '../models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense(this.addExpense,{Key? key}) : super(key: key);

  final void Function(Expense) addExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category? _selectedCategory;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitExpenseData() {
    final amount = double.tryParse(_amountController.text);
    final amountValidation =(amount == null || _amountController.text.trim().isEmpty)? false: true;
    final titleValidation = _titleController.text.trim().isEmpty ? false : true;
    final dateValidation = _selectedDate == null ? false : true;
    final categoryValidation = _selectedCategory == null ? false : true;

    if (!titleValidation || !amountValidation || !dateValidation || !categoryValidation) {
      showDialog(
        context: context,
        builder: ((ctx) =>  AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text("Please make sure a valid title, amount, date and category was entered"),
          actions: [
            TextButton(
              onPressed: (){Navigator.pop(ctx);},
              child: const Text("Okay"),
            ),
          ],
        )),
      );
      return;
    }
    widget.addExpense(Expense(amount: amount, title: _titleController.text, date: _selectedDate!, category: _selectedCategory!));
    _closeOverlay();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _closeOverlay() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(labelText: "Title"),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    prefixText: "\$ ",
                    label: Text("Amount"),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(_selectedDate == null
                        ? "No date selected"
                        : formatter.format(_selectedDate!)),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toString()),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = val;
                    });
                  }),
              const Spacer(),
              Row(children: [
                TextButton(
                  onPressed: _closeOverlay,
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: _submitExpenseData,
                  child: const Text("Add Expense"),
                ),
              ])
            ],
          )
        ],
      ),
    );
  }
}
