import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/animations/fade_in.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:dnotes/screens/trash/trash_contrl.dart';
import 'package:dnotes/widgets/app_text.dart';
import 'package:dnotes/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:highlight/languages/dart.dart';

class TrashView extends StatelessWidget {
  TrashView({super.key});
  final TrashController controller = Get.put(TrashController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: controller.isGetBack.value);
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
      toolbarHeight: 60,
      elevation: 0,
      backgroundColor: AppColor.lightBgClr,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        height: 60,
        width: AppHelper.isDesktop ? 60.w : 100.w,
        padding: AppHelper.isMobile == false
            ? EdgeInsets.symmetric(horizontal: 3.w)
            : const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: AppSvgIcon(
                AppImages.backIcon,
                onTap: () {
                  Get.back(result: controller.isGetBack.value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: AppText(
                "Trash",
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  mainLayout(BuildContext context) {
    return Container(
        height: double.infinity,
        margin: EdgeInsets.only(
          left: AppHelper.isMobile == false ? 3.w : 2.w,
          bottom: 10,
          right: AppHelper.isMobile == false ? 3.w : 2.w,
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildListLayout(context),
              AppHelper.sizedBox(4, null),
            ],
          ),
        ));
  }

  buildListLayout(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.isTrue) {
        return FadeInAnything(child: Container());
      } else if (controller.notesList.isEmpty) {
        return FadeInAnything(
          child: Center(
              child: Padding(
            padding: EdgeInsets.only(top: 25.h),
            child: AppText(
              "No Notes",
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
          )),
        );
      } else {
        return controller.listItemCount.value == 1
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.notesList.length,
                itemBuilder: (context, index) {
                  var items = controller.notesList[index];
                  // add data from firebase firestore to code controller
                  controller.codeController = CodeController(
                    text: items.text,
                    language: dart,
                  );
                  //
                  return buildChildrenLayout(context, items);
                })
            : MasonryGridView.count(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                crossAxisCount: controller.listItemCount.value,
                itemCount: controller.notesList.length,
                itemBuilder: ((context, index) {
                  var items = controller.notesList[index];
                  // add data from firebase firestore to code controller
                  controller.codeController = CodeController(
                    text: items.text,
                    language: dart,
                  );
                  //
                  return buildChildrenLayout(context, items);
                }));
      }
    });
  }

  buildChildrenLayout(BuildContext context, NotesList items) {
    return FadeInAnything(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: Material(
          borderRadius: BorderRadius.circular(13),
          color: Color(int.parse(items.noteColor)),
          child: InkWell(
            borderRadius: BorderRadius.circular(13),
            onTap: () async {
              NotesList notes = NotesList(
                  id: items.id,
                  title: items.title,
                  text: items.text,
                  date: items.date,
                  isDeleted: items.isDeleted,
                  noteColor: items.noteColor);
              var result = await Get.toNamed(AppRoutes.notesRoute, arguments: {
                "notes": notes,
                "isFromTrash": true,
                "isFromSearch": false
              });
              if (result == true) {
                controller.isGetBack(true);
                // refresh notes data in trash screen
                controller.getDataFromFirebase();
              } else {
                controller.isGetBack(false);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  items.title.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: AppText(
                            items.title,
                            fontSize: 16.sp,
                            maxLines: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  items.text.isEmpty
                      ? Container()
                      : Container(
                          width: 100.w,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0),
                          child: AppText(
                            items.text,
                            maxLines: 8,
                            fontColor: AppColor.fontHintClr,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
