import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/animations/fade_anim.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/screens/home/home_contrl.dart';
import 'package:dnotes/widgets/app_text.dart';
import 'package:dnotes/widgets/app_toast.dart';
import 'package:dnotes/widgets/icon_button.dart';
import 'package:dnotes/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.isOptionShowing.isTrue) {
          controller.isOptionShowing(false);
        } else {
          return true;
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
              child: AppText(
                "DNotes",
                fontSize: AppHelper.font(context, 20),
                fontWeight: FontWeight.w600,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 75),
                  child: AppIconButton(
                    AppImages.addIcon,
                    onTap: () {
                      controller.isFromEdit(false);
                      Get.toNamed(AppRoutes.notes);
                    },
                  ),
                ),
                AppIconButton(
                  AppImages.searchIcon,
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 75),
                  child: popupMenu(context),
                )
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
          physics: const BouncingScrollPhysics(),
          child: FadeAppAnimation(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppHelper.isMobile
                    ? Obx(() {
                        return controller.isMobileListView.isTrue
                            ? buildListLayout(context)
                            : buildGridLayout(context);
                      })
                    : Obx(() {
                        return controller.isDesktopListView.isTrue
                            ? buildListLayout(context)
                            : buildGridLayout(context);
                      }),
                // AppHelper.isMobile
                //     ? buildListLayout(context)
                //     : buildGridLayout(context),
                AppHelper.sizedBox(context, 1, null),
                InkWell(
                  onTap: () {
                    AppToast.showToast(
                        context, "This is Custome toast for testing");
                  },
                  child: const AppText("Tap Me for Test"),
                ),
              ],
            ),
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
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return buildChildrenLayout(context, true);
        });
  }

  buildGridLayout(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: AppHelper.isWeb
            ? const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.6,
              )
            : SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: AppHelper.isMobile ? 0.65 : 1.5,
              ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return buildChildrenLayout(context, false);
        });
  }

  buildChildrenLayout(BuildContext context, bool isListView) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: AppColor.whiteColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onLongPress: () {
            if (controller.isOptionShowing.isTrue) {
              controller.isOptionShowing(false);
            } else {
              controller.isOptionShowing(true);
            }
          },
          onTap: () {
            controller.isFromEdit(true);
            Get.toNamed(AppRoutes.notes);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: AppText(
                    "Heading Text This is normal Text I think it is good for first app startup for now !!",
                    fontSize: AppHelper.font(context, 12),
                    maxLines: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                  ),
                  child: SingleChildScrollView(
                    child: CodeTheme(
                      data: const CodeThemeData(styles: vs2015Theme),
                      child: CodeField(
                        enabled: false,
                        readOnly: true,
                        maxLines: 8,
                        wrap: true,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
