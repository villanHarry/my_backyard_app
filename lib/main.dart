import 'dart:io';
import 'package:backyard/Controller/state_management.dart';
import 'package:backyard/Service/app_in_app_purchase.dart';
import 'package:backyard/Service/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:backyard/Utils/app_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'Utils/my_colors.dart';

BitmapDescriptor pin = BitmapDescriptor.defaultMarker;

void main() async {
  configLoading();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppInAppPurchase().initialize();
  ScreenUtil.ensureScreenSize();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(
      providers: StateManagement.providersList, child: const MyApp()));
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..backgroundColor = Colors.transparent
    ..indicatorColor = const Color(0xffB4B4B4)
    ..textColor = Colors.transparent
    ..boxShadow = [const BoxShadow(color: Colors.transparent)]
    ..maskType = EasyLoadingMaskType.custom
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 35.0
    ..radius = 10.0
    ..maskColor = Colors.transparent //.withOpacity(0.6)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        navigatorKey: navigatorKey,
        darkTheme: lightTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [MonthYearPickerLocalizations.delegate],
        title: 'My Backyard',
        locale: const Locale('en', 'US'),
        builder: EasyLoading.init(),
        // home: HomePage(),
        onGenerateRoute: AppRouter.onGenerateRoute,
      );
    });
  }
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
