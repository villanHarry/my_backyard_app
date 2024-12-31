import 'dart:developer';
import 'dart:io';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/response_model.dart';
import 'package:backyard/Model/user_model.dart';
import 'package:backyard/Service/api.dart';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/Utils/local_shared_preferences.dart';
import 'package:backyard/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AuthAPIS {
  static Future<bool> signIn(
      {required String email, required String password}) async {
    try {
      // final devicetoken = await FirebaseMessaging.instance.getToken();
      // final type =
      //     navigatorKey.currentContext?.read<UserController>().user?.role;
      http.Response? res = await AppNetwork.networkRequest(
          requestTypes.POST.name, API.SIGN_IN_ENDPOINT,
          parameters: {
            'email': email,
            'password': password,
            // "role": type?.name ?? "",
            "devicetoken": "fjhgjhgjh", //devicetoken ?? "",
            "devicetype": Platform.isAndroid ? "android" : "ios",
          });
      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status == 1) {
          navigatorKey.currentContext
              ?.read<UserController>()
              .setUser(User.setUser2(model.data?["user"]));
          if (model.data?["user"]["is_profile_completed"] == 1 &&
              model.data?["user"]["is_verified"] == 1) {
            SharedPreference localDatabase = SharedPreference();
            await localDatabase.sharedPreference;
            localDatabase.clear();
            localDatabase.setUser(user: model.data?["user"]);
          }
          return true;
        } else {
          CustomToast().showToast(message: model.message ?? "");
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> signInWithId({required String id}) async {
    try {
      http.Response? res = await AppNetwork.networkRequest(
        requestTypes.GET.name,
        "${API.SIGN_IN_WITH_ID_ENDPOINT}?user_id=$id",
      );
      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status == 1) {
          navigatorKey.currentContext
              ?.read<UserController>()
              .setUser(User.setUser2(model.data?["user"]));
          if (model.data?["user"]["is_profile_completed"] == 1 &&
              model.data?["user"]["is_verified"] == 1) {
            SharedPreference localDatabase = SharedPreference();
            await localDatabase.sharedPreference;
            localDatabase.clear();
            localDatabase.setUser(user: model.data?["user"]);
          }
          return true;
        } else {
          CustomToast().showToast(message: model.message ?? "");
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> forgotPassword({required String email}) async {
    try {
      http.Response? res = await AppNetwork.networkRequest(
          requestTypes.POST.name, API.FORGOT_PASSWORD_ENDPOINT,
          parameters: {'email': email});
      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status == 1) {
          navigatorKey.currentContext
              ?.read<UserController>()
              .setUser(User.setUser(model.data?["user"]));
          return true;
        } else {
          CustomToast().showToast(message: model.message ?? "");
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> changePassword(
      {required int id, required String password}) async {
    try {
      http.Response? res = await AppNetwork.networkRequest(
          requestTypes.POST.name, API.CHANGE_PASSWORD_ENDPOINT,
          parameters: {'id': id.toString(), 'password': password});
      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status == 1) {
          navigatorKey.currentContext
              ?.read<UserController>()
              .setUser(User.setUser(model.data?["user"]));
          return true;
        } else {
          CustomToast().showToast(message: model.message ?? "");
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> verifyAccount(
      {required String otpCode, required int id}) async {
    try {
      // final devicetoken = await FirebaseMessaging.instance.getToken();
      http.Response? res = await AppNetwork.networkRequest(
          requestTypes.POST.name, API.VERIFY_ACCOUNT_ENDPOINT,
          parameters: {
            "otp": otpCode,
            "user_id": id.toString(),
            "devicetoken": "fjhgjhgjh", //devicetoken ?? "",
            "devicetype": Platform.isAndroid ? "android" : "ios",
          });
      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status == 1) {
          navigatorKey.currentContext
              ?.read<UserController>()
              .setUser(User.setUser2(model.data?["user"]));
          if (model.data?["user"]["is_profile_completed"] == 1) {
            SharedPreference localDatabase = SharedPreference();
            await localDatabase.sharedPreference;
            localDatabase.clear();
            localDatabase.setUser(user: model.data?["user"]);
          }
          return true;
        } else {
          CustomToast().showToast(message: model.message ?? "");
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> completeProfile(
      {String? firstName,
      String? isPushNotify,
      String? lastName,
      String? address,
      String? email,
      String? phone,
      String? description,
      String? subId,
      double? lat,
      double? long,
      String? role,
      int? categoryId,
      List<BussinessScheduling>? days,
      File? image}) async {
    try {
      Map<String, String> parameters = {};
      List<http.MultipartFile> attachments = [];
      if (role != null) {
        parameters.addAll({'role': role});
      }
      if (firstName != null) {
        parameters.addAll({'name': firstName});
      }
      if (lastName != null) {
        parameters.addAll({'last_name': lastName});
      }
      if (subId != null) {
        parameters.addAll({'sub_id': subId});
      }
      if (categoryId != null) {
        parameters.addAll({'category_id': categoryId.toString()});
      }
      if (days != null) {
        final formatter = NumberFormat('00');
        for (int i = 0; i < days.length; i++) {
          if (days[i].startTime != null) {
            parameters.addAll({
              'days[$i][day]': days[i].day ?? "",
              'days[$i][start_time]':
                  '${formatter.format(_get24hour(days[i].startTime ?? "").hour)}:${formatter.format(_get24hour(days[i].startTime ?? "").minute)}',
              'days[$i][end_time]':
                  '${formatter.format(_get24hour(days[i].endTime ?? "").hour)}:${formatter.format(_get24hour(days[i].endTime ?? "").minute)}'
            });
          }
        }
      }
      if (email != null) {
        parameters.addAll({'email': email});
      }
      if (phone != null) {
        parameters.addAll({'phone': phone});
      }
      if (isPushNotify != null) {
        parameters.addAll({'is_push_notify': isPushNotify});
      }
      if (address != null) {
        parameters.addAll({'address': address});
      }
      if (description != null) {
        parameters.addAll({'description': description});
      }
      if (lat != null) {
        parameters.addAll({
          'latitude': lat.toString(),
        });
      }
      if (long != null) {
        parameters.addAll({
          'longitude': long.toString(),
        });
      }

      if (image != null) {
        attachments.add(
            await http.MultipartFile.fromPath('profile_image', image.path));
      }
      http.Response? res = await AppNetwork.networkRequest(
          requestTypes.POST.name, API.COMPLETE_PROFILE_ENDPOINT,
          parameters: parameters, attachments: attachments, header: true);
      if (res != null) {
        final model = responseModelFromJson(res.body);
        CustomToast().showToast(message: model.message ?? "");
        if (model.status == 1) {
          navigatorKey.currentContext
              ?.read<UserController>()
              .setUser(User.setUser(model.data?["user"]), isNotToken: true);
          SharedPreference localDatabase = SharedPreference();
          await localDatabase.sharedPreference;
          localDatabase.clear();
          localDatabase.setUser(
            user: model.data?["user"],
            token:
                navigatorKey.currentContext?.read<UserController>().user?.token,
          );
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static TimeOfDay _get24hour(String val) {
    int hour = int.parse(val.split(":").first);
    int minute = int.parse(val.split(":").last.split(" ").first);

    return TimeOfDay(hour: hour, minute: minute);
  }

  static Future<bool> resendCode({String? id}) async {
    try {
      http.Response? res = await AppNetwork.networkRequest(
          requestTypes.POST.name, API.RESEND_OTP_ENDPOINT,
          parameters: {"user_id": id ?? ""});
      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status == 1) {
          return true;
        } else {
          CustomToast().showToast(message: model.message ?? "");
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<void> signOut() async {
    try {
      AppNetwork.loadingProgressIndicator();
      http.Response? res = await AppNetwork.networkRequest(
          requestTypes.POST.name, API.SIGN_OUT_ENDPOINT,
          header: true);
      AppNavigation.navigatorPop();
      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status == 1) {
          navigatorKey.currentContext?.read<UserController>().clear();
          AppNavigation.navigateToRemovingAll(AppRouteName.SPLASH_SCREEN_ROUTE);
          CustomToast().showToast(message: "Logout Successfully");
        } else {
          CustomToast().showToast(message: model.message ?? "");
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<bool> socialLogin(
      {String? socialToken,
      String? socialType,
      String? name,
      String? email,
      String? phone}) async {
    try {
      // final devicetoken = await FirebaseMessaging.instance.getToken();
      String? firstName;
      String? lastName;
      if (name != null && (name).contains(" ")) {
        firstName = (name).split(" ").first;
        lastName = (name).split(" ").last;
      } else {
        firstName = (name ?? "");
        lastName = (name ?? "");
      }
      http.Response? res = await AppNetwork.networkRequest(
          requestTypes.POST.name, API.SOCIAL_LOGIN_ENDPOINT,
          parameters: {
            "first_name": firstName,
            "last_name": lastName,
            "social_token": socialToken ?? "",
            "social_type": socialType ?? "",
            "device_type": Platform.isAndroid ? "android" : "ios",
            "device_token": "fjhgjhgjh", //devicetoken ?? "",
            "role": navigatorKey.currentContext
                    ?.read<UserController>()
                    .user
                    ?.role
                    ?.name ??
                "",
            'phone': phone ?? ""
          });
      if (res != null) {
        final model = responseModelFromJson(res.body);
        CustomToast().showToast(message: model.message ?? "");
        if (model.status == 1) {
          navigatorKey.currentContext?.read<UserController>().setUser(
              User.setUser2(model.data?["user"],
                  token: model.data?["bearer_token"]));
          if (socialType == "phone") {
            final user =
                navigatorKey.currentContext?.read<UserController>().user;
            user?.phone = phone;
            navigatorKey.currentContext?.read<UserController>().setUser(user!);
          }
          if (model.data?["user"]["is_profile_completed"] == 1) {
            if ((model.data["isDeleted"] ?? 0) == 0) {
              SharedPreference localDatabase = SharedPreference();
              await localDatabase.sharedPreference;
              localDatabase.clear();
              localDatabase.setUser(user: model.data?["user"]);
            }
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<void> deleteAccount() async {
    try {
      AppNetwork.loadingProgressIndicator();
      http.Response? res = await AppNetwork.networkRequest(
          requestTypes.POST.name, API.DELETE_ACCOUNT_ENDPOINT,
          header: true);
      AppNavigation.navigatorPop();
      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status == 1) {
          navigatorKey.currentContext?.read<UserController>().clear();
          AppNavigation.navigateToRemovingAll(AppRouteName.SPLASH_SCREEN_ROUTE);
          CustomToast().showToast(message: "Account Deleted Successfully");
        } else {
          CustomToast().showToast(message: model.message ?? "");
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
