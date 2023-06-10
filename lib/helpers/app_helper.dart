import 'package:flutter/material.dart';
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

  // sized box
  static sizedBox(BuildContext context, double? height, double? width) {
    double deviceScreenWidth = MediaQuery.of(context).size.width;
    double deviceScreenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height == null ? 0.0 : deviceScreenHeight * height / 100,
      width: width == null ? 0.0 : deviceScreenWidth * width / 100,
    );
  }

  // responsive font
  static double font(BuildContext context, double fontSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktopWidth = screenWidth > 1008;
    bool isTabletWidth = screenWidth > 600 && screenWidth < 1008;
    // Adjust font size based on device width
    if (isDesktopWidth) {
      // Desktop font size calculation
      return screenWidth * (fontSize / 13) / 100;
    } else if (isTabletWidth) {
      // Tablet font size calculation
      return screenWidth * (fontSize / 8) / 100;
    } else {
      // Other devices font size calculation
      return screenWidth * (fontSize / 3.8) / 100;
    }
  }

  // responsive height
  static height(BuildContext context, double height) {
    // Returned Responsive Height based on Device Height
    return MediaQuery.of(context).size.height * height / 100;
  }

  // responsive width
  static width(BuildContext context, double width) {
    // Returned Responsive Width based on Device Width
    return MediaQuery.of(context).size.width * width / 100;
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
