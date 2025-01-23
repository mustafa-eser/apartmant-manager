import 'package:apartmantmanager/global/index.dart';
import 'package:apartmantmanager/index.dart';
import 'package:apartmantmanager/widgets/custom_alert.dart';
import 'package:apartmantmanager/widgets/form_field.dart';
import 'package:flutter/material.dart';

class AddAnnouncements extends StatefulWidget {
  const AddAnnouncements({super.key});

  @override
  State<AddAnnouncements> createState() => _AddAnnouncementsState();
}

class _AddAnnouncementsState extends State<AddAnnouncements> {
  final globalService = GetIt.I<GlobalService>();
  final managerService = GetIt.I<ManagerService>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Announcement".tr(),
        ),
        elevation: 0,
        backgroundColor: GlobalConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: Rx.combineLatest2(
            managerService.startDate$, managerService.endDate$, (a, b) => null),
        builder: (context, snapshot) {
          return Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormWidgets.buildSectionHeader(
                              "Announcement Details".tr(),
                              Icons.notification_add_outlined),

                          // Start Date
                          _buildDateField(context,
                              label: "Start Date",
                              dateSubject: managerService.startDate$),

                          const SizedBox(height: 16),

                          // End Date
                          _buildDateField(context,
                              label: "End Date",
                              dateSubject: managerService.endDate$),

                          const SizedBox(height: 16),

                          // Announcement Content
                          FormWidgets.buildFormField(
                            "Announcement Content",
                            managerService.contentCont,
                            required: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _buildSubmitButton(),
            ],
          );
        },
      ),
    );
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
          "Add Announcement".tr(),
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

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Call add announcement method
    managerService
        .addAnnouncement(
      startDate: managerService.startDate$.value,
      endDate: managerService.endDate$.value,
      content: managerService.contentCont.text,
    )
        .then((response) {
      // Close loading dialog
      Navigator.pop(context);

      if (response?.result == true) {
        CustomAlertBanner(
          title: "Process Successful".tr(),
          message: "Announcement added successfully.".tr(),
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
          message: response?.message ?? "Announcement could not be added".tr(),
          isSuccess: false,
        );
      }
    }).catchError((error) {
      // Close loading dialog
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
    managerService.startDate$.add(null);
    managerService.endDate$.add(null);
    managerService.contentCont.clear();
  }

  @override
  void dispose() {
    // Clear form controllers if needed
    super.dispose();
  }
}
