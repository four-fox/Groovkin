import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groovkin/utils/constant.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../model/single_ton_data.dart';

class SubscriptionScreenTwo extends StatefulWidget {
  const SubscriptionScreenTwo({super.key});

  @override
  State<SubscriptionScreenTwo> createState() => _SubscriptionScreenTwoState();
}

class _SubscriptionScreenTwoState extends State<SubscriptionScreenTwo> {
  bool isActive = false;

  void perfomMagic() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]?.isActive == true) {
      isActive =
          customerInfo.entitlements.all[entitlementID]?.isActive ?? false;
      appData.entitlementIsActive = isActive;
      setState(() {});
    } else {
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }

      if (offerings == null || offerings.current == null) {
        // offerings are empty, show a message to your user
      } else {
        // current offering is available, show paywall
        await showModalBottomSheet(
          useRootNavigator: true,
          isScrollControlled: true,
          isDismissible: true,
          context: context,
          builder: (context) {
            return Paywall(offering: offerings!.current!);
          },
        ).then((_) {
          setState(() {});
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    perfomMagic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: isActive == true
              ? const Text(
                  "Your Are Premium User",
                  style: TextStyle(color: Colors.white),
                )
              : const Text(
                  "You Are Not Premium User",
                  style: TextStyle(color: Colors.white),
                )),
    );
  }
}

class Paywall extends StatefulWidget {
  final Offering offering;
  const Paywall({super.key, required this.offering});

  @override
  State<Paywall> createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Wrap(
        children: [
          Container(
            height: 70.0,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            child: const Center(
                child: Text(
              '✨ Groovkin Premium',
            )),
          ),
          const Padding(
            padding:
                EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'Groovkin PREMIUM',
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: widget.offering.availablePackages.length,
            itemBuilder: (context, index) {
              var myProductList = widget.offering.availablePackages;
              return Card(
                color: Colors.black,
                child: ListTile(
                  onTap: () async {
                    CustomerInfo customerInfo =
                        await Purchases.purchasePackage(myProductList[index]);
                    EntitlementInfo? entitlement =
                        customerInfo.entitlements.all[entitlementID];
                    isActive = entitlement?.isActive ?? false;
                    setState(() {});
                  },
                  title: Text(
                    myProductList[index].storeProduct.identifier,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    myProductList[index].storeProduct.description,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    myProductList[index].storeProduct.priceString,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 32, bottom: 16, left: 16.0, right: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // InAppPurchase.instance.restorePurchases(applicationUserName: );
                },
                child: const Text(
                  "Restore",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
