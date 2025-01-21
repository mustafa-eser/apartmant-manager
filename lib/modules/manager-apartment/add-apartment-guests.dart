import 'dart:io';

import 'package:apartmantmanager/global/enums/banner-enums.dart';
import 'package:apartmantmanager/global/helpers/constants.dart';
import 'package:apartmantmanager/global/index.dart';
import 'package:apartmantmanager/modules/manager-apartment/manager-service.dart';
import 'package:apartmantmanager/widgets/CButton.dart';
import 'package:apartmantmanager/widgets/CTextFormField.dart';
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

  @override
  Widget build(BuildContext context) {
    double W = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Add Apartment Guest".tr())),
      body: StreamBuilder(
          stream: Rx.combineLatest2(managerService.startDate$, managerService.endDate$, (a, b) => null),
          builder: (context, snapshot) {
            return Column(children: [
              Expanded(
                  child: SingleChildScrollView(
                      child: Container(
                          padding: paddingAll5,
                          child: Column(
                            children: [
                              StreamBuilder(
                                  stream: selectedPhoto$.stream,
                                  builder: (context, snapshot) {
                                    return Container(
                                        decoration: BoxDecoration(color: Colors.white, borderRadius: borderRadius8, border: Border.all(color: Colors.black87)),
                                        child: selectedPhoto$.value != null
                                            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                SizedBox(
                                                    width: MediaQuery.of(context).size.width - 32,
                                                    height: (MediaQuery.of(context).size.width - 32) / 1.57,
                                                    child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: PhotoView(imageProvider: FileImage(File(selectedPhoto$.value!.path)), initialScale: 0.093))),
                                                Container(
                                                    width: W - 32,
                                                    padding: paddingAll10,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white60,
                                                        boxShadow: [
                                                          BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 5, offset: Offset(0, 3))
                                                        ],
                                                        borderRadius:
                                                            const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                                        border: const Border(
                                                            left: BorderSide(color: Colors.white),
                                                            right: BorderSide(color: Colors.white),
                                                            bottom: BorderSide(color: Colors.white))),
                                                    child: CButton(
                                                        title: "Delete Photo".tr(),
                                                        backgroundColor: Colors.white,
                                                        isBorder: true,
                                                        func: () {
                                                          selectedPhoto$.value = null;
                                                          selectedPhoto$.add(selectedPhoto$.value);
                                                        }))
                                              ])
                                            : Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      width: W - 32,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                                      ),
                                                      child: Padding(
                                                          padding: paddingAll15,
                                                          child: Column(children: [
                                                            Container(
                                                                padding: paddingAll15,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(color: Colors.white),
                                                                    borderRadius: BorderRadius.circular(12),
                                                                    color: Colors.white,
                                                                    boxShadow: const [
                                                                      BoxShadow(color: Color(0x0C101828), blurRadius: 2, offset: Offset(0, 1), spreadRadius: 0)
                                                                    ]),
                                                                child: const Icon(Icons.camera_alt_outlined)),
                                                            SizedBox(height: W / 40),
                                                            Text("Take a new photo or select one from your photos".tr(),
                                                                style: k25Gilroy(context), textAlign: TextAlign.center)
                                                          ]))),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                          border: Border(
                                                              left: BorderSide(color: Colors.white),
                                                              right: BorderSide(color: Colors.white),
                                                              bottom: BorderSide(color: Colors.white))),
                                                      child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                          child: Row(children: [
                                                            Expanded(
                                                              child: InkWell(
                                                                child: Container(
                                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                                    decoration: BoxDecoration(
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                              color: Color(0x0C101828), blurRadius: 2, offset: Offset(0, 1), spreadRadius: 0)
                                                                        ],
                                                                        color: Colors.black87,
                                                                        borderRadius: BorderRadius.circular(8),
                                                                        border: Border.all(color: Colors.white)),
                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                      const Icon(Icons.photo_camera, color: Colors.white),
                                                                      const SizedBox(width: 8),
                                                                      Text("Take a Photo".tr(),
                                                                          textAlign: TextAlign.center, style: k25Gilroy(context, color: Colors.white))
                                                                    ])),
                                                                onTap: () async {
                                                                  selectedPhoto$.value = await GlobalFunction().selectImageFromCamera();
                                                                  selectedPhoto$.add(selectedPhoto$.value);
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(width: W / 40),
                                                            Expanded(
                                                                child: InkWell(
                                                              child: Container(
                                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                                  decoration: BoxDecoration(
                                                                      boxShadow: const [
                                                                        BoxShadow(
                                                                            color: Color(0x0C101828), blurRadius: 2, offset: Offset(0, 1), spreadRadius: 0)
                                                                      ],
                                                                      color: GlobalConfig.primaryColor,
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      border: Border.all(
                                                                        color: GlobalConfig.primaryColor,
                                                                      )),
                                                                  child: Center(
                                                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                    const Icon(Icons.photo_library, color: Colors.white),
                                                                    const SizedBox(width: 8),
                                                                    Text("Select Photo".tr(), style: k25Gilroy(context, color: Colors.white))
                                                                  ]))),
                                                              onTap: () async {
                                                                selectedPhoto$.value = await GlobalFunction().selectImageFromGallery();
                                                                selectedPhoto$.add(selectedPhoto$.value);
                                                              },
                                                            ))
                                                          ])))
                                                ],
                                              ));
                                  }),
                              CTextFormField(labelText: "Apartment Name".tr(), controller: managerService.apartmentNameCont, context: context, maxLines: 1),
                              SizedBox(height: W / 40),
                              CTextFormField(labelText: "Name".tr(), controller: managerService.nameCont, context: context, maxLines: 1),
                              SizedBox(height: W / 40),
                              CTextFormField(labelText: "Last Name".tr(), controller: managerService.surnameCont, context: context, maxLines: 1),
                              SizedBox(height: W / 40),
                              CTextFormField(labelText: "Email".tr(), controller: managerService.emailCont, context: context, maxLines: 1),
                              SizedBox(height: W / 40),
                              CTextFormField(labelText: "Phone Number".tr(), controller: managerService.phoneCont, context: context, maxLines: 1),
                              SizedBox(height: W / 40),
                              CTextFormField(labelText: "Nationalty No".tr(), controller: managerService.nationaltyNoCont, context: context, maxLines: 1),
                              SizedBox(height: W / 40),
                              CTextFormField(labelText: "Block Name".tr(), controller: managerService.blockNameCont, context: context, maxLines: 1),
                              SizedBox(height: W / 40),
                              CTextFormField(labelText: "Plate No".tr(), controller: managerService.plateCont, context: context, maxLines: 1),
                              SizedBox(height: W / 40),
                              Row(children: [
                                Expanded(
                                    child: CTextFormField(
                                        labelText: "Flat Number".tr(), controller: managerService.flatNumberCont, context: context, maxLines: 1)),
                                SizedBox(width: W / 40),
                                Expanded(
                                    child: CTextFormField(
                                        labelText: "Number of People".tr(), controller: managerService.numberOfPeopleCont, context: context, maxLines: 1))
                              ]),
                              SizedBox(height: W / 40),
                              CTextFormField(labelText: "Contact Name".tr(), controller: managerService.blockNameCont, context: context, maxLines: 1),
                              SizedBox(height: W / 40),
                              CTextFormField(labelText: "Balance".tr(), controller: managerService.balanceCont, context: context, maxLines: 1),
                              SizedBox(height: W / 40),
                            ],
                          )))),
              Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, left: 10, right: 10),
                  child: CButton(
                      width: W,
                      title: "Add",
                      func: () {
                        if (managerService.nameCont.text.isEmpty) {
                          kShowDialogBanner(BannerType.ERROR, "Name cannot be empty. Please enter a valid name.", context);
                        } else if (managerService.surnameCont.text.isEmpty) {
                          kShowDialogBanner(BannerType.ERROR, "Last Name cannot be empty. Please enter a valid last name.", context);
                        } else if (managerService.phoneCont.text.isEmpty) {
                          kShowDialogBanner(BannerType.ERROR, "Phone Number cannot be empty. Please enter a valid phone number.", context);
                        } else {
                          managerService
                              .addAndUpdateApartmentGuest(
                                  guestId: null,
                                  email: managerService.emailCont.text,
                                  nationaltyNo: int.parse(managerService.nationaltyNoCont.text),
                                  numberOfPeople: int.parse(managerService.numberOfPeopleCont.text),
                                  flatNumber: managerService.flatNumberCont.text,
                                  apartmentName: managerService.apartmentNameCont.text,
                                  balance: double.parse(managerService.balanceCont.text),
                                  blockName: managerService.blockNameCont.text,
                                  endDate: managerService.endDate$.value,
                                  startDate: managerService.startDate$.value,
                                  contactName: managerService.contactNameCont.text)
                              .then((value) {
                            if (value?.result == true) {
                              kShowDialogBanner(BannerType.SUCCESS, "Success", context);
                            } else if (value?.result == false) {
                              kShowDialogBanner(BannerType.SUCCESS, "ERROr", context);
                            }
                          });
                        }
                      }))
            ]);
          }),
    );
  }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(title: Text('Apartment Guests'.tr())),
//     body: RefreshIndicator(
//       color: GlobalConfig.primaryColor,
//       onRefresh: () => globalService.fetchApartments(apartmentUid!),
//       child: StreamBuilder<List<Apartment>?>(
//         stream: globalService.apartments$.stream,
//         builder: (context, snapshot) {
//           if (isLoading$.value) {
//             return Center(child: CircularProgressIndicator(color: GlobalConfig.primaryColor));
//           }
//
//           final apartments = globalService.apartments$.value;
//           if (apartments == null || apartments.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.apartment,
//                     size: 64,
//                     color: Colors.grey.shade400,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No Apartments Found'.tr(),
//                     style: AppTextStyles.cardTitle.copyWith(
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return Column(
//             children: [
//               // _buildSearchBar(),
//               Expanded(
//                 child: ListView.builder(
//                   padding: const EdgeInsets.only(bottom: 16),
//                   itemCount: _filteredApartments.length,
//                   itemBuilder: (context, index) {
//                     var item = _filteredApartments[index];
//                     return Container(
//                       padding: paddingAll10,
//                       margin: marginAll5,
//                       decoration: BoxDecoration(
//
//                       ),
//                       child: Text(item.name ?? '', style: k25Trajan(context)),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     ),
//   );
// }
}
