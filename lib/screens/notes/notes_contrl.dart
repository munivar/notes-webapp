import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/screens/home/home_contrl.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:highlight/languages/dart.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class NotesController extends GetxController {
  final homeContrl = Get.find<HomeController>();
  CodeController codeController = CodeController();
  TextEditingController titleContrl = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isWordWrap = false.obs;
  late FirebaseFirestore collectionRef;
  RxString notesId = "".obs;
  RxString newNotesId = "".obs;
  RxString dateValue = "".obs;
  RxBool isFromTrash = false.obs;
  RxBool isFromSearch = false.obs;
  RxBool isDeletedValue = false.obs;
  RxString noteColor = "0xffFFFFFF".obs;
  Timer apiTimer = Timer(const Duration(milliseconds: 600), () {});
  List colorList = [
    "0xffFFFFFF",
    "0xffFFBBBC",
    "0xffD1FFD8",
    "0xffFFFDBA",
    "0xffBAFEFD"
  ];
  List<String> popupMenuList = AppHelper.isWeb
      ? [Const.copyText, Const.wordWrapOn, Const.wordWrapOff]
      : [Const.copyText, Const.shareText, Const.wordWrapOn, Const.wordWrapOff];

  @override
  void onInit() {
    // word wrap code
    if (AppHelper.isWeb == true) {
      isWordWrap(false);
    } else {
      isWordWrap(true);
    }
    // initializing firebase firestore
    collectionRef = FirebaseFirestore.instance;
    // getting notes data
    var arguments = Get.arguments;
    NotesList notes = arguments["notes"] as NotesList;
    isFromTrash.value = arguments["isFromTrash"];
    isFromSearch.value = arguments["isFromSearch"];
    if (notes.id != "dnotes") {
      notesId.value = notes.id;
      dateValue.value = notes.date;
      titleContrl.text = notes.title;
      isDeletedValue.value = notes.isDeleted;
      codeController = CodeController(text: notes.text, language: dart);
    }
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
    super.onInit();
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  void onMenuTap(BuildContext context, String selectedMenuItem) async {
    Get.back();
    switch (selectedMenuItem) {
      case Const.wordWrapOn:
        enableWordWrap();
        break;
      case Const.wordWrapOff:
        disableWordWrap();
        break;
      case Const.copyText:
        copyTextToClipboard(context, codeController.text);
        break;
      case Const.shareText:
        shareText(codeController.text);
        break;
      default:
        break;
    }
  }

  // Enable word wrapping logic
  void enableWordWrap() {
    isWordWrap(true);
  }

  // Disable word wrapping logic
  void disableWordWrap() {
    isWordWrap(false);
  }

  // Copy text to clipboard logic
  void copyTextToClipboard(BuildContext context, String text) async {
    isLoading(true);
    await Clipboard.setData(ClipboardData(text: text)).then((value) {
      isLoading(false);
    });
  }

  // Share text logic
  void shareText(String text) async {
    isLoading(true);
    await Share.share(text);
    isLoading(false);
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
      isLoading(true);
      if (notesId.isNotEmpty) {
        // Get a instance to the Firestore collection
        final notesRef = collectionRef
            .collection(Const.fireNotes)
            .doc(homeContrl.userId.value)
            .collection(Const.fireUserNotes)
            .doc(notesId.value);
        // create notes jsonReq
        final notes = NotesList(
          id: notesId.value,
          title: titleContrl.text.trim(),
          text: codeController.text.trim(),
          date: dateValue.value,
          isDeleted: isDeletedValue.value,
          noteColor: noteColor.value,
        );
        final jsonReq = notes.toJson();
        // create doc and write data in firebase firestore
        await notesRef.set(jsonReq);
        isLoading(false);
        // refresh notes data in home screen
        homeContrl.getDataFromFirebase();
      } else {
        // formating date
        DateTime now = DateTime.now();
        DateFormat formatter = DateFormat("dd MMM yyyy - hh:mm a");
        String formattedDate = formatter.format(now);
        // add new notes
        final notesRef = collectionRef
            .collection(Const.fireNotes)
            .doc(homeContrl.userId.value)
            .collection(Const.fireUserNotes)
            .doc();
        notesId.value = notesRef.id;
        dateValue.value = formattedDate;
        isDeletedValue.value = false;
        noteColor.value = "0xffFFFFFF";
        // create notes jsonReq
        final notes = NotesList(
          id: notesRef.id,
          title: titleContrl.text.trim(),
          text: codeController.text.trim(),
          date: formattedDate,
          isDeleted: false,
          noteColor: noteColor.value,
        );
        final jsonReq = notes.toJson();
        await notesRef.set(jsonReq);
        isLoading(false);
        // refresh notes data in home screen
        homeContrl.getDataFromFirebase();
      }
    } catch (e) {
      debugPrint("firebaseError ->> $e");
      isLoading(false);
    }
  }

  // change notes color in firebase firestore
  Future changeNoteColorInFirebase(
      BuildContext context, String noteColor) async {
    try {
      isLoading(true);
      Get.back();
      final notesRef = collectionRef
          .collection(Const.fireNotes)
          .doc(homeContrl.userId.value)
          .collection(Const.fireUserNotes)
          .doc(notesId.value);
      await notesRef.update({"noteColor": noteColor});
      isLoading(false);
      // refresh notes data in home screen
      homeContrl.getDataFromFirebase();
    } catch (e) {
      isLoading(false);
      debugPrint("firebaseError ->> $e");
    }
  }

  // move notes in trash in firebase firestore
  Future moveToTrashInFirebase(BuildContext context) async {
    try {
      isLoading(true);
      final notesRef = collectionRef
          .collection(Const.fireNotes)
          .doc(homeContrl.userId.value)
          .collection(Const.fireUserNotes)
          .doc(notesId.value);
      await notesRef.update({"isDeleted": true});
      isLoading(false);
      // refresh notes data in home screen
      homeContrl.getDataFromFirebase();
      Get.back();
    } catch (e) {
      isLoading(false);
      debugPrint("firebaseError ->> $e");
    }
  }

  // revert back notes in trash in firebase firestore
  Future revertBackFromFirebase(BuildContext context) async {
    try {
      isLoading(true);
      final notesRef = collectionRef
          .collection(Const.fireNotes)
          .doc(homeContrl.userId.value)
          .collection(Const.fireUserNotes)
          .doc(notesId.value);
      await notesRef.update({"isDeleted": false});
      isLoading(false);
      Get.back(result: true);
    } catch (e) {
      isLoading(false);
      debugPrint("firebaseError ->> $e");
    }
  }

  // delete notes in trash in firebase firestore
  Future deleteNotesInFirebase(BuildContext context) async {
    try {
      isLoading(true);
      final notesRef = collectionRef
          .collection(Const.fireNotes)
          .doc(homeContrl.userId.value)
          .collection(Const.fireUserNotes)
          .doc(notesId.value);
      await notesRef.delete();
      isLoading(false);
      Get.back(result: true);
    } catch (e) {
      isLoading(false);
      debugPrint("firebaseError ->> $e");
    }
  }
}
