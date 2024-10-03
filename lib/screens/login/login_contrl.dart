import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/helpers/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController usernameContrl = TextEditingController();
  TextEditingController passwordContrl = TextEditingController();
  RxBool isRegister = false.obs;
  RxBool isLoading = false.obs;
  late FirebaseFirestore collectionRef;

  @override
  void onInit() {
    // initializing firebase firestore
    collectionRef = FirebaseFirestore.instance;
    super.onInit();
  }

  void onSignInBtnTap(BuildContext context) {
    if (usernameContrl.text.isNotEmpty) {
      if (passwordContrl.text.isNotEmpty) {
        if (isRegister.isTrue) {
          registerUserWithFirebase(context);
        } else {
          signInUserWithFirebase(context);
        }
      } else {
        AppHelper.closeKeyboard(context);
      }
    } else {
      AppHelper.closeKeyboard(context);
    }
  }

  Future registerUserWithFirebase(BuildContext context) async {
    try {
      isLoading(true);
      final userRef = collectionRef.collection(Const.fireUsers);
      QuerySnapshot querySnapshot = await userRef
          .where(FieldPath.fromString("username"),
              isEqualTo: usernameContrl.text.trim())
          .get();
      // Check if the document exists
      if (querySnapshot.size > 0) {
        // ignore: use_build_context_synchronously

        isLoading(false);
      } else {
        // register user with details in firebase firestore
        var userRef = collectionRef.collection(Const.fireUsers).doc();
        userRef.set({
          "id": userRef.id,
          "username": usernameContrl.text.trim(),
          "password": passwordContrl.text.trim(),
        });
        // going to next screen and setup isLogin true
        Const.isAuthSucess = true;
        AppStorage.setData(Const.isLogin, true);
        AppStorage.setData(Const.userId, userRef.id);
        isLoading(false);
        Get.offAllNamed(AppRoutes.homeRoute);
        //
      }
    } catch (e) {
      isLoading(false);
      debugPrint("firebaseError ->> $e");
    }
  }

  Future signInUserWithFirebase(BuildContext context) async {
    try {
      isLoading(true);
      final userRef = collectionRef.collection(Const.fireUsers);
      QuerySnapshot querySnapshot = await userRef
          .where(FieldPath.fromString("username"),
              isEqualTo: usernameContrl.text.trim())
          .get();
      // Check if the document exists
      if (querySnapshot.size > 0) {
        // Iterate through each document
        for (var document in querySnapshot.docs) {
          // Get the data from the document
          var data = document.data() as Map<String, dynamic>;
          if (data["password"] == passwordContrl.text.trim()) {
            AppStorage.setData(Const.userId, data["id"]);
            // going to next screen and setup isLogin true
            Const.isAuthSucess = true;
            AppStorage.setData(Const.isLogin, true);
            isLoading(false);
            Get.offAllNamed(AppRoutes.homeRoute);
            //
          } else {
            isLoading(false);
            // ignore: use_build_context_synchronously
          }
        }
      } else {
        // ignore: use_build_context_synchronously
        isLoading(false);
      }
    } catch (e) {
      isLoading(false);
      debugPrint("firebaseError ->> $e");
    }
  }
}
