import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/main.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class AppInAppPurchase {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  Stream<List<PurchaseDetails>> get purchaseStream =>
      _inAppPurchase.purchaseStream;

  // Initialize a singleton instance
  static final AppInAppPurchase _instance = AppInAppPurchase._internal();
  factory AppInAppPurchase() => _instance;
  AppInAppPurchase._internal();

  // Connect to the store
  Future<void> initialize() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      // Handle store not available scenario
      debugPrint('The store is not available');
      return;
    }
    // Load or refresh subscriptions here if needed
  }

  // Fetch products
  Future<void> fetchSubscriptions(List<String> ids) async {
    navigatorKey.currentContext?.read<UserController>().setLoading(true);
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(ids.toSet());
    navigatorKey.currentContext?.read<UserController>().setLoading(true);
    if (response.error != null) {
      // Handle errors here
      CustomToast().showToast(
          message: 'Failed to fetch subscriptions: ${response.error!.message}');
      debugPrint('Failed to fetch subscriptions: ${response.error!.message}');
      return;
    }
    // Use response.productDetails according to your UI/logic needs
    navigatorKey.currentContext
        ?.read<UserController>()
        .setProductDetails(response.productDetails);
    CustomToast().showToast(
        message: "Subscriptions Fetched: ${response.productDetails.length}");
  }

  // Buy a subscription
  Future<void> buySubscription(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  // Complete a purchase
  void completePurchase(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      _inAppPurchase.completePurchase(purchaseDetails);
    }
  }

  // Handle purchase updates
  void handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        completePurchase(purchaseDetails);
        // TODO: Unlock features or content here
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint('Purchase Error: ${purchaseDetails.error}');
      }
    }
  }
}
