import 'package:apartmantmanager/modules/manager-apartment/manager-model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../global/index.dart';

class ManagerService {
  BehaviorSubject<List<ApartmantManagerInfoModel>?> manager$ =
      BehaviorSubject.seeded(null);

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
  final TextEditingController descriptionCont = TextEditingController();
  final TextEditingController amountCont = TextEditingController();
  final TextEditingController typeIdCont = TextEditingController();
  final TextEditingController contentCont = TextEditingController();
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
            "Parameters": {
              "HOTELID": GlobalConfig.hotelId,
              "APTUID": apartmentUid
            }
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
              "STARTDATE": startDate?.toIso8601String(),
              "ENDDATE": endDate?.toIso8601String(),
              "PLATENO": plateNo,
              "OWNERNAME": ownerName,
              "OWNERPHONE": ownerPhone,
              "BALANCE": balance,
              "EMAIL": email
            }
          }));

      if (response.statusCode == 200) {
        try {
          var data = json.decode(utf8.decode(response.bodyBytes));

          if (data['status'] == 'success' || data['result'] == true) {
            return RequestResponse(
                message: "Apartment guest added/updated successfully.",
                result: true);
          } else {
            String errorMessage =
                data['message'] ?? "Apartment guest could not be added/updated";
            return RequestResponse(message: errorMessage, result: false);
          }
        } catch (decodeError) {
          return RequestResponse(
            message: "Response parsing failed: ${decodeError.toString()}",
            result: false,
          );
        }
      } else {
        return RequestResponse(
          message: "Server error: ${response.statusCode}",
          result: false,
        );
      }
    } catch (e) {
      return RequestResponse(
        message: "Network error: ${e.toString()}",
        result: false,
      );
    }
  }

  Future<RequestResponse?> addAnnouncement(
      {DateTime? startDate, DateTime? endDate, String? content}) async {
    try {
      var response = await http.post(
        Uri.parse(GlobalConfig.url),
        headers: {'User-Agent': 'apartmentApp_1.0.0'},
        body: json.encode({
          "Action": "Execute",
          "Object": "SP_MOBILE_APARTMENT_NEWS_INSERT",
          "Parameters": {
            "APARTMENTUID": apartmentUid,
            "STARTDATE": startDate?.toIso8601String() ??
                DateTime.now().toIso8601String(),
            "ENDDATE":
                endDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
            "CONTENT": content,
          }
        }),
      );

      if (response.statusCode == 200) {
        try {
          var responseBody = utf8.decode(response.bodyBytes);
          var data = json.decode(responseBody);
          var result = data[0][0]['SUCCESS'].toString();
          if (int.tryParse(result) == 1) {
            return RequestResponse(
                message: "Announcement added successfully", result: true);
          } else {
            return RequestResponse(
                message: "Unexpected response format: $responseBody",
                result: false);
          }
        } catch (decodeError) {
          return RequestResponse(
            message: "Response parsing failed: $decodeError",
            result: false,
          );
        }
      } else {
        return RequestResponse(
          message: "Server error: ${response.statusCode}",
          result: false,
        );
      }
    } catch (e) {
      return RequestResponse(
        message: "Network error: $e",
        result: false,
      );
    }
  }

  Future<RequestResponse?> addIncomeAndExpenses(
      {DateTime? date,
      int? typeId,
      String? description,
      double? amount}) async {
    try {
      var response = await http.post(
        Uri.parse(GlobalConfig.url),
        body: json.encode({
          "Action": "Execute",
          "Object": "SP_MOBILE_APARTMENT_MONTHLY_EXPENSE_INSERT",
          "Parameters": {
            "DATE": date?.toIso8601String(),
            "APARTMENTUID": apartmentUid,
            "TYPEID": typeId,
            "DESCRIPTION": description,
            "AMOUNT": amount
          }
        }),
      );

      if (response.statusCode == 200) {
        try {
          var responseBody = utf8.decode(response.bodyBytes);
          var data = json.decode(responseBody);
          var result = data[0][0]['SUCCESS'].toString();
          if (int.tryParse(result) == 1) {
            return RequestResponse(
                message: "Income/Expense added successfully", result: true);
          } else {
            return RequestResponse(
                message: "Unexpected response format: $responseBody",
                result: false);
          }
        } catch (decodeError) {
          return RequestResponse(
            message: "Response parsing failed: $decodeError",
            result: false,
          );
        }
      } else {
        return RequestResponse(
          message: "Server error: ${response.statusCode}",
          result: false,
        );
      }
    } catch (e) {
      return RequestResponse(
        message: "Network error: ${e.toString()}",
        result: false,
      );
    }
  }
}
