import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
// ignore: depend_on_referenced_packages
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// ignore: depend_on_referenced_packages
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class InAppPurchasedFlutter {
  InAppPurchasedFlutter._interval();

  static InAppPurchasedFlutter _singleton = InAppPurchasedFlutter._interval();

  factory InAppPurchasedFlutter() {
    return _singleton;
  }

  final InAppPurchase inAppPurchase = InAppPurchase.instance;

  late StreamSubscription<List<PurchaseDetails>> inAppSubScription;
  late StreamSubscription<List<PurchaseDetails>> subscription;

  List<ProductDetails> products = [];
  List<PurchaseDetails> purchased = [];

  final List<String> androidProductIds = [];
  final List<String> iosProductIds = [];

  Future<void> initStoreInfo() async {
    final bool isAvailable = await inAppPurchase.isAvailable();
    if (!isAvailable) {
      products = []; 
      purchased = []; 
    }

    if (Platform.isIOS) {
      inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    }
  
    final ProductDetailsResponse productDetailsResponse =
        await inAppPurchase.queryProductDetails(
            Platform.isIOS ? iosProductIds.toSet() : androidProductIds.toSet());

    if (productDetailsResponse.error != null) {
      products = productDetailsResponse.productDetails;
      purchased = <PurchaseDetails>[];
      return;
    }

    if (productDetailsResponse.productDetails.isEmpty) {
      products = productDetailsResponse.productDetails;
      purchased = <PurchaseDetails>[];
      return;
    }
    products = productDetailsResponse.productDetails;
  }

  StreamSubscription<List<PurchaseDetails>> getInAppSubscriptions() {
    final Stream<List<PurchaseDetails>> subscriptionUpdated =
        inAppPurchase.purchaseStream;

    subscription = subscriptionUpdated.listen(
      (List<PurchaseDetails> purchasedDetails) {
        _listenToPurchaseUpdated(purchasedDetails);
      },
      onDone: () {
        subscription.cancel();
      },
    );
    return subscription;
  }

  StreamSubscription<List<PurchaseDetails>> getInAppPurchased() {
    final Stream<List<PurchaseDetails>> purchasedUpdated =
        inAppPurchase.purchaseStream;

    inAppSubScription = purchasedUpdated.listen(
      (List<PurchaseDetails> purchasedDetails) {
        _listenToPurchaseUpdated(purchasedDetails);
      },
      onDone: () {
        inAppSubScription.cancel();
      },
    );
    return inAppSubScription;
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchasedDetails) async {
    for (PurchaseDetails purchaseDetails in purchasedDetails) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        break;
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        break;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = purchaseDetails.productID == "subscription"
              ? await _verifySubscription(purchaseDetails)
              : await _verifyPurchase(purchaseDetails, 1);
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
          break;
        } else {
          break;
        }
        if (Platform.isAndroid) {
          if (purchaseDetails.productID == "subscription") {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await inAppPurchase.completePurchase(purchaseDetails);
        }
        break;
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails, int? badgeId) {
    if (purchaseDetails.productID == "badge_4.99" &&
        purchaseDetails.status == PurchaseStatus.purchased) {
      if (badgeId != null) {
        // addBadge(badgeId);
      }
    }
    return Future<bool>.value(true);
  }

  bool check = false;
  Future<bool> _verifySubscription(PurchaseDetails purchaseDetails) {
    if (check == false) {
      check = true;
      Future.delayed(Duration(seconds: 3), () {
        check = false;
      });

      ProductDetails product =
          products.singleWhere((e) => e.id == "subscription");

      if (purchaseDetails.status == PurchaseStatus.purchased) {
        // addSubscription(
        //   purchaseDetails.transactionDate!,
        //   purchaseDetails.purchaseID!,
        //   purchaseDetails.purchaseID!,
        //   purchaseDetails.productID,
        //   product.rawPrice.toString(),
        //   product.currencyCode,
        // );
      } else {
        // if (subscriptionModel!.data == null) {
        // addSubscription(
        //     purchaseDetails.transactionDate!,
        //     purchaseDetails.purchaseID!,
        //     purchaseDetails.purchaseID!,
        //     purchaseDetails.productID,
        //     product.rawPrice.toString(),
        //     product.currencyCode,
        //     isRestore: true);
        // }
      }
      // if (subscriptionApproved.value == true) {
      //   subscriptionApproved.value = false;
      //   initializeSubscription(
      //     product.rawPrice.toString(),
      //     product.currencyCode,
      //   );
      // }
    }
    return Future<bool>.value(true);
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == "subscription") {
    } else {
      purchased.add(purchaseDetails);
    }
  }

  void handleError(IAPError error) {
    print("error");
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  finishPreviousPaymentAndPurchased() async {
    final Completer<void> purchaseCompleter = Completer();
    final paymentWrapper = SKPaymentQueueWrapper();

    try {
      final transactions = await paymentWrapper.transactions();
      for (var transaction in transactions) {
        await paymentWrapper.finishTransaction(transaction);
      }
    } catch (e) {
      rethrow;
    }

    // calling this here because when i tap on purchase this stream listen and we want to hit api when purchase status to be purchased
    getInAppPurchased();

    if (products.isNotEmpty) {
      // show Dialog
      // You want to pass the product where come from the backend and match that id to our productIds
      // inAppPurchase
      //     .buyConsumable(
      //         purchaseParam: PurchaseParam(productDetails: productDetails))
      //     .then((_) {
      //   purchaseCompleter.complete();
      // });
    }
    await purchaseCompleter.future; // Wait until purchase completes
  }

  finishPaymentSubscription() async {
    final Completer<void> completer = Completer();
    final wrapperTransaction = SKPaymentQueueWrapper();
    final List<SKPaymentTransactionWrapper> transations =
        await wrapperTransaction.transactions();
    for (var transation in transations) {
      wrapperTransaction.finishTransaction(transation);
    }

    await inAppPurchase
        .buyNonConsumable(
            purchaseParam: PurchaseParam(
                productDetails:
                    products.singleWhere((ProductDetails e) => e.id == "")))
        .then((_) {
      completer.complete();
    });

  }

}
