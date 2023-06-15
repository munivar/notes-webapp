import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/animations/fade_anim.dart';
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
import 'package:get/get.dart';

class NotesView extends StatelessWidget {
  NotesView({super.key});
  final NotesController controller = Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return Future(() => false);
      },
      child: SafeArea(
        child: FadeFirstAnimation(
          child: Scaffold(
            backgroundColor: AppColor.lightBgClr,
            appBar: appbarLayout(context),
            body: mainLayout(context),
          ),
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
        padding: EdgeInsets.symmetric(horizontal: AppHelper.width(context, 3)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AppIconButton(
                  AppImages.backIcon,
                  padding: const EdgeInsets.all(8),
                  onTap: () {
                    Get.back();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: SizedBox(
                    width: AppHelper.width(context, 46),
                    child: TextFormField(
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      onChanged: (value) {
                        debugPrint("titleText ->> $value");
                        controller.saveNotes(context);
                      },
                      style: TextStyle(
                        fontSize: AppHelper.font(context, 16),
                        color: AppColor.fontClr,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: AppColor.primaryClr,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          fontSize: AppHelper.font(context, 16),
                          color: AppColor.fontHintClr,
                          fontWeight: FontWeight.normal,
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
                  return Padding(
                    padding: EdgeInsets.only(
                        right: controller.notesId.isNotEmpty ? 80 : 40),
                    child: AppIconButton(
                      AppImages.searchIcon,
                      padding: const EdgeInsets.all(11),
                      onTap: () {},
                    ),
                  );
                }),
                Obx(() {
                  return controller.notesId.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: AppIconButton(
                            AppImages.deleteIcon,
                            padding: const EdgeInsets.all(11),
                            onTap: () {
                              controller.deleteNotesInFirebase(context);
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

  popupMenu(BuildContext context) {
    return AppPopupMenu(
      menuKey: controller.notePopupKey,
      onTap: () {
        dynamic state = controller.notePopupKey.currentState;
        state.showButtonMenu();
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
                  controller.onMenuTap(context, index);
                }),
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
            left: AppHelper.isWeb ? 15 : 0,
            top: 15,
            bottom: 15,
            right: AppHelper.isWeb ? 15 : 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColor.codeFieldClr,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
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
                        debugPrint("fieldText ->> $p0");
                        controller.saveNotes(context);
                      },
                      wrap: controller.isWordWrap.value,
                      horizontalScroll: true,
                      decoration: BoxDecoration(
                          color: AppColor.codeFieldClr,
                          borderRadius: BorderRadius.circular(20)),
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
        ),
      ),
    );
  }
}
