import 'dart:ui';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/screens/login/login_contrl.dart';
import 'package:dnotes/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: mainLayout(context),
          ),
        ),
      ),
    );
  }

  mainLayout(BuildContext context) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Center(
        child: Container(
          height: 70.h,
          width: AppHelper.isWeb == true ? 500 : 100.w,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withOpacity(0.4),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: containerLayout(context),
        ),
      ),
    );
  }

  containerLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppHelper.sizedBox(1, null),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                AppImages.notesLogo,
                height: 7.h,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: AppText(
                "To-Do List",
                fontSize: 32.sp,
                fontColor: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        AppHelper.sizedBox(AppHelper.isWeb == true ? 5 : 10, null),
        Obx(() {
          return AppText(
            controller.isRegister.isTrue
                ? "Looks like you're new here!"
                : "Login to your Account",
            fontSize: 24.sp,
            fontColor: Colors.white,
            fontWeight: FontWeight.bold,
          );
        }),
        AppHelper.sizedBox(1, null),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.4.w),
          child: TextFormField(
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            maxLines: 1,
            autofocus: true,
            onChanged: (value) {},
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColor.whiteColor.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            cursorColor: AppColor.primaryClr,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Username',
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: AppColor.whiteColor.withOpacity(0.6),
                fontWeight: FontWeight.normal,
              ),
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 14.0, top: 14.0),
            ),
            controller: controller.usernameContrl,
          ),
        ),
        Container(
          height: 2,
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
              color: AppColor.whiteColor.withOpacity(0.20),
              borderRadius: BorderRadius.circular(50)),
          width: 100.w,
        ),
        AppHelper.sizedBox(1, null),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.4.w),
          child: TextFormField(
              scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              maxLines: 1,
              onChanged: (value) {},
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColor.whiteColor.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
              cursorColor: AppColor.primaryClr,
              obscureText: true,
              onFieldSubmitted: (value) {
                controller.onSignInBtnTap(context);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Password',
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  color: AppColor.whiteColor.withOpacity(0.6),
                  fontWeight: FontWeight.normal,
                ),
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 14.0, top: 14.0),
              ),
              controller: controller.passwordContrl),
        ),
        Container(
          height: 2,
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
              color: AppColor.whiteColor.withOpacity(0.20),
              borderRadius: BorderRadius.circular(50)),
          width: 100.w,
        ),
        AppHelper.sizedBox(3, null),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.8.w),
          child: Material(
            color: AppColor.primaryClr,
            borderRadius: BorderRadius.circular(50),
            child: InkWell(
              onTap: () {
                controller.onSignInBtnTap(context);
              },
              borderRadius: BorderRadius.circular(50),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Obx(
                    () {
                      return controller.isLoading.isTrue
                          ? SizedBox(
                              height: 28,
                              child: AppHelper.appLoader(Colors.white),
                            )
                          : AppText(
                              controller.isRegister.isTrue
                                  ? "Register"
                                  : "Login",
                              fontColor: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        AppHelper.sizedBox(2, null),
        AppText(
          "or",
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          fontColor: AppColor.whiteColor.withOpacity(0.4),
        ),
        AppHelper.sizedBox(1, null),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (controller.isRegister.isTrue) {
                controller.isRegister(false);
              } else {
                controller.isRegister(true);
              }
            },
            borderRadius: BorderRadius.circular(50),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Obx(() {
                  return AppText(
                    controller.isRegister.isTrue
                        ? "Login to your Account"
                        : "Register in To-Do Account",
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    fontColor: Colors.white.withOpacity(0.6),
                    decoration: TextDecoration.underline,
                  );
                })),
          ),
        ),
      ],
    );
  }
}
