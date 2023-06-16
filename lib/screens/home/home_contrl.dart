import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/helpers/app_storage.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final GlobalKey homePopupKey = GlobalKey();
  List<String> popupMenuList = ["ListView", "GridView", "Trash", "LogOut"];
  CodeController codeController = CodeController();
  RxList<NotesList> notesList = RxList<NotesList>([]);
  RxBool isLoading = false.obs;
  RxInt listItemCount = 1.obs;
  RxString userId = "".obs;
  late FirebaseFirestore collectionRef;

  @override
  void onInit() {
    // getDataFromFirebase
    getDataFromFirebase();
    // setup item count of list view
    if (AppHelper.isMobile) {
      listItemCount.value = 1;
    } else {
      listItemCount.value = 3;
    }
    // initializing firebase firestore
    collectionRef = FirebaseFirestore.instance;
    super.onInit();
  }

  // getUserIdFromStorage
  getDataFromFirebase() async {
    try {
      isLoading(true);
      notesList.clear();
      userId.value = await AppStorage.getData(Const.userId);
      var querySnapshot = await FirebaseFirestore.instance
          .collection(Const.fireNotes)
          .doc(userId.value)
          .collection(Const.fireUserNotes)
          .where("isDeleted", isEqualTo: false)
          .get();
      final firebaseNotesList = querySnapshot.docs
          .map((doc) => NotesList.fromJson(doc.data()))
          .toList();
      notesList.value = firebaseNotesList;
      isLoading(false);
    } catch (e) {
      debugPrint("firebaseError ->> $e");
    }
  }

  // on menu item tap
  void onMenuTap(int index) {
    Get.back();
    if (popupMenuList[index] == "ListView") {
      listItemCount.value = 1;
    } else if (popupMenuList[index] == "GridView") {
      if (AppHelper.isMobile) {
        listItemCount.value = 2;
      } else {
        listItemCount.value = 3;
      }
    } else if (popupMenuList[index] == "Trash") {
      Get.toNamed(AppRoutes.trash);
    } else if (popupMenuList[index] == "LogOut") {
      signOutWithFirebase();
    }
  }

  Future signOutWithFirebase() async {
    await AppStorage.removeAllData();
    await AppStorage.setData(Const.isLogin, false);
    Get.offAllNamed(AppRoutes.login);
  }

  // - read notes data from firestore
  Stream<List<NotesList>> readNotes() {
    if (userId.value.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection(Const.fireNotes)
          .doc(userId.value)
          .collection(Const.fireUserNotes)
          .orderBy("date")
          .snapshots()
          .map((event) {
        return event.docs.map((doc) => NotesList.fromJson(doc.data())).toList();
      });
    } else {
      return const Stream.empty();
    }
  }
}
