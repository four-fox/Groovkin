import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/payment/stripe_connect_widgets.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/payment/payment_controller.dart';
import 'package:groovkin/payment/payment_widgets.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<PaymentController>()
        ? Get.find<PaymentController>()
        : Get.put(PaymentController());
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Payment Activity"),
      body: GetBuilder<PaymentController>(
        initState: (_) => controller.refreshPaymentMethods(),
        builder: (controller) {
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const StripeConnectBanner(),
              const SizedBox(height: 8),
              Text(
                "Payment Methods",
                style: poppinsMediumStyle(
                  fontSize: 17,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              ...controller.paymentMethods.map(
                (card) => PaymentMethodCardTile(
                  card: card,
                  onSetDefault: () => controller.setDefaultPaymentMethod(card),
                  onDelete: () => controller.deletePaymentMethod(card),
                ),
              ),
              if (controller.paymentMethods.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'No payment method added.\nAdd a secure card before accepting event requests. Your card details are handled securely by Stripe.',
                    textAlign: TextAlign.center,
                    style: poppinsRegularStyle(
                      context: context,
                      fontSize: 14,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.connectOnboardingScreen),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: DynamicColor.darkGrayClr,
                  ),
                  child: Text(
                    'Manage Stripe payout and payment account setup.',
                    style: poppinsRegularStyle(
                      context: context,
                      fontSize: 13,
                      color: DynamicColor.whiteClr,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Transaction History",
                style: poppinsMediumStyle(
                  fontSize: 17,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: DynamicColor.darkGrayClr,
                ),
                child: Row(
                  children: [
                    Icon(Icons.receipt_long_outlined,
                        color: DynamicColor.yellowClr, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Transaction history will appear here after payments are processed.',
                        style: poppinsRegularStyle(
                          context: context,
                          fontSize: 13,
                          color: DynamicColor.whiteClr,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () => Get.toNamed(Routes.addCardDetails),
            text: "Add Secure Card",
          ),
        ),
      ),
    );
  }
}

class ViewAllCardList extends StatelessWidget {
  const ViewAllCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionScreen();
  }
}
