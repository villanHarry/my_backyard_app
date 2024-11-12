import 'dart:io';
import 'dart:ui';
import 'package:backyard/Arguments/screen_arguments.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/app_size.dart';
import 'package:backyard/View/Widget/Dialog/custom_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_textfield.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/base_view.dart';
import 'package:share_plus/share_plus.dart';
import '../../Component/custom_bottomsheet_indicator.dart';
import '../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../../Utils/enum.dart';

class DiscountOffers extends StatefulWidget {
  @override
  State<DiscountOffers> createState() => _DiscountOffersState();
}

class _DiscountOffersState extends State<DiscountOffers> {
  late bool business =
      context.read<UserController>().user?.role == Role.Business;

  @override
  Widget build(BuildContext context) {
    return BaseView(
        screenTitle: 'Discount Offers',
        bgImage: '',
        showAppBar: true,
        showBackButton: true,
        trailingAppBar: business
            ? IconButton(
                onPressed: () {
                  editOffer(context);
                },
                icon: Icon(
                  Icons.more_horiz_rounded,
                  size: 35,
                  color: Colors.black,
                ))
            : Image.asset(
                ImagePath.favorite,
                color: MyColors().redColor,
                scale: 2,
              ),
        // backgroundColor: Colors.white,
        child: CustomPadding(
          horizontalPadding: 4.w,
          topPadding: 0,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.asset(
                      ImagePath.random4,
                      scale: 1,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(ImagePath.shadow, scale: 1, fit: BoxFit.cover),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: MyColors().black,
                              borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.all(16) +
                              EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MyText(
                                title: '\$50   ',
                                fontWeight: FontWeight.w600,
                                size: 16,
                                clr: MyColors().whiteColor,
                                cut: true,
                              ),
                              MyText(
                                  title: '\$40',
                                  fontWeight: FontWeight.w600,
                                  size: 16,
                                  clr: MyColors().whiteColor),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: MyColors().black,
                              borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.all(12) +
                              EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                ImagePath.coins,
                                scale: 2,
                              ),
                              MyText(
                                  title: '   +500',
                                  fontWeight: FontWeight.w600,
                                  size: 16,
                                  clr: MyColors().whiteColor),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    Expanded(
                        child: MyText(
                      title: 'Deal 01',
                      fontWeight: FontWeight.w600,
                      size: 16,
                    )),
                    Container(
                      decoration: BoxDecoration(
                          color: MyColors().primaryColor,
                          borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.all(16) +
                          EdgeInsets.symmetric(horizontal: 20),
                      child: MyText(
                        title: 'Food',
                        clr: MyColors().whiteColor,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                textDetail(
                    title: 'Offers Details:',
                    description:
                        'Classic checkerboard slip ons with office white under tone and reinforced waffle cup soles is a tone and reinforced waffle cup soles.CIassic ka checkerboard slip ons with office white hnan dunder tone and reinforced.'),
                textDetail(
                    title: 'Terms And Conditions ',
                    description:
                        'Tell your friends about MY BACKYARD Provider Club and register them on the app.'),
                textDetail(
                    title: 'Step 2:',
                    description:
                        'Complete all the steps of registration including payment for registration.'),
                textDetail(
                    title: 'Step 3:',
                    description:
                        'Go to the Manage Account Section in Settings page and enter your registered phone number and validate there.'),
                textDetail(
                    title: 'Step 4:',
                    description:
                        'Go to the Manage Account Section in Settings page and enter your registered phone number and validate there.'),
                SizedBox(
                  height: 2.h,
                ),
                MyButton(
                  title: business ? 'Download QR Code' : 'Scan Now',
                  onTap: () {
                    if (business) {
                      downloadDialog(context);
                    } else {
                      AppNavigation.navigateTo(AppRouteName.SCAN_QR_ROUTE,
                          arguments: ScreenArguments(fromOffer: true));
                    }
                  },
                  bgColor: MyColors().whiteColor,
                  textColor: MyColors().black,
                  borderColor: MyColors().black,
                ),
                SizedBox(
                  height: 2.h,
                ),
                MyButton(
                  title: 'Share with Friends',
                  onTap: () async {
                    Share.share(
                      'This is the text I want to share.',
                      subject: 'Shared Discount Offers',
                    );
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
        ));
  }

  textDetail({required String title, required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          title: title,
          fontWeight: FontWeight.w600,
          size: 14,
        ),
        SizedBox(
          height: 1.h,
        ),
        MyText(
          title: description,
          size: 13,
        ),
        SizedBox(
          height: 2.h,
        ),
      ],
    );
  }

  void editOffer(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        // backgroundColor: MyColors().whiteColor,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder:
              (BuildContext context, StateSetter s /*You can rename this!*/) {
            return Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                  color: MyColors().whiteColor,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSize.BOTTOMSHEETRADIUS))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BottomSheetIndicator(),
                  SizedBox(
                    height: 2.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      AppNavigation.navigatorPop();
                      AppNavigation.navigateTo(AppRouteName.CREATE_OFFER_ROUTE,
                          arguments: ScreenArguments(fromEdit: true));
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePath.editProfile,
                          scale: 2,
                          color: MyColors().primaryColor,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        MyText(
                          title: 'Edit Offer',
                          size: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      AppNavigation.navigatorPop();
                      deleteDialog(context);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePath.delete,
                          scale: 2,
                          color: MyColors().redColor,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        MyText(
                          title: 'Delete Offer',
                          size: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom,
                  )
                ],
              ),
            );
          });
        });
  }

  deleteDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(0),
              insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
              content: CustomDialog(
                title: 'Alert',
                image: ImagePath.like,
                description: 'Are you sure you want to delete this offer?',
                b1: 'Continue',
                onYes: (v) {
                  AppNavigation.navigatorPop();
                  CustomToast()
                      .showToast(message: 'Offer deleted successfully');
                },
              ),
            ),
          );
        });
  }

  downloadDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(0),
              insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
              content: CustomDialog(
                title: 'Download',
                image: ImagePath.download,
                description: 'Are you sure you want to download qr code?',
                b1: 'Continue',
                onYes: (v) {
                  AppNavigation.navigatorPop();
                  CustomToast()
                      .showToast(message: 'QR Code downloaded successfully');
                },
              ),
            ),
          );
        });
  }
}
