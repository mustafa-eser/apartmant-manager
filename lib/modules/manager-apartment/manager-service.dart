import 'package:apartmantmanager/modules/manager-apartment/manager-model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../global/index.dart';

class ManagerService {
  BehaviorSubject<List<ApartmantManagerInfoModel>?> manager$ = BehaviorSubject.seeded(null);

  final TextEditingController nameCont = TextEditingController();
  final TextEditingController surnameCont = TextEditingController();
  final TextEditingController emailCont = TextEditingController();
  final TextEditingController apartmentNameCont = TextEditingController();

  final TextEditingController phoneCont = TextEditingController();
  final TextEditingController ownerNameCont = TextEditingController();
  final TextEditingController ownerPhoneCont = TextEditingController();
  final TextEditingController numberOfPeopleCont = TextEditingController();
  final TextEditingController flatNumberCont = TextEditingController();
  final TextEditingController nationaltyNoCont = TextEditingController();
  final TextEditingController blockNameCont = TextEditingController();
  final TextEditingController contactNameCont = TextEditingController();
  final TextEditingController plateCont = TextEditingController();
  final TextEditingController ownerCont = TextEditingController();
  final TextEditingController balanceCont = TextEditingController();
  BehaviorSubject<DateTime?> startDate$ = BehaviorSubject.seeded(null);
  BehaviorSubject<DateTime?> endDate$ = BehaviorSubject.seeded(null);

  Future<RequestResponse?> apartmentInfo() async {
    try {
      var response = await http.post(Uri.parse(GlobalConfig.url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            "Action": "Execute",
            "Object": "SP_APARTMENT_SITES",
            "Parameters": {"HOTELID": GlobalConfig.hotelId, "APTUID": apartmentUid}
          }));

      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        if (data.isNotEmpty) {
          List<ApartmantManagerInfoModel> managerList = [];
          data[0].forEach((item) {
            managerList.add(ApartmantManagerInfoModel.fromMap(item));
          });
          manager$.add(managerList);
        }
      }
    } catch (e, stackTrace) {
      print('$e\n$stackTrace');
    }

    return null;
  }

  Future<RequestResponse?> addAndUpdateApartmentGuest(
      {int? guestId,
      String? apartmentName,
      String? blockName,
      String? flatNumber,
      String? contactName,
      int? nationaltyNo,
      int? phone,
      int? numberOfPeople,
      DateTime? startDate,
      DateTime? endDate,
      String? ownerName,
      int? ownerPhone,
      String? plateNo,
      String? email,
      double? balance,
      String? photoUrl}) async {
    try {
      var response = await http.post(Uri.parse(GlobalConfig.url),
          body: json.encode({
            "Action": "Execute",
            "Object": "SP_APARTMENT_FLATS_INSERT_OR_UPDATE",
            "Parameters": {
              "HOTELID": GlobalConfig.hotelId,
              "APTUID": apartmentUid,
              "ID": guestId,
              "SITENAME": apartmentName,
              "BLOCKNAME": blockName,
              "FLATNUMBER": flatNumber,
              "PHOTOURL": photoUrl,
              "CONTACTNAME": contactName,
              "IDNO": nationaltyNo,
              "PHONE": phone,
              "NUMBEROFPEOPLE": numberOfPeople,
              "STARTDATE": startDate,
              "ENDDATE": endDate,
              "PLATENO": plateNo,
              "OWNERNAME": ownerName,
              "OWNERPHONE": ownerPhone,
              "BALANCE": balance,
              "EMAIL": email
            }
          }));

      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e, stackTrace) {}

    return null;
  }

  Future<RequestResponse?> addAnnouncement() async {
    try {
      var response = await http.post(
        Uri.parse(GlobalConfig.url),
        body: json.encode({
          "Action": "Execute",
          "Object": "SP_MOBILE_APARTMENT_NEWS_LIST",
          "Parameters": {"APARTMENTUID": apartmentUid}
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e, stackTrace) {}

    return null;
  }

  Future<RequestResponse?> addIncomeAndExpenses() async {
    try {
      var response = await http.post(
        Uri.parse(GlobalConfig.url),
        body: json.encode({
          "Action": "Execute",
          "Object": "SP_MOBILE_APARTMENT_NEWS_LIST",
          "Parameters": {
            "APARTMENTUID": apartmentUid,
          }
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e, stackTrace) {}

    return null;
  }
}
