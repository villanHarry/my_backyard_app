import 'dart:ui';

import 'package:backyard/Arguments/screen_arguments.dart';
import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Model/menu_model.dart';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/auth_apis.dart';
import 'package:backyard/View/Authentication/change_password.dart';
import 'package:backyard/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_card.dart';
import 'package:backyard/Component/custom_switch.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Component/custom_toggle_bar.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/View/Common/Settings/payment_settings.dart';
import 'package:flutter/material.dart';
import 'package:backyard/View/Widget/Dialog/delete_account.dart';
import 'package:provider/provider.dart';
import '../../../../../Utils/my_colors.dart';
import '../../../../../Utils/responsive.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../../Arguments/content_argument.dart';
import '../../../Utils/app_strings.dart';
import '../../../Utils/enum.dart';
import '../../../Utils/utils.dart';
import '../../base_view.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool val = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  bool get getBusinesses =>
      (navigatorKey.currentContext?.read<UserController>().isSwitch ?? false)
          ? false
          : navigatorKey.currentContext?.read<UserController>().user?.role ==
              Role.Business;

  @override
  Widget build(Build) {
    return BaseView(
      bgImage: '',
      child: CustomPadding(
          topPadding: 2.h,
          horizontalPadding: 3.w,
          child: Column(
            children: [
              CustomAppBar(
                screenTitle: "Settings",
                leading: getBusinesses ? MenuIcon() : BackButton(),
                trailing: getBusinesses ? NotificationIcon() : null,
                bottom: 2.h,
              ),
              Consumer<UserController>(builder: (context, val, _) {
                return (val.user?.role == Role.Business)
                    ? Padding(
                        padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyColors().whiteColor,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.2),
                                blurRadius: 10.0,
                                offset: const Offset(0, 5),
                                spreadRadius: 2.0, //extend the shadow
                              )
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.sp, vertical: 15.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const MyText(
                                  title: "Switch User",
                                  fontWeight: FontWeight.w500,
                                  size: 15),
                              CustomSwitch(
                                switchValue: val.isSwitch,
                                toggleColor: MyColors().primaryColor,
                                inActiveColor:
                                    MyColors().greyColor3.withOpacity(.2),
                                onChange: (v) {},
                                onChange2: (v) {
                                  val.setSwitch(v);
                                  // AppNavigation.navigateToRemovingAll(
                                  //     AppRouteName.HOME_SCREEN_ROUTE);
                                  Navigator.popUntil(
                                      navigatorKey.currentContext!,
                                      (route) => route.isFirst);
                                  Navigator.pushReplacementNamed(
                                      navigatorKey.currentContext!,
                                      AppRouteName.HOME_SCREEN_ROUTE);
                                },
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              }),
              showBarberList(l: business ? businessList : userList),
            ],
          )),
    );
  }

  late bool business =
      context.read<UserController>().user?.role == Role.Business;

  getData() {
    if (context.read<UserController>().user?.isPushNotify == 1) {
      val = true;
    }
  }

  List<MenuModel> businessList = [
    MenuModel(name: 'Push Notification', onTap: () {}),
    MenuModel(
        name: 'Privacy Policy',
        onTap: () {
          AppNavigation.navigateTo(AppRouteName.CONTENT_SCREEN,
              arguments: ContentRoutingArgument(
                  title: 'Privacy Policy',
                  contentType: AppStrings.PRIVACY_POLICY_TYPE,
                  url: 'https://www.google.com/'));
        }),
    MenuModel(
        name: 'About App',
        onTap: () {
          AppNavigation.navigateTo(AppRouteName.CONTENT_SCREEN,
              arguments: ContentRoutingArgument(
                  title: 'About App',
                  contentType: AppStrings.ABOUT_APP_TYPE,
                  url: 'https://www.google.com/'));
        }),
    MenuModel(
        name: 'Terms & Conditions',
        onTap: () {
          AppNavigation.navigateTo(AppRouteName.CONTENT_SCREEN,
              arguments: ContentRoutingArgument(
                  title: 'Terms & Conditions',
                  contentType: AppStrings.TERMS_AND_CONDITION_TYPE,
                  url: 'https://www.google.com/'));
        }),
    MenuModel(
        name: 'Delete Account',
        onTap: () {
          showDialog(
              context: navigatorKey.currentContext!,
              barrierDismissible: false,
              builder: (Build) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: AlertDialog(
                    backgroundColor: Colors.transparent,
                    contentPadding: const EdgeInsets.all(0),
                    insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
                    content: DeleteDialog(
                      title: 'Delete Account',
                      subTitle: 'Do you want to delete your account?',
                      onYes: () async {
                        AppNetwork.loadingProgressIndicator();
                        await AuthAPIS.deleteAccount();
                        AppNavigation.navigatorPop();
                      },
                    ),
                  ),
                );
              });
        }),
    MenuModel(
        name: 'Change Password',
        onTap: () {
          AppNavigation.navigateTo(AppRouteName.CHANGE_PASSWORD_ROUTE,
              arguments: const ChangePasswordArguments(fromSettings: true));
        }),
    MenuModel(
        name: 'Subscriptions',
        onTap: () {
          AppNavigation.navigateTo(AppRouteName.SUBSCRIPTION_SCREEN_ROUTE);
        })
  ];
  late List<MenuModel> userList = [
    MenuModel(
        name: 'Push Notification',
        onTap: () async {
          val = !val;
        }),
    MenuModel(
        name: 'Privacy Policy',
        onTap: () {
          AppNavigation.navigateTo(AppRouteName.CONTENT_SCREEN,
              arguments: ContentRoutingArgument(
                  title: 'Privacy Policy',
                  contentType: AppStrings.PRIVACY_POLICY_TYPE,
                  url: 'https://www.google.com/'));
        }),
    MenuModel(
        name: 'About App',
        onTap: () {
          AppNavigation.navigateTo(AppRouteName.CONTENT_SCREEN,
              arguments: ContentRoutingArgument(
                  title: 'About App',
                  contentType: AppStrings.ABOUT_APP_TYPE,
                  url: 'https://www.google.com/'));
        }),
    MenuModel(
        name: 'Terms & Conditions',
        onTap: () {
          AppNavigation.navigateTo(AppRouteName.CONTENT_SCREEN,
              arguments: ContentRoutingArgument(
                  title: 'Terms & Conditions',
                  contentType: AppStrings.TERMS_AND_CONDITION_TYPE,
                  url: 'https://www.google.com/'));
        }),
    // MenuModel(
    //     name: 'Payment Details',
    //     onTap: () {
    //       AppNavigation.navigateTo(AppRouteName.PAYMENT_METHOD_ROUTE,
    //           arguments: ScreenArguments(fromSettings: true));
    //     }),
    MenuModel(
        name: 'Delete Account',
        onTap: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (Build) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: AlertDialog(
                    backgroundColor: Colors.transparent,
                    contentPadding: const EdgeInsets.all(0),
                    insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
                    content: DeleteDialog(
                      title: 'Delete Account',
                      subTitle: 'Do you want to delete your account?',
                      onYes: () async {
                        AppNetwork.loadingProgressIndicator();
                        await AuthAPIS.deleteAccount();
                        AppNavigation.navigatorPop();
                      },
                    ),
                  ),
                );
              });
        }),
    MenuModel(
        name: 'Change Password',
        onTap: () {
          AppNavigation.navigateTo(AppRouteName.CHANGE_PASSWORD_ROUTE,
              arguments: const ChangePasswordArguments(fromSettings: true));
        }),
    MenuModel(
        name: 'Subscriptions',
        onTap: () {
          AppNavigation.navigateTo(AppRouteName.SUBSCRIPTION_SCREEN_ROUTE);
        })
  ];
  showBarberList({required List<MenuModel> l}) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 11, left: 10.sp, right: 10.sp),
      itemCount: l.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              l[index].onTap?.call();
            },
            child: Container(
              decoration:
                  // index==0?
                  BoxDecoration(
                color: MyColors().whiteColor,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.2),
                    blurRadius: 10.0,
                    offset: const Offset(0, 5),
                    spreadRadius: 2.0, //extend the shadow
                  )
                ],
              )
              // : BoxDecoration(
              //   borderRadius: BorderRadius.circular(100),
              //   gradient: LinearGradient(colors: [
              //     MyColors().primaryColor,
              //     MyColors().primaryColor2 ], begin: Alignment.centerLeft, end: Alignment.centerRight)
              // )
              ,
              padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
              margin: EdgeInsets.only(bottom: 1.5.h),
              // padding: EdgeInsets.all(2.w)+EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    title: l[index].name!,
                    fontWeight: FontWeight.w500,
                    size: 15,
                    // clr: index == 0 ? null : Colors.white,
                  ),
                  if (index == 0)
                    // CupertinoSwitch(
                    //   value: val,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       val = value;
                    //     });
                    //   },
                    // ),
                    CustomSwitch(
                      switchValue: val,
                      toggleColor: MyColors().primaryColor,
                      inActiveColor: MyColors().greyColor3.withOpacity(.2),
                      onChange: (v) {},
                      onChange2: (v) async {
                        val = !val;
                        setState(() {});
                        // await AuthController.i.onOffNotifications(,
                        //     onSuccess: () {}, on: val);
                      },
                    )
                  else
                    Icon(
                      Icons.keyboard_arrow_right,
                      // color: Colors.white,
                    )
                ],
              ),
            ));
      },
    );
  }
}
