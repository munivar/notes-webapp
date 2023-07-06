import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

enum DeviceType { isMobile, isTablet, isDesktop }

enum DeviceOrientation { isPortrait, isLandscape }

class AppHelper {
  // getting device type
  static DeviceType get deviceType {
    final double deviceWidth =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
    final double devicePixelRatio =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .devicePixelRatio;

    if (devicePixelRatio < 2.0) {
      // Non-Retina devices
      if (deviceWidth >= 600) {
        return DeviceType.isTablet;
      } else {
        return DeviceType.isMobile;
      }
    } else {
      // Retina devices
      if (deviceWidth >= 960) {
        return DeviceType.isDesktop;
      } else if (deviceWidth >= 600) {
        return DeviceType.isTablet;
      } else {
        return DeviceType.isMobile;
      }
    }
  }

  // getting device orientation
  static DeviceOrientation get deviceOrientation {
    final orientation =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).orientation;
    if (orientation == Orientation.portrait) {
      return DeviceOrientation.isPortrait;
    } else {
      return DeviceOrientation.isLandscape;
    }
  }

  // returning value
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
}

// responsive height, width and font
extension ResponsiveSizeExtension on num {
  double get h => Get.height * (this / 100);
  double get w => Get.width * (this / 100);
  double get sp => Get.textScaleFactor * this;
}
