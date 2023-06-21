import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_fun.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/screens/notes/notes_contrl.dart';
import 'package:dnotes/widgets/app_text.dart';
import 'package:dnotes/widgets/icon_button.dart';
import 'package:dnotes/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NotesView extends StatelessWidget {
  NotesView({super.key});
  final NotesController controller = Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.isLoading.isFalse) {
          Get.back();
        }
        return Future(() => false);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColor.lightBgClr,
          appBar: appbarLayout(context),
          body: mainLayout(context),
        ),
      ),
    );
  }

  appbarLayout(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.lightBgClr,
      toolbarHeight: 75,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        height: 75,
        padding: AppHelper.isMobile == false
            ? EdgeInsets.symmetric(horizontal: AppHelper.width(context, 3))
            : const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AppIconButton(
                  AppImages.backIcon,
                  padding: const EdgeInsets.all(9),
                  onTap: () {
                    if (controller.isLoading.isFalse) {
                      Get.back();
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: SizedBox(
                    width: AppHelper.width(context, 46),
                    child: TextFormField(
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      onChanged: (value) {
                        controller.saveNotes(context);
                      },
                      style: TextStyle(
                        fontSize: AppHelper.font(context, 16),
                        color: AppColor.fontClr,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                      cursorColor: AppColor.primaryClr,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          fontSize: AppHelper.font(context, 16),
                          color: AppColor.fontHintClr,
                          fontWeight: FontWeight.normal,
                          overflow: TextOverflow.ellipsis,
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 14.0, top: 14.0),
                      ),
                      controller: controller.titleContrl,
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Obx(() {
                  return controller.isFromTrash.isTrue
                      ? Padding(
                          padding: const EdgeInsets.only(right: 80),
                          child: AppIconButton(
                            AppImages.revertIcon,
                            padding: const EdgeInsets.all(13),
                            onTap: () {
                              if (controller.isLoading.isFalse) {
                                controller.revertBackFromFirebase(context);
                              }
                            },
                          ),
                        )
                      : Container();
                }),
                Obx(() {
                  return controller.notesId.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 43),
                          child: AppIconButton(
                            AppImages.deleteIcon,
                            padding: const EdgeInsets.all(13),
                            onTap: () {
                              if (controller.isFromTrash.isTrue) {
                                deleteDialog(context);
                              } else {
                                controller.moveToTrashInFirebase(context);
                              }
                            },
                          ),
                        )
                      : Container();
                }),
                popupMenu(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // -- dialog for delete confirmation
  deleteDialog(BuildContext context) {
    Get.dialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: 120,
          height: 210,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColor.fontClr,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: SvgPicture.asset(AppImages.deleteIcon),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: AppText(
                    "Are you sure to Delete this Notes Permanently ?",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          Get.back();
                        },
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: AppText(
                            "Cancel",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          Get.back();
                          controller.deleteNotesInFirebase(context);
                        },
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: AppText(
                            "Delete Note",
                            fontColor: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  popupMenu(BuildContext context) {
    return AppPopupMenu(
      menuKey: controller.notePopupKey,
      onTap: () {
        if (controller.isLoading.isFalse) {
          dynamic state = controller.notePopupKey.currentState;
          state.showButtonMenu();
        }
      },
      child: SizedBox(
        width: 190,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: controller.popupMenuList.length,
          itemBuilder: ((context, index) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (() {
                  controller.onMenuTap(
                      context, controller.popupMenuList[index]);
                }),
                borderRadius: BorderRadius.circular(13),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: AppText(
                    controller.popupMenuList[index],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  mainLayout(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.only(
            left: AppHelper.width(context, 3),
            bottom: AppHelper.height(context, 4),
            right: AppHelper.width(context, 3)),
        padding: EdgeInsets.only(
            left: AppHelper.isWeb ? 15 : 5,
            top: 5,
            bottom: 5,
            right: AppHelper.isWeb ? 15 : 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: AppColor.codeFieldClr,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                CodeTheme(
                    data: const CodeThemeData(styles: vs2015Theme),
                    child: Obx(() {
                      return CodeField(
                        textSelectionTheme: TextSelectionThemeData(
                          cursorColor: Colors.white.withOpacity(0.20),
                          selectionColor: Colors.white.withOpacity(0.20),
                          selectionHandleColor: Colors.white.withOpacity(0.20),
                        ),
                        onChanged: (p0) {
                          controller.saveNotes(context);
                        },
                        wrap: controller.isWordWrap.value,
                        horizontalScroll: true,
                        lineNumbers: false,
                        enabled: AppHelper.isWeb
                            ? true
                            : AppHelper.isLandscape
                                ? false
                                : true,
                        smartQuotesType: SmartQuotesType.enabled,
                        decoration: BoxDecoration(
                            color: AppColor.codeFieldClr,
                            borderRadius: BorderRadius.circular(13)),
                        controller: controller.codeController,
                        textStyle: TextStyle(
                            fontSize: AppHelper.font(context, 11),
                            fontWeight: FontWeight.w500,
                            fontFamily: Const.codeFamily),
                      );
                    })),
                Obx(() {
                  return controller.isLoading.isTrue
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: AppFun.appLoader(Colors.white),
                          ),
                        )
                      : Container();
                }),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AppText(
                  "Created on ${controller.dateValue.value}",
                  fontSize: AppHelper.font(context, 10),
                  fontColor: AppColor.fontHintClr,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
