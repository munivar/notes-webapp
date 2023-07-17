import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/screens/notes/notes_contrl.dart';
import 'package:dnotes/widgets/app_text.dart';
import 'package:dnotes/widgets/popup_menu.dart';
import 'package:dnotes/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vector_graphics/vector_graphics.dart';

class NotesView extends StatelessWidget {
  NotesView({super.key});
  final GlobalKey<PopupMenuButtonState> popupMenuKey =
      GlobalKey<PopupMenuButtonState>();
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
      toolbarHeight: 122,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        padding: AppHelper.isMobile == false
            ? EdgeInsets.symmetric(horizontal: 3.w)
            : const EdgeInsets.all(0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: AppSvgIcon(
                    AppImages.backIcon,
                    height: 30,
                    width: 30,
                    padding: const EdgeInsets.all(7),
                    onTap: () {
                      if (controller.isLoading.isFalse) {
                        Get.back();
                      }
                    },
                  ),
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Obx(() {
                      return controller.isFromTrash.isTrue
                          ? Padding(
                              padding: const EdgeInsets.only(right: 92, top: 1),
                              child: AppSvgIcon(
                                AppImages.revertIcon,
                                height: 20,
                                width: 20,
                                padding: const EdgeInsets.all(12.5),
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
                              padding: const EdgeInsets.only(right: 48),
                              child: AppSvgIcon(
                                AppImages.deleteIcon,
                                height: 21,
                                width: 21,
                                padding: const EdgeInsets.all(12),
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
            SizedBox(
              width: 92.w,
              height: 60,
              child: Center(
                child: TextFormField(
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  expands: true,
                  maxLines: null,
                  minLines: null,
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
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.transparent,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.transparent,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.transparent,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    hintText: 'Enter notes title here...',
                    hintStyle: TextStyle(
                      fontSize: 18.sp,
                      color: AppColor.fontHintClr,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                    contentPadding:
                        const EdgeInsets.only(left: 10, right: 10, top: 5),
                  ),
                  controller: controller.titleContrl,
                ),
              ),
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
                  child: const SvgPicture(
                    AssetBytesLoader(AppImages.deleteIcon),
                    colorFilter:
                        ColorFilter.mode(AppColor.fontClr, BlendMode.srcIn),
                    excludeFromSemantics: false,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
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
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            fontSize: 16.sp,
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
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
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
      menuKey: popupMenuKey,
      onTap: () {
        if (controller.isLoading.isFalse) {
          dynamic state = popupMenuKey.currentState;
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
      margin: EdgeInsets.only(left: 3.w, bottom: 2.h, right: 3.w),
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
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5),
                    child: AppText(
                      "Created on ${controller.dateValue.value}",
                      fontSize: 13.sp,
                      fontColor: AppColor.fontHintClr,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: Const.fontFamily,
                            letterSpacing: 1),
                      );
                    })),
              ],
            ),
            Obx(() {
              return controller.isLoading.isTrue
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2, right: 4),
                        child: AppHelper.appLoader(Colors.white),
                      ),
                    )
                  : Container();
            }),
          ],
        ),
      ),
    );
  }
}
