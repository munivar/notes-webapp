import 'dart:ui';
import 'package:dnotes/animations/fade_in.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/screens/home/home_contrl.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:dnotes/widgets/app_text.dart';
import 'package:dnotes/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final GlobalKey<PopupMenuButtonState> popupMenuKey =
      GlobalKey<PopupMenuButtonState>();
  final HomeController controller = Get.put(HomeController());

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
            drawerScrimColor: Colors.transparent,
            body: mainLayout(context),
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
          width: AppHelper.isWeb == true ? 52.w : 92.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppHelper.isWeb == true
                  ? SizedBox(height: 18.h)
                  : SizedBox(height: 8.h),
              AppHelper.isWeb == true
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        murti(context),
                        SizedBox(width: 4.w),
                        quotes(context),
                        // const Text("सरल स्वभाव, न मन कूटिलाई,\nजथा लाभ, संतोष सदाई."),
                      ],
                    )
                  : Column(
                      children: [
                        murti(context),
                        SizedBox(height: 4.h),
                        quotes(context),
                      ],
                    ),
              const SizedBox(height: 42),
              TextField(
                maxLines: 1,
                autofocus: AppHelper.isWeb == true ? true : false,
                controller: controller.searchContrl,
                onChanged: (value) {
                  controller.searchQueryInDatabase(value.toString());
                },
                onSubmitted: (value) async {
                  controller.onLaunch(value);
                },
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    hintText: "Search.....",
                    hintStyle: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600),
                    prefix: const SizedBox(width: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(500)),
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withOpacity(0.3),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12)),
              ),
              const SizedBox(height: 12),
              buildListLayout(context),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  murti(BuildContext context) {
    return Container(
      height: 180,
      width: 180,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.4),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(500),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(500),
        child: Image.asset(
          "assets/images/murti.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  quotes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "-------------x-------------",
          style: TextStyle(
            fontSize: 24.sp,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "સરળ સ્વભાવ, ન મન કુટિલાઇ,",
          style: TextStyle(
            fontSize: 24.sp,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "જથા લાભ, સંતોષ સદાઈ...",
          style: TextStyle(
            fontSize: 24.sp,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "-------------x-------------",
          style: TextStyle(
            fontSize: 24.sp,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  buildListLayout(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.isTrue) {
        return const FadeInAnything(child: SizedBox(height: 28));
      } else if (controller.notesList.isEmpty) {
        return FadeInAnything(
          child: Center(
              child: Padding(
            padding: EdgeInsets.only(top: 25.h),
            child: Column(
              children: [
                AppText(
                  "No Notes",
                  fontWeight: FontWeight.w600,
                  fontColor: Colors.white.withOpacity(0.8),
                  fontSize: 18.sp,
                ),
                AppHelper.sizedBox(0.5, null),
                AppText(
                  "Tap the Add button to \n Create a Notes",
                  maxLines: 2,
                  fontSize: 14.sp,
                  fontColor: Colors.white.withOpacity(0.6),
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          )),
        );
      } else {
        return MasonryGridView.count(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            scrollDirection: Axis.vertical,
            crossAxisCount: AppHelper.isWeb == true ? 3 : 1,
            itemCount: controller.notesList.length,
            itemBuilder: ((context, index) {
              var items = controller.notesList[index];
              // add data from firebase firestore to code controller
              // controller.codeController = CodeController(
              //   text: items.text,
              //   language: dart,
              // );
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
                noteColor: items.noteColor,
              );
              Get.toNamed(AppRoutes.notesRoute, arguments: {
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
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  fontColor: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            deleteBtn(context, items.id),
                          ],
                        ),
                  items.text.isEmpty
                      ? Container()
                      : Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: 100.w,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 0),
                                child: AppText(
                                  items.text,
                                  maxLines: 2,
                                  fontColor: Colors.white.withOpacity(0.5),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            items.title.isEmpty
                                ? deleteBtn(context, items.id)
                                : const SizedBox(),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  deleteBtn(BuildContext context, String id) {
    return AppSvgIcon(
      AppImages.deleteIcon,
      height: 21,
      width: 21,
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      onTap: () {
        deleteDialog(context, id);
      },
    );
  }

  // -- dialog for delete confirmation
  deleteDialog(BuildContext context, String id) {
    Get.dialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: 360,
          height: 220,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(24),
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
                      "Are you sure Move this Notes to Trash ?",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                                color: AppColor.fontClr),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {
                            Get.back();
                            controller.moveToTrashInFirebase(context, id);
                          },
                          child: Text(
                            "Move to Trash",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                                color: Colors.red),
                          ),
                        ),
                      ],
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
