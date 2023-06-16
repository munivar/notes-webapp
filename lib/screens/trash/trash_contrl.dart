import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_storage.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:get/get.dart';

class TrashController extends GetxController {
  CodeController codeController = CodeController();
  RxString userId = "".obs;
  late FirebaseFirestore collectionRef;

  @override
  void onInit() {
    // get user id from get storage
    getUserIdFromStorage();
    // initializing firebase firestore
    collectionRef = FirebaseFirestore.instance;
    super.onInit();
  }

  // getUserIdFromStorage
  getUserIdFromStorage() async {
    userId.value = await AppStorage.getData(Const.userId);
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
