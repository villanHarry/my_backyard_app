import 'dart:io';
import 'dart:ui';
import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_dropdown.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_refresh.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Component/custom_textfield.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/category_model.dart';
import 'package:backyard/Service/general_apis.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/Widget/Dialog/custom_dialog.dart';
import 'package:backyard/View/Widget/upload_media.dart';
import 'package:backyard/main.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:backyard/View/base_view.dart';
import 'package:provider/provider.dart';
import '../../../Utils/image_path.dart';
import 'package:sizer/sizer.dart';
import '../../Model/category_product_model.dart';
import '../../Service/navigation_service.dart';

class CreateOffer extends StatefulWidget {
  CreateOffer({super.key, this.edit = false});
  bool edit = false;
  @override
  State<CreateOffer> createState() => _CreateOfferState();
}

class _CreateOfferState extends State<CreateOffer> {
  File permit = File("");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setLoading(true);
      await getCategories();
      setLoading(false);
    });
    // getData();
  }

  Future<void> getCategories() async {
    await GeneralAPIS.getCategories();
  }

  void setLoading(bool val) {
    navigatorKey.currentContext?.read<HomeController>().setLoading(val);
  }

  List<Category> categories = [
    Category(id: 'Category 1', categoryName: 'Category 1'),
    Category(id: 'Category 2', categoryName: 'Category 2'),
    Category(id: 'Category 3', categoryName: 'Category 3'),
  ];
  CategoryModel? selected;

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
        child: CustomRefresh(
          onRefresh: () async {
            await getCategories();
          },
          child: CustomPadding(
            topPadding: 0.h,
            horizontalPadding: 3.w,
            child: Consumer<HomeController>(builder: (context, val, _) {
              return val.loading
                  ? Center(
                      child: CircularProgressIndicator(
                          color: MyColors().primaryColor),
                    )
                  : Column(
                      children: [
                        CustomAppBar(
                          screenTitle:
                              widget.edit ? 'Edit Offer' : "Create Offer",
                          leading: widget.edit ? BackButton() : MenuIcon(),
                          trailing: widget.edit ? null : NotificationIcon(),
                          bottom: 2.h,
                        ),
                        // Wrap(children: List.generate(, (index) => )),
                        SizedBox(
                          height: 2.h,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                permit.path != ""
                                    ? GestureDetector(
                                        onTap: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();

                                          ImageGalleryClass()
                                              .imageGalleryBottomSheet(
                                                  context: context,
                                                  onMediaChanged: (val) {
                                                    if (val != null) {
                                                      permit = File(val);
                                                    }
                                                  });
                                        },
                                        child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          color: MyColors().secondaryColor,
                                          dashPattern: [6, 6, 6, 6],
                                          strokeWidth: 2,
                                          radius: Radius.circular(12),
                                          padding: EdgeInsets.all(6),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            child: Container(
                                              width: 100.w,
                                              height: 12.h,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: (permit.path == ""
                                                        ?
                                                        // AuthController.i.user.value.permit!=''?
                                                        // NetworkImage(APIEndpoints.baseImageURL+AuthController.i.user.value.permit) :
                                                        const AssetImage(
                                                            ImagePath
                                                                .noUserImage)
                                                        : FileImage(
                                                            permit)) as ImageProvider),
                                                //   color: MyColors().secondaryColor.withOpacity(.26),
                                                // border: Border.all(
                                                //   color: MyColors().secondaryColor
                                                // )
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    :
                                    // AuthController.i.user.value.permit!=''?
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     FocusManager.instance.primaryFocus?.unfocus();
                                    //     Get.bottomSheet(
                                    //       UploadMedia(
                                    //         file: (val) {
                                    //           permit.value = val!;
                                    //         },
                                    //         singlePick: true,
                                    //       ),
                                    //       isScrollControlled: true,
                                    //       backgroundColor: Theme
                                    //           .of(context)
                                    //           .selectedRowColor,
                                    //       shape: const RoundedRectangleBorder(
                                    //           borderRadius: BorderRadius.only(
                                    //               topLeft: Radius.circular(20),
                                    //               topRight: Radius.circular(20)
                                    //           )
                                    //       ),
                                    //     );
                                    //   },
                                    //   child: DottedBorder(
                                    //     borderType: BorderType.RRect,
                                    //     color: MyColors().primaryColor,
                                    //     dashPattern: [6, 6, 6, 6],
                                    //     strokeWidth: 2,
                                    //     radius: Radius.circular(12),
                                    //     padding: EdgeInsets.all(6),
                                    //     child: ClipRRect(
                                    //       borderRadius: BorderRadius.all(Radius.circular(12)),
                                    //       child: Container(
                                    //         width: 100.w,
                                    //         height: 12.h,
                                    //         decoration: BoxDecoration(
                                    //           image: DecorationImage(
                                    //               fit: BoxFit.cover,
                                    //               image:
                                    //               (permit.value.path == ""?
                                    //               AuthController.i.user.value.permit!=''?
                                    //               NetworkImage(APIEndpoints.baseImageURL+AuthController.i.user.value.permit) :
                                    //               const AssetImage(ImagePath.noUserImage) :
                                    //               FileImage(permit.value)) as ImageProvider
                                    //           ),
                                    //           //   color: MyColors().secondaryColor.withOpacity(.26),
                                    //           // border: Border.all(
                                    //           //   color: MyColors().secondaryColor
                                    //           // )
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ):
                                    uploadMedia(),
                                SizedBox(height: 2.h),
                                customTitle(
                                  title: 'Title',
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                MyTextField(
                                  hintText: 'Title',
                                  // controller: name,
                                  maxLength: 32,
                                  showLabel: false,
                                  backgroundColor: MyColors().container,
                                  // borderColor: MyColors().secondaryColor,
                                  // hintTextColor: MyColors().grey,
                                  // textColor: MyColors().black,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                customTitle(
                                  title: 'Select Category',
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                CustomDropDown2(
                                  hintText: 'Select Category',
                                  bgColor: MyColors().container,
                                  dropDownData: val.categories,
                                  dropdownValue: selected,
                                  validator: (v) {
                                    selected = v;
                                    setState(() {});
                                  },
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                customTitle(
                                  title: 'Actual Price',
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                MyTextField(
                                  hintText: 'Actual Price',
                                  // controller: name,
                                  maxLength: 6,
                                  inputType: TextInputType.number,
                                  showLabel: false,
                                  onlyNumber: true,
                                  backgroundColor: MyColors().container,
                                  // borderColor: MyColors().secondaryColor,
                                  // hintTextColor: MyColors().grey,
                                  // textColor: MyColors().black,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                customTitle(
                                  title: 'Discount Price',
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                MyTextField(
                                  hintText: 'Discount Price',
                                  // controller: name,
                                  maxLength: 6,
                                  inputType: TextInputType.number,
                                  showLabel: false,
                                  onlyNumber: true,
                                  backgroundColor: MyColors().container,
                                  // borderColor: MyColors().secondaryColor,
                                  // hintTextColor: MyColors().grey,
                                  // textColor: MyColors().black,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),

                                customTitle(
                                  title: 'Reward Points',
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                MyTextField(
                                  hintText: 'Reward Points',
                                  // controller: name,
                                  maxLength: 6,
                                  inputType: TextInputType.number,
                                  showLabel: false,
                                  onlyNumber: true,
                                  backgroundColor: MyColors().container,
                                  // borderColor: MyColors().secondaryColor,
                                  // hintTextColor: MyColors().grey,
                                  // textColor: MyColors().black,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                customTitle(
                                  title: 'Short Details',
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                MyTextField(
                                  height: 8.h,
                                  hintText: 'Short Details', showLabel: false,
                                  maxLines: 5, minLines: 5,
                                  // controller: description,
                                  borderRadius: 25, maxLength: 275,
                                  backgroundColor: MyColors().container,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                customTitle(
                                  title: 'Description',
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                MyTextField(
                                  height: 8.h,
                                  hintText: 'Description', showLabel: false,
                                  maxLines: 5, minLines: 5,
                                  // controller: description,
                                  borderRadius: 25, maxLength: 275,
                                  backgroundColor: MyColors().container,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                MyButton(
                                  title: 'Continue',
                                  onTap: () {
                                    completeDialog();
                                  },
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                // SizedBox(height: 10.h,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
            }),
          ),
        ),
      ),
    );
  }

  customTitle({required String title}) {
    return Padding(
      padding: EdgeInsets.only(left: 3.w),
      child: MyText(title: title),
    );
  }

  uploadMedia() {
    return Container(
      // height: 40.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                ImageGalleryClass().imageGalleryBottomSheet(
                    context: context,
                    onMediaChanged: (val) {
                      if (val != null) {
                        permit = File(val);
                      }
                    });
              },
              child: Container(
                width: 100.w,
                height: 12.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  image: DecorationImage(
                      image: AssetImage(
                        ImagePath.dottedBorder,
                      ),
                      fit: BoxFit.fill),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(ImagePath.upload,
                        scale: 2, color: MyColors().primaryColor),
                    SizedBox(
                      height: 1.h,
                    ),
                    MyText(
                      title: 'Upload image',
                      size: 16,
                      clr: MyColors().black,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 2.h,
          ),
          // Wrap(children: List.generate(imagePath.length, (index) => Padding(
          //   padding:  EdgeInsets.symmetric(horizontal:2.w,vertical: 2.w),
          //   child: Container(
          //       width: 25.w,
          //       height: 25.w,
          //       // alignment: Alignment.center,
          //       decoration: BoxDecoration(
          //           color: MyColors().whiteColor,
          //           borderRadius: BorderRadius.circular(3),
          //           border: Border.all(color: MyColors().primaryColor),
          //           image: index < imagePath.length
          //               ? DecorationImage(
          //               image:( imagePath[index].isNetwork?NetworkImage(
          //                   APIEndpoints.baseImageURL+imagePath[index].path
          //               ): FileImage(
          //                 File(imagePath[index].path),
          //               )) as ImageProvider,
          //               fit: BoxFit.cover)
          //               : null),
          //       child: index < imagePath.length
          //           ? Align(
          //           alignment: Alignment.topRight,
          //           child: GestureDetector(
          //               onTap: () {
          //                 if(onTapRemove!=null)
          //                 {
          //                   onTapRemove!();
          //                 }
          //                 imagePath.removeAt(index);
          //               },
          //               child: Icon(
          //                 Icons.cancel,
          //                 color: MyColors().primaryColor,
          //                 size: 20,
          //               )))
          //           : const SizedBox()),
          // )),)
        ],
      ),
    );
  }

  completeDialog() {
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
              content: CustomDialog(
                title: 'Successfully',
                image: ImagePath.scan3,
                description: widget.edit
                    ? 'Offer have been successfully updated.'
                    : 'Offer have been successfully created.',
                b1: 'Continue',
                b2: 'Download QR Code',
                onYes: (v) {
                  AppNavigation.navigatorPop();
                },
                button2: (v) {
                  downloadDialog();
                },
              ),
            ),
          );
        });
  }

  downloadDialog() {
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
              content: CustomDialog(
                title: 'Download',
                image: ImagePath.download,
                description: 'Are you sure you want to download qr code?',
                b1: 'Continue',
                onYes: (v) {
                  AppNavigation.navigatorPop();
                  CustomToast()
                      .showToast(message: 'QR Code downloaded successfully');
                },
              ),
            ),
          );
        });
  }
}
