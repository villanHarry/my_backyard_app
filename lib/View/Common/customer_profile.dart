import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_image.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/file_network.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/User/offers.dart';
import 'package:flutter/material.dart';
import 'package:backyard/View/base_view.dart';
import 'package:provider/provider.dart';
import '../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../../Model/user_model.dart';

/// TO BE DELETED
/// Made separate profile for business as in ALfa there needs to be much handling

class CustomerProfile extends StatefulWidget {
  CustomerProfile({super.key, this.isMe = true});
  bool isMe = true;
  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  TextEditingController s = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  List<String> items = ['Contact Details', 'Offers & Discounts'];
  String i = 'Contact Details';
  List<FileNetwork> images = List<FileNetwork>.empty();
  bool business =
      true; //GlobalController.values.userRole.value == UserRole.business;

  @override
  Widget build(BuildContext context) {
    print(business);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BaseView(
        bgImage: '',
        child: CustomPadding(
          topPadding: 0.h,
          horizontalPadding: 3.w,
          child: Column(
            children: [
              if (widget.isMe) ...[
                CustomAppBar(
                  screenTitle: "User Profile",
                  leading: MenuIcon(),
                  trailing: EditIcon(),
                  bottom: 2.h,
                ),
              ] else ...[
                CustomAppBar(
                  screenTitle: "User Profile", leading: BackButton(),
                  // trailing: business?null: Image.asset(ImagePath.favorite,scale: 2,color: MyColors().redColor,),
                  bottom: 2.h,
                ),
              ],
              profileCard()
            ],
          ),
        ),
      ),
    );
  }

  profileCard() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<UserController>(builder: (context, val, _) {
              return Container(
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
              );
            }),
            SizedBox(
              height: 2.h,
            ),
            MyText(
              title: 'Lisa Marie',
              fontWeight: FontWeight.w500,
              size: 18,
            ),
            MyText(
              title: 'lisa.maria@example.com',
              size: 16,
            ),
            SizedBox(height: 1.5.h),
            MyText(
                title: 'Availed Offers', size: 14, fontWeight: FontWeight.w600),
            MyText(
                title: '25',
                size: 36,
                clr: MyColors().primaryColor,
                fontWeight: FontWeight.w600),
            // SizedBox(
            //   height: 1.h,
            // ),
            // Container(decoration: BoxDecoration(color: MyColors().primaryColor,borderRadius: BorderRadius.circular(30)),
            //   padding: EdgeInsets.all(12)+EdgeInsets.symmetric(horizontal: 20),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Image.asset(ImagePath.coins,scale: 2,),
            //       MyText(title: '  150',fontWeight: FontWeight.w600,size: 16,clr: MyColors().whiteColor),
            //     ],),
            // ),
            // MyText(title: u.value.fullName,fontWeight: FontWeight.w600,size: 18,),
            SizedBox(
              height: 2.h,
            ),

            if (!business) ...[
              // Row(
              //   children: [
              //     sessionButton(title: items[0]),
              //     SizedBox(
              //       width: 3.w,
              //     ),
              //     sessionButton(title: items[1]),
              //   ],
              // ),
              SizedBox(
                height: 2.h,
              ),
              // if (i == items[0]) ...[
              //   Container(
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       color: MyColors().container,
              //       borderRadius: BorderRadius.circular(8),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(0.2), // Shadow color
              //           blurRadius: 10, // Spread of the shadow
              //           spreadRadius: 2, // Size of the shadow
              //           offset: const Offset(0, 4), // Position of the shadow
              //         ),
              //       ],
              //     ),
              //     padding: EdgeInsets.all(3.w),
              //     child: Column(
              //       children: [
              //         // if(u.value.email!='')...[
              //         //                 userDetail(title: ImagePath.location,text: u.value.location?.address??''),
              //         // ],
              //         userDetail(
              //             title: 'Phone Number', text: '+1 234 567 890'),
              //         userDetail(
              //             title: 'Email Address', text: 'abcd@gmail.com'),
              //         userDetail(
              //             title: 'Address',
              //             text: '812 lorum street, dummy address, USA'),
              //       ],
              //     ),
              //   ),
              // ],
              // if (i == items[1]) ...[
              ListView.builder(
                  // itemCount:s.length,
                  itemCount: 8,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, index) => OfferTile(
                      // availed: true,
                      )),
              // ],
              SizedBox(
                height: 2.h,
              ),
            ],
          ],
        ),
      ),
    );
  }

  getData() async {
    // u = AuthController.i.user;
    // if (widget.isMe) {
    //   // await AuthController.i.getDashboard(context: context);
    //   u = AuthController.i.user;
    // } else {
    //   business = !business;
    //   u = HomeController.i.endUser;
    // }
  }

  userDetail({required String text, String title = ''}) {
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
          Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: MyText(
                  title: text,
                  size: 14,
                )),
          ),
        ],
      ),
    );
  }

  sessionButton({required String title}) {
    return Expanded(
      child: MyButton(
        title: title,
        onTap: () {
          i = title;
          setState(() {});
        },
        gradient: false,
        bgColor: i == title ? MyColors().primaryColor : MyColors().whiteColor,
        borderColor: MyColors().primaryColor,
        textColor: i == title ? null : MyColors().primaryColor,
        height: 5.2.h,
        width: 40.w,
      ),
    );
  }
}
