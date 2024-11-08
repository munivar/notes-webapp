import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/screens/home/home_contrl.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrashController extends GetxController {
  final homeContrl = Get.find<HomeController>();
  CodeController codeController = CodeController();
  RxList<NotesList> notesList = RxList<NotesList>([]);
  RxBool isLoading = true.obs;
  RxBool isGetBack = false.obs;
  late FirebaseFirestore collectionRef;

  @override
  void onInit() {
    // getDataFromFirebase
    getDataFromFirebase();
    // initializing firebase firestore
    collectionRef = FirebaseFirestore.instance;
    super.onInit();
  }

  // getUserIdFromStorage
  getDataFromFirebase() async {
    try {
      isLoading(true);
      notesList.clear();
      update();
      var querySnapshot = await FirebaseFirestore.instance
          .collection(Const.fireNotes)
          .doc(homeContrl.userId.value)
          .collection(Const.fireUserNotes)
          .orderBy(FieldPath.fromString("date"), descending: true)
          .where("isDeleted", isEqualTo: true)
          .get();
      final firebaseNotesList = querySnapshot.docs
          .map((doc) => NotesList.fromJson(doc.data()))
          .toList();
      notesList.value = firebaseNotesList;
      isLoading(false);
      update();
    } catch (e) {
      debugPrint("firebaseError ->> $e");
    }
  }
}
