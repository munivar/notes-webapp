import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/animations/fade_anim.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_fun.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/screens/home/home_contrl.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:dnotes/widgets/app_text.dart';
import 'package:dnotes/widgets/app_toast.dart';
import 'package:dnotes/widgets/icon_button.dart';
import 'package:dnotes/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:get/get.dart';
import 'package:highlight/languages/dart.dart';
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
      toolbarHeight: 75,
      elevation: 0,
      backgroundColor: AppColor.lightBgClr,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        height: 75,
        width: AppHelper.isDesktop
            ? AppHelper.width(context, 60)
            : AppHelper.width(context, 100),
        padding: EdgeInsets.symmetric(horizontal: AppHelper.width(context, 3)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 120),
                  child: AppIconButton(
                    AppImages.addIcon,
                    onTap: () {
                      Get.toNamed(AppRoutes.notes, arguments: {
                        "id": "dnotes",
                        "title": "",
                        "text": "",
                        "date": "",
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: AppIconButton(
                    AppImages.refreshIcon,
                    padding: const EdgeInsets.all(12),
                    onTap: () {
                      Get.offAllNamed(AppRoutes.home);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: AppIconButton(
                    AppImages.searchIcon,
                    padding: const EdgeInsets.all(11),
                    onTap: () {},
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
            left: AppHelper.width(context, 3),
            bottom: 10,
            right: AppHelper.width(context, 3)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildListLayout(context),
              // AppHelper.sizedBox(context, 4, null),
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
                  controller.onMenuTap(index);
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

  buildListLayout(BuildContext context) {
    return Obx(() {
      return StreamBuilder(
          stream: controller.readNotes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final items = snapshot.data!;
              if (items.isNotEmpty) {
                return Obx(() {
                  return controller.listItemCount.value == 1
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: items.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            // add data from firebase firestore to code controller
                            controller.codeController = CodeController(
                              text: items[index].text,
                              language: dart,
                            );
                            //
                            return buildChildrenLayout(
                                context, index, items, true);
                          })
                      : MasonryGridView.count(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          crossAxisCount: controller.listItemCount.value,
                          itemCount: items.length,
                          itemBuilder: ((context, index) {
                            // add data from firebase firestore to code controller
                            controller.codeController = CodeController(
                              text: items[index].text,
                              language: dart,
                            );
                            //
                            return buildChildrenLayout(
                                context, index, items, false);
                          }));
                });
              } else {
                return Center(
                    child: Column(
                  children: [
                    AppText(
                      "No Notes",
                      fontWeight: FontWeight.bold,
                      fontSize: AppHelper.font(context, 14),
                    ),
                    AppHelper.sizedBox(context, 2, null),
                    const AppText("Tap the Add button to create a notes",
                        fontWeight: FontWeight.w500),
                  ],
                ));
              }
            } else {
              return Center(
                child: SizedBox(
                  height: 40,
                  child: AppFun.appLoader(null),
                ),
              );
            }
          });
    });
  }

  buildChildrenLayout(
      BuildContext context, int index, List<NotesList> items, bool isListView) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: AppColor.whiteColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Get.toNamed(AppRoutes.notes, arguments: {
              "id": items[index].id,
              "title": items[index].title,
              "text": items[index].text,
              "date": items[index].date,
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                items[index].title.isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: AppText(
                          items[index].title,
                          fontSize: AppHelper.font(context, 12),
                          maxLines: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                items[index].text.isEmpty
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: AppColor.codeFieldClr,
                        ),
                        child: SingleChildScrollView(
                          child: CodeTheme(
                            data: const CodeThemeData(styles: vs2015Theme),
                            child: CodeField(
                              enabled: false,
                              readOnly: true,
                              wrap: true,
                              minLines: 1,
                              maxLines: 9,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(15)),
                              controller: controller.codeController,
                              textStyle: TextStyle(
                                  fontSize: AppHelper.font(context, 10),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: Const.codeFamily),
                            ),
                          ),
                        ),
                      ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: AppText(
                      "Created on ${items[index].date}",
                      fontSize: AppHelper.font(context, 10),
                      fontColor: AppColor.fontHintClr,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
