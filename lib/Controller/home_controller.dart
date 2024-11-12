import 'package:backyard/Model/category_model.dart';
import 'package:backyard/Model/offer_model.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Model/card_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class HomeController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  int currentIndex = 0;
  LatLng currentLocation = const LatLng(40.76317565846268, -73.99172240955043);

  String adminID = '';

  bool loading = true;

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  List<Offer>? _offers;
  List<Offer>? get offers => _offers;

  void setOffers(List<Offer>? val) {
    _offers = val;
    notifyListeners();
  }

  List<CategoryModel>? _categories;
  List<CategoryModel>? get categories => _categories;

  void setCategories(List<CategoryModel>? model) {
    _categories = model;
    notifyListeners();
  }

  ///Card
  List<CardModel>? cards;

  PersistentTabController homeBottom = PersistentTabController(initialIndex: 0);

  void setIndex(int i) {
    currentIndex = i;
    notifyListeners();
  }

  jumpTo({required int i}) {
    currentIndex = i;
    homeBottom.jumpToTab(i);

    notifyListeners();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  /// Chats end
}
