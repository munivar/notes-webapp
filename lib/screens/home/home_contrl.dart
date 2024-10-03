import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/helpers/app_storage.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  TextEditingController searchContrl = TextEditingController();
  RxList<NotesList> notesList = RxList<NotesList>([]);
  RxList<NotesList> cloneList = RxList<NotesList>([]);
  RxBool isLoading = false.obs;
  RxBool isSearch = false.obs;
  RxString userId = "".obs;
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
      cloneList.clear();
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
      cloneList.value = firebaseNotesList;
      isLoading(false);
    } catch (e) {
      debugPrint("firebaseError ->> $e");
    }
  }

  // searchQueryInDatabase
  searchQueryInDatabase(String searchText) {
    if (searchText.isEmpty) {
      notesList.value = [...cloneList];
      return;
    }
    notesList.value = [...cloneList];
    List<NotesList> resultList = [];
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

  void onAddTap() async {
    NotesList notes = NotesList(
      id: "dnotes",
      title: "",
      text: "",
      date: "",
      isDeleted: false,
      noteColor: "0xffFFFFFF",
    );
    Get.toNamed(AppRoutes.notesRoute, arguments: {
      "notes": notes,
      "isFromTrash": false,
      "isFromSearch": false,
    });
  }

  void onLaunch(String value) async {
    if (value.toString() == "add") {
      onAddTap();
      searchContrl.text = "";
      isSearch(false);
      update();
    } else if (value.toString() == "ref") {
      getDataFromFirebase();
      searchContrl.text = "";
      isSearch(false);
      update();
    } else if (value.toString() == "trash") {
      goToTrash();
      searchContrl.text = "";
      isSearch(false);
      update();
    } else if (value.toString() == "logout") {
      signOutWithFirebase();
      searchContrl.text = "";
      isSearch(false);
      update();
    } else {
      isSearch(true);
      update();
      if (value.toString().contains(".")) {
        await launchUrl(Uri.parse("http://$value"),
            webOnlyWindowName: "_blank", mode: LaunchMode.platformDefault);
      } else {
        await launchUrl(Uri.parse("https://www.google.com/search?q=$value"),
            webOnlyWindowName: "_blank", mode: LaunchMode.platformDefault);
      }
      isSearch(false);
      update();
    }
  }

  goToTrash() async {
    Get.toNamed(AppRoutes.trashRoute);
  }

  Future signOutWithFirebase() async {
    await AppStorage.removeAllData();
    Const.isAuthSucess = false;
    await AppStorage.setData(Const.isLogin, false);
    Get.offAllNamed(AppRoutes.loginRoute);
  }

  // move notes in trash in firebase firestore
  Future moveToTrashInFirebase(BuildContext context, String id) async {
    try {
      final notesRef = collectionRef
          .collection(Const.fireNotes)
          .doc(userId.value)
          .collection(Const.fireUserNotes)
          .doc(id);
      await notesRef.update({"isDeleted": true});
    } catch (e) {
      debugPrint("firebaseError ->> $e");
    }
  }
}
