import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
  
class InAppPurchased {
  static InAppPurchased? _instance;
  
  InAppPurchased._a();
  
  factory InAppPurchased() {
    return _instance ??= InAppPurchased._a();
  }

  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> purchasedSubscrption;
  late StreamSubscription<List<PurchaseDetails>> subscriptionStream;
  List<ProductDetails> _product = [];
  List<PurchaseDetails> _purchase = [];
  
  final List<String> _identifiers = ["rc_premium_month", "rc_premium_year"];

  Future<void> initStore() async {
    bool isAvailable = await inAppPurchase.isAvailable();

    if (!isAvailable) {
      _product = [];
      _purchase = [];
      return;
    }

    if (Platform.isIOS) {
      inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    }

    final ProductDetailsResponse productDetailsResponse =
        await inAppPurchase.queryProductDetails(_identifiers.toSet());

    if (productDetailsResponse.error != null) {
      _product = productDetailsResponse.productDetails;
      _purchase = <PurchaseDetails>[];
      return;
    }

    if (productDetailsResponse.productDetails.isEmpty) {
      _product = productDetailsResponse.productDetails;
      _purchase = <PurchaseDetails>[];
      return;
    }

    for (var action in productDetailsResponse.productDetails) {
      _product.add(action);
    }

    log(_product.length.toString());
  }

  Future<void> purchasedStream() async {
    final Stream<List<PurchaseDetails>> purchaseStream =
        inAppPurchase.purchaseStream;

    purchasedSubscrption = purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetails) async {
        listenPurchasedStream(purchaseDetails);
      },
      onDone: () {
        purchasedSubscrption.cancel();
      },
      onError: (e) {},
    );
  }

  Future<void> streamSubscription() async {
    final Stream<List<PurchaseDetails>> streamSubscription =
        inAppPurchase.purchaseStream;

    subscriptionStream = streamSubscription.listen(
      (List<PurchaseDetails> purchasedDetails) async {
        listenPurchasedStream(purchasedDetails);
      },
      onDone: () {
        subscriptionStream.cancel();
      },
      onError: (_) {},
    );
  }

  listenPurchasedStream(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        if (kDebugMode) {
          print("Printing");
        }
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        if (kDebugMode) {
          print("Cancel");
        }
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
          return;
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = purchaseDetails.productID == "rc_premium_month"
              ? await _verifySubscription(purchaseDetails)
              : await _verifyPurchased(purchaseDetails);
          if (valid) {
            unawaited(deleiverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchased();
          }
          break;
        } else {
          BotToast.showText(text: "Error buying an item");
          break;
        }
      }
      if (Platform.isAndroid) {
        if (purchaseDetails.productID == "subscription") {
          final InAppPurchaseAndroidPlatformAddition
              inAppPurchaseStoreKitPlatformAddition = inAppPurchase
                  .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          await inAppPurchaseStoreKitPlatformAddition
              .consumePurchase(purchaseDetails);
        }
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await inAppPurchase.completePurchase(purchaseDetails);
      }
      break;
    }
  }

  Future<void> handleError(IAPError ipaError) async {
    if (kDebugMode) {
      print(ipaError.message);
    }
  }

  Future<void> deleiverProduct(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == "subscription") {
    } else {
      _purchase.add(purchaseDetails);
    }
  }

  Future<bool> _verifySubscription(PurchaseDetails purchasedDetails) async {
    return Future<bool>.value(true);
  }

  Future<bool> _verifyPurchased(PurchaseDetails purchasedDetail) async {
    return Future<bool>.value(true);
  }

  Future<void> _handleInvalidPurchased() async {}

  Future<void> purchaseNonConsumable() async {
    final Completer purchaseCompleter = Completer();
    final SKPaymentQueueWrapper skPaymentQueueWrapper = SKPaymentQueueWrapper();

    try {
      List<SKPaymentTransactionWrapper> skPaymentTransactionWrapper =
          await skPaymentQueueWrapper.transactions();

      for (var transaction in skPaymentTransactionWrapper) {
        await skPaymentQueueWrapper.finishTransaction(transaction);
      }
    } catch (e) {}
    await inAppPurchase
        .buyNonConsumable(
            purchaseParam: PurchaseParam(
                productDetails: _product
                    .singleWhere((data) => data.id == "rc_premium_month")))
        .then((value) {
      purchaseCompleter.complete();
    });

    await purchaseCompleter.future;
  }

  Future<void> purchasedConsumable() async {
    final Completer purchasedCompleter = Completer();
    final SKPaymentQueueWrapper skPaymentQueueWrapper = SKPaymentQueueWrapper();
    final List<SKPaymentTransactionWrapper> skTransaction =
        await skPaymentQueueWrapper.transactions();
    for (var transaction in skTransaction) {
      skPaymentQueueWrapper.finishTransaction(transaction);
    }

    await inAppPurchase
        .buyConsumable(
      purchaseParam: PurchaseParam(
        productDetails:
            _product.singleWhere((data) => _identifiers.contains(data)),
      ),
    )
        .then((value) {
      purchasedCompleter.complete();
    }).onError((error, _) {});

    await purchasedCompleter.future;
  }

  Future<void> restorePurchased() async {
    await inAppPurchase.restorePurchases();
  }


}
