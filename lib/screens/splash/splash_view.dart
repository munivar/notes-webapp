import 'package:dnotes/animations/fade_anim.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/screens/splash/splash_contrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: mainLayout(context),
      ),
    );
  }

  mainLayout(BuildContext context) {
    return Container(
      color: AppColor.lightBgClr,
      child: Center(
        child: Image.asset(
          AppImages.notesLogo,
          height: AppHelper.height(context, 6),
        ),
      ),
    );
  }
}
