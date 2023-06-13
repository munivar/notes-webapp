import 'dart:async';
import 'package:dnotes/helpers/app_fun.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController usernameContrl = TextEditingController();
  TextEditingController emailContrl = TextEditingController();
  TextEditingController passwordContrl = TextEditingController();
  RxBool isRegister = false.obs;
  RxBool isLoading = false.obs;

  void onSignInBtnTap(BuildContext context) {
    if (usernameContrl.text.isNotEmpty) {
      if (passwordContrl.text.isNotEmpty) {
        if (isRegister.isTrue) {
          if (emailContrl.text.isNotEmpty) {
            onBtnTapFunction();
          } else {
            AppToast.showToast(context, "Email ID field is Required");
            AppFun.closeKeyboard(context);
          }
        } else {
          onBtnTapFunction();
        }
      } else {
        AppToast.showToast(context, "Password field is Required");
        AppFun.closeKeyboard(context);
      }
    } else {
      AppToast.showToast(context, "Username field is Required");
      AppFun.closeKeyboard(context);
    }
  }

  void onBtnTapFunction() {
    isLoading(true);
    Timer(const Duration(milliseconds: 1500), () {
      isLoading(false);
      Get.offAllNamed(AppRoutes.home);
    });
  }
}
