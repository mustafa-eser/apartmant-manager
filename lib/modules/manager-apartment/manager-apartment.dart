import 'package:apartmantmanager/global/index.dart';
import 'package:apartmantmanager/index.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class ManagerApartmentInfo extends StatefulWidget {
  const ManagerApartmentInfo({super.key});

  @override
  State<ManagerApartmentInfo> createState() => _ManagerApartmentInfoState();
}

class _ManagerApartmentInfoState extends State<ManagerApartmentInfo> {
  final manager = GetIt.I<ManagerService>();

  @override
  void initState() {
    GetIt.I<ManagerService>().apartmentInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double W = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text("Apartment Manager".tr())),
      body: StreamBuilder(
          stream: GetIt.I<ManagerService>().manager$,
          builder: (context, snapshot) {
            return SingleChildScrollView(
                child: Column(children: [
              Column(children: <Widget>[
                Container(
                    width: W,
                    padding: paddingAll10,
                    margin: marginAll10,
                    decoration: BoxDecoration(
                        borderRadius: borderRadius10,
                        gradient: LinearGradient(
                            colors: [const Color.fromARGB(255, 177, 11, 11).withAlpha(150), Color.fromARGB(255, 0, 88, 189)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      if (manager.manager$.value?.first.name != null)
                        Text("${manager.manager$.value?.first.name}", style: k25Trajan(context, color: Colors.white)),
                      if (manager.manager$.value?.first.manager != null)
                        Row(children: [
                          Text("Manager : ".tr(), style: k25Trajan(context, color: Colors.white)),
                          Text("${manager.manager$.value?.first.manager}", style: k25Trajan(context, color: Colors.white))
                        ]),
                      if (manager.manager$.value?.first.address != null)
                        Text("${manager.manager$.value?.first.address}", style: k25Gilroy(context, color: Colors.white)),
                      if (manager.manager$.value?.first.address != null) SizedBox(height: W / 90),
                      if (manager.manager$.value?.first.managerphone != null)
                        InkWell(
                            onTap: () => launchUrl(Uri.parse('tel:${manager.manager$.value?.first.managerphone}')),
                            child: Container(
                              padding: paddingAll5,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: borderRadius10),
                              child: Row(children: [
                                const Icon(Icons.call, color: Colors.green),
                                SizedBox(width: W / 50),
                                Text("${manager.manager$.value?.first.managerassistantphone}", style: k25Trajan(context, color: Colors.black87))
                              ]),
                            ))
                    ])),
                _buildManager(
                  context: context,
                  title: "Add Apartment Guests".tr(),
                  imageAsset: "assets/icons/apartments.png",
                  firstColor: const Color(0xFF9628FA),
                  secondColor: const Color(0xFF5F0FF8),
                  width: W,
                  onTap: () {
                    Navigator.push(context, RouteAnimation.createRoute(const AddApartmentGuests(), 1, 0));
                  },
                ),
                _buildManager(
                  context: context,
                  title: "Add Income & Expenses".tr(),
                  imageAsset: "assets/icons/income.png",
                  firstColor: const Color.fromARGB(255, 125, 206, 19),
                  secondColor: const Color.fromARGB(255, 107, 189, 0),
                  width: W,
                  onTap: () {
                    Navigator.push(context, RouteAnimation.createRoute(const AddIncomeExpenses(), 1, 0));
                  },
                ),
                _buildManager(
                    context: context,
                    title: "Add Announcement".tr(),
                    imageAsset: "assets/icons/notifications.png",
                    firstColor: const Color(0xFF17B3FE),
                    secondColor: const Color(0xFF0587FF),
                    width: W,
                    onTap: () {
                      Navigator.push(context, RouteAnimation.createRoute(const AddAnnounements(), 1, 0));
                    })
              ])
            ]));
          }),
    );
  }
}

Widget _buildManager(
    {required String title,
    required String imageAsset,
    required Color firstColor,
    required Color secondColor,
    required double width,
    required VoidCallback onTap,
    required BuildContext context}) {
  return InkWell(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          width: width / 2.28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [firstColor.withAlpha(150), secondColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: borderRadius10,
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 30, spreadRadius: 0, offset: const Offset(5, 10))]),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
                width: width / 20, height: width / 20, child: Image.asset(imageAsset, fit: BoxFit.contain, alignment: Alignment.center, color: Colors.white)),
            SizedBox(width: width / 35),
            Text(title, style: k25Trajan(context).copyWith(color: Colors.white), textAlign: TextAlign.center)
          ])));
}
