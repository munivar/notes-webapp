import 'package:dnotes/screens/home/home_view.dart';
import 'package:dnotes/screens/login/login_view.dart';
import 'package:dnotes/screens/notes/notes_view.dart';
import 'package:dnotes/screens/search/search_view.dart';
import 'package:dnotes/screens/splash/splash_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splash = "/splash";
  static const String home = "/home";
  static const String login = "/login";
  static const String notes = "/notes";
  static const String search = "/search";

  static getPages() {
    return [
      GetPage(
        name: splash,
        page: () => SplashView(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: login,
        page: () => LoginView(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: home,
        page: () => HomeView(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: notes,
        page: () => NotesView(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: search,
        page: () => SearchView(),
        transition: Transition.fadeIn,
      ),
    ];
  }
}
