import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_storage.dart';
import 'package:dnotes/screens/home/home_contrl.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:dnotes/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:highlight/languages/dart.dart';
import 'package:share_plus/share_plus.dart';

class NotesController extends GetxController {
  final homeContrl = Get.find<HomeController>();
  final GlobalKey notePopupKey = GlobalKey();
  CodeController codeController = CodeController();
  TextEditingController titleContrl = TextEditingController();
  RxBool isWordWrap = false.obs;
  late FirebaseFirestore collectionRef;
  RxString userId = "".obs;
  RxString notesId = "".obs;
  RxString newNotesId = "".obs;
  Timer apiTimer = Timer(const Duration(milliseconds: 600), () {});
  List<String> popupMenuList = AppHelper.isWeb
      ? [
          "Copy Text",
          "WordWrap (Off)",
          "WordWrap (On)",
        ]
      : [
          "Copy Text",
          "Share Text",
          "WordWrap (Off)",
          "WordWrap (On)",
        ];

  @override
  void onInit() {
    // initializing firebase firestore
    collectionRef = FirebaseFirestore.instance;
    // initializing code controller
    // get notes data
    if (homeContrl.isFromEdit.isTrue) {
      dynamic argumentData = Get.arguments;
      notesId.value = argumentData["id"];
      var title = argumentData["title"];
      var text = argumentData["text"];

      // adding data to text controller
      titleContrl.text = title;
      codeController = CodeController(
        text: homeContrl.isFromEdit.isTrue ? text : "",
        // text: "",
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
    }

    // get user id from get storage
    getUserIdFromStorage();
    super.onInit();
  }

  // getUserIdFromStorage
  getUserIdFromStorage() async {
    userId.value = await AppStorage.getData(Const.userId);
  }

  @override
  void onClose() {
    codeController.dispose();
    homeContrl.isFromEdit(false);
    homeContrl.isNewNotes(false);
    super.onClose();
  }

  // on menu item tap
  void onMenuTap(BuildContext context, int index) async {
    Get.back();
    if (popupMenuList[index] == "WordWrap (On)") {
      isWordWrap(true);
    } else if (popupMenuList[index] == "WordWrap (Off)") {
      isWordWrap(false);
    } else if (popupMenuList[index] == "Copy Text") {
      copyTextToClipboard(context, codeController.text);
    } else if (popupMenuList[index] == "Share Text") {
      shareText(codeController.text);
    }
  }

  // copy text to clipboard
  void copyTextToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text)).then((value) {
      AppToast.showToast(context, "Copied to Clipboard");
    });
  }

  // share first text
  void shareText(String text) async {
    await Share.share(text);
  }

  // save note
  void saveNotes(BuildContext context) {
    apiTimer.cancel();
    apiTimer = Timer(const Duration(milliseconds: 600), () {
      addNotesInFirebase(context);
    });
  }

  // save notes in firebase firestore
  Future addNotesInFirebase(BuildContext context) async {
    try {
      if (homeContrl.isFromEdit.isTrue) {
        // Get a instance to the Firestore collection
        final notesRef = collectionRef
            .collection(Const.fireNotes)
            .doc(userId.value)
            .collection(Const.fireUserNotes)
            .doc(notesId.value);
        // create notes jsonReq
        final notes = NotesList(
            id: notesId.value,
            title: titleContrl.text.trim(),
            text: codeController.text.trim());
        final jsonReq = notes.toJson();
        // create doc and write data in firebase firestore
        await notesRef.set(jsonReq);
      } else if (homeContrl.isNewNotes.isTrue) {
        // Get a instance to the Firestore collection
        final notesRef = collectionRef
            .collection(Const.fireNotes)
            .doc(userId.value)
            .collection(Const.fireUserNotes)
            .doc(newNotesId.value);
        // create notes jsonReq
        final notes = NotesList(
            id: newNotesId.value,
            title: titleContrl.text.trim(),
            text: codeController.text.trim());
        final jsonReq = notes.toJson();
        // create doc and write data in firebase firestore
        await notesRef.set(jsonReq);
      } else {
        final notesRef = collectionRef
            .collection(Const.fireNotes)
            .doc(userId.value)
            .collection(Const.fireUserNotes)
            .doc();
        // create notes jsonReq
        final notes = NotesList(
            id: notesRef.id,
            title: titleContrl.text.trim(),
            text: codeController.text.trim());
        final jsonReq = notes.toJson();
        // create doc and write data in firebase firestore
        await notesRef.set(jsonReq);
        newNotesId.value = notesRef.id;
        homeContrl.isNewNotes(true);
      }
    } catch (e) {
      debugPrint("firebaseError ->> $e");
    }
  }
}
