import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/screens/home/home_contrl.dart';
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
  List<String> popupMenuList = [
    "Copy Text",
    "Share Text",
    "WordWrap (Off)",
    "WordWrap (On)",
  ];
  List<String> popupImageList = [
    AppImages.copyIcon,
    AppImages.shareIcon,
    AppImages.wrapIcon,
    AppImages.wrapIcon,
  ];
  RxBool isWordWrap = false.obs;

  @override
  void onInit() {
    codeController = CodeController(
      text: homeContrl.isFromEdit.isTrue ? Const.codeSnippet["dart"] : "",
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
    super.onInit();
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  void onMenuTap(BuildContext context, int index) {
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

  // -- copy text to clipboard
  void copyTextToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text)).then((value) {
      AppToast.showToast(context, "Copied to Clipboard");
    });
  }

  // -- share first text
  void shareText(String text) async {
    await Share.share(text);
  }
}
