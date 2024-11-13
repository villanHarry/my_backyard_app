import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:backyard/Arguments/screen_arguments.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_height.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/menu_model.dart';
import 'package:backyard/Service/app_in_app_purchase.dart';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/auth_apis.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/View/Widget/Dialog/profile_complete_dialog.dart';
import 'package:backyard/main.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/base_view.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import '../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';

class SubscriptionScreen extends StatefulWidget {
  SubscriptionScreen({this.fromCompleteProfile = false});
  bool fromCompleteProfile = false;

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late final user = context.read<UserController>().user;
  StreamSubscription<List<PurchaseDetails>>? purchaseStream;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (user?.role == Role.Business) {
        await AppInAppPurchase().fetchSubscriptions([
          subscription_enums.bus_sub_monthly.name,
          subscription_enums.bus_sub_annually.name
        ]);
      } else {
        await AppInAppPurchase()
            .fetchSubscriptions([subscription_enums.user_sub.name]);
      }
    });
    purchaseStream = AppInAppPurchase().purchaseStream.listen((event) {
      AppInAppPurchase().handlePurchaseUpdates(event);
    });
    // TODO: implement initState
    super.initState();
  }

  String getPrice(String e, String price) {
    switch (e) {
      case "user_sub":
        return '$price Annually';
      case "bus_sub_monthly":
        return '$price Monthy';
      case "bus_sub_annually":
        return '$price Annually';
      default:
        return "";
    }
  }

  List<String> getPoints(String e) {
    switch (e) {
      case "user_sub":
        return [
          "Subscribers save money enjoying a whole year, making it a more economical for long-term users.",
          "Subscribers may benefit from additional perks such as:\n• Discounts on future subscriptions.\n• Access to special events and promotions.\n• Fostering a sense of community and appreciation."
        ];

      case "bus_sub_monthly":
        return [
          'Business Subscribers can enjoy access of the following:',
          'A month-to-month service to reach the local community.'
        ];
      case "bus_sub_annually":
        return [
          "Annual business subscribers receive 20% off versus month to month business users.",
          "Also exclusive access to the following:\n• New features.\n• Updates.\n• Improvements throughout the year.",
          "Ensuring they always have the latest tools and enhancements at their fingertips."
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        screenTitle: 'Choose your package',
        bgImage: '',
        showAppBar: true,
        showBackButton: true,
        // backgroundColor: Colors.white,
        child: Consumer<UserController>(
          builder: (context, value, child) {
            if (value.loading) {
              return Center(
                  child: CircularProgressIndicator(
                color: MyColors().greenColor,
              ));
            } else {
              return PageView.builder(
                  itemCount: value.productDetails.length,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics()),
                  itemBuilder: (_, index) => Column(
                        children: [
                          subscriptionTile(
                              value: value,
                              context: context,
                              m: value.productDetails[index]),
                        ],
                      ));
            }
          },
        ));
  }

  Widget subscriptionTile(
      {required BuildContext context,
      //required MenuModel m
      UserController? value,
      required ProductDetails m}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            blurRadius: 10, // Spread of the shadow
            spreadRadius: 5, // Size of the shadow
            offset: const Offset(0, 4), // Position of the shadow
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      // height: responsive.setHeight(75),
      width: 100.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: MyColors().primaryColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20))),
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
            // margin: EdgeInsets.symmetric(vertical: 1.w,horizontal: 1.w),
            child: Column(
              children: [
                MyText(
                  title: m.title,
                  clr: MyColors().whiteColor,
                  fontWeight: FontWeight.w600,
                  size: 18,
                ),
                MyText(
                  title: getPrice(m.id, m.price),
                  clr: MyColors().whiteColor,
                  fontWeight: FontWeight.w600,
                  size: 18,
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          for (int i = 0; i < getPoints(m.id).length; i++)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w) +
                  EdgeInsets.only(bottom: 2.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check,
                    color: MyColors().primaryColor,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                      child: MyText(
                    title: getPoints(m.id)[i],
                    size: 14,
                    clr: MyColors().black,
                  )),
                ],
              ),
            ),
          FutureBuilder(
              future: AppInAppPurchase().isSubscriptionActive(m.id),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.done
                    ? MyButton(
                        onTap: () async {
                          if (value?.purchaseLoading == false &&
                              (snapshot.data ?? false) == false) {
                            if (widget.fromCompleteProfile) {
                              // AppNavigation.navigateTo(AppRouteName.ADD_CARD_ROUTE,
                              //     arguments:
                              //         ScreenArguments(args: {"price": m.price}));
                              // CustomToast().showToast(
                              //     message: 'Subscription purchased successfully');
                              ///
                              ///
                              AppNetwork.loadingProgressIndicator();
                              final user = context.read<UserController>().user;
                              final result = await AuthAPIS.completeProfile(
                                firstName: user?.name,
                                lastName: user?.lastName,
                                description: user?.description,
                                address: user?.address,
                                lat: user?.latitude,
                                long: user?.longitude,
                                email: user?.email,
                                phone: user?.phone,
                                days: user?.days,
                                image: File(user?.profileImage ?? ""),
                              );
                              AppNavigation.navigatorPop();
                              if (result) {
                                completeDialog(onTap: () {
                                  AppNavigation.navigateToRemovingAll(
                                      AppRouteName.HOME_SCREEN_ROUTE);
                                });
                              }
                            } else {
                              AppInAppPurchase().buySubscription(m);
                              // AppNavigation.navigatorPop();
                            }
                          }

                          ///
                          ///
                        },
                        loading: value?.purchaseLoading,
                        title: (snapshot.data ?? false)
                            ? "Subscribed"
                            : "Continue",
                        width: 80.w,
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            color: MyColors().greenColor),
                      );
              }),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  completeDialog({required Function onTap}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                contentPadding: const EdgeInsets.all(0),
                insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
                content: ProfileCompleteDialog(
                  onYes: (v) {
                    onTap();
                  },
                ),
              ),
            ),
          );
        });
  }

  List<MenuModel> s =
      navigatorKey.currentContext?.read<UserController>().user?.role ==
              Role.User
          ? [
              MenuModel(
                  name: "All Access User", //'Standard Package',
                  subTitle: '\$ 1.99/ Annually',
                  price: 1.99,
                  points: [
                    "Subscribers save money enjoying a whole year, making it a more economical for long-term users.",
                    "Subscribers may benefit from additional perks such as:\n• Discounts on future subscriptions.\n• Access to special events and promotions.\n• Fostering a sense of community and appreciation."
                  ]),
            ]
          : [
              MenuModel(
                  name: "Business Access", //'Standard Package',
                  subTitle: '\$ 99.99/ Monthy',
                  price: 99.99,
                  points: [
                    'Business Subscribers can enjoy access of the following:',
                    'A month-to-month service to reach the local community.'
                  ]),
              MenuModel(
                  name: "Special Offer", //'Premium Package',
                  subTitle: '\$ 999.99/ Annually',
                  price: 999.99,
                  points: [
                    "Annual business subscribers receive 20% off versus month to month business users.",
                    "Also exclusive access to the following:\n• New features.\n• Updates.\n• Improvements throughout the year.",
                    "Ensuring they always have the latest tools and enhancements at their fingertips."
                  ]),
            ];
}

// "Subscribers save money compared to the monthly plan, enjoying a lower overall rate for committing to a year, making it a more economical choice for long-term users.",
// "Annual subscribers receive exclusive access to new features, updates, and improvements throughout the year, ensuring they always have the latest tools and enhancements at their fingertips.",
// "Subscribers may benefit from additional perks, such as loyalty bonuses, discounts on future subscriptions, or access to special events and promotions, fostering a sense of community and appreciation."
