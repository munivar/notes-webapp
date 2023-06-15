import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

// All Common Used Function is here in AppFun Class
class AppFun {
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
        width: 30,
        height: 30,
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
