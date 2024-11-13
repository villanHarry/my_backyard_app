import 'dart:async';
import 'dart:developer';

import 'package:backyard/Arguments/profile_screen_arguments.dart';
import 'package:backyard/Model/user_model.dart';
import 'package:backyard/Service/bus_apis.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/Utils/local_shared_preferences.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/main.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart' as in_app;

class UserController extends ChangeNotifier {
  UserController({required this.context}) {
    locationStream = Geolocator.getPositionStream(
            locationSettings:
                const LocationSettings(timeLimit: Duration(minutes: 30)))
        .listen((event) async {
      if ((geo ?? false) && (_user?.token != null)) {
        if (onTap) {
          _user?.latitude = event.latitude;
          _user?.longitude = event.longitude;
          List<Placemark> placemarks =
              await placemarkFromCoordinates(event.latitude, event.longitude);
          _user?.address = placemarks[0].locality ?? "";
          if (mapController != null) {
            await BusAPIS.getBuses(event.latitude, event.longitude);
            mapController?.moveCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(event.latitude, event.longitude),
                    zoom: 13.4746)));
            circles.add(Circle(
                circleId: const CircleId("myLocation"),
                radius: 1 * 1609.344,
                strokeWidth: 1,
                zIndex: 0,
                center: LatLng(event.latitude, event.longitude),
                fillColor: MyColors().primaryColor.withOpacity(.15),
                strokeColor: MyColors().primaryColor));
            notifyListeners();
            onTap = false;
            Timer(const Duration(minutes: 10), () {
              onTap = true;
            });
          }
        }
      }
    });
  }

  late StreamSubscription<Position>? locationStream;
  bool onTap = true;
  GoogleMapController? mapController;
  BuildContext context;
  User? _user;
  User? get user => _user;
  bool? geo = true;
  Set<Circle> circles = {};
  Set<Marker> markers = {};
  List<in_app.ProductDetails> productDetails = [];
  bool loading = false;

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  void setProductDetails(List<in_app.ProductDetails> val) {
    print("Subscriptions Fetched");
    productDetails = val;
    notifyListeners();
  }

  void setController(GoogleMapController? controller) {
    mapController = controller;
    notifyListeners();
  }

  void addMarker(User user) {
    MarkerId markerId = MarkerId(user.id?.toString() ?? "");
    Marker marker = Marker(
      onTap: () => AppNavigation.navigateTo(AppRouteName.USER_PROFILE_ROUTE,
          arguments:
              ProfileScreenArguments(isMe: false, isUser: false, user: user)),
      markerId: markerId,
      icon: pin,
      position: LatLng(user.latitude ?? 0.0, user.longitude ?? 0.0),
    );
    markers.add(marker);
    // markers.refresh();
    notifyListeners();
  }

  void setGeo(bool val) {
    geo = val;
    notifyListeners();
  }

  void setCategory(int? id) {
    _user?.categoryId = id;
    notifyListeners();
  }

  void setUser(User user, {bool isNotToken = false}) {
    String? token;
    if (isNotToken) {
      token = _user?.token;
      _user = user;
      _user?.token = token;
    } else {
      _user = user;
    }

    notifyListeners();
  }

  void updateDays(List<BussinessScheduling> days) {
    _user?.days = days;
    notifyListeners();
  }

  void setRole(Role val) {
    if (_user == null) {
      _user = User(role: val);
    } else {
      _user?.setRole = val;
    }
    notifyListeners();
  }

  Future<void> clear() async {
    SharedPreference ld = SharedPreference();
    await ld.sharedPreference;
    ld.clear();
    _user = null;
  }
}
