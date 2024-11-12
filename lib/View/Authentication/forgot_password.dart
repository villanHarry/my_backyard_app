// import 'package:backyard/Component/custom_padding.dart';
// import 'package:backyard/Controller/auth_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// import '../../../Component/custom_buttom.dart';
// import '../../../Utils/image_path.dart';
// import '../../Component/custom_background_image.dart';
// import '../../Component/custom_rectangle_textfield.dart';
// import '../Widget/appLogo.dart';
// import '../base_view.dart';
//
// class ForgotPassword extends StatelessWidget {
//   ForgotPassword({super.key});
//
//   TextEditingController email = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomBackgroundImage(
//       child: CustomPadding(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppLogo(),
//               SizedBox(height:3.h,),
//               CustomRectangulatTextFormField(
//                 controller: email,
//                 hintText: 'EMAIL',
//                 maxLength: 35,
//                 iconPath: ImagePath.emailIcon,
//                 isIcon: false,
//                 title: 'EMAIL',
//                 keyType: TextInputType.emailAddress,
//               ),
//               SizedBox(
//                 height: 3.h,
//               ),
//               MyButton(title: 'GET A CODE', onTap: (){onSubmit(context);}),
//               SizedBox(height:2.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   onSubmit(context){
//     AuthController.i.email=email.text;
//     // AuthController.i.forgetPasswordValidation(context);
//   }
// }
//
