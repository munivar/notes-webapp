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
      toolbarHeight: 60,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        padding: AppHelper.isMobile == false
            ? EdgeInsets.symmetric(horizontal: 3.w)
            : const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
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
                    padding: const EdgeInsets.only(top: 1),
                    child: SizedBox(
                      width: 46.w,
                      child: Center(
                        child: TextFormField(
                          scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (value) {
                            controller.saveNotes(context);
                          },
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppColor.fontClr,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                          cursorColor: AppColor.primaryClr,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                            hintStyle: TextStyle(
                              fontSize: 16.sp,
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
                  ),
                ],
              ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AppText(
                    "Are you sure to Delete this Notes Permanently ?",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          child: AppText(
                            "Cancel",
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          child: AppText(
                            "Delete Note",
                            fontColor: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
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
        child: Column(
          children: [
            ListView.builder(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: AppText(
                        controller.popupMenuList[index],
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                );
              }),
            ),
            AppHelper.sizedBox(1, null),
            Container(
              height: 2,
              width: 190,
              color: AppColor.fontHintClr.withOpacity(0.2),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 15, bottom: 10),
              child: SizedBox(
                height: 30,
                child: GetBuilder<NotesController>(builder: (controller) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.colorList.length,
                      itemBuilder: (context, index) {
                        var items = controller.colorList[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              width: 1,
                              color: AppColor.fontHintClr,
                            ),
                          ),
                          child: Material(
                            color: Color(int.parse(items)),
                            borderRadius: BorderRadius.circular(50),
                            child: InkWell(
                              onTap: () {
                                controller.changeNoteColorInFirebase(
                                    context, items);
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: const SizedBox(
                                width: 27,
                                height: 30,
                              ),
                            ),
                          ),
                        );
                      });
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  mainLayout(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.only(left: 3.w, bottom: 4.h, right: 3.w),
      padding: EdgeInsets.only(
          left: AppHelper.isWeb ? 15 : 5,
          top: 5,
          bottom: 5,
          right: AppHelper.isWeb ? 15 : 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: AppColor.codeFieldClr,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 5),
                child: AppText(
                  "Created on ${controller.dateValue.value}",
                  fontSize: 12.sp,
                  fontColor: AppColor.fontHintClr,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(13)),
                        controller: controller.codeController,
                        textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: Const.fontFamily,
                            letterSpacing: 1),
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
          ],
        ),
      ),
    );
  }
}
