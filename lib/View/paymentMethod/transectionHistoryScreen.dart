import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
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
                    'No secure payment methods saved.',
                    textAlign: TextAlign.center,
                    style: poppinsRegularStyle(
                      context: context,
                      fontSize: 14,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: DynamicColor.darkGrayClr,
                ),
                child: Text(
                  'Detailed transaction and payout history requires a verified backend endpoint. The final payment API reference does not list one, so this screen avoids inventing an endpoint.',
                  style: poppinsRegularStyle(
                    context: context,
                    fontSize: 13,
                    color: DynamicColor.whiteClr,
                  ),
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
            onTap: () => Get.toNamed(Routes.addCardDetails,
                arguments: {"paymentMethod": 2}),
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
