import 'package:apartmantmanager/modules/manager-apartment/manager-service.dart';
import 'package:apartmantmanager/widgets/custom_alert.dart';
import 'package:apartmantmanager/widgets/form_field.dart';
import 'package:flutter/material.dart';

import 'package:apartmantmanager/global/index.dart';

class AddIncomeExpenses extends StatefulWidget {
  const AddIncomeExpenses({super.key});

  @override
  State<AddIncomeExpenses> createState() => _AddIncomeExpensesState();
}

class _AddIncomeExpensesState extends State<AddIncomeExpenses> {
  final globalService = GetIt.I<GlobalService>();
  final managerService = GetIt.I<ManagerService>();
  final _formKey = GlobalKey<FormState>();

  int _transactionType = 1; // 1 for income, -1 for expense

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Income & Expenses".tr(),
        ),
        elevation: 0,
        backgroundColor: GlobalConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          FormWidgets.buildSectionHeader(
                            "Transaction Details".tr(),
                            Icons.account_balance_wallet_outlined,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // _buildDateField(
                          //   context,
                          //   label: "Start Date",
                          //   dateSubject: managerService.startDate$,
                          // ),
                          FormWidgets.buildFormField(
                            "Description".tr(),
                            managerService.descriptionCont,
                            required: true,
                          ),
                          FormWidgets.buildFormField(
                            "Amount".tr(),
                            managerService.amountCont,
                            keyboardType: TextInputType.number,
                            required: true,
                            prefix: Text('₺ ',
                                style: AppTextStyles.cardTitle.copyWith(
                                  fontSize: 15,
                                )),
                            customValidator: _validateAmount,
                          ),
                          _buildTransactionTypeSelector(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildTransactionTypeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade400)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _transactionType = 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _transactionType == 1
                      ? Colors.green.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: _transactionType == 1 ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Income".tr(),
                      style: TextStyle(
                        color:
                            _transactionType == 1 ? Colors.green : Colors.grey,
                        fontWeight: _transactionType == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _transactionType = -1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _transactionType == -1
                      ? Colors.red.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: _transactionType == -1 ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Expense".tr(),
                      style: TextStyle(
                        color:
                            _transactionType == -1 ? Colors.red : Colors.grey,
                        fontWeight: _transactionType == -1
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, BehaviorSubject<DateTime?> dateSubject) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      DateTime defaultDateTime = dateSubject == managerService.startDate$
          ? pickedDate.copyWith(hour: 10, minute: 0, second: 0, millisecond: 0)
          : pickedDate.copyWith(hour: 17, minute: 0, second: 0, millisecond: 0);

      dateSubject.add(defaultDateTime);
    }
  }

  Widget _buildDateField(BuildContext context,
      {required String label,
      required BehaviorSubject<DateTime?> dateSubject}) {
    return InkWell(
      onTap: () => _selectDate(context, dateSubject),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withAlpha(25),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3))
            ]),
        child: Text(
          dateSubject.value != null
              ? "${dateSubject.value!.toLocal().toString().split(' ')[0]} ${dateSubject.value!.hour.toString().padLeft(2, '0')}:${dateSubject.value!.minute.toString().padLeft(2, '0')}"
              : "Select $label".tr(),
          style: AppTextStyles.bodyText.copyWith(
              color: dateSubject.value != null
                  ? Colors.grey.shade900
                  : Colors.grey.shade600),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(
          16, 8, 16, 8 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: GlobalConfig.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          "Add Transaction".tr(),
          style: AppTextStyles.cardTitle.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    managerService
        .addIncomeAndExpenses(
      typeId: _transactionType,
      description: managerService.descriptionCont.text,
      amount: double.tryParse(managerService.amountCont.text) ?? 0.0,
    )
        .then((response) {
      Navigator.pop(context);

      if (response!.result) {
        CustomAlertBanner(
          title: "Process Successful".tr(),
          message: "Transaction successfully added.".tr(),
          isSuccess: true,
          onConfirm: () {
            _clearForm();
          },
          confirmButtonText: "Add New".tr(),
          onClose: () {
            _clearForm();
            Navigator.pop(context);
            Navigator.pop(context);
          },
          closeButtonText: "Go Back".tr(),
        ).show(context);
      } else {
        showCustomBanner(
          context,
          title: "Process Failed".tr(),
          message: response.message ?? "Transaction cannot be added".tr(),
          isSuccess: false,
        );
      }
    }).catchError((error) {
      Navigator.pop(context);

      showCustomBanner(
        context,
        title: "Error".tr(),
        message: "An unexpected error occurred.".tr(),
        isSuccess: false,
      );
    });
  }

  void _clearForm() {
    managerService.descriptionCont.clear();
    managerService.amountCont.clear();
    setState(() {
      _transactionType = 1; // Reset to income
    });
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'Enter a valid positive amount';
    }
    return null;
  }
}
