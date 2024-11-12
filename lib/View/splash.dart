import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/user_model.dart';
import 'package:backyard/Utils/local_shared_preferences.dart';
import 'package:backyard/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../Utils/image_path.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // SplashController controller = Get.put(SplashController());

  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // saveFCMToken();
    timer = Timer(const Duration(seconds: 3), () async {
      pin = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(100, 100)),
          ImagePath.homeAltered);

      SharedPreference localDatabase = SharedPreference();
      await localDatabase.sharedPreference;
      Map<String, dynamic>? user = localDatabase.getUser();
      // final val = await FirebaseMessaging.instance.getToken();
      // log("TOKEN");
      // log(val ?? "");
      // print(val ?? "");
      if (user != null) {
        userFunction(user);
      } else {
        AppNavigation.navigateReplacementNamed(AppRouteName.ROLE_SELECTION);
      }
    });
    // setNotifications(context);
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void userFunction(Map<String, dynamic> user) {
    log("USER MODEL: ${json.encode(user)}");
    context
        .read<UserController>()
        .setUser(User.setUser2(user, token: user["bearer_token"]));
    log("Bearer Token:");
    log(context.read<UserController>().user?.token ?? "");
    Navigator.of(context).pushReplacementNamed(AppRouteName.HOME_SCREEN_ROUTE);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(ImagePath.splashImage),
      )),
      child: Image.asset(
        ImagePath.go,
        scale: 2,
      ),
    );
  }
}
