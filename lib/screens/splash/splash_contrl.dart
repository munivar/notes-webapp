import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/helpers/app_storage.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    goToHome();
    super.onInit();
  }

  void goToHome() {
    AppStorage.getData(Const.isLogin).then((value) {
      if (value == true) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }
}
