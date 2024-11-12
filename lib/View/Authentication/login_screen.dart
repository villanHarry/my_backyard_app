import 'package:backyard/Arguments/screen_arguments.dart';
import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_background_image.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_textfield.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Component/validations.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/auth_apis.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:backyard/View/Widget/appLogo.dart';
import '../../Component/custom_buttom.dart';
import '../../Component/custom_terms_condition.dart';
import '../../Component/custom_text.dart';
import '../../Utils/image_path.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundImage(
      child: CustomPadding(
        topPadding: 6.h,
        child: Column(
          children: [
            CustomAppBar(
              screenTitle: '',
              leading: CustomBackButton(),
              bottom: 6.h,
            ),
            AppLogo(
              onTap: () {},
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    MyText(
                      title: 'Login With Email',
                      size: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Form(
                      key: _form,
                      child: MyTextField(
                        hintText: 'Email',
                        controller: email,
                        maxLength: 35,
                        inputType: TextInputType.emailAddress,
                        prefixWidget: Image.asset(
                          ImagePath.email,
                          scale: 2,
                          color: MyColors().primaryColor,
                        ),
                        validation: (p0) => p0?.validateEmail,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    MyButton(
                        title: 'Continue',
                        onTap: () {
                          onSubmit();
                        }),
                  ],
                ),
              ),
            ),
            if (MediaQuery.of(context).viewInsets.bottom == 0) ...[
              const CustomTermsCondition(),
              SizedBox(
                height: 4.h,
              ),
            ],
          ],
        ),
      ),
    );
  }

  onSubmit() async {
    if (_form.currentState?.validate() ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();
      AppNetwork.loadingProgressIndicator();
      final val = await AuthAPIS.signIn(email: email.text);
      AppNavigation.navigatorPop();
      if (val) {
        CustomToast().showToast(
            message:
                "OTP Verification code has been sent to your email address",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5);

        AppNavigation.navigateTo(AppRouteName.ENTER_OTP_SCREEN_ROUTE);
      }
    }
  }
}
