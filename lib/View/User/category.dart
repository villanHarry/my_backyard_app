import 'dart:ui';

import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_card.dart';
import 'package:backyard/Component/custom_image.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_refresh.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Model/menu_model.dart';
import 'package:backyard/Model/user_model.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/app_strings.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/Widget/search_tile.dart';
import 'package:flutter/material.dart';
import 'package:backyard/View/Widget/Dialog/payment_dialog.dart';
import 'package:backyard/View/base_view.dart';
import 'package:provider/provider.dart';
import '../../../Utils/image_path.dart';
import '../../Component/custom_empty_data.dart';
import '../../Component/custom_height.dart';
import 'package:sizer/sizer.dart';
import '../../Service/navigation_service.dart';
import '../../main.dart';

class Category extends StatefulWidget {
  const Category({super.key});
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  TextEditingController s = TextEditingController();
  bool searchOn = false;
  List<MenuModel> categories = [
    MenuModel(name: 'Family Fun', image: ImagePath.familyFun),
    MenuModel(name: 'Home Services', image: ImagePath.homeServices),
    MenuModel(name: 'Food & Beverage', image: ImagePath.foodBeverage),
    MenuModel(
        name: 'Entertainment & Recreation',
        image: ImagePath.entertainRecreation),
    MenuModel(name: 'Retail & Boutique', image: ImagePath.retailBoutique),
    MenuModel(name: 'Liquor Stores', image: ImagePath.liquorStores),
    MenuModel(
        name: 'Flowers & Flower Services', image: ImagePath.flowerServices),
    MenuModel(name: 'Sports & Fitness', image: ImagePath.sportsFitness),
    MenuModel(name: 'General Retail', image: ImagePath.generalRetail),
    MenuModel(name: 'Bakery & coffee shop', image: ImagePath.bakeryCoffeeShop),
    MenuModel(name: 'Everything pets', image: ImagePath.everythingPets),
    MenuModel(
        name: 'Pool and Lawn Services', image: ImagePath.poolLawnServices),
    MenuModel(name: 'Health & Beauty', image: ImagePath.healthBeauty),
    MenuModel(name: 'Medical Services', image: ImagePath.medicalServices),
  ];
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
        topSafeArea: false,
        bottomSafeArea: false,
        resizeBottomInset: false,
        child: CustomRefresh(
          onRefresh: () async {},
          child: Consumer<HomeController>(builder: (context, val, _) {
            return Column(
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
                        screenTitle: 'Offers & Discounts',
                        leading: MenuIcon(),
                        trailing: NotificationIcon(),
                        bottom: 2.h,
                      ),
                      // SearchTile(
                      //   showFilter: false,
                      //   search: s,
                      //   onTap: () async {
                      //     // await getAddress(context);
                      //   },
                      //   onChange: (v) async {
                      //     // await getAddress(context);
                      //   },
                      // ),
                      SizedBox(
                        height: 2.h,
                      ),
                    ],
                  ),

                  // CustomAppBar(screenTitle:"Location",leading: CustomBackButton(),titleColor: MyColors().black,),
                ),
                Expanded(
                  child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 3.w,
                        mainAxisSpacing: 3.w,
                      ),
                      // gridDelegate: _monthPickerGridDelegate,
                      itemCount: categories.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      itemBuilder: (BuildContext ctx, index) {
                        return Stack(
                          children: [
                            Container(
                              width: 100.w,
                              height: 20.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: AssetImage(
                                        categories[index].image!,
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                            GestureDetector(
                              onTap: () {
                                AppNavigation.navigateTo(
                                    AppRouteName.SEARCH_RESULT_ROUTE);
                              },
                              child: Container(
                                width: 100.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF183400).withOpacity(.8),
                                      spreadRadius: 0,
                                      blurRadius: 0,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: MyText(
                                  title: categories[index].name!,
                                  clr: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  size: 16,
                                  center: true,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
