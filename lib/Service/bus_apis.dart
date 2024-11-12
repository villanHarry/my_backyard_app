import 'dart:developer';

import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/offer_model.dart';
import 'package:backyard/Model/response_model.dart';
import 'package:backyard/Model/user_model.dart';
import 'package:backyard/Service/api.dart';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class BusAPIS {
  static Future<void> getBuses(double? lat, double? long) async {
    try {
      final controller = navigatorKey.currentContext?.read<UserController>();
      http.Response? res = await AppNetwork.networkRequest(
          requestTypes.GET.name,
          "${API.GET_BUSES_ENDPOINT}?lat=${lat ?? 0.0}&long=${long ?? 0.0}&radius=1",
          header: true);
      if (res != null) {
        final model = responseModelFromJson(res.body);

        if (model.status == 1) {
          List<User> users = [];
          users = List<User>.from(
              (model.data?["businesses"] ?? {}).map((x) => User.setUser(x)));
          for (var user in users) {
            controller?.addMarker(user);
          }
          // controller?.setCategories(List<CategoryModel>.from(
          //     (model.data ?? {}).map((x) => CategoryModel.fromJson(x))));
        } else {
          CustomToast().showToast(message: model.message ?? "");
        }
      }
    } catch (e) {
      log("GET BUSES ENDPOINT: ${e.toString()}");
    }
  }

  static Future<void> getOfferById(String busId) async {
    try {
      final controller = navigatorKey.currentContext?.read<HomeController>();
      http.Response? res = await AppNetwork.networkRequest(
          requestTypes.GET.name, "${API.GET_OFFERS_ENDPOINT}?bus_id=$busId",
          header: true);
      if (res != null) {
        final model = responseModelFromJson(res.body);

        if (model.status == 1) {
          controller?.setOffers(List<Offer>.from(
              (model.data?["offer"] ?? {}).map((x) => Offer.fromJson(x))));
        } else {
          CustomToast().showToast(message: model.message ?? "");
        }
      }
    } catch (e) {
      log("GET OFFERS ENDPOINT: ${e.toString()}");
    }
  }
}
