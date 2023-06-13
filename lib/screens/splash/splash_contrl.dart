import 'dart:async';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    goToHome();
    super.onInit();
  }

  void goToHome() {
    Timer(const Duration(milliseconds: 400), () {
      Get.offAllNamed(AppRoutes.login);
    });
  }
}
