import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/helpers/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:highlight/languages/dart.dart';

class HomeController extends GetxController {
  final GlobalKey homePopupKey = GlobalKey();
  List<String> popupMenuList = ["ListView", "GridView", "LogOut"];
  CodeController codeController = CodeController();
  TextEditingController titleContrl = TextEditingController();
  RxBool isMobileListView = true.obs;
  RxBool isDesktopListView = false.obs;
  RxBool isOptionShowing = false.obs;
  RxBool isFromEdit = false.obs;
  late FirebaseFirestore collectionRef;

  @override
  void onInit() {
    // initializing firebase firestore
    collectionRef = FirebaseFirestore.instance;
    // initializing code controller
    codeController = CodeController(
      text: Const.codeSnippet["dart"],
      language: dart,
      // patternMap: {
      //   r"\B#[a-zA-Z0-9]+\b": const TextStyle(color: Color(0xff4FC1E9)),
      //   r"\B@[a-zA-Z0-9]+\b": const TextStyle(
      //     fontWeight: FontWeight.w800,
      //     color: Color(0xff4FC1E9),
      //   ),
      //   r"\B![a-zA-Z0-9]+\b":
      //       const TextStyle(color: Colors.yellow, fontStyle: FontStyle.italic),
      // },
      // stringMap: {"bev": const TextStyle(color: Colors.indigo)},
    );
    super.onInit();
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  void onMenuTap(int index) {
    Get.back();
    if (popupMenuList[index] == "ListView") {
      if (AppHelper.isMobile) {
        isMobileListView(true);
      } else {
        isDesktopListView(true);
      }
    } else if (popupMenuList[index] == "GridView") {
      if (AppHelper.isMobile) {
        isMobileListView(false);
      } else {
        isDesktopListView(false);
      }
    } else if (popupMenuList[index] == "LogOut") {
      signOutWithFirebase();
    }
  }

  Future signOutWithFirebase() async {
    await AppStorage.removeAllData();
    await AppStorage.setData(Const.isLogin, false);
    Get.offAllNamed(AppRoutes.login);
  }
}
