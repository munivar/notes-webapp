import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class AppPopupMenu extends StatelessWidget {
  final Widget child;
  final Offset? offset;
  final double? iconSize;
  final String? assetName;
  final Color? iconColor;
  final double? iconHeight;
  final double? iconWidth;
  final Key? menuKey;
  final void Function()? onTap;
  const AppPopupMenu({
    super.key,
    this.menuKey,
    required this.child,
    this.offset,
    this.iconWidth,
    this.assetName,
    this.iconColor,
    this.iconHeight,
    this.iconSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    List<String> popupList = ["context"];
    return PopupMenuButton(
        key: menuKey,
        elevation: 3,
        color: Colors.white,
        iconColor: Colors.white,
        splashRadius: 2,
        tooltip: "",
        enabled: false,
        iconSize: 44,
        offset: offset ?? const Offset(-10, 15),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        icon: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(50),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 9, vertical: 10),
              child: SvgPicture(
                AssetBytesLoader(AppImages.menuIcon),
                colorFilter:
                    ColorFilter.mode(AppColor.whiteColor, BlendMode.srcIn),
                excludeFromSemantics: false,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
        itemBuilder: ((context) {
          return popupList.map((e) {
            return PopupMenuItem(
              enabled: false,
              child: child,
            );
          }).toList();
        }));
  }
}
