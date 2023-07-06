import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_helper.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;
  final Color? fontColor;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextAlign? textAlign;
  final String? fontFamily;
  final TextDecoration? decoration;
  const AppText(
    this.text, {
    super.key,
    this.fontColor,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.textAlign,
    this.wordSpacing,
    this.fontFamily,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        textScaleFactor: 1,
        maxLines: maxLines ?? 1,
        overflow: overflow ?? TextOverflow.ellipsis,
        textAlign: textAlign ?? TextAlign.left,
        style: TextStyle(
          decoration: decoration,
          fontSize: fontSize ?? 12.sp,
          color: fontColor ?? AppColor.fontClr,
          fontWeight: fontWeight ?? FontWeight.w400,
          letterSpacing: letterSpacing ?? 0.7,
          wordSpacing: wordSpacing ?? 0,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
}
