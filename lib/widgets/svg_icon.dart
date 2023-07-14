import 'package:dnotes/animations/fade_in.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class AppSvgIcon extends StatelessWidget {
  final String assetImage;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final void Function()? onTap;
  final BoxFit? fit;
  final double? height;
  final double? width;
  const AppSvgIcon(
    this.assetImage, {
    super.key,
    this.onTap,
    this.color,
    this.padding,
    this.fit,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInAnything(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(50),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(10),
            child: SvgPicture(
              AssetBytesLoader(assetImage),
              colorFilter:
                  ColorFilter.mode(color ?? AppColor.fontClr, BlendMode.srcIn),
              excludeFromSemantics: false,
              alignment: Alignment.center,
              fit: fit ?? BoxFit.none,
              height: height,
              width: width,
            ),
          ),
        ),
      ),
    );
  }
}
