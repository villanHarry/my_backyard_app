import 'dart:async';
import 'dart:developer';

import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_background_image.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/auth_apis.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:backyard/View/Widget/appLogo.dart';
import 'package:provider/provider.dart';
import '../../../Component/custom_text.dart';
import '../../../Utils/my_colors.dart';
import '../../Component/custom_toast.dart';
import 'package:flutter/services.dart';
// import 'package:timer_builder/timer_builder.dart';

class EnterOTPArguements {
  EnterOTPArguements({this.phoneNumber, this.verification});

  String? verification;
  String? phoneNumber;
}

class EnterOTP extends StatefulWidget {
  EnterOTP({Key? key, this.phoneNumber, this.verification}) : super(key: key);

  String? verification;
  final String? phoneNumber;

  @override
  State<EnterOTP> createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  TextEditingController otp = TextEditingController(text: "");

  /// #Timer
  Timer? timer;
  int resend = 0;
  String pinCode = '0';
  final form = GlobalKey<FormState>();
  final FocusNode _otpFocusNode = FocusNode();
  late final userController = context.read<UserController>();

  Future<void> startTimer({bool val = true}) async {
    if (resend == 0) {
      setState(() {
        resend = 59;
      });
      if (val) {
        if (widget.verification != null) {
          AppNetwork.loadingProgressIndicator();
          await resendCode(phoneNumber: widget.phoneNumber ?? "");
          AppNavigation.navigatorPop();
        } else {
          AppNetwork.loadingProgressIndicator();
          final value =
              await AuthAPIS.resendCode(id: userController.user?.id.toString());
          AppNavigation.navigatorPop();
          if (value) {
            CustomToast().showToast(
                message:
                    "We have resend OTP verification code at your email address");
          }
        }
      }
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (resend == 0) {
          timer.cancel();
        } else {
          setState(() {
            resend--;
          });
        }
      });
    } else {
      CustomToast().showToast(message: "Please wait...");
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startTimer(val: false);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundImage(
      child: CustomPadding(
        topPadding: 6 * (1.sh / 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomAppBar(
              screenTitle: '',
              leading: CustomBackButton(),
              bottom: 6.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppLogo(),
                    SizedBox(
                      height: 4.h,
                    ),
                    const MyText(
                      title: 'OTP Verification',
                      size: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    20.verticalSpace,
                    label(
                        label:
                            "We have sent you an email containing 6 digits verification code. Please enter the code to verify your identity."),
                    10.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: otp,
                        onCompleted: (v) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          _onCompleteNavigation();
                        },
                        autoDismissKeyboard: true,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.circle,
                          fieldHeight: 48.r,
                          fieldWidth: 48.r,
                          activeFillColor: MyColors().secondaryColor,
                          inactiveFillColor: MyColors().secondaryColor,
                          selectedFillColor: MyColors().secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                          inactiveColor: MyColors().whiteColor,
                          activeColor: MyColors().whiteColor,
                          selectedColor: MyColors().whiteColor,
                          borderWidth: 1,
                          errorBorderColor: Theme.of(context).colorScheme.error,
                        ),
                        textStyle:
                            TextStyle(color: MyColors().black, fontSize: 15),
                        cursorColor: MyColors().whiteColor,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: false, signed: false),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        enableActiveFill: true,
                      ),
                    ),
                    35.verticalSpace,
                    timerWidget()
                  ],
                ),
              ),
            ),
            if (MediaQuery.of(context).viewInsets.bottom == 0)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 3.h),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Didn't receive a code? ",
                      style: GoogleFonts.roboto(
                          color: MyColors().black, fontSize: 15),
                      children: [
                        TextSpan(
                          text: 'Resend Code',
                          style: GoogleFonts.roboto(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                              color: resend == 0
                                  ? MyColors().black
                                  : MyColors().hintColor,
                              fontSize: 16),
                          recognizer: TapGestureRecognizer()
                            ..onTap = startTimer,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget label({required String label}) {
    return Text(label,
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          height: 1.1.sp,
          fontWeight: FontWeight.w400,
          color: MyColors().black,
        ));
  }

  Widget timerWidget() {
    return Container(
        height: 110.r,
        width: 110.r,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 110.r,
              height: 110.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: MyColors().black, shape: BoxShape.circle),
              child: Text(
                "00:${resend < 10 ? "0$resend" : resend}",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: MyColors().whiteColor),
              ),
            ),
            SizedBox(
                width: 107.r,
                height: 107.r,
                child: CircularProgressIndicator(
                  value: resend / 59,
                  color: MyColors().whiteColor,
                  backgroundColor: Colors.transparent,
                )),
          ],
        ));
  }

  Future<void> resendCode({required String phoneNumber}) async {
    try {
      AppNetwork.loadingProgressIndicator();

      FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+1$phoneNumber",
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential authCredential) async {},
          verificationFailed: (FirebaseAuthException authException) {
            AppNavigation.navigatorPop();
            CustomToast().showToast(message: "Invalid Phone Number");
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            widget.verification = verificationId;
            AppNavigation.navigatorPop();
            CustomToast().showToast(
                message:
                    "We have resend OTP verification code at your phone number",
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 5);
            AppNavigation.navigateTo(
              AppRouteName.ENTER_OTP_SCREEN_ROUTE,
              arguments: EnterOTPArguements(
                phoneNumber: phoneNumber,
                verification: verificationId,
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } catch (error) {
      log("error");
      AppNavigation.navigatorPop();
      CustomToast().showToast(message: error.toString());
    }
  }

  Future<void> verifyPhoneCode(
      {String? phoneNo,
      String? phoneCode,
      required String verificationId,
      required String verificationCode}) async {
    try {
      AppNetwork.loadingProgressIndicator();
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: verificationCode);
      final _user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (_user.user != null) {
        FirebaseAuth.instance.signOut();
        final value = await AuthAPIS.socialLogin(
            phone: phoneNo ?? "",
            socialToken: _user.user?.uid,
            socialType: "phone");
        AppNavigation.navigatorPop();
        if (value) {
          AppNavigation.navigateTo(AppRouteName.HOME_SCREEN_ROUTE);
        } else {
          if (userController.user?.isProfileCompleted != null) {
            if ((userController.user?.isProfileCompleted ?? 0) == 0) {
              AppNavigation.navigateTo(
                  AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE);
            }
          }
        }
      }
    } catch (error) {
      AppNavigation.navigatorPop();
      CustomToast().showToast(message: 'Invalid OTP verification code');
      otp.clear();
    }
  }

  Future<void> _onCompleteNavigation() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (widget.verification != null) {
      await verifyPhoneCode(
          phoneNo: widget.phoneNumber,
          verificationId: widget.verification ?? "",
          verificationCode: otp.text);
    } else {
      AppNetwork.loadingProgressIndicator();
      final value = await AuthAPIS.verifyAccount(
          otpCode: otp.text, id: userController.user?.id ?? 0);
      AppNavigation.navigatorPop();
      if (value) {
        CustomToast()
            .showToast(message: 'Account validation completed. OTP verified');
        navigation();
      } else {
        // CustomToast().showToast(message: 'Invalid OTP verification code');
        otp.clear();
      }
    }
  }

  void navigation() async {
    if (userController.user?.isProfileCompleted == 1) {
      AppNavigation.navigateTo(AppRouteName.HOME_SCREEN_ROUTE);
    } else {
      AppNavigation.navigateTo(AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE);
    }
  }

  /// #Timer
}
