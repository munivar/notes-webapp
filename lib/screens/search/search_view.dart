import 'package:dnotes/animations/fade_in.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:dnotes/screens/search/search_contrl.dart';
import 'package:dnotes/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});
  final SearchhController controller = Get.put(SearchhController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
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
      backgroundColor: AppColor.lightBgClr,
      toolbarHeight: 60,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        height: 60,
        padding: AppHelper.isMobileL ||
                AppHelper.isMobileS ||
                AppHelper.isMobileM == false
            ? EdgeInsets.symmetric(horizontal: 3.w)
            : const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AppSvgIcon(
                  AppImages.backIcon,
                  height: 30,
                  width: 30,
                  padding: const EdgeInsets.all(7),
                  onTap: () {
                    Get.back();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: SizedBox(
                    width: 65.w,
                    child: GetBuilder<SearchhController>(builder: (controller) {
                      return TextFormField(
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        onChanged: (value) {
                          controller.notesList.clear();
                          controller.resultList.clear();
                          controller.searchQueryInDatabase(value.toString());
                          if (value.isNotEmpty) {
                            controller.isCloseShow(true);
                          } else {
                            controller.isCloseShow(false);
                          }
                        },
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColor.fontClr,
                          fontWeight: FontWeight.bold,
                        ),
                        cursorColor: AppColor.primaryClr,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search your notes...',
                          hintStyle: TextStyle(
                            fontSize: 16.sp,
                            color: AppColor.fontHintClr,
                            fontWeight: FontWeight.w500,
                          ),
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 14.0, top: 14.0),
                        ),
                        controller: controller.searchContrl,
                      );
                    }),
                  ),
                ),
              ],
            ),
            Obx(() {
              return controller.isCloseShow.isTrue
                  ? AppSvgIcon(
                      AppImages.closeIcon,
                      onTap: () {
                        controller.searchContrl.text = "";
                        controller.notesList.clear();
                        controller.resultList.clear();
                        controller.isCloseShow(false);
                      },
                    )
                  : Container();
            }),
          ],
        ),
      ),
    );
  }

  mainLayout(BuildContext context) {
    return Container(
        height: double.infinity,
        margin: EdgeInsets.only(
          left: AppHelper.isMobileL ||
                  AppHelper.isMobileS ||
                  AppHelper.isMobileM == false
              ? 3.w
              : 2.w,
          bottom: 10,
          right: AppHelper.isMobileL ||
                  AppHelper.isMobileS ||
                  AppHelper.isMobileM == false
              ? 3.w
              : 2.w,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
    return Center(child: Obx(() {
      if (controller.isLoading.isTrue) {
        return FadeInAnything(child: Container());
      } else {
        return FadeInAnything(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: controller.notesList.length,
              itemBuilder: (context, index) {
                final items = controller.notesList[index];
                // controller.codeController =
                //     CodeController(text: items.text, language: dart);
                return FadeInAnything(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Material(
                      borderRadius: BorderRadius.circular(13),
                      color: Color(int.parse(items.noteColor)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(13),
                        onTap: () {
                          Get.back();
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
                            "isFromSearch": true,
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              items.title.isEmpty
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3, left: 5, right: 5),
                                      child: TextWithHighlight(
                                        text: items.title,
                                        searchText:
                                            controller.searchContrl.text,
                                        style: TextStyle(
                                          color: AppColor.fontClr,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: Const.fontFamily,
                                          letterSpacing: 0.7,
                                        ),
                                        highlightStyle: TextStyle(
                                          color: AppColor.primaryClr,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: Const.fontFamily,
                                          letterSpacing: 0.7,
                                        ),
                                      ),
                                    ),
                              items.text.isEmpty
                                  ? Container()
                                  : Container(
                                      width: 100.w,
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5, bottom: 5, top: 8),
                                      child: TextWithHighlight(
                                        text: items.text,
                                        searchText:
                                            controller.searchContrl.text,
                                        style: TextStyle(
                                          color: AppColor.fontHintClr,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: Const.fontFamily,
                                          letterSpacing: 0.7,
                                        ),
                                        highlightStyle: TextStyle(
                                          color: AppColor.primaryClr
                                              .withOpacity(0.85),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: Const.fontFamily,
                                          letterSpacing: 0.7,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        );
      }
    }));
  }
}

class TextWithHighlight extends StatelessWidget {
  final String text;
  final String searchText;
  final TextStyle? style;
  final TextStyle? highlightStyle;

  const TextWithHighlight({
    super.key,
    required this.text,
    required this.searchText,
    required this.style,
    required this.highlightStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (searchText.isEmpty) {
      return Text(text, style: style);
    }
    final regex = RegExp(searchText, caseSensitive: false);
    final matches = regex.allMatches(text);
    if (matches.isEmpty) {
      return Text(text, style: style);
    }
    final List<TextSpan> spans = [];
    int previousMatchEnd = 0;
    for (final match in matches) {
      final nonMatchText = text.substring(previousMatchEnd, match.start);
      final matchText = text.substring(match.start, match.end);
      if (nonMatchText.isNotEmpty) {
        spans.add(TextSpan(text: nonMatchText, style: style));
      }
      spans.add(TextSpan(
        text: matchText,
        style: highlightStyle,
      ));
      previousMatchEnd = match.end;
    }
    if (previousMatchEnd < text.length) {
      final nonMatchText = text.substring(previousMatchEnd);
      spans.add(TextSpan(text: nonMatchText, style: style));
    }
    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }
}
