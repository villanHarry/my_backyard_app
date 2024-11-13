import 'dart:io';
import 'package:backyard/Arguments/profile_screen_arguments.dart';
import 'package:backyard/Arguments/screen_arguments.dart';
import 'package:backyard/Component/custom_empty_data.dart';
import 'package:backyard/Component/custom_height.dart';
// import 'package:backyard/Model/session_model.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/View/Widget/search_tile.dart';
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
import '../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';

import 'offers.dart';

class SearchResult extends StatelessWidget {
  List<String> i = [
    ImagePath.random1,
    ImagePath.random2,
    ImagePath.random3,
    ImagePath.random1,
    ImagePath.random2,
    ImagePath.random3,
    ImagePath.random1,
  ];
  @override
  Widget build(BuildContext context) {
    return BaseView(
        screenTitle: 'Search Result',
        bgImage: '',
        showAppBar: true,
        showBackButton: true,
        // backgroundColor: Colors.white,
        child: CustomPadding(
          horizontalPadding: 0.w,
          topPadding: 0,
          child: Consumer<HomeController>(builder: (context, val, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchTile(showFilter: false),
                      SizedBox(
                        height: 2.h,
                      ),
                      MyText(
                        title: 'Nearby Business',
                        size: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                    ],
                  ),
                ),
                CustomHeight(
                    prototype: businessTile(context: context),
                    listView: ListView.builder(
                        itemCount: i.length,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 0.h),
                        physics: AlwaysScrollableScrollPhysics(
                            parent: const ClampingScrollPhysics()),
                        shrinkWrap: true,
                        itemBuilder: (_, index) =>
                            businessTile(img: i[index], context: context))),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                  child: MyText(
                    title: 'Trending Offers',
                    size: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                offerList(),
              ],
            );
          }),
        ));
  }

  Widget offerList() {
    return Expanded(
        child: ListView.builder(
            // itemCount:s.length,
            itemCount: 10,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
            physics: AlwaysScrollableScrollPhysics(
                parent: const ClampingScrollPhysics()),
            shrinkWrap: true,
            itemBuilder: (_, index) => OfferTile()));
  }

  businessTile({String? img, required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(right: 3.w),
      child: GestureDetector(
        onTap: () {
          // HomeController.i.endUser.value=u??User();
          AppNavigation.navigateTo(AppRouteName.USER_PROFILE_ROUTE,
              arguments: ProfileScreenArguments(isMe: false, isUser: false));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              img ?? ImagePath.random1,
              scale: 2,
            ),
            SizedBox(
              height: 1.h,
            ),
            MyText(title: 'Business Name')
          ],
        ),
      ),
    );
  }
}
