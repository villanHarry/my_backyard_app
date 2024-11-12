import 'package:backyard/View/Business/create_offer.dart';
import 'package:backyard/View/Business/customers.dart';
import 'package:backyard/View/Common/Settings/settings.dart';
import 'package:backyard/View/User/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/Component/custom_drawer.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/Business/business_home.dart';
import 'package:backyard/View/User/offers.dart';
import 'package:backyard/View/Common/user_profile.dart';
import 'package:provider/provider.dart';
import 'User/user_home.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int index = 0;
  int inActiveColor = 0XFFD2D2D2;
  int activeColor = 0XFF57BA00;
  late final business =
      context.read<UserController>().user?.role == Role.Business;

  void setIndex(int val) {
    index = val;
    setState(() {});
  }

  @override
  void initState() {
    
    // TODO: implement initState
    super.initState();
  }

  /// Controller to handle bottom nav bar and also handles initial page
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return onWillPop(context);
      },
      child: Consumer<HomeController>(builder: (context, val, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          key: val.drawerKey,
          resizeToAvoidBottomInset: false,
          // extendBodyBehindAppBar: true,
          drawer: CustomDrawer(),
          // body: GetBuilder<HomeController>(
          //     builder: (context) {
          //       return business? (businessPages[h.currentIndex.value]):userPages[h.currentIndex.value];
          //     }
          // ),
          // bottomNavigationBar: CustomBottomBar(),

          body: !(business)
              ? Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Stack(children: [
                    SizedBox(height: 1.sh - 100, child: userPages[index]),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 108,
                        width: 1.sw,
                        padding: EdgeInsets.symmetric(horizontal: 19.sp),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (int i = 0; i < userTabs.length; i++)
                              GestureDetector(
                                onTap: () => setIndex(i),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(userTabs[i]["icon"] ?? "",
                                        scale: 1,
                                        fit: BoxFit.fitHeight,
                                        color: Color(index == i
                                            ? activeColor
                                            : inActiveColor),
                                        height: 22.sp),
                                    const SizedBox(height: 6),
                                    Text(
                                      userTabs[i]["title"] ?? "",
                                      style: TextStyle(
                                        color: Color(index == i
                                            ? activeColor
                                            : inActiveColor),
                                        fontWeight: index == i
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        fontSize: index == i ? 14.sp : 12.sp,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                )
              : PersistentTabView(
                  context,
                  controller: val.homeBottom,
                  screens: businessPages,
                  // (trainer? (trainerPages[h.currentIndex.value]):traineePages[h.currentIndex.value]),
                  items: businessTab,
                  confineToSafeArea: false,
                  navBarHeight: 65,
                  stateManagement: false,
                  backgroundColor:
                      Colors.white, // Customize the background color
                  handleAndroidBackButtonPress: true,
                  resizeToAvoidBottomInset: false,
                  decoration: NavBarDecoration(
                    borderRadius: BorderRadius.circular(0.0),
                    colorBehindNavBar: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        blurRadius: 10, // Spread of the shadow
                        spreadRadius: 5, // Size of the shadow
                        offset: const Offset(0, 4), // Position of the shadow
                      ),
                    ],
                  ),
                  bottomScreenMargin: 75,
                  padding: EdgeInsets.only(top: 0, bottom: 10),
                  // margin: const EdgeInsets.symmetric(vertical: 50), // Adjust the margin if needed
                  navBarStyle: NavBarStyle.style15, // Set the style to style15
                ),
          extendBody: false,
        );
      }),
    );
  }

  List<Widget> userPages = <Widget>[
    UserHome(),
    const Category(),
    // ScanQR(),
    const Offers(),
    UserProfile(),
  ];
  List<Widget> businessPages = <Widget>[
    const BusinessHome(),
    const Customers(),
    CreateOffer(),
    const Settings(),
    UserProfile(
      isUser: false,
      isMe: true,
    )
  ];

  // List<PersistentBottomNavBarItem> userTab = <PersistentBottomNavBarItem>[
  //   PersistentBottomNavBarItem(
  //       icon: Image.asset(ImagePath.home2, scale: 1),
  //       inactiveIcon: Image.asset(ImagePath.home, scale: 1),
  //       title: 'Home',
  //       activeColorPrimary: MyColors().primaryColor,
  //       activeColorSecondary: MyColors().primaryColor),
  //   PersistentBottomNavBarItem(
  //       icon: Image.asset(ImagePath.offer2, scale: 1),
  //       inactiveIcon: Image.asset(ImagePath.offers, scale: 1),
  //       title: 'Offers',
  //       activeColorPrimary: MyColors().primaryColor,
  //       activeColorSecondary: MyColors().primaryColor),
  //   // PersistentBottomNavBarItem(icon: Image.asset(ImagePath.scan,scale: 1), title: '',activeColorSecondary: MyColors().primaryColor,activeColorPrimary: MyColors().whiteColor,contentPadding: 50,iconSize: 40),
  //   PersistentBottomNavBarItem(
  //       icon: Image.asset(ImagePath.category2, scale: 1),
  //       inactiveIcon: Image.asset(ImagePath.savedOffersIcon, scale: 1),
  //       title: 'Saved',
  //       activeColorPrimary: MyColors().primaryColor,
  //       activeColorSecondary: MyColors().primaryColor),
  //   PersistentBottomNavBarItem(
  //       icon: Image.asset(ImagePath.profile2, scale: 1),
  //       inactiveIcon: Image.asset(ImagePath.profile, scale: 1),
  //       title: 'Profile',
  //       activeColorPrimary: MyColors().primaryColor,
  //       activeColorSecondary: MyColors().primaryColor),
  // ];
  List<Map<String, String>> userTabs = [
    {"title": "Home", "icon": ImagePath.homeAltered},
    {"title": "Offers", "icon": ImagePath.offerAltered},
    {"title": "Saved", "icon": ImagePath.savedOffersIcon},
    {"title": "Profile", "icon": ImagePath.profile},
  ];
  List<PersistentBottomNavBarItem> businessTab = <PersistentBottomNavBarItem>[
    PersistentBottomNavBarItem(
        icon: Image.asset(ImagePath.home5, scale: 1),
        inactiveIcon: Image.asset(ImagePath.home4, scale: 1),
        title: 'Home',
        activeColorPrimary: MyColors().primaryColor,
        activeColorSecondary: MyColors().primaryColor),
    PersistentBottomNavBarItem(
        icon: Image.asset(ImagePath.customers2, scale: 1),
        inactiveIcon: Image.asset(ImagePath.customers, scale: 1),
        title: 'Customers',
        activeColorPrimary: MyColors().primaryColor,
        activeColorSecondary: MyColors().primaryColor),
    PersistentBottomNavBarItem(
        icon: Image.asset(ImagePath.add, scale: 2),
        title: '',
        activeColorSecondary: MyColors().primaryColor,
        activeColorPrimary: MyColors().whiteColor),
    PersistentBottomNavBarItem(
        icon: Image.asset(ImagePath.setting2, scale: 1),
        inactiveIcon: Image.asset(ImagePath.settings, scale: 1),
        title: 'Settings',
        activeColorPrimary: MyColors().primaryColor,
        activeColorSecondary: MyColors().primaryColor),
    PersistentBottomNavBarItem(
        icon: Image.asset(ImagePath.profile2, scale: 1),
        inactiveIcon: Image.asset(ImagePath.profile, scale: 1),
        title: 'Profile',
        activeColorPrimary: MyColors().primaryColor,
        activeColorSecondary: MyColors().primaryColor),
  ];

  onWillPop(context) async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return false;
  }
}
