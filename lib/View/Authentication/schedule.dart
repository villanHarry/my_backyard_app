import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_checkbox.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/menu_model.dart';
import 'package:backyard/Model/user_model.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/Utils/utils.dart';
import 'package:backyard/main.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/View/base_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Schedule extends StatefulWidget {
  Schedule({this.edit = false, this.args});
  bool edit = false;
  Map<String, dynamic>? args;
  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  List<MenuModel> hours = [
    MenuModel(name: 'Mon', val: false),
    MenuModel(name: 'Tue', val: false),
    MenuModel(name: 'Wed', val: false),
    MenuModel(name: 'Thu', val: false),
    MenuModel(name: 'Fri', val: false),
    MenuModel(name: 'Sat', val: false),
    MenuModel(name: 'Sun', val: false),
  ];

  String openTime = 'Open Time';
  String closeTime = 'Close Time';

  @override
  Widget build(BuildContext context) {
    return BaseView(
        screenTitle: widget.edit ? 'Edit Opening Hours' : 'Opening Hours',
        bgImage: '',
        showAppBar: true,
        showBackButton: true,
        child: CustomPadding(
          horizontalPadding: 4.w,
          topPadding: 0,
          child: Consumer<UserController>(builder: (context, val, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                time(
                    t: openTime,
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      await Utils().selectTime(context, onTap: (v) {
                        openTime = v.format(context);
                        setState(() {});
                      });
                    }),
                SizedBox(
                  height: 2.h,
                ),
                time(
                    t: closeTime,
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      await Utils().selectTime(context, onTap: (v) {
                        closeTime = v.format(context);
                        setState(() {});
                      });
                    }),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: MyText(
                    title: 'Set Days',
                    fontWeight: FontWeight.w600,
                    size: 16,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Wrap(
                  children: List.generate(
                    hours.length,
                    (index) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CheckBoxWidget(
                          defaultVal: hours[index].val!,
                          onChange: (newValue) {
                            hours[index].val = newValue;
                            print(newValue);
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w) +
                                EdgeInsets.only(right: 1.w, top: 0.h),
                            child: MyText(
                                title: '${hours[index].name}',
                                clr: MyColors().black,
                                size: 12)),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                MyButton(
                    title: widget.edit ? 'Update' : 'Next',
                    onTap: () {
                      onSubmit(context);
                    }),
                SizedBox(
                  height: 3.h,
                ),
              ],
            );
          }),
        ));
  }

  onSubmit(context) {
    bool daySelected = false;
    for (var v in hours) {
      if (v.val == true) {
        daySelected = true;
      }
    }
    if (openTime == 'Open Time') {
      CustomToast().showToast(message: 'Opening time is required');
    } else if (closeTime == 'Close Time') {
      CustomToast().showToast(message: 'Closing time is required');
    } else if (!daySelected) {
      CustomToast().showToast(message: 'Please select one day at least');
    } else {
      if (widget.edit) {
        AppNavigation.navigatorPop();
        CustomToast()
            .showToast(message: 'Opening closing time updated successfully');
      } else {
        final controller = navigatorKey.currentContext?.read<UserController>();
        User? user = controller?.user;
        List<BussinessScheduling> days = [];
        for (int i = 0; i < hours.length; i++) {
          if (hours[i].val ?? false) {
            days.add(BussinessScheduling(
                day: daysOfWeek.values.elementAt(i).name,
                startTime: openTime,
                endTime: closeTime));
          }
        }
        user?.name = widget.args?["name"];
        user?.description = widget.args?["description"];
        user?.isPushNotify = widget.args?["isPushNotify"];
        user?.address = widget.args?["address"];
        user?.latitude = widget.args?["lat"];
        user?.longitude = widget.args?["lng"];
        user?.phone = widget.args?["phone"];
        user?.email = widget.args?["email"];
        user?.days = days;
        user?.profileImage = widget.args?["image"];

        controller?.setUser(user ?? User());

        AppNavigation.navigateTo(AppRouteName.CATEGORY_SCREEN_ROUTE);
      }
    }
  }

  time({required String t, required Function onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
            color: MyColors().lightGrey2,
            borderRadius: BorderRadius.circular(25)),
        child: MyText(
          title: t,
        ),
      ),
    );
  }
}
