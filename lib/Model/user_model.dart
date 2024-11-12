import 'package:backyard/Utils/enum.dart';

class User {
  int? id;
  Role? role;
  String? name;
  String? lastName;
  String? profileImage;
  String? address;
  double? latitude;
  double? longitude;
  String? email;
  String? token;
  String? emailOtp;
  String? emailVerifiedAt;
  String? phone;
  int? isProfileCompleted;
  int? isPushNotify;
  String? deviceType;
  String? deviceToken;
  String? socialType;
  String? socialToken;
  int? categoryId;
  String? description;
  int? isBlocked;
  String? status;
  int? subId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<BussinessScheduling>? days;

  User({
    this.id,
    this.role,
    this.name,
    this.lastName,
    this.profileImage,
    this.token,
    this.address,
    this.latitude,
    this.longitude,
    this.days,
    this.description,
    this.categoryId,
    this.email,
    this.emailOtp,
    this.emailVerifiedAt,
    this.phone,
    this.subId,
    this.isProfileCompleted,
    this.isPushNotify,
    this.deviceType,
    this.deviceToken,
    this.socialType,
    this.socialToken,
    this.isBlocked,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory User.setUser(Map<String, dynamic> json) => User(
        id: json["id"],
        role: getRole(json["role"]),
        name: json["name"],
        lastName: json["last_name"],
        categoryId: json["category_id"] == null
            ? null
            : int.parse(json["category_id"].toString()),
        description: json["description"],
        profileImage: json["profile_image"],
        address: json["address"],
        days: json["days"] == null
            ? []
            : sortingDays(List<BussinessScheduling>.from(
                json["days"].map((x) => BussinessScheduling.fromJson(x)))),
        latitude: json["latitude"] == null
            ? null
            : double.parse(json["latitude"]?.toString() ?? "0.0"),
        longitude: json["longitude"] == null
            ? null
            : double.parse(json["longitude"]?.toString() ?? "0.0"),
        email: json["email"],
        emailOtp: json["email_otp"],
        emailVerifiedAt: json["email_verified_at"],
        phone: json["phone"],
        isProfileCompleted: json["is_profile_completed"],
        isPushNotify: json["is_push_notify"],
        deviceType: json["device_type"],
        deviceToken: json["device_token"],
        socialType: json["social_type"],
        socialToken: json["social_token"],
        isBlocked: json["is_blocked"],
        status: json["status"],
        subId: json["sub_id"] == null
            ? null
            : int.parse(json["sub_id"].toString()),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  factory User.setUser2(Map<String, dynamic> json, {String? token}) => User(
        id: json["id"],
        role: getRole(json["role"]),
        token: token ?? json["bearer_token"],
        name: json["name"],
        lastName: json["last_name"],
        days: json["days"] == null
            ? []
            : sortingDays(List<BussinessScheduling>.from(
                json["days"].map((x) => BussinessScheduling.fromJson(x)))),
        profileImage: json["profile_image"],
        address: json["address"],
        latitude: json["latitude"] == null
            ? null
            : double.parse(json["latitude"]?.toString() ?? "0.0"),
        longitude: json["longitude"] == null
            ? null
            : double.parse(json["longitude"]?.toString() ?? "0.0"),
        email: json["email"],
        emailOtp: json["email_otp"],
        emailVerifiedAt: json["email_verified_at"],
        phone: json["phone"],
        isProfileCompleted: json["is_profile_completed"],
        isPushNotify: json["is_push_notify"],
        deviceType: json["device_type"],
        deviceToken: json["device_token"],
        socialType: json["social_type"],
        socialToken: json["social_token"],
        isBlocked: json["is_blocked"],
        status: json["status"],
        subId: json["sub_id"] == null
            ? null
            : int.parse(json["sub_id"].toString()),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  static Role? getRole(String? role) {
    for (var element in Role.values) {
      if (element.name.toLowerCase() == role?.toLowerCase()) {
        return element;
      }
    }
    return null;
  }

  static List<BussinessScheduling> sortingDays(List<BussinessScheduling> val) {
    final days = daysOfWeek.values.map((e) => e.name).toList();
    final list = val;

    for (var value in list) {
      days.remove(value.day);
    }

    if (days.isNotEmpty) {
      for (var day in days) {
        list.add(BussinessScheduling(day: day));
      }
    }

    return list;
  }

  set setRole(Role val) => role = val;
}

class BussinessScheduling {
  int? id;
  int? ownerId;
  String? day;
  String? startTime;
  String? endTime;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  BussinessScheduling(
      {this.id,
      this.ownerId,
      this.day,
      this.startTime,
      this.endTime,
      this.status,
      this.createdAt,
      this.updatedAt});

  factory BussinessScheduling.fromJson(Map<String, dynamic> json) =>
      BussinessScheduling(
        id: json["id"],
        ownerId: json["owner_id"],
        day: json["day"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}