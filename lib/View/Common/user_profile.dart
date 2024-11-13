import 'dart:developer';
import 'dart:ui';

import 'package:backyard/Arguments/content_argument.dart';
import 'package:backyard/Arguments/screen_arguments.dart';
import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_empty_data.dart';
import 'package:backyard/Component/custom_height.dart';
import 'package:backyard/Component/custom_icon_container.dart';
import 'package:backyard/Component/custom_image.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_refresh.dart';
import 'package:backyard/Component/custom_switch.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Model/file_network.dart';
import 'package:backyard/Service/api.dart';
import 'package:backyard/Service/bus_apis.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_size.dart';
import 'package:backyard/Utils/app_strings.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/User/offers.dart';
import 'package:backyard/View/Widget/view_all_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:backyard/View/base_view.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../../Utils/image_path.dart';
import '../../Component/custom_bottomsheet_indicator.dart';
import '../../Component/custom_radio_tile.dart';
import '../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../../Model/user_model.dart';
import '../../Utils/app_router_name.dart';
import '../../Utils/utils.dart';

/// Only this file to be used for both profile views for business and user etc
/// Made separate profile for business as in ALfa there needs to be much handling

class UserProfile extends StatefulWidget {
  UserProfile({super.key, this.isMe = true, this.user, this.isUser = true});
  bool isMe = true;
  bool isUser = true;
  User? user;
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController s = TextEditingController();
  late bool business =
      context.read<UserController>().user?.role == Role.Business;
  List<String> items = ['Offers', 'About', 'Reviews'];
  String i = 'Offers';

  void setLoading(bool val) {
    context.read<HomeController>().setLoading(val);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.user != null) {
        setLoading(true);
        await BusAPIS.getOfferById(widget.user?.id?.toString() ?? "");
        setLoading(true);
      }
    });
    business = !widget
        .isUser; // GlobalController.values.userRole.value == UserRole.business;
    if (business && widget.isMe) {
      i = 'About';
    }
  }

  List<FileNetwork> images = List<FileNetwork>.empty();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BaseView(
        bgImage: '',
        child: CustomPadding(
          topPadding: widget.isMe ? 2.h : 0,
          horizontalPadding: widget.isMe ? 20.sp : 10.sp,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isMe) ...[
                CustomAppBar(
                  screenTitle: business ? 'Business Profile' : 'Profile',
                  leading: MenuIcon(),
                  trailing: EditIcon(),
                  bottom: 2.h,
                ),
              ] else ...[
                CustomAppBar(
                  screenTitle: business ? 'Business Profile' : 'Profile',
                  leading: BackButton(),
                  trailing: business
                      ? Image.asset(
                          ImagePath.favorite,
                          scale: 2.5,
                          color: MyColors().redColor,
                        )
                      : null,
                  bottom: 2.h,
                ),
              ],
              if (business) ...[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.user != null)
                          CustomImage(
                            height: 20.h,
                            width: 100.w,
                            borderRadius: BorderRadius.circular(10),
                            url: (widget.user?.profileImage ?? ""),
                          )
                        else
                          Image.asset(ImagePath.random6),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: MyText(
                              title: widget.user?.name ?? ""
                              //'Lorum Ipsum Cafe'
                              ,
                              fontWeight: FontWeight.w600,
                              size: 16,
                            )),
                            Image.asset(
                              ImagePath.location,
                              scale: 2,
                              color: MyColors().primaryColor,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        MyText(
                          title: widget.user?.address ?? ""
                          // 'Peoples Plaza, New Road, Kathmandu - 600m'
                          ,
                          size: 12,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          children: [
                            MyText(
                              title: '4.0  ',
                              size: 12,
                            ),
                            RatingBar(
                              initialRating: 4,
                              // initialRating:d.endUser.value.avgRating,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              glowColor: Colors.yellow,
                              updateOnDrag: false,
                              ignoreGestures: true,
                              ratingWidget: RatingWidget(
                                full: Image.asset(
                                  ImagePath.star,
                                  width: 4.w,
                                ),
                                half: Image.asset(
                                  ImagePath.star,
                                  width: 4.w,
                                ),
                                empty: Image.asset(
                                  ImagePath.starOutlined,
                                  width: 4.w,
                                ),
                              ),
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              onRatingUpdate: (rating) {},
                              itemSize: 3.w,
                            ),
                            MyText(
                              title: '  250 Ratings',
                              size: 12,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        if (widget.isMe) ...[
                          Row(
                            children: [
                              sessionButton2(title: items[1]),
                              SizedBox(
                                width: 3.w,
                              ),
                              sessionButton2(title: items[2]),
                            ],
                          ),
                        ] else ...[
                          SizedBox(
                              height: 5.h,
                              width: 100.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  for (int i = 0; i < items.length; i++)
                                    sessionButton(title: items[i])
                                ],
                              )),
                        ],
                        SizedBox(
                          height: 2.h,
                        ),
                        if (i == items[0]) ...[
                          Container(
                            decoration: BoxDecoration(
                                color: MyColors().primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Image.asset(
                                  ImagePath.offer,
                                  scale: 2,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                        title:
                                            'Extra 25%, off, up to \$\$. 3,000.00',
                                        fontWeight: FontWeight.w600,
                                        clr: MyColors().whiteColor,
                                      ),
                                      MyText(
                                        title: 'Promo Code SAVE. Ends 6/9.',
                                        clr: MyColors().whiteColor,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                MyButton(
                                  title: 'Apply',
                                  onTap: () {},
                                  gradient: false,
                                  bgColor: MyColors().black,
                                  borderColor: MyColors().black,
                                  textColor: MyColors().whiteColor,
                                  height: 5.2.h,
                                  width: 24.w,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          ListView.builder(
                              itemCount: 10,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.h),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (_, index) => OfferTile())
                          // Consumer<HomeController>(builder: (context, val, _) {
                          //   if (val.loading) {
                          //     return CircularProgressIndicator(
                          //       color: MyColors().primaryColor,
                          //     );
                          //   } else {
                          //     return ListView.builder(
                          //         itemCount: val.offers?.length,
                          //         padding: EdgeInsets.symmetric(
                          //             horizontal: 3.w, vertical: 0.h),
                          //         physics: NeverScrollableScrollPhysics(),
                          //         shrinkWrap: true,
                          //         itemBuilder: (_, index) => OfferTile());
                          //   }
                          // })
                        ],
                        if (i == items[1]) ...[
                          MyText(
                            title: 'Description',
                            fontWeight: FontWeight.w600,
                            size: 14,
                          ),
                          SizedBox(
                            height: .5.h,
                          ),
                          MyText(
                              title:
                                  'Classic checkerboard slip ons with office white under tone and reinforced waffle cup soles is a tone and reinforced waffle cup soles.CIassic ka checkerboard slip ons with office white hnan dunder tone and reinforced.'),
                          SizedBox(
                            height: 2.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      title: 'Contact No:',
                                      fontWeight: FontWeight.w600,
                                      size: 14,
                                    ),
                                    SizedBox(
                                      height: .5.h,
                                    ),
                                    MyText(title: '+1 234 567 890'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      title: 'Location:',
                                      fontWeight: FontWeight.w600,
                                      size: 14,
                                    ),
                                    SizedBox(
                                      height: .5.h,
                                    ),
                                    MyText(title: 'abc School & college'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          MyText(
                            title: 'Opening Hours',
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          MyText(
                            title: 'Open • Closes',
                            fontWeight: FontWeight.w600,
                            clr: MyColors().primaryColor,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                title: 'Monday',
                                fontWeight: FontWeight.w600,
                                clr: Color(0xff717171),
                              ),
                              MyText(
                                title: '8 AM-5 PM',
                                fontWeight: FontWeight.w600,
                                clr: Color(0xffB9BCBE),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                title: 'Tuesday',
                                fontWeight: FontWeight.w600,
                                clr: Color(0xff717171),
                              ),
                              MyText(
                                title: '8 AM–5 PM',
                                fontWeight: FontWeight.w600,
                                clr: Color(0xffB9BCBE),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                title: 'Wednesday',
                                fontWeight: FontWeight.w600,
                                clr: Color(0xff717171),
                              ),
                              MyText(
                                title: '8 AM–5 PM',
                                fontWeight: FontWeight.w600,
                                clr: Color(0xffB9BCBE),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                title: 'Thursday',
                                fontWeight: FontWeight.w600,
                                clr: Color(0xff717171),
                              ),
                              MyText(
                                title: '8 AM–5 PM',
                                fontWeight: FontWeight.w600,
                                clr: Color(0xffB9BCBE),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                title: 'Friday',
                                fontWeight: FontWeight.w600,
                                clr: Color(0xff717171),
                              ),
                              MyText(
                                title: '8 AM–5 PM',
                                fontWeight: FontWeight.w600,
                                clr: Color(0xffB9BCBE),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                title: 'Saturday',
                                fontWeight: FontWeight.w600,
                                clr: Color(0xff717171),
                              ),
                              MyText(
                                title: 'Closed',
                                fontWeight: FontWeight.w600,
                                clr: Color(0xffB9BCBE),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                title: 'Sunday',
                                fontWeight: FontWeight.w600,
                                clr: Color(0xff717171),
                              ),
                              MyText(
                                title: 'Closed',
                                fontWeight: FontWeight.w600,
                                clr: Color(0xffB9BCBE),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                        ],
                        if (i == items[2]) ...[
                          Center(
                            child: Column(
                              children: [
                                MyText(
                                  title: '4.6',
                                  fontWeight: FontWeight.w600,
                                  size: 48,
                                  clr: Color(0xffF1A635),
                                  center: true,
                                ),
                                RatingBar(
                                  initialRating: 4,
                                  // initialRating:d.endUser.value.avgRating,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  glowColor: Colors.yellow,
                                  updateOnDrag: false,
                                  ignoreGestures: true,
                                  ratingWidget: RatingWidget(
                                    full: Image.asset(
                                      ImagePath.star,
                                      width: 4.w,
                                    ),
                                    half: Image.asset(
                                      ImagePath.star,
                                      width: 4.w,
                                    ),
                                    empty: Image.asset(
                                      ImagePath.starOutlined,
                                      width: 4.w,
                                    ),
                                  ),
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  onRatingUpdate: (rating) {},
                                  itemSize: 5.w,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                MyText(title: 'Based On 50 Reviews', size: 14),
                                SizedBox(
                                  height: 3.h,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      ImagePath.random7,
                                      scale: 2,
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MyText(
                                                title: 'Jay Smith',
                                                size: 14,
                                              ),
                                              MyText(
                                                title: '2 Days Ago',
                                                size: 14,
                                              ),
                                            ],
                                          ),
                                          RatingBar(
                                            initialRating: 4,
                                            // initialRating:d.endUser.value.avgRating,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            glowColor: Colors.yellow,
                                            updateOnDrag: false,
                                            ignoreGestures: true,
                                            ratingWidget: RatingWidget(
                                              full: Image.asset(
                                                ImagePath.star,
                                                width: 4.w,
                                              ),
                                              half: Image.asset(
                                                ImagePath.star,
                                                width: 4.w,
                                              ),
                                              empty: Image.asset(
                                                ImagePath.starOutlined,
                                                width: 4.w,
                                              ),
                                            ),
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 2.0),
                                            onRatingUpdate: (rating) {},
                                            itemSize: 3.w,
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          MyText(
                                            title:
                                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      ImagePath.random7,
                                      scale: 2,
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MyText(
                                                title: 'Jay Smith',
                                                size: 14,
                                              ),
                                              MyText(
                                                title: '2 Days Ago',
                                                size: 14,
                                              ),
                                            ],
                                          ),
                                          RatingBar(
                                            initialRating: 4,
                                            // initialRating:d.endUser.value.avgRating,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            glowColor: Colors.yellow,
                                            updateOnDrag: false,
                                            ignoreGestures: true,
                                            ratingWidget: RatingWidget(
                                              full: Image.asset(
                                                ImagePath.star,
                                                width: 4.w,
                                              ),
                                              half: Image.asset(
                                                ImagePath.star,
                                                width: 4.w,
                                              ),
                                              empty: Image.asset(
                                                ImagePath.starOutlined,
                                                width: 4.w,
                                              ),
                                            ),
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 2.0),
                                            onRatingUpdate: (rating) {},
                                            itemSize: 3.w,
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          MyText(
                                            title:
                                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                if (!widget.isMe) ...[
                                  MyButton(
                                    title: 'Write a Review',
                                    onTap: () {
                                      AppNavigation.navigateTo(
                                          AppRouteName.GIVE_REVIEW_ROUTE);
                                    },
                                  )
                                ],
                              ],
                            ),
                          )
                          // SizedBox(height: 2.h,),
                          // ListView.builder(
                          //     itemCount:10,
                          //     padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 0.h),
                          //     physics: NeverScrollableScrollPhysics(),
                          //     shrinkWrap: true,
                          //     itemBuilder: (_, index) =>OfferTile()
                          // )
                        ],
                      ],
                    ),
                  ),
                )
              ] else ...[
                profileCard()
              ],
            ],
          ),
        ),
      ),
    );
  }

  profileCard() {
    return Consumer<UserController>(builder: (context, val, _) {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    // color: Colors.red,
                    color: MyColors().primaryColor,
                    shape: BoxShape.circle),
                height: 15.9.h,
                width: 15.9.h,
                alignment: Alignment.center,
                child: CustomImage(
                  height: 15.h,
                  width: 15.h,
                  isProfile: true,
                  photoView: false,
                  url: val.user?.profileImage,
                  radius: 100,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              MyText(
                title: val.user?.name ?? "",
                fontWeight: FontWeight.w500,
                size: 18,
              ),
              // SizedBox(
              //   height: 1.h,
              // ),
              if (val.user?.socialType == null ||
                  val.user?.socialType == "phone") ...[
                MyText(
                  title: val.user?.email ?? "",
                  size: 16,
                ),
                // MyText(title: u.value.fullName,fontWeight: FontWeight.w600,size: 18,),
                SizedBox(
                  height: 3.5.h,
                )
              ],

              if (!business) ...[
                const Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      title: 'Personal Details',
                      fontWeight: FontWeight.w600,
                      size: 18,
                    )),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColors().container,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        blurRadius: 10, // Spread of the shadow
                        spreadRadius: 2, // Size of the shadow
                        offset: const Offset(0, 4), // Position of the shadow
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    children: [
                      // if(u.value.email!='')...[
                      //                 userDetail(title: ImagePath.location,text: u.value.location?.address??''),
                      // ],
                      userDetail(
                          title: 'Phone Number', text: val.user?.phone ?? ""),
                      userDetail(
                          title: 'Email Address', text: val.user?.email ?? ""),
                      userDetail(
                          title: 'Geo Location',
                          widget: CustomSwitch(
                            height: 3,
                            width: 12,
                            switchValue: val.geo,
                            onChange: (v) {},
                            toggleColor: MyColors().primaryColor,
                            onChange2: (v) async {
                              val.setGeo(v);
                            },
                          )),

                      // userDetail(
                      //     title: 'Address',
                      //     text: '812 street, dummy address, USA'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  userDetail({String? text, String title = '', Widget? widget}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment:
            title != '' ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            title: title,
            size: 14,
            clr: MyColors().black,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            width: 2.w,
          ),
          if (text != null)
            Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: MyText(title: text, size: 12)),
            ),
          if (widget != null) widget
        ],
      ),
    );
  }

  sessionButton({required String title}) {
    return Padding(
      padding: EdgeInsets.only(right: 2.w),
      child: MyButton(
        title: title,
        onTap: () async {
          i = title;
          setState(() {});
          if (i == 'Offers') {
            setLoading(true);
            await BusAPIS.getOfferById(widget.user?.id?.toString() ?? "");
            setLoading(true);
          }
        },
        gradient: false,
        bgColor: i == title ? MyColors().black : MyColors().whiteColor,
        borderColor: MyColors().black,
        textColor: i == title ? null : MyColors().black,
        height: 5.2.h,
        width: 29.w,
      ),
    );
  }

  sessionButton2({required String title}) {
    return Expanded(
      child: MyButton(
        title: title,
        onTap: () {
          i = title;
          setState(() {});
        },
        gradient: false,
        bgColor: i == title ? MyColors().black : MyColors().whiteColor,
        borderColor: MyColors().black,
        textColor: i == title ? null : MyColors().black,
        height: 5.2.h,
        width: 40.w,
      ),
    );
  }
}
