import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:backyard/Arguments/content_argument.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/menu_model.dart';
import 'package:backyard/Service/app_in_app_purchase.dart';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/auth_apis.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/app_strings.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/View/Widget/Dialog/profile_complete_dialog.dart';
import 'package:backyard/main.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/base_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
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
  final CarouselController _controller = CarouselController();
  int index = 0;
  String subscribed = "";
  final pageController = PageController();

  String getId(int id) {
    switch (id) {
      case 1:
        return "user_sub";
      case 2:
        return "bus_sub_monthly";
      case 3:
        return "bus_sub_annually";

      default:
        return "";
    }
  }

  int? getId2(String id) {
    switch (id) {
      case "user_sub":
        return 1;
      case "bus_sub_monthly":
        return 2;
      case "bus_sub_annually":
        return 3;

      default:
        return null;
    }
  }

  @override
  void initState() {
    if (!widget.fromCompleteProfile) {
      subscribed = getId(
          navigatorKey.currentContext?.read<UserController>().user?.subId ?? 0);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (user?.role == Role.Business) {
        await AppInAppPurchase().fetchSubscriptions([
          subscription_enums.bus_sub_annually.name,
          subscription_enums.bus_sub_monthly.name
        ]);
      } else {
        await AppInAppPurchase()
            .fetchSubscriptions([subscription_enums.user_sub.name]);
      }
    });
    purchaseStream = AppInAppPurchase().purchaseStream.listen((events) async {
      AppInAppPurchase().handlePurchaseUpdates(events);
      for (var event in events) {
        if (event.status == PurchaseStatus.purchased) {
          // if (user?.role == Role.Business) {
          // if (widget.fromCompleteProfile) {
          //   AppNetwork.loadingProgressIndicator();
          //   final result = await AuthAPIS.completeProfile(
          //     firstName: user?.name,
          //     lastName: user?.lastName,
          //     description: user?.description,
          //     address: user?.address,
          //     lat: user?.latitude,
          //     long: user?.longitude,
          //     email: user?.email,
          //     role: Role.Business.name,
          //     // phone: user?.phone,
          //     days: user?.days,
          //     subId: getId2(event.productID)?.toString(),
          //     image: File(user?.profileImage ?? ""),
          //   );
          //   AppNavigation.navigatorPop();
          //   if (result) {
          //     completeDialog(onTap: () {
          //       AppNavigation.navigateToRemovingAll(
          //           AppRouteName.HOME_SCREEN_ROUTE);
          //     });
          //   }
          // } else {
          // AppNetwork.loadingProgressIndicator();
          // final result = await AuthAPIS.completeProfile(
          //     days: user?.days, subId: getId2(event.productID)?.toString());
          // AppNavigation.navigatorPop();
          // if (result) {
          //   setState(() {
          //     subscribed = event.productID;
          //   });
          //   AppNavigation.navigatorPop();
          // }
          // }
          // } else {
          AppNetwork.loadingProgressIndicator();
          final result = await AuthAPIS.completeProfile(
              subId: getId2(event.productID)?.toString());
          AppNavigation.navigatorPop();
          if (result) {
            setState(() {
              subscribed = event.productID;
            });
            AppNavigation.navigatorPop();
          }
        }
        // }
      }
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

  String getDuration(String e) {
    switch (e) {
      case "user_sub":
        return ' /year';
      case "bus_sub_monthly":
        return ' /month';
      case "bus_sub_annually":
        return ' /year';
      default:
        return "";
    }
  }

  List<String> getPoints(String e) {
    switch (e) {
      case "user_sub":
        return [
          "Enjoy exclusive offers through My Backyard and the family owned businesses in your area. #Shoplocal",
          "Unlock hidden gems in your community with 16 different categories.",
          "The User Package is good for 12 months and yearly auto renews thereafter."
        ];

      case "bus_sub_monthly":
        return [
          "Business Subscribers can enjoy access of the following:",
          "As a local family owned business, reach tens of thousands of households while promoting your product and/or service for better brand awareness and attracting new customers.",
          "Promote exclusive offers to the My Backyard users at any time of a day, week or month, unlimited.",
          "This is a month to month subscription which auto renews every month thereafter the initial month."
        ];
      case "bus_sub_annually":
        return [
          "The Annual Subscription for business is ideal for companies in the community that are service providers such as but not limited to: Reality, Family Owned Physicians, Dental Practices, Insurance Companies and more.",
          "Stay ahead of the curve with the annual subscription and it's updates as needed.",
          "The Annual Subscription for businesses will auto renew after the 12th month."
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        screenTitle: 'Choose your package',
        topSafeArea: false,
        bgImage: '',
        showAppBar: true,
        showBackButton: true,
        // backgroundColor: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 5.h),
            Expanded(
              child: Consumer<UserController>(
                builder: (context, value, child) {
                  if (value.loading) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: MyColors().greenColor,
                    ));
                  } else {
                    return CarouselSlider(
                        carouselController: _controller,
                        options: CarouselOptions(
                            // aspectRatio: 4.4,
                            // scrollPhysics: const NeverScrollableScrollPhysics(),
                            enableInfiniteScroll: false,
                            viewportFraction: .9,
                            // padEnds: false,
                            enlargeCenterPage: true,
                            onPageChanged: (value, reason) {
                              setState(() {
                                index = value;
                              });
                            },
                            enlargeStrategy: CenterPageEnlargeStrategy.zoom),
                        items: [
                          for (int i = 0; i < value.productDetails.length; i++)
                            subscriptionTile(
                                value: value,
                                context: context,
                                m: value.productDetails[i]),
                        ]);

                    // PageView.builder(
                    //     controller: pageController,
                    //     itemCount: value.productDetails.length,
                    //     scrollDirection: Axis.horizontal,
                    //     physics: const AlwaysScrollableScrollPhysics(
                    //         parent: ClampingScrollPhysics()),
                    //     itemBuilder: (_, index) => Column(
                    //           children: [
                    //             // Row(
                    //             //   children: [
                    //             //     SizedBox(width: 1.w),
                    //             //     GestureDetector(
                    //             //       onTap: () {
                    //             //         pageController.previousPage(
                    //             //             duration: const Duration(
                    //             //                 milliseconds: 300),
                    //             //             curve: Curves.linear);
                    //             //       },
                    //             //       child: Icon(Icons.arrow_back_ios_rounded,
                    //             //           color: MyColors().black, size: 35),
                    //             //     ),
                    //             //     const Spacer(),
                    //             subscriptionTile(
                    //                 value: value,
                    //                 context: context,
                    //                 m: value.productDetails[index]),
                    //             //     const Spacer(),
                    //             //     GestureDetector(
                    //             //       onTap: () {
                    //             //         pageController.nextPage(
                    //             //             duration: const Duration(
                    //             //                 milliseconds: 300),
                    //             //             curve: Curves.linear);
                    //             //       },
                    //             //       child: Icon(
                    //             //           Icons.arrow_forward_ios_rounded,
                    //             //           color: MyColors().black,
                    //             //           size: 35),
                    //             //     ),
                    //             //     SizedBox(width: 1.w),
                    //             //   ],
                    //             // ),
                    //           ],
                    //         ));
                  }
                },
              ),
            ),
            if (widget.fromCompleteProfile && (user?.role == Role.User))
              GestureDetector(onTap: () {}, child: const Text("Skip")),
            Consumer<UserController>(builder: (context, val, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < val.productDetails.length; i++)
                    Container(
                      height: 2.5.w,
                      width: 2.5.w,
                      margin: EdgeInsets.symmetric(horizontal: .9.w),
                      decoration: BoxDecoration(
                          color: index == i
                              ? MyColors().primaryColor
                              : MyColors().greyColor2,
                          shape: BoxShape.circle),
                    )
                ],
              );
            }),
            footer(),
          ],
        ));
  }

  Widget footer() {
    return RichText(
      textAlign: TextAlign.center,
      textScaleFactor: 1.03,
      text: TextSpan(
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w400,
          fontSize: 13,
          color: MyColors().black,
        ),
        children: [
          TextSpan(
            text: '\nTerms & Conditions',
            style: GoogleFonts.roboto(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              decorationThickness: 2,
              color: MyColors().greenColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                AppNavigation.navigateTo(AppRouteName.CONTENT_SCREEN,
                    arguments: ContentRoutingArgument(
                        title: 'Terms & Conditions',
                        url: 'https://www.google.com/',
                        contentType: AppStrings.TERMS_AND_CONDITION_TYPE));
              },
          ),
          TextSpan(
            text: ' & ',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              decorationThickness: 2,
              color: MyColors().black,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(
            text: 'Privacy Policy',
            style: GoogleFonts.roboto(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              decorationThickness: 2,
              color: MyColors().greenColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                AppNavigation.navigateTo(AppRouteName.CONTENT_SCREEN,
                    arguments: ContentRoutingArgument(
                        title: 'Privacy Policy',
                        url: 'https://www.google.com/',
                        contentType: AppStrings.PRIVACY_POLICY_TYPE));

                // AppNavigation.navigateTo( AppRouteName.CONTENT_SCREEN, arguments: ContentRoutingArgument(
                //     title: AppStrings.PRIVACY_POLICY,
                //     contentType: AppStrings.PRIVACY_POLICY_TYPE));
              },
          ),
        ],
      ),
    );
  }

  Widget subscriptionTile(
      {required BuildContext context,
      //required MenuModel m
      UserController? value,
      required ProductDetails m}) {
    return Container(
      width: 100.w,
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
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
      // height: responsive.setHeight(75),
      // width: 100.w,
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyText(
                      title: m.price,
                      clr: MyColors().whiteColor,
                      fontWeight: FontWeight.w600,
                      size: 30,
                    ),
                    MyText(
                        title: getDuration(m.id),
                        clr: MyColors().whiteColor.withOpacity(.5),
                        fontWeight: FontWeight.w600,
                        size: 18)
                  ],
                ),
                MyText(
                    title: m.title.split("(").firstOrNull ?? "",
                    clr: MyColors().whiteColor,
                    fontWeight: FontWeight.w500,
                    size: 16,
                    height: 1.1),
                // if (m.description.isNotEmpty)
                //   Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 8.w),
                //     child: MyText(
                //       title: m.description, //getPrice(m.id, m.price),
                //       clr: MyColors().whiteColor.withOpacity(.5),
                //       align: TextAlign.center,
                //       fontStyle: FontStyle.italic,
                //       fontWeight: FontWeight.w600,
                //       size: 14,
                //     ),
                //   ),
              ],
            ),
          ),
          if (m.description.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 2.h),
                MyText(
                  title: "Description:",
                  clr: MyColors().black,
                  fontWeight: FontWeight.w600,
                  size: 15,
                ),
                MyText(
                  title: m.description, //getPrice(m.id, m.price),
                  clr: MyColors().black,
                  align: TextAlign.center,
                  size: 14,
                ),
              ],
            ),
          SizedBox(height: 2.h),
          for (int i = 0; i < getPoints(m.id).length; i++)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w) +
                  // EdgeInsets.only(bottom: 2.h)
                  EdgeInsets.only(bottom: 1.h),
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
                    // size: 14,
                    size: 12,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    height: 1.3,
                    clr: MyColors().black,
                  )),
                ],
              ),
            ),
          // FutureBuilder(
          //     future: AppInAppPurchase().isSubscriptionActive(m.id),
          //     builder: (context, snapshot) {
          //       return snapshot.connectionState == ConnectionState.done?
          SizedBox(height: 1.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: MyButton(
              onTap: () async {
                if (context.read<UserController>().user?.subId == null) {
                  if (widget.fromCompleteProfile) {
                    // AppNavigation.navigateTo(AppRouteName.ADD_CARD_ROUTE,
                    //     arguments:
                    //         ScreenArguments(args: {"price": m.price}));
                    // CustomToast().showToast(
                    //     message: 'Subscription purchased successfully');
                    ///
                    ///
                    AppInAppPurchase().buySubscription(m);
                  } else {
                    AppInAppPurchase().buySubscription(m);
                    // AppNavigation.navigatorPop();
                  }
                } else {
                  if (subscribed == m.id) {
                    CustomToast().showToast(message: "Already Subscribed");
                  }
                }

                ///
                ///
              },
              bgColor: user?.subId == null
                  ? Colors.black
                  : (subscribed == m.id)
                      ? Colors.black
                      : Colors.black.withOpacity(.5),
              loading: value?.purchaseLoading,
              title: (subscribed == m.id) ? "Subscribed" : "Subscribe",
              // width: 80.w,
            ),
          )
          // : Center(
          //     child: CircularProgressIndicator(
          //         color: MyColors().greenColor),
          //   );})
          ,
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
