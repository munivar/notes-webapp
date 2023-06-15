import 'package:dnotes/helpers/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIconButton extends StatelessWidget {
  final String assetName;
  final double? height;
  final double? width;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final void Function()? onTap;
  const AppIconButton(
    this.assetName, {
    this.onTap,
    super.key,
    this.color,
    this.height,
    this.width,
    this.padding,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 42,
      width: width ?? 42,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(50),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(10),
            child: SvgPicture.asset(
              assetName,
              color: color ?? AppColor.fontClr,
            ),
          ),
        ),
      ),
    );
  }
}
