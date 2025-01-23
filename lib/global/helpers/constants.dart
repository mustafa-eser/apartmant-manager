import 'package:another_flushbar/flushbar.dart';
import 'package:apartmantmanager/widgets/Default-notification-banner.dart';
import 'package:flutter/material.dart';

import '../../widgets/CButton.dart';
import '../../widgets/widgets.dart';
import '../enums/index.dart';
import '../index.dart';

Flushbar? _currentFlushbar;

Flushbar kShowBanner(BannerType bannerType, String text, BuildContext context,
    {int? durationSeconds, Function()? onDismissed, Color? color}) {
  if (_currentFlushbar != null) {
    _currentFlushbar!.dismiss();
  }

  DefaultNotificationBanner notificationBanner;

  switch (bannerType) {
    case BannerType.ERROR:
      notificationBanner = DefaultNotificationBanner(
          iconPath: 'assets/image/wrong.png',
          text: tr(text),
          color: color ?? Colors.red,
          context: context,
          durationSeconds: durationSeconds ?? 7);
      break;

    case BannerType.SUCCESS:
      notificationBanner = DefaultNotificationBanner(
          iconPath: 'assets/image/success.png',
          text: tr(text),
          color: Color.fromARGB(255, 9, 184, 14),
          context: context,
          durationSeconds: durationSeconds ?? 7);
      break;

    default:
      throw ArgumentError('Invalid BannerType: $bannerType');
  }

  _currentFlushbar = notificationBanner.show();

  return _currentFlushbar!;
}

Future<void> kShowDialogBanner(
    BannerType bannerType, String text, BuildContext context,
    {int? durationSeconds, Function()? onDismissed, Color? color}) async {
  switch (bannerType) {
    case BannerType.ERROR:
      await _showDialog(context, 'Error', text, 'assets/animation/alert.json',
          color ?? Colors.red);
      break;

    case BannerType.SUCCESS:
      await _showDialog(
          context,
          'Success',
          text,
          'assets/animation/success-dialog.json',
          const Color.fromARGB(255, 9, 184, 14));
      break;

    default:
      throw ArgumentError('Invalid BannerType: $bannerType');
  }
}

Future<void> kShowNavigatorDialogBanner(BannerType bannerType, String text,
    String navigatorTitle, BuildContext context,
    {int? durationSeconds,
    Function()? onDismissed,
    Color? color,
    required Widget navigator}) async {
  {
    switch (bannerType) {
      case BannerType.ERROR:
        showNavigatorDialog(context, 'Error', text, navigatorTitle,
            'assets/animation/alert.json', color ?? Colors.red, navigator);
        break;

      case BannerType.SUCCESS:
        showNavigatorDialog(
            context,
            'Success',
            text,
            navigatorTitle,
            'assets/animation/success-dialog.json',
            const Color.fromARGB(255, 9, 184, 14),
            navigator);
        break;

      default:
        throw ArgumentError('Invalid BannerType: $bannerType');
    }
  }
}

Future<void> _showDialog(
  BuildContext context,
  String title,
  String message,
  String iconPath,
  Color color,
) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        double W = MediaQuery.of(context).size.width;
        return AlertDialog(
          title: Container(
              alignment: Alignment.center,
              child: Lottie.asset(iconPath,
                  width: W / 5, height: W / 5, fit: BoxFit.cover)),
          content: Text(message,
              textAlign: TextAlign.center,
              style: k25Gilroy(context, color: Colors.black)),
          actions: [
            CButton(
                title: "Okay".tr(),
                func: () => Navigator.of(context).pop(),
                width: W,
                isLoadingActive: true,
                height: W / 10,
                isBorder: true)
          ],
        );
      });
}

Future<void> showNavigatorDialog(
    BuildContext context,
    String title,
    String navigatorTitle,
    String message,
    String iconPath,
    Color color,
    Widget navigator) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      double W = MediaQuery.of(context).size.width;
      return AlertDialog(
        title: Container(
            alignment: Alignment.center,
            child: Lottie.asset(iconPath,
                width: W / 5, height: W / 5, fit: BoxFit.cover)),
        content: Text(message,
            textAlign: TextAlign.center,
            style: k25Gilroy(context, color: Colors.black)),
        actions: [
          CButton(
              title: navigatorTitle,
              func: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context, RouteAnimation.createRoute(navigator, 1, 0));
              },
              width: W,
              isLoadingActive: true,
              height: W / 10),
          SizedBox(height: W / 40),
          CButton(
              title: "Okay".tr(),
              func: () => Navigator.of(context).pop(),
              width: W,
              isLoadingActive: true,
              height: W / 10,
              isBorder: true),
        ],
      );
    },
  );
}
