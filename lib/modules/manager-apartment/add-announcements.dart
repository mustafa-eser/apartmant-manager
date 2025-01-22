import 'package:apartmantmanager/global/enums/banner-enums.dart';
import 'package:apartmantmanager/global/helpers/constants.dart';
import 'package:apartmantmanager/global/index.dart';
import 'package:apartmantmanager/index.dart';
import 'package:apartmantmanager/widgets/CButton.dart';
import 'package:apartmantmanager/widgets/CTextFormField.dart';
import 'package:flutter/material.dart';

class AddAnnounements extends StatefulWidget {
  const AddAnnounements({super.key});

  @override
  State<AddAnnounements> createState() => _AddAnnounementsState();
}

class _AddAnnounementsState extends State<AddAnnounements> {
  final TextEditingController announcementCont = TextEditingController();
  final BehaviorSubject<DateTime?> startDate$ = BehaviorSubject.seeded(null);
  final BehaviorSubject<DateTime?> endDate$ = BehaviorSubject.seeded(null);

  Future<void> selectDate(BuildContext context, BehaviorSubject<DateTime?> dateSubject) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      dateSubject.add(pickedDate);
    }
  }

  @override
  void dispose() {
    startDate$.close();
    endDate$.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double W = MediaQuery.of(context).size.width;
    double H = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text("Add Announcement".tr())),
      body: StreamBuilder(
          stream: Rx.combineLatest3(startDate$, endDate$, isLoading$, (a, b, c) => null),
          builder: (context, snapshot) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Container(
                  height: H * 0.8,
                  padding: paddingAll10,
                  child: Column(
                    children: [
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        InkWell(
                            onTap: () => selectDate(context, startDate$),
                            child: Container(
                                width: W,
                                padding: paddingAll10,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: borderRadius10,
                                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 5, offset: Offset(0, 3))]),
                                child: Text(startDate$.value != null ? "Selected Date: ${startDate$.value!.toLocal()}".split(' ')[0] : "Select Start Date".tr(),
                                    style: k28Gilroy(context)))),
                        SizedBox(height: W / 40),
                        InkWell(
                            onTap: () => selectDate(context, startDate$),
                            child: Container(
                                width: W,
                                padding: paddingAll10,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: borderRadius10,
                                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 5, offset: Offset(0, 3))]),
                                child: Text(startDate$.value != null ? "End Date: ${startDate$.value!.toLocal()}".split(' ')[0] : "Select End Date".tr(),
                                    style: k28Gilroy(context)))),
                        SizedBox(height: W / 40),
                        CTextFormField(labelText: "Announcement Note Added".tr(), controller: announcementCont, context: context, maxLines: 5),
                      ])),
                      Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                        child: CButton(
                          width: W,
                          title: "Add Announcement".tr(),
                          func: () {
                            isLoading$.add(true);
                            GetIt.I<ManagerService>().addAnnouncement().then((value) {
                              isLoading$.add(false);
                              if (value?.result == true) {
                                kShowDialogBanner(BannerType.SUCCESS, "Succesfull", context);
                              } else if (value?.result == false) {
                                kShowDialogBanner(BannerType.ERROR, "Error", context);
                              }
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
