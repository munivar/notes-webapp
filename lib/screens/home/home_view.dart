import 'package:dnotes/animations/fade_anim.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/screens/home/home_contrl.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:dnotes/widgets/app_text.dart';
import 'package:dnotes/widgets/icon_button.dart';
import 'package:dnotes/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // make it false if you want to use custom function
        // use Get.back()
        // return Future(() => false);
        return Future(() => true);
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
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: InkWell(
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Get.offAllNamed(AppRoutes.home);
                },
                child: AppText(
                  "DNotes",
                  fontSize: AppHelper.font(context, 20),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: AppIconButton(
                    AppImages.addIcon,
                    onTap: () {
                      NotesList notes = NotesList(
                          id: "dnotes",
                          title: "",
                          text: "",
                          date: "",
                          isDeleted: false);
                      Get.toNamed(AppRoutes.notes, arguments: {
                        "notes": notes,
                        "isFromTrash": false,
                        "isFromSearch": false,
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 43),
                  child: AppIconButton(
                    AppImages.searchIcon,
                    padding: const EdgeInsets.all(12),
                    onTap: () {
                      Get.toNamed(AppRoutes.search);
                    },
                  ),
                ),
                popupMenu(context),
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

  popupMenu(BuildContext context) {
    return AppPopupMenu(
      menuKey: controller.homePopupKey,
      onTap: () {
        dynamic state = controller.homePopupKey.currentState;
        state.showButtonMenu();
      },
      child: SizedBox(
        width: 135,
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
                  controller.onMenuTap(controller.popupMenuList[index]);
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

  buildListLayout(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.isTrue) {
        return FadeAppAnimation(child: Container());
      } else if (controller.notesList.isEmpty) {
        return FadeAppAnimation(
          child: Center(
              child: Padding(
            padding: EdgeInsets.only(top: AppHelper.height(context, 25)),
            child: Column(
              children: [
                AppText(
                  "No Notes",
                  fontWeight: FontWeight.w600,
                  fontSize: AppHelper.font(context, 14),
                ),
                AppHelper.sizedBox(context, 0.5, null),
                AppText(
                  "Tap the Add button to \n Create a Notes",
                  maxLines: 2,
                  fontSize: AppHelper.font(context, 10),
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                ),
              ],
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
                  // controller.codeController = CodeController(
                  //   text: items.text,
                  //   language: dart,
                  // );
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
                  // controller.codeController = CodeController(
                  //   text: items.text,
                  //   language: dart,
                  // );
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
          color: AppColor.whiteColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(13),
            onTap: () {
              NotesList notes = NotesList(
                  id: items.id,
                  title: items.title,
                  text: items.text,
                  date: items.date,
                  isDeleted: items.isDeleted);
              Get.toNamed(AppRoutes.notes, arguments: {
                "notes": notes,
                "isFromTrash": false,
                "isFromSearch": false,
              });
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
