import 'package:apartmantmanager/global/index.dart';
import 'package:flutter/material.dart';

class AddIncomeExpenses extends StatefulWidget {
  const AddIncomeExpenses({super.key});

  @override
  State<AddIncomeExpenses> createState() => _AddIncomeExpensesState();
}

class _AddIncomeExpensesState extends State<AddIncomeExpenses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("Add Income & Expenses".tr()),
    ));
  }
}
