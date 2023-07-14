import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_storage.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchhController extends GetxController {
  TextEditingController searchContrl = TextEditingController();
  // CodeController codeController = CodeController();
  RxList<NotesList> notesList = RxList<NotesList>([]);
  RxList<NotesList> cloneList = RxList<NotesList>([]);
  List<NotesList> resultList = [];
  RxString userId = "".obs;
  RxBool isLoading = false.obs;
  RxBool isCloseShow = false.obs;
  Timer apiTimer = Timer(const Duration(milliseconds: 600), () {});

  @override
  void onInit() {
    // getDataFromFirebaseFirestore
    getDataFromFirebase();
    super.onInit();
  }

  // getDataFromFirebaseFirestore
  getDataFromFirebase() async {
    try {
      isLoading(true);
      userId.value = await AppStorage.getData(Const.userId);
      var querySnapshot = await FirebaseFirestore.instance
          .collection(Const.fireNotes)
          .doc(userId.value)
          .collection(Const.fireUserNotes)
          .orderBy(FieldPath.fromString("date"), descending: true)
          .where("isDeleted", isEqualTo: false)
          .get();
      final firebaseNotesList = querySnapshot.docs
          .map((doc) => NotesList.fromJson(doc.data()))
          .toList();
      cloneList.value = firebaseNotesList;
      isLoading(false);
    } catch (e) {
      debugPrint("firebaseError ->> $e");
    }
  }

  // searchQueryInDatabase
  searchQueryInDatabase(String searchText) {
    notesList.value = [...cloneList];
    for (var document in cloneList) {
      String finalText = document.title.toString().toLowerCase() +
          document.text.toString().toLowerCase() +
          document.date.toString().toLowerCase();
      if (finalText.contains(searchText)) {
        resultList.add(document);
      } else {
        resultList.remove(document);
      }
    }
    notesList.value = resultList;
  }
}
