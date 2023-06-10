import 'package:dnotes/animations/fade_anim.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/screens/home/home_contrl.dart';
import 'package:dnotes/widgets/app_text.dart';
import 'package:dnotes/widgets/app_toast.dart';
import 'package:dnotes/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appbarLayout(context),
        body: mainLayout(context),
      ),
    );
  }

  appbarLayout(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.backgroundClr,
      toolbarHeight: 75,
      elevation: 0,
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
              children: [
                AppIconButton(
                  AppImages.addIcon,
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 38),
                  child: AppIconButton(
                    AppImages.searchIcon,
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 76),
                  child: AppIconButton(
                    AppImages.menuIcon,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    onTap: () {},
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
        width: double.infinity,
        color: AppColor.backgroundClr,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FadeAppAnimation(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppHelper.isMobile
                    ? buildListLayout(context)
                    : buildGridLayout(context),
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

  buildListLayout(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return buildChildrenLayout(context);
        });
  }

  buildGridLayout(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return buildChildrenLayout(context);
        });
  }

  buildChildrenLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppHelper.width(context, 2), vertical: 5),
      child: Material(
        borderRadius: BorderRadius.circular(25),
        color: AppColor.whiteColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            Get.toNamed(AppRoutes.notes);
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "Heading Text",
                  fontSize: AppHelper.font(context, 14),
                  fontWeight: FontWeight.w500,
                ),
                AppText(
                  "This is normal Text \n I think it is good for first app startup for now !!",
                  fontSize: AppHelper.font(context, 12),
                  maxLines: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
