import 'package:dnotes/screens/home/home_view.dart';
import 'package:dnotes/screens/login/login_view.dart';
import 'package:dnotes/screens/notes/notes_view.dart';
import 'package:dnotes/screens/splash/splash_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splash = "/splash";
  static const String home = "/home";
  static const String login = "/login";
  static const String notes = "/notes";

  static getPages() {
    return [
      GetPage(
        name: splash,
        page: () => SplashView(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 250),
      ),
      GetPage(
        name: login,
        page: () => LoginView(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 250),
      ),
      GetPage(
        name: home,
        page: () => HomeView(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 250),
      ),
      GetPage(
        name: notes,
        page: () => NotesView(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 250),
      ),
    ];
  }
}
