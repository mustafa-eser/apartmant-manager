import 'dart:io';

import 'package:apartmantmanager/global/index.dart';
import 'package:apartmantmanager/modules/manager-apartment/manager-service.dart';
import 'package:apartmantmanager/widgets/custom_alert.dart';
import 'package:apartmantmanager/widgets/form_field.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class AddApartmentGuests extends StatefulWidget {
  const AddApartmentGuests({super.key});

  @override
  State<AddApartmentGuests> createState() => _AddApartmentGuestsState();
}

class _AddApartmentGuestsState extends State<AddApartmentGuests> {
  final globalService = GetIt.I<GlobalService>();
  final managerService = GetIt.I<ManagerService>();
  BehaviorSubject<File?> selectedPhoto$ = BehaviorSubject.seeded(null);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Apartment Guest".tr(),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPhotoSection(w, theme),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormWidgets.buildSectionHeader(
                                  "Personal Information", Icons.person_outline),
                              // _buildFormField(
                              //   "Apartment Name",
                              //   managerService.apartmentNameCont,
                              //   required: true,
                              // ),
                              // _buildFormField(
                              //   "Name",
                              //   managerService.nameCont,
                              //   required: true,
                              // ),
                              // _buildFormField(
                              //   "Last Name",
                              //   managerService.surnameCont,
                              //   required: true,
                              // ),
                              FormWidgets.buildFormField(
                                "Contact Name",
                                managerService.contactNameCont,
                                required: true,
                              ),
                              FormWidgets.buildFormField(
                                "Email",
                                managerService.emailCont,
                                keyboardType: TextInputType.emailAddress,
                                required: false,
                                customValidator: _validateEmail,
                              ),
                              FormWidgets.buildFormField(
                                "Phone Number",
                                managerService.phoneCont,
                                keyboardType: TextInputType.phone,
                                required: false,
                                customValidator: _validatePhoneNumber,
                              ),

                              FormWidgets.buildFormField(
                                "Nationality No",
                                managerService.nationaltyNoCont,
                                keyboardType: TextInputType.number,
                                required: false,
                                customValidator: _validateNationalityNumber,
                              ),
                              const SizedBox(height: 18),
                              FormWidgets.buildSectionHeader(
                                  "Apartment Details", Icons.apartment),
                              FormWidgets.buildFormField(
                                "Block Name",
                                managerService.blockNameCont,
                                required: true,
                              ),
                              FormWidgets.buildFormField(
                                "Plate No",
                                managerService.plateCont,
                                required: false,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: FormWidgets.buildFormField(
                                      "Flat Number",
                                      managerService.flatNumberCont,
                                      keyboardType: TextInputType.number,
                                      required: true,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: FormWidgets.buildFormField(
                                      "Number of People",
                                      managerService.numberOfPeopleCont,
                                      keyboardType: TextInputType.number,
                                      required: false,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              FormWidgets.buildSectionHeader(
                                  "Balance Information",
                                  Icons.account_balance_wallet_outlined),

                              FormWidgets.buildFormField(
                                "Balance",
                                managerService.balanceCont,
                                keyboardType: TextInputType.number,
                                prefix: Text('₺ ',
                                    style: AppTextStyles.cardTitle.copyWith(
                                      color: GlobalConfig.primaryColor,
                                      fontSize: 15,
                                    )),
                                required: false,
                              ),
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
          );
        },
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_add_alt_1_outlined),
            const SizedBox(width: 10),
            Text(
              "Add Resident".tr(),
              style: AppTextStyles.cardTitle.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
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
        return Center(
          child: CircularProgressIndicator(
            color: GlobalConfig.primaryColor,
          ),
        );
      },
    );

    managerService
        .addAndUpdateApartmentGuest(
      guestId: null,
      contactName: managerService.contactNameCont.text,
      email: managerService.emailCont.text,
      phone: int.tryParse(managerService.phoneCont.text) ?? 0,
      nationaltyNo: int.tryParse(managerService.nationaltyNoCont.text) ?? 0,
      blockName: managerService.blockNameCont.text,
      plateNo: managerService.plateCont.text,
      flatNumber: managerService.flatNumberCont.text,
      numberOfPeople: int.tryParse(managerService.numberOfPeopleCont.text) ?? 1,
      balance: double.tryParse(managerService.balanceCont.text) ?? 0.0,
      apartmentName: managerService.apartmentNameCont.text,
      endDate: managerService.endDate$.value,
      startDate: managerService.startDate$.value,
    )
        .then((response) {
      Navigator.pop(context);

      if (response!.result) {
        CustomAlertBanner(
          title: "Process Successful".tr(),
          message: "New apartment resident successfully added.".tr(),
          isSuccess: true,
          onConfirm: () {
            _clearForm();
          },
          confirmButtonText: "Add New Guest".tr(),
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
          message: response.message,
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
    managerService.emailCont.clear();
    managerService.nationaltyNoCont.clear();
    managerService.numberOfPeopleCont.clear();
    managerService.flatNumberCont.clear();
    managerService.apartmentNameCont.clear();
    managerService.balanceCont.clear();
    managerService.blockNameCont.clear();
    managerService.contactNameCont.clear();
    managerService.nameCont.clear();
    managerService.surnameCont.clear();
    managerService.phoneCont.clear();
    managerService.plateCont.clear();
    selectedPhoto$.value = null;
    selectedPhoto$.add(null);
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return null;

    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return null;

    // Adjust this regex based on your specific phone number format requirements
    final phoneRegExp =
        RegExp(r'^[+]?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validateNationalityNumber(String? value) {
    if (value == null || value.isEmpty) return null;

    // Assuming nationality number is a numeric value with a specific length
    if (value.length < 10 ||
        value.length > 11 ||
        !RegExp(r'^\d+$').hasMatch(value)) {
      return 'Enter a valid nationality number (10-11 digits)';
    }
    return null;
  }

  Widget _buildPhotoSection(double width, ThemeData theme) {
    return StreamBuilder(
      stream: selectedPhoto$.stream,
      builder: (context, snapshot) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: selectedPhoto$.value != null
              ? _buildSelectedPhoto(width)
              : _buildPhotoSelector(width),
        );
      },
    );
  }

  Widget _buildSelectedPhoto(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: SizedBox(
            width: width - 32,
            height: (width - 32) / 1.57,
            child: PhotoView(
              imageProvider: FileImage(File(selectedPhoto$.value!.path)),
              initialScale: PhotoViewComputedScale.covered,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              backgroundDecoration: BoxDecoration(color: Colors.grey.shade300),
              basePosition: Alignment.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: ElevatedButton.icon(
            onPressed: () {
              selectedPhoto$.value = null;
              selectedPhoto$.add(selectedPhoto$.value);
            },
            icon: const Icon(Icons.delete_outline),
            label: Text(
              "Remove Photo".tr(),
              style: AppTextStyles.bodyText
                  .copyWith(color: GlobalConfig.primaryColor),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: GlobalConfig.primaryColor.withAlpha(20),
              foregroundColor: GlobalConfig.primaryColor,
              elevation: 0,
              side: BorderSide(color: GlobalConfig.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSelector(double width) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            "Add Guest Photo".tr(),
            style: AppTextStyles.cardTitle.copyWith(
              color: GlobalConfig.primaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text("Take a new photo or select one from your gallery".tr(),
              textAlign: TextAlign.center, style: AppTextStyles.bodyText),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildPhotoButton(
                  icon: Icons.camera_alt_outlined,
                  label: "Camera".tr(),
                  onTap: () async {
                    selectedPhoto$.value =
                        await GlobalFunction().selectImageFromCamera();
                    selectedPhoto$.add(selectedPhoto$.value);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPhotoButton(
                  icon: Icons.photo_library_outlined,
                  label: "Gallery".tr(),
                  primary: true,
                  onTap: () async {
                    selectedPhoto$.value =
                        await GlobalFunction().selectImageFromGallery();
                    selectedPhoto$.add(selectedPhoto$.value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool primary = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(
        label,
        style: AppTextStyles.bodyText.copyWith(
          color: primary ? Colors.white : Colors.grey.shade800,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: primary ? GlobalConfig.primaryColor : Colors.white,
        foregroundColor: primary ? Colors.white : GlobalConfig.primaryColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            width: 1.5,
            color: primary ? Colors.transparent : GlobalConfig.primaryColor,
          ),
        ),
      ),
    );
  }
}
