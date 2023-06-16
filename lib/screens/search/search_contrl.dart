import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  TextEditingController searchContrl = TextEditingController();
  CodeController codeController = CodeController();
  RxList<DocumentSnapshot> notesList = RxList<DocumentSnapshot>([]);
  RxList<DocumentSnapshot> cloneList = RxList<DocumentSnapshot>([]);
  List<DocumentSnapshot> resultList = [];
  RxString userId = "".obs;
  RxBool isLoading = false.obs;
  late QuerySnapshot querySnapshot;
  RxBool isCloseShow = false.obs;
  Timer apiTimer = Timer(const Duration(milliseconds: 600), () {});

  @override
  void onInit() {
    // getDataFromFirebaseFirestore
    getDataFromGetStorage();
    super.onInit();
  }

  // getDataFromFirebaseFirestore
  getDataFromGetStorage() async {
    try {
      isLoading(true);
      userId.value = await AppStorage.getData(Const.userId);
      querySnapshot = await FirebaseFirestore.instance
          .collection(Const.fireNotes)
          .doc(userId.value)
          .collection(Const.fireUserNotes)
          .get();
      cloneList.value = [...querySnapshot.docs];
      isLoading(false);
    } catch (e) {
      debugPrint("firebaseError ->> $e");
    }
  }

  // searchQueryInDatabase
  searchQueryInDatabase(String searchText) {
    notesList.value = [...cloneList];
    // Iterate through each document
    for (var document in querySnapshot.docs) {
      // Get the data from the document
      var data = document.data() as Map<String, dynamic>;
      String title = data["title"].toString().toLowerCase() +
          data["text"].toString().toLowerCase() +
          data["date"].toString().toLowerCase();
      if (title.contains(searchText)) {
        resultList.add(document);
      } else {
        resultList.remove(document);
      }
    }
    notesList.value = resultList;
  }
}
