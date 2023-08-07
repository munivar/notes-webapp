import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/screens/home/home_view.dart';
import 'package:dnotes/screens/login/login_view.dart';
import 'package:dnotes/screens/notes/notes_view.dart';
import 'package:dnotes/screens/search/search_view.dart';
import 'package:dnotes/screens/trash/trash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String loginRoute = "/";
  static const String homeRoute = "/home";
  static const String notesRoute = "/notes";
  static const String searchRoute = "/search";
  static const String trashRoute = "/trash";

  static final List<GetPage> routes = [
    GetPage(
      name: loginRoute,
      transition: Transition.fade,
      curve: Curves.fastEaseInToSlowEaseOut,
      page: () => LoginView(),
    ),
    GetPage(
      name: homeRoute,
      page: () => HomeView(),
      transition: Transition.fade,
      curve: Curves.fastEaseInToSlowEaseOut,
      middlewares: [RouteMiddleWare()],
    ),
    GetPage(
      name: notesRoute,
      page: () => NotesView(),
      transition: Transition.fade,
      curve: Curves.fastEaseInToSlowEaseOut,
      middlewares: [RouteMiddleWare()],
    ),
    GetPage(
      name: searchRoute,
      page: () => SearchView(),
      transition: Transition.fade,
      curve: Curves.fastEaseInToSlowEaseOut,
      middlewares: [RouteMiddleWare()],
    ),
    GetPage(
      name: trashRoute,
      transition: Transition.fade,
      curve: Curves.fastEaseInToSlowEaseOut,
      page: () => TrashView(),
      middlewares: [RouteMiddleWare()],
    ),
  ];
}

class RouteMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return Const.isAuthSucess == false
        ? const RouteSettings(name: AppRoutes.loginRoute)
        : null;
  }
}
