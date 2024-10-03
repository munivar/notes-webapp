import 'dart:ui';
import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/animations/fade_in.dart';
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
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: appbarLayout(context),
            body: mainLayout(context),
          ),
        ),
      ),
    );
  }

  appbarLayout(BuildContext context) {
    return AppBar(
      toolbarHeight: 60,
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: Center(
        child: Container(
          height: 60,
          width: AppHelper.isWeb == true ? 78.w : 96.w,
          padding: AppHelper.isWeb == true
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
                  height: 30,
                  width: 30,
                  color: Colors.white,
                  padding: const EdgeInsets.all(7),
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: AppText(
                  "Trash",
                  fontSize: 22.sp,
                  fontColor: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  mainLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: SizedBox(
          width: AppHelper.isWeb == true ? 72.w : 92.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildListLayout(context),
              AppHelper.sizedBox(4, null),
            ],
          ),
        ),
      ),
    );
  }

  buildListLayout(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.isTrue) {
        return FadeInAnything(
          child: SizedBox(height: 28, child: AppHelper.appLoader(Colors.white)),
        );
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
        return MasonryGridView.count(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            crossAxisCount: AppHelper.isWeb == true ? 3 : 1,
            itemCount: controller.notesList.length,
            itemBuilder: ((context, index) {
              var items = controller.notesList[index];
              // add data from firebase firestore to code controller
              controller.codeController = CodeController(
                text: items.text,
                language: dart,
              );
              //
              return buildChildrenLayout(context, items, index);
            }));
      }
    });
  }

  buildChildrenLayout(BuildContext context, NotesList items, int index) {
    return FadeInAnything(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            // color: Color(int.parse(items.noteColor)),
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withOpacity(0.4),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
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
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 12,
                              width: 12,
                              margin: const EdgeInsets.only(top: 7.5, right: 3),
                              decoration: BoxDecoration(
                                color: Color(int.parse(items.noteColor)),
                                borderRadius: BorderRadius.circular(500),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: AppText(
                                  items.title,
                                  fontSize: 16.sp,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  fontColor: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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
                            fontColor: Colors.white.withOpacity(0.5),
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
