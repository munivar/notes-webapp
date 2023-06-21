import 'package:dnotes/firebase_options.dart';
import 'package:dnotes/helpers/app_color.dart';
import 'package:dnotes/helpers/app_const.dart';
import 'package:dnotes/helpers/app_routes.dart';
import 'package:dnotes/helpers/scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';

GlobalKey<NavigatorState> toastNavigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const StartApp());
  // Checking device preview in diffrent Devices
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => const StartApp(),
  //   ),
  // );
}

Future<void> initializeDependencies() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await setupSystemUIOverlayStyle();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeGetStorage();
}

Future<void> setupSystemUIOverlayStyle() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: AppColor.lightBgClr,
    statusBarColor: AppColor.lightBgClr,
  ));
}

Future<void> initializeGetStorage() async {
  await GetStorage.init();
}

class StartApp extends StatelessWidget {
  const StartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      builder: FToastBuilder(),
      navigatorKey: toastNavigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.getPages(),
      scrollBehavior: CustomScrollBehavior(),
      title: "DNotes",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColor.primaryClr,
        fontFamily: Const.fontFamily,
      ),
    );
  }
}
