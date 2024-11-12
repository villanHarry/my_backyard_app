import 'dart:ui';

import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_card.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_refresh.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/app_strings.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/Utils/utils.dart';
import 'package:backyard/View/User/offers.dart';
import 'package:backyard/View/Widget/Dialog/reject_dialog.dart';
import 'package:backyard/View/Widget/search_tile.dart';
import 'package:backyard/View/Widget/view_all_widget.dart';
import 'package:flutter/material.dart';
import 'package:backyard/View/base_view.dart';
import 'package:provider/provider.dart';
import '../../../Utils/image_path.dart';
import '../../Component/custom_empty_data.dart';
import '../../Component/custom_height.dart';
import 'package:sizer/sizer.dart';
import '../../Service/navigation_service.dart';
import '../../main.dart';

class BusinessHome extends StatefulWidget {
  const BusinessHome({super.key});

  @override
  State<BusinessHome> createState() => _BusinessHomeState();
}

class _BusinessHomeState extends State<BusinessHome> {
  TextEditingController s = TextEditingController();
  bool searchOn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => true);
        // return Utils().onWillPop(context, currentBackPressTime: currentBackPressTime);
      },
      child: BaseView(
        bgImage: '',
        bottomSafeArea: false,
        topSafeArea: false,
        child: CustomRefresh(
          onRefresh: () async {},
          child: Consumer<UserController>(builder: (context, val, _) {
            return CustomPadding(
              topPadding: 0.h,
              horizontalPadding: 0.w,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors().whiteColor,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          blurRadius: 10, // Spread of the shadow
                          spreadRadius: 5, // Size of the shadow
                          offset: const Offset(0, 4), // Position of the shadow
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(top: 7.h) +
                        EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomAppBar(
                          screenTitle: "Home",
                          leading: MenuIcon(),
                          trailing: NotificationIcon(),
                          bottom: 2.h,
                        ),
                        SearchTile(
                          showFilter: false,
                          // search: location,
                          onTap: () async {
                            // await getAddress(context);
                          },
                          onChange: (v) async {
                            // await getAddress(context);
                          },
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Expanded(
                      child: ListView.builder(
                          // itemCount:s.length,
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.h),
                          physics: AlwaysScrollableScrollPhysics(
                              parent: const ClampingScrollPhysics()),
                          shrinkWrap: true,
                          itemBuilder: (_, index) => OfferTile()))
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  rejectDialog({required Function onTap}) {
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
              content: RejectDialog(
                onYes: (v) {
                  onTap();
                },
              ),
            ),
          );
        });
  }
}
