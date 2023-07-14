import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:lottie/lottie.dart';

enum DeviceType { isMobile, isTablet, isDesktop }

enum DeviceOrientation { isPortrait, isLandscape }

class AppHelper {
  // getting device type
  static DeviceType get deviceType {
    final mediaQueryData = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.implicitView!);
    final double width = mediaQueryData.size.width;
    if (width >= 960) {
      return DeviceType.isDesktop;
    } else if (width >= 600) {
      return DeviceType.isTablet;
    } else {
      return DeviceType.isMobile;
    }
  }

  // getting device orientation
  static DeviceOrientation get deviceOrientation {
    final orientation =
        // ignore: deprecated_member_use
        MediaQueryData.fromView(WidgetsBinding.instance.window).orientation;
    if (orientation == Orientation.portrait) {
      return DeviceOrientation.isPortrait;
    } else {
      return DeviceOrientation.isLandscape;
    }
  }

  static bool get isMobile => deviceType == DeviceType.isMobile;
  static bool get isTablet => deviceType == DeviceType.isTablet;
  static bool get isDesktop => deviceType == DeviceType.isDesktop;
  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;
  static bool get isWeb => kIsWeb;
  static bool get isPortrait =>
      deviceOrientation == DeviceOrientation.isPortrait;
  static bool get isLandscape =>
      deviceOrientation == DeviceOrientation.isLandscape;

  // responsive sizedbox
  static SizedBox sizedBox(double? height, double? width) {
    return SizedBox(width: width?.w, height: height?.h);
  }

  // Format date
  static String formateDate(String date) {
    if (date.isNotEmpty) {
      try {
        final finalDate = DateTime.parse(date);
        return DateFormat("dd/MM/yyyy").format(finalDate);
      } catch (e) {
        // Handle parsing errors, e.g., return an error message or a default value
        return "Invalid date format";
      }
    } else {
      return "";
    }
  }

  // Format time
  static String formateTime(String time) {
    if (time.isNotEmpty) {
      try {
        final finalTime = DateTime.parse(time);
        return DateFormat("hh:mm a").format(finalTime);
      } catch (e) {
        // Handle parsing errors, e.g., return an error message or a default value
        return "Invalid time format";
      }
    } else {
      return "";
    }
  }

  // Format date and time
  static String formatDateTime(String date) {
    if (date.isNotEmpty) {
      try {
        final finalDateTime = DateTime.parse(date);
        return DateFormat("EEE, dd MMM yyyy - hh:mm a").format(finalDateTime);
      } catch (e) {
        // Handle parsing errors, e.g., return an error message or a default value
        return "Invalid date format";
      }
    } else {
      return "";
    }
  }

  // opening keyboard
  static void openKeyboard(BuildContext context, FocusNode? focusNode) {
    SystemChannels.textInput.invokeMethod('TextInput.show');
    FocusScope.of(context).requestFocus(focusNode);
  }

  // closing keyboard
  static void closeKeyboard(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  // app loader
  static appLoader(Color? color) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color ?? AppColor.fontClr, BlendMode.srcIn),
      child: Lottie.asset(
        AppImages.loadingJson,
        width: 28,
        height: 28,
      ),
    );
  }

  // function for picking date
  static pickDate(BuildContext context) async {
    try {
      DateTime? dateValue = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1700),
        lastDate: DateTime(2101),
        locale: const Locale("en"), // Specify the desired locale
      );
      if (dateValue != null) {
        return dateValue;
      } else {
        throw Exception(
            "No date selected"); // Throw an error if no date is selected
      }
    } catch (e) {
      throw Exception(
          "Failed to show date picker: $e"); // Propagate the error with more information
    }
  }
}

// responsive height, width and font
extension ResponsiveSizeExtension on num {
  double get h => Get.height * (this / 100);
  double get w => Get.width * (this / 100);
  double get sp => Get.textScaleFactor * this;
}
