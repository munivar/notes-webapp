import 'package:code_text_field/code_text_field.dart';
import 'package:dnotes/animations/fade_anim.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_fun.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/screens/notes/note_list.dart';
import 'package:dnotes/screens/search/search_contrl.dart';
import 'package:dnotes/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:highlight/languages/dart.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});
  final SearchController controller = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
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
                    width: AppHelper.width(context, 70),
                    child: GetBuilder<SearchController>(builder: (controller) {
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
                          fontSize: AppHelper.font(context, 16),
                          color: AppColor.fontClr,
                          fontWeight: FontWeight.bold,
                        ),
                        cursorColor: AppColor.primaryClr,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search your notes...',
                          hintStyle: TextStyle(
                            fontSize: AppHelper.font(context, 16),
                            color: AppColor.fontHintClr,
                            fontWeight: FontWeight.normal,
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
                  ? AppIconButton(
                      AppImages.closeIcon,
                      padding: const EdgeInsets.all(11),
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
              AppHelper.sizedBox(context, 4, null),
            ],
          ),
        ));
  }

  buildListLayout(BuildContext context) {
    return Center(child: Obx(() {
      if (controller.isLoading.isTrue) {
        return FadeAppAnimation(child: Container());
      } else {
        return FadeAppAnimation(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: controller.notesList.length,
              reverse: true,
              itemBuilder: (context, index) {
                final items = controller.notesList[index];
                controller.codeController =
                    CodeController(text: items.text, language: dart);
                return FadeAppAnimation(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColor.whiteColor,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          NotesList notes = NotesList(
                              id: items.id,
                              title: items.title,
                              text: items.text,
                              date: items.date,
                              isDeleted: items.isDeleted);
                          Get.toNamed(AppRoutes.notes, arguments: {
                            "notes": notes,
                            "isFromTrash": false,
                            "isFromSearch": true,
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              items.title == ""
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child: TextWithHighlight(
                                        text: items.title,
                                        searchText:
                                            controller.searchContrl.text,
                                        style: TextStyle(
                                          color: AppColor.fontClr,
                                          fontSize: AppHelper.font(context, 12),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: Const.fontFamily,
                                        ),
                                        highlightStyle: TextStyle(
                                          color: AppColor.primaryClr,
                                          fontSize: AppHelper.font(context, 12),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: Const.fontFamily,
                                        ),
                                      ),
                                      // AppText(
                                      //   title,
                                      //   fontSize: AppHelper.font(context, 12),
                                      //   maxLines: 2,
                                      //   fontWeight: FontWeight.bold,
                                      // ),
                                    ),
                              items.text == ""
                                  ? Container()
                                  : Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColor.lightBgClr,
                                      ),
                                      child: Container(
                                        width: AppHelper.width(context, 100),
                                        padding: const EdgeInsets.all(10),
                                        child: TextWithHighlight(
                                          text: items.text,
                                          searchText:
                                              controller.searchContrl.text,
                                          style: TextStyle(
                                              color: AppColor.fontClr,
                                              fontSize:
                                                  AppHelper.font(context, 10),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: Const.codeFamily),
                                          highlightStyle: TextStyle(
                                            color: AppColor.primaryClr,
                                            fontSize:
                                                AppHelper.font(context, 10),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: Const.codeFamily,
                                          ),
                                        ),
                                      ),
                                    ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: TextWithHighlight(
                                    text: "Created on ${items.date}",
                                    searchText: controller.searchContrl.text,
                                    style: TextStyle(
                                        fontSize: AppHelper.font(context, 10),
                                        color: AppColor.fontHintClr,
                                        fontFamily: Const.fontFamily),
                                    highlightStyle: TextStyle(
                                      color: AppColor.primaryClr,
                                      fontSize: AppHelper.font(context, 10),
                                      fontFamily: Const.fontFamily,
                                    ),
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
