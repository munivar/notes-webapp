import 'package:dnotes/animations/fade_anim.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/screens/login/login_contrl.dart';
import 'package:dnotes/widgets/app_text.dart';
import 'package:dnotes/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.lightBgClr,
        body: mainLayout(context),
      ),
    );
  }

  mainLayout(BuildContext context) {
    return Container(
        color: AppHelper.isWeb == false ? Colors.white : Colors.transparent,
        height: AppHelper.height(context, 100),
        margin: AppHelper.isWeb == false
            ? const EdgeInsets.all(0)
            : EdgeInsets.only(
                left: AppHelper.width(context, 3),
                bottom: 10,
                right: AppHelper.width(context, 3)),
        padding: EdgeInsets.symmetric(horizontal: AppHelper.width(context, 5)),
        child: FadeAppAnimation(
          child: Center(
            child: AppHelper.isWeb == false
                ? containerLayout(context)
                : Container(
                    height: AppHelper.height(context, 70),
                    width: AppHelper.isMobile != true
                        ? 500
                        : AppHelper.width(context, 100),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: containerLayout(context),
                  ),
          ),
        ));
  }

  containerLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppHelper.sizedBox(context, 1, null),
          Obx(() {
            return AppText(
              controller.isRegister.isTrue
                  ? "Register to your"
                  : "Login to your",
              fontSize: AppHelper.font(context, 24),
              fontWeight: FontWeight.w900,
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.notesLogo,
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: AppText(
                  "DNotes Account",
                  fontSize: AppHelper.font(context, 14),
                  fontWeight: FontWeight.w900,
                ),
              )
            ],
          ),
          AppHelper.sizedBox(context, 4, null),
          Padding(
            padding: AppHelper.isMobile != true
                ? EdgeInsets.symmetric(
                    horizontal: AppHelper.width(context, 1.4))
                : const EdgeInsets.all(0),
            child: TextFormField(
              scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              maxLines: 1,
              onChanged: (value) {},
              style: TextStyle(
                fontSize: AppHelper.font(context, 12),
                color: AppColor.fontClr,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: AppColor.primaryClr,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Username',
                hintStyle: TextStyle(
                  fontSize: AppHelper.font(context, 12),
                  color: AppColor.fontHintClr,
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
            margin:
                EdgeInsets.symmetric(horizontal: AppHelper.width(context, 2)),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(50)),
            width: AppHelper.width(context, 100),
          ),
          AppHelper.sizedBox(context, 1, null),
          Obx(() {
            return controller.isRegister.isFalse
                ? Container()
                : Column(
                    children: [
                      Padding(
                        padding: AppHelper.isMobile != true
                            ? EdgeInsets.symmetric(
                                horizontal: AppHelper.width(context, 1.4))
                            : const EdgeInsets.all(0),
                        child: TextFormField(
                          scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          onChanged: (value) {},
                          style: TextStyle(
                            fontSize: AppHelper.font(context, 12),
                            color: AppColor.fontClr,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: AppColor.primaryClr,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email ID',
                            hintStyle: TextStyle(
                              fontSize: AppHelper.font(context, 12),
                              color: AppColor.fontHintClr,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 14.0, top: 14.0),
                          ),
                          controller: controller.emailContrl,
                        ),
                      ),
                      Container(
                        height: 2,
                        margin: EdgeInsets.symmetric(
                            horizontal: AppHelper.width(context, 2)),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(50)),
                        width: AppHelper.width(context, 100),
                      ),
                      AppHelper.sizedBox(context, 1, null),
                    ],
                  );
          }),
          Padding(
            padding: AppHelper.isMobile != true
                ? EdgeInsets.symmetric(
                    horizontal: AppHelper.width(context, 1.4))
                : const EdgeInsets.all(0),
            child: TextFormField(
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: (value) {},
                style: TextStyle(
                  fontSize: AppHelper.font(context, 12),
                  color: AppColor.fontClr,
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
                    fontSize: AppHelper.font(context, 12),
                    color: AppColor.fontHintClr,
                    fontWeight: FontWeight.normal,
                  ),
                  contentPadding: const EdgeInsets.only(
                      left: 14.0, bottom: 14.0, top: 14.0),
                ),
                controller: controller.passwordContrl),
          ),
          Container(
            height: 2,
            margin:
                EdgeInsets.symmetric(horizontal: AppHelper.width(context, 2)),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(50)),
            width: AppHelper.width(context, 100),
          ),
          AppHelper.sizedBox(context, 3, null),
          Padding(
            padding: AppHelper.isMobile != true
                ? EdgeInsets.symmetric(
                    horizontal: AppHelper.width(context, 1.8))
                : const EdgeInsets.symmetric(horizontal: 10),
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
                            ? const SizedBox(
                                height: 29,
                                child: AppLoaderWidget(color: Colors.white))
                            : AppText(
                                controller.isRegister.isTrue
                                    ? "Register"
                                    : "Login",
                                fontColor: Colors.white,
                                fontWeight: FontWeight.w500,
                              );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          AppHelper.sizedBox(context, 1, null),
          const AppText(
            "or",
            fontWeight: FontWeight.w500,
            fontColor: AppColor.fontHintClr,
          ),
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
                          : "Register to your Account",
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    );
                  })),
            ),
          ),
        ],
      ),
    );
  }
}
