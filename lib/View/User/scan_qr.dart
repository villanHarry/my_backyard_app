import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:backyard/View/Widget/Dialog/offer_availed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_textfield.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/base_view.dart';
import '../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';

class ScanQR extends StatefulWidget {
  bool fromOffer = false;
  ScanQR({this.fromOffer = false});
  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool scan = true;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.fromOffer) {
      Timer(const Duration(seconds: 3), () {
        scannedDialog(onTap: () {
          AppNavigation.navigatorPop();
          AppNavigation.navigatorPop();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        screenTitle: 'Scan QR',
        bgImage: '',
        showAppBar: true,
        showBackButton: true,
        bottomSafeArea: false,
        backgroundColor: Colors.white,
        child: CustomPadding(
          horizontalPadding: 0.w,
          topPadding: 0,
          child: Container(
            // color:  MyColors().primaryColor,
            child: Stack(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: MyColors().whiteColor,
                      borderRadius: 10,
                      borderLength: 130,
                      borderWidth: 10,
                      overlayColor: MyColors().primaryColor,
                      // cutOutBottomOffset:100
                    ),
                  ),
                ),
                Center(child: Image.asset(ImagePath.border, scale: 2))
              ],
            ),
          ),
        ));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      // if(result!.code==HomeController.i.currentSession.value.id && scan){
      //   scan=false;
      //   HomeController.i.verifyQR(context);
      // }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  scannedDialog({required Function onTap}) {
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
              content: OfferAvailedDialog(
                onYes: (v) {
                  onTap();
                },
              ),
            ),
          );
        });
  }
}
