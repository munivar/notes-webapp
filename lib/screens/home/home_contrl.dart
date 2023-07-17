import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/helpers/app_storage.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List<String> popupMenuList = [
    Const.listView,
    Const.gridView,
    Const.trash,
    Const.logOut
  ];
  // CodeController codeController = CodeController();
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
          .orderBy(FieldPath.fromString("date"), descending: true)
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

  void onMenuTap(String selectedMenuItem) async {
    Get.back();
    switch (selectedMenuItem) {
      case Const.listView:
        convertToListView();
        break;
      case Const.gridView:
        convertToGridView();
        break;
      case Const.trash:
        goToTrash();
        break;
      case Const.logOut:
        signOutWithFirebase();
        break;
      default:
        break;
    }
  }

  convertToListView() {
    listItemCount.value = 1;
  }

  convertToGridView() {
    if (AppHelper.isMobile) {
      listItemCount.value = 2;
    } else {
      listItemCount.value = 3;
    }
  }

  goToTrash() async {
    var result = await Get.toNamed(AppRoutes.trashRoute);
    if (result == true) {
      // refresh data
      getDataFromFirebase();
    }
  }

  Future signOutWithFirebase() async {
    await AppStorage.removeAllData();
    Const.isAuthSucess = false;
    await AppStorage.setData(Const.isLogin, false);
    Get.offAllNamed(AppRoutes.loginRoute);
  }
}
