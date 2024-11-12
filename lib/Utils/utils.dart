import 'dart:convert';
import 'package:backyard/Service/auth_apis.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:jiffy/jiffy.dart';
import 'package:backyard/Model/notification_model.dart';
import 'package:backyard/Model/user_model.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:intl/intl.dart';
import 'package:backyard/Utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:backyard/main.dart';
import 'package:place_picker/place_picker.dart';
import 'local_shared_preferences.dart';

class Utils {
  static const String mDY = 'MM-dd-yyyy';
  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  static const googleApiKey = "AIzaSyBmaS0B0qwokES4a_CiFNVkVJGkimXkNsk";

  static Future<bool> requestLocationPermission(
      {bool openSettings = true}) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // CustomToast().showToast('Error', 'Location services are disabled. Please enable the services', true);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CustomToast().showToast(message: 'Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (openSettings) {
        await openAppSettings();
      }
      // CustomToast().showToast('Error', 'Location permissions are permanently denied, we cannot request permissions.', true);
      return false;
    }
    return true;
  }

  Future<Position?> pickLocation({bool openSettings = true}) async {
    if (await requestLocationPermission(openSettings: openSettings)) {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );
      return position;
    } else {
      return null; // Permission not granted
    }
  }

  Future<LocationResult> showPlacePicker(context) async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              AppStrings.GOOGLE_API_KEY,
            )));
    return result;
  }
  // saveFCMToken()async{
  //   var t = SharedPreference().getFcmToken();
  //   log("getFcmToken ${t}");
  //   if(t==null){
  //     log("getFcmToken k andar");
  //     SharedPreference().setFcmToken(token: await FirebaseMessagingService().getToken()??'');
  //   }
  // }

  selectDate(BuildContext context,
      {DateTime? firstDate,
      DateTime? lastDate,
      initialDate,
      String? format,
      bool formatted = true}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? selectedDate,
      firstDate: firstDate ?? DateTime(1800),
      lastDate: lastDate ?? DateTime.now(),
    );
    print(picked);
    if (picked != null) {
      selectedDate = picked;
      formattedDate = DateFormat(format ?? mDY).format(selectedDate);
      if (formatted) {
        return formattedDate;
      } else {
        return selectedDate;
      }
    } else {
      return null;
    }
  }

  static String relativeTime(String date) {
    DateTime d = DateTime.parse(date);
    return Jiffy.parse(d.toLocal().toString()).fromNow();
  }

  static Future<void> logout(
      {bool fromLogout = false, required BuildContext c}) async {
    if (fromLogout == true) {
      await AuthAPIS.signOut();
    }
    AppNavigation.navigateTo(AppRouteName.ROLE_SELECTION);
  }

  parseDate({
    required String d,
  }) {
    return DateFormat('MMM dd yyyy')
        .format(((DateTime.parse(d))).toUtc().toLocal());
  }

  selectTime(BuildContext context, {required Function(TimeOfDay) onTap}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context, //context of current state
    );
    if (pickedTime != null) {
      onTap(pickedTime);
      return pickedTime.format(context);
    }
    // else{
    //   print("Time is not selected");
    // }
  }

  convertTimeToMinutes({required int h, required int m}) {
    final duration = Duration(hours: h, minutes: m, seconds: 0);
    return duration.inMinutes;
  }

  // getUserChat(
  //     {required User? u1, required User? u2, required User currentUser}) {
  //   if (u1!.id != currentUser.id) {
  //     return u1;
  //   } else {
  //     return u2;
  //   }
  // }

  maskedNumber({required String phone}) {
    var maskFormatter = MaskTextInputFormatter(
        mask: '(###) ###-####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
    return maskFormatter.maskText(phone);
  }

  unMaskedNumber({required String phone}) {
    var maskFormatter = MaskTextInputFormatter(
        mask: '(###) ###-####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
    return maskFormatter.unmaskText(phone);
  }

  loadingOn() {
    EasyLoading.instance.userInteractions = false;
    EasyLoading.show(status: 'Please wait...', dismissOnTap: false);
  }

  loadingOff() {
    EasyLoading.dismiss();
  }

  DateTime convertToDateTime({String? formattedDateTime, required String d}) {
    return DateFormat(formattedDateTime ?? mDY).parse(d);
  }
}

extension StringExtension on String {
  String? capitalizeFirstLetter() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
