import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../main.dart';

class AppToast {
  static void showToast(BuildContext context, String message) {
    FToast appToast = FToast();
    appToast.init(toastNavigatorKey.currentContext!);
    appToast.removeCustomToast();
    appToast.showToast(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: AppHelper.isMobile
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  AppImages.notesLogo,
                  height: AppHelper.height(context, 4),
                ),
              ),
              const SizedBox(width: 10),
              AppText(
                message,
                maxLines: 2,
                fontWeight: FontWeight.w600,
                fontSize: AppHelper.font(context, 13),
              ),
            ],
          )),
      gravity: ToastGravity.BOTTOM,
      positionedToastBuilder: (context, child) {
        return AppHelper.isMobile && AppHelper.isWeb != true
            ? Positioned(
                bottom: AppHelper.isIOS ? 50 : 20,
                right: 20,
                left: 20,
                child: child,
              )
            : Positioned(
                bottom: 20,
                right: 20,
                child: child,
              );
      },
      toastDuration: const Duration(milliseconds: 2000),
    );
  }
}
