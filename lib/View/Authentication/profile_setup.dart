import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:backyard/Arguments/screen_arguments.dart';
import 'package:backyard/Component/custom_switch.dart';
import 'package:backyard/Component/validations.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/user_model.dart';
import 'package:backyard/Service/api.dart';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/auth_apis.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/main.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:place_picker/place_picker.dart';
import 'package:backyard/Utils/utils.dart';
import 'package:backyard/View/Widget/upload_media.dart';
import 'package:backyard/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:provider/provider.dart';
import '../../../../Utils/image_path.dart';
import '../../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../../Component/custom_background_image.dart';
import '../../Component/custom_padding.dart';
import '../../Component/custom_textfield.dart';
import '../../Utils/app_router_name.dart';
import '../Widget/Dialog/profile_complete_dialog.dart';
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key, required this.editProfile});
  final bool editProfile;
  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  late final business =
      context.read<UserController>().user?.role == Role.Business;
  File imageProfile = File("");
  bool isMerchantSetupActive = false;
  TextEditingController firstName = TextEditingController();
  final _form = GlobalKey<FormState>();
  String title = '';
  String buttonTitle = 'Continue';
  TextEditingController lastName = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController phone = TextEditingController();
  bool? geo = false;
  bool errorText = false;
  String country = 'US';
  String dialCode = "1";
  double lat = 0, lng = 0;
  bool emailReadOnly = false, phoneReadOnly = false;
  String? merchantUrl;
  late final userController = context.read<UserController>();
  late final userController2 = context.watch<UserController>();

  /// #Timer
  final Duration _duration = const Duration(seconds: 15);
  final CountDownController _countDownController = CountDownController();
  bool isTimeComplete = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstName.text = userController.user?.name ?? "";
    lastName.text = userController.user?.lastName ?? "";
    emailC.text = userController.user?.email ?? "";
    phone.text = userController.user?.phone ?? "";
    if (widget.editProfile) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: widget.editProfile
          ? BaseView(
              bgImage: '',
              child: body(),
            )
          : CustomBackgroundImage(
              image: ImagePath.bgImage1,
              child: SafeArea(
                child: body(),
              ),
            ),
    );
  }

  body() {
    return Form(
      key: _form,
      child: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: CustomAppBar(
              screenTitle: title,
              leading: CustomBackButton(),
              bottom: 0.h,
            ),
          ),
          Expanded(
            child: CustomPadding(
              topPadding: 2.h,
              child: ListView(
                reverse: false,
                physics: const BouncingScrollPhysics(),
                children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          ImageGalleryClass().imageGalleryBottomSheet(
                              context: context,
                              onMediaChanged: (val) {
                                if (val != null) {
                                  imageProfile = File(val);
                                  setState(() {
                                    errorText = imageProfile.path.isEmpty;
                                  });
                                }
                              });
                        },
                        child: CircleAvatar(
                          radius: 70.0,
                          backgroundColor: MyColors().primaryColor,
                          child: CircleAvatar(
                              radius: 65.0,
                              backgroundImage: (imageProfile.path == ""
                                  ? (context
                                                  .read<UserController>()
                                                  .user
                                                  ?.profileImage ??
                                              "")
                                          .isNotEmpty
                                      ? NetworkImage(API.public_url +
                                          (context
                                                  .read<UserController>()
                                                  .user
                                                  ?.profileImage ??
                                              ""))
                                      : const AssetImage(ImagePath.noUserImage)
                                  : FileImage(imageProfile)) as ImageProvider,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  backgroundColor: MyColors().whiteColor,
                                  radius: 14.0,
                                  child: CircleAvatar(
                                    backgroundColor: MyColors().primaryColor,
                                    radius: 13.0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        ImageGalleryClass()
                                            .imageGalleryBottomSheet(
                                                context: context,
                                                onMediaChanged: (val) {
                                                  if (val != null) {
                                                    imageProfile = File(val);
                                                    setState(() {
                                                      errorText = imageProfile
                                                          .path.isEmpty;
                                                    });
                                                  }
                                                });
                                      },
                                      child: Image.asset(
                                        ImagePath.editIcon,
                                        scale: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      )),
                  if (errorText)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Image can't be empty",
                          style: TextStyle(
                            color:
                                widget.editProfile ? Colors.red : Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 3.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextField(
                        controller: firstName,
                        hintText: business ? "Business Name" : 'First Name',
                        maxLength: 30,
                        prefixWidget: Image.asset(
                          ImagePath.person,
                          scale: 2,
                          color: widget.editProfile
                              ? MyColors().primaryColor
                              : MyColors().primaryColor,
                        ),
                        backgroundColor:
                            !widget.editProfile ? null : MyColors().container,
                        validation: (p0) => p0?.validateEmpty(
                            business ? "Business Name" : 'First Name'),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      if (!business) ...[
                        MyTextField(
                          controller: lastName,
                          hintText: 'Last Name',
                          maxLength: 30,
                          prefixWidget: Image.asset(ImagePath.person,
                              scale: 2,
                              color: widget.editProfile
                                  ? MyColors().primaryColor
                                  : MyColors().primaryColor),
                          backgroundColor:
                              !widget.editProfile ? null : MyColors().container,
                          validation: (p0) => p0?.validateEmpty("Last Name"),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        )
                      ],
                      if (userController.user?.socialType == null ||
                          userController.user?.socialType == "phone") ...[
                        MyTextField(
                          hintText: 'Email Address',
                          controller: emailC,
                          maxLength: 35,
                          onChanged: (v) {},
                          readOnly: widget.editProfile
                              ? (userController2.user?.emailVerifiedAt != null)
                              : (userController2.user?.email ?? "").isNotEmpty,
                          inputType: TextInputType.emailAddress,
                          prefixWidget: Image.asset(ImagePath.email,
                              scale: 2,
                              color: widget.editProfile
                                  ? MyColors().primaryColor
                                  : MyColors().primaryColor),
                          backgroundColor:
                              !widget.editProfile ? null : MyColors().container,
                          validation: (p0) => p0?.validateEmail,
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                      ],
                      MyTextField(
                        prefixWidget: Image.asset(ImagePath.phone,
                            scale: 2,
                            color: widget.editProfile
                                ? MyColors().primaryColor
                                : MyColors().primaryColor),
                        controller: phone,
                        hintText: 'Phone Number',
                        inputType: TextInputType.phone,
                        contact: true,
                        readOnly: widget.editProfile
                            ? (userController2.user?.socialType == "phone")
                            : (userController2.user?.phone ?? "").isNotEmpty,
                        backgroundColor:
                            !widget.editProfile ? null : MyColors().container,
                        validation: (value) {
                          final cleanedPhoneNumber = value
                              .toString()
                              .replaceAll(RegExp(r'[()-\s]'),
                                  ''); // Remove brackets, dashes, and spaces
                          log(cleanedPhoneNumber);

                          if (cleanedPhoneNumber == null ||
                              !isNumeric(cleanedPhoneNumber)) {
                            return "Phone number field can\"t be empty";
                          }
                          if (cleanedPhoneNumber.length < 10) {
                            return "Invalid Phone Number";
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      if (!business) ...[
                        if (!widget.editProfile)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                  title: "Geo Location",
                                  fontWeight: FontWeight.w500,
                                  size: 15,
                                  clr: widget.editProfile
                                      ? Colors.black
                                      : Colors.white),
                              CustomSwitch(
                                switchValue: geo,
                                onChange: (v) {},
                                onChange2: (v) async {
                                  geo = v;
                                  setState(() {});
                                },
                              )
                            ],
                          ),
                      ] else ...[
                        MyTextField(
                          prefixWidget: Image.asset(ImagePath.location,
                              scale: 2,
                              color: widget.editProfile
                                  ? MyColors().primaryColor
                                  : MyColors().primaryColor),
                          controller: location,
                          hintText: 'Address',
                          readOnly: true,
                          onTap: () async {
                            await getAddress(context);
                          },
                          backgroundColor:
                              !widget.editProfile ? null : MyColors().container,
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        MyTextField(
                          height: 8.h,
                          hintText: 'Description',
                          showLabel: false,
                          maxLines: 5,
                          minLines: 5,
                          controller: description,
                          borderRadius: 25,
                          maxLength: 275,
                          backgroundColor:
                              !widget.editProfile ? null : MyColors().container,
                          validation: (p0) => p0?.validateEmpty("description"),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          if (MediaQuery.of(context).viewInsets.bottom == 0) ...[
            if (widget.editProfile && business) ...[
              MyButton(
                  width: 90.w,
                  title: 'Update Hours',
                  borderColor: MyColors().black,
                  bgColor: MyColors().whiteColor,
                  textColor: MyColors().black,
                  onTap: () {
                    AppNavigation.navigateTo(AppRouteName.SCHEDULE_SCREEN_ROUTE,
                        arguments: ScreenArguments(fromEdit: true));
                  }),
              SizedBox(height: 2.h),
            ],
            MyButton(
                width: 90.w,
                title: buttonTitle,
                onTap: () {
                  onSubmit();
                }),
            SizedBox(height: 2.h),
          ],
        ],
      ),
    );
  }

  Future<void> getAddress(context) async {
    LocationResult t = await Utils().showPlacePicker(context);
    print(t.formattedAddress.toString());
    lat = t.latLng?.latitude ?? 0;
    lng = t.latLng?.longitude ?? 0;
    location.text = t.formattedAddress ?? '';
  }

  onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      errorText = imageProfile.path.isEmpty;
    });
    if ((_form.currentState?.validate() ?? false) && !(errorText)) {
      final role = context.read<UserController>().user?.role;
      if (widget.editProfile) {
        AppNetwork.loadingProgressIndicator();
        await AuthAPIS.completeProfile(
            firstName: firstName.text,
            lastName: role == Role.Business ? lastName.text : null,
            categoryId:
                role == Role.Business ? userController.user?.categoryId : null,
            description: role == Role.Business ? description.text : null,
            isPushNotify: "1",
            address: role == Role.Business ? location.text : null,
            lat: role == Role.Business ? lat : null,
            long: role == Role.Business ? lng : null,
            image: imageProfile);
        AppNavigation.navigatorPop();
        AppNavigation.navigatorPop();
      } else {
        if (role == Role.User) {
          AppNetwork.loadingProgressIndicator();
          final value = await AuthAPIS.completeProfile(
              firstName: firstName.text,
              lastName: lastName.text,
              isPushNotify: "1",
              email: emailC.text != userController.user?.email &&
                      emailC.text.isNotEmpty
                  ? emailC.text
                  : null,
              phone:
                  phone.text != userController.user?.phone ? phone.text : null,
              image: imageProfile);
          AppNavigation.navigatorPop();
          if (value) {
            completeDialog(onTap: () {
              AppNavigation.navigateToRemovingAll(
                  AppRouteName.HOME_SCREEN_ROUTE);
            });
          }

          // final controller =
          //     navigatorKey.currentContext?.read<UserController>();
          // User? user = controller?.user;
          // user?.name = firstName.text;
          // user?.isPushNotify = 1;
          // user?.phone =
          //     phone.text != userController.user?.phone ? phone.text : null;
          // user?.email = emailC.text != userController.user?.email &&
          //         emailC.text.isNotEmpty
          //     ? emailC.text
          //     : null;
          // user?.profileImage = imageProfile.path;
          // AppNavigation.navigateTo(AppRouteName.SUBSCRIPTION_SCREEN_ROUTE,
          //     arguments: ScreenArguments(fromCompleteProfile: true));
        } else {
          Map<String, dynamic> arguments = {
            "name": firstName.text,
            "description": description.text,
            "isPushNotify": 1,
            "address": location.text,
            "lat": lat,
            "lng": lng,
            "email": emailC.text,
            "phone": phone.text,
            "image": imageProfile.path,
          };
          AppNavigation.navigateTo(AppRouteName.SCHEDULE_SCREEN_ROUTE,
              arguments: ScreenArguments(args: arguments, fromEdit: false));
        }
      }
    }
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
                    log('Yaha arha h 2');
                    onTap();
                  },
                ),
              ),
            ),
          );
        });
  }
}
