// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class SubscriptionTest extends GetxController {
  SubscriptionTest._interval();

  late StreamSubscription streamSubscription;
  List<PurchaseDetails> purchases = [];
  List<ProductDetails> products = [];
  static SubscriptionTest? singleton;

  final InAppPurchase inAppPurchase = InAppPurchase.instance;

  factory SubscriptionTest() {
    return singleton ??= SubscriptionTest._interval();
  }

  List<String> ids = ["rc_premium_month", "rc_premium_year"];

  fetchInitialSubscription() async {
    final bool isAvailable = await inAppPurchase.isAvailable();
    if (!isAvailable) {
      products = <ProductDetails>[];
      purchases = <PurchaseDetails>[];
    }

    if (Platform.isIOS) {
      inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    }

    ProductDetailsResponse productDetailsResponse =
        await inAppPurchase.queryProductDetails(ids.toSet());
    if (productDetailsResponse.productDetails.isEmpty) {
      products = productDetailsResponse.productDetails;
      purchases = <PurchaseDetails>[];
      return;
    }
    if (productDetailsResponse.error != null) {
      products = productDetailsResponse.productDetails;
      purchases = <PurchaseDetails>[];
      return;
    }

    products = productDetailsResponse.productDetails;
  }

  @override
  void onInit() {
    super.onInit();
    fetchInitialSubscription();
    streamSubscription = inAppPurchase.purchaseStream.listen(
        (List<PurchaseDetails> subscriptionDetails) {
      _listenSubscription(subscriptionDetails);
    }, onDone: () {
      streamSubscription.cancel();
    }, onError: (error) {});
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  _listenSubscription(List<PurchaseDetails> subscriptionDetails) async {
    for (var purchasedDetails in subscriptionDetails) {
      if (purchasedDetails.status == PurchaseStatus.pending) {
        break;
      } else if (purchasedDetails.status == PurchaseStatus.canceled) {
        break;
      } else {
        if (purchasedDetails.status == PurchaseStatus.error) {
          handleError(purchasedDetails.error);
        } else if (purchasedDetails.status == PurchaseStatus.purchased ||
            purchasedDetails.status == PurchaseStatus.restored) {
          final bool valid = purchasedDetails.productID == "subscription"
              ? await verifySubscription(purchasedDetails)
              : verifyPurchased(purchasedDetails);
          if (valid) {
            unawaited(deliverProduct(purchasedDetails));
          } else {
            _handleInvalidPurchase(purchasedDetails);
            return;
          }
          break;
        } else {
          break;
        }
        if (Platform.isAndroid) {
          if (purchasedDetails.productID == "subsciption") {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchasedDetails);
          }
        }
        if (purchasedDetails.pendingCompletePurchase) {
          await inAppPurchase.completePurchase(purchasedDetails);
        }
        break;
      }
    }
  }

  finishPaymentSubscription(PurchaseDetails purchasedDeails) async {
    final Completer<void> completer = Completer();
    final wrapperTrancsition = SKPaymentQueueWrapper();
    final List<SKPaymentTransactionWrapper> transations =
        await wrapperTrancsition.transactions();

    for (var element in transations) {
      SKPaymentQueueWrapper().finishTransaction(element);
    }

    await inAppPurchase
        .buyNonConsumable(
            purchaseParam: PurchaseParam(
                productDetails: products
                    .singleWhere((data) => data.id == "rc_premium_month")))
        .then((_) {
      completer.complete();
    });
  }

  deliverProduct(PurchaseDetails purchasedDetais) async {
    if (purchasedDetais.productID == "subscription") {
    } else {
      purchases.add(purchasedDetais);
    }
  }

  _handleInvalidPurchase(PurchaseDetails purchasedDetails) async {}

  verifySubscription(PurchaseDetails purchasedDetails) async {
    return Future<bool>.value(true);
  }

  verifyPurchased(PurchaseDetails purchasedDetails) async {
    return Future<bool>.value(true);
  }

  handleError(IAPError? error) {
    log("Error ${error.toString()}");
  }
}
