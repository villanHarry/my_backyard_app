import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:backyard/Utils/my_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image/image.dart' as img;
import 'package:backyard/Service/auth_apis.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:intl/intl.dart';
import 'package:backyard/Utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:backyard/main.dart';
import 'package:place_picker/place_picker.dart';
import 'package:encrypt/encrypt.dart' as en;

class Utils {
  static final key = en.Key.fromUtf8('3Df7G9uWq8s2BxM4Tz1pV5cK7nL0yQ6h');
  static final iv = en.IV.fromLength(16);
  static String getDuration(DateTime? val) {
    final duration = DateTime.now().difference(val ?? DateTime.now());
    int min = duration.inMinutes;
    int hour = duration.inHours;
    int days = duration.inDays;
    int month = days ~/ 30;
    int year = days ~/ 365;
    if (min.isNegative) {
      min = min * -1;
    }
    if (hour.isNegative) {
      hour = hour * -1;
    }
    if (days.isNegative) {
      days = days * -1;
    }
    if (month.isNegative) {
      month = month * -1;
    }
    if (year.isNegative) {
      year = year * -1;
    }

    if (min < 60) {
      return "$min Mins Ago";
    }
    if (hour < 60) {
      return "$hour Hrs Ago";
    }
    if (days < 30) {
      return "$days Days Ago";
    }
    if (month < 12) {
      return "$days Days Ago";
    }

    return "$year Years Ago";
  }

  static String checkClosed(String? startTime, String? endTime) {
    if (startTime != null && endTime != null) {
      return "${timeFormat(startTime)} - ${timeFormat(endTime)}";
    } else {
      return "Closed";
    }
  }

  static String timeFormat(String val) {
    int hour = int.parse(val.split(":")[0]);
    int min = int.parse(val.split(":")[1]);
    return TimeOfDay(hour: hour, minute: min)
        .format(navigatorKey.currentContext!);
  }

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

  static Future<ByteData> getCircularImageByteData(ui.Image image) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(
        pictureRecorder,
        Rect.fromPoints(const Offset(0, 0),
            Offset(image.width.toDouble(), image.height.toDouble())));

    // Draw the image inside a circular clip
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = MyColors().primaryColor
      ..strokeWidth = 15.0;

    final radius = image.width / 2;

    // Clip the canvas to a circular shape
    canvas.clipPath(Path()
      ..addOval(Rect.fromCircle(
          center: Offset(image.width / 2, image.height / 2), radius: radius)));

    // Draw the image inside the circular path
    canvas.drawImage(image, const Offset(0, 0), paint);

    // Draw the stroke (circle border) around the clipped area
    canvas.drawCircle(Offset(image.width / 2, image.height / 2), radius, paint);

    // Convert the canvas to an image and then to ByteData
    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(image.width, image.height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!;
  }

  static Future<Uint8List?> loadNetWorkImage(String path) async {
    final completer = Completer<ImageInfo>();
    var image = CachedNetworkImageProvider(path);

    image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completer.complete(info)));
    final imageInfo = await completer.future;
    final byteData =
        await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }

  static Future<BitmapDescriptor> getNetworkImageMarker3() async {
    const size = 50.0; // Size of the circle
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder,
        Rect.fromPoints(const Offset(0, 0), const Offset(size, size)));

    final paint = Paint()
      ..color = MyColors().primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());

    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(pngBytes);
  }

  static Future<BitmapDescriptor> getNetworkImageMarker2(
      String imageUrl) async {
    Uint8List? image = await loadNetWorkImage(imageUrl);
    final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
        image!.buffer.asUint8List(),
        targetHeight: 100,
        targetWidth: 100);
    final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final byteData = await getCircularImageByteData(frameInfo.image);
    // await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImageMarker = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedImageMarker);
  }

  static Future<BitmapDescriptor> getNetworkImageMarker(String imageUrl) async {
    int size = .18.sw.toInt();
    final response = await HttpClient().getUrl(Uri.parse(imageUrl));
    final bytes = await response.close().then((response) =>
        response.fold<Uint8List>(Uint8List(0),
            (previous, current) => Uint8List.fromList(previous + current)));
    // Decode the image from bytes
    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize the image
    img.Image resizedImage = img.copyResize(image, width: size, height: size);

    // Create a circular mask (cutting out the circle)
    img.Image circularImage = img.Image(
        width: size, height: size, backgroundColor: img.ColorRgba8(0, 0, 0, 0));

    // Draw a circle mask over the image
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        int dx = x - size ~/ 2;
        int dy = y - size ~/ 2;
        // Check if the pixel lies within a circle (distance from the center)
        if (dx * dx + dy * dy <= (size / 2) * (size / 2)) {
          circularImage.setPixel(x, y, resizedImage.getPixel(x, y));
        } else {
          // // Set transparent color for outside circle
          // circularImage.setPixel(
          //     x, y, img.ColorRgba8(0, 0, 0, 0)); // Transparent
        }
      }
    }

    // Convert the image back to bytes
    Uint8List circleBytes = Uint8List.fromList(img.encodePng(circularImage));

    // Return the BitmapDescriptor created from the circular image
    return BitmapDescriptor.fromBytes(circleBytes);
  }

  Future<LocationResult> showPlacePicker(context) async {
    // Permission.locationAlways.request();
    if (Platform.isAndroid) {
      Permission.location.request();
    } else {
      Permission.locationAlways.request();
    }
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(AppStrings.GOOGLE_API_KEY)));
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
