import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/animations/fade_anim.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:dnotes/screens/trash/trash_contrl.dart';
import 'package:dnotes/widgets/app_text.dart';
import 'package:dnotes/widgets/icon_button.dart';
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
      toolbarHeight: 75,
      elevation: 0,
      backgroundColor: AppColor.lightBgClr,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        height: 75,
        width: AppHelper.isDesktop
            ? AppHelper.width(context, 60)
            : AppHelper.width(context, 100),
        padding: AppHelper.isMobile == false
            ? EdgeInsets.symmetric(horizontal: AppHelper.width(context, 3))
            : const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppIconButton(
                  AppImages.backIcon,
                  padding: const EdgeInsets.all(9),
                  onTap: () {
                    Get.back(result: controller.isGetBack.value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: AppText(
                    "Trash",
                    fontSize: AppHelper.font(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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
          left: AppHelper.isMobile == false
              ? AppHelper.width(context, 3)
              : AppHelper.width(context, 2),
          bottom: 10,
          right: AppHelper.isMobile == false
              ? AppHelper.width(context, 3)
              : AppHelper.width(context, 2),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildListLayout(context),
              AppHelper.sizedBox(context, 4, null),
            ],
          ),
        ));
  }

  buildListLayout(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.isTrue) {
        return FadeAppAnimation(child: Container());
      } else if (controller.notesList.isEmpty) {
        return FadeAppAnimation(
          child: Center(
              child: Padding(
            padding: EdgeInsets.only(top: AppHelper.height(context, 25)),
            child: AppText(
              "No Notes",
              fontWeight: FontWeight.w500,
              fontSize: AppHelper.font(context, 14),
            ),
          )),
        );
      } else {
        return controller.listItemCount.value == 1
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
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
                physics: const ScrollPhysics(),
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
    return FadeAppAnimation(
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
              var result = await Get.toNamed(AppRoutes.notes, arguments: {
                "notes": notes,
                "isFromTrash": true,
                "isFromSearch": false
              });
              debugPrint("result ->>> $result");
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
                            fontSize: AppHelper.font(context, 12),
                            maxLines: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  items.text.isEmpty
                      ? Container()
                      : Container(
                          width: AppHelper.width(context, 100),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0),
                          child: AppText(
                            items.text,
                            maxLines: 8,
                            fontColor: AppColor.fontHintClr,
                            fontSize: AppHelper.font(context, 10),
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
