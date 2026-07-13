import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/payment/payment_controller.dart';
import 'package:groovkin/payment/payment_widgets.dart';

class AddCardDetails extends StatelessWidget {
  const AddCardDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final bool fromSignUp = Get.arguments?["fromSignUp"] ?? false;
    final controller = Get.isRegistered<PaymentController>()
        ? Get.find<PaymentController>()
        : Get.put(PaymentController());
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, backArrow: fromSignUp ? false : true),
      body: GetBuilder<PaymentController>(
        builder: (controller) {
          return PaymentStateView(
            state: controller.state,
            message: controller.errorMessage,
            onRetry: controller.addPaymentMethod,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add a secure payment method',
                    style: poppinsMediumStyle(
                      context: context,
                      fontSize: 22,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Groovkin no longer collects card numbers, expiry dates, or security codes. Stripe securely collects and tokenizes your card, then Laravel stores only safe card metadata.',
                    style: poppinsRegularStyle(
                      context: context,
                      fontSize: 14,
                      color: DynamicColor.grayClr,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: DynamicColor.darkGrayClr,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lock, color: DynamicColor.yellowClr),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your card is handled by Stripe PaymentSheet. Do not share card details in support messages.',
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
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (fromSignUp) ...[
                CustomButton(
                  borderClr: Colors.transparent,
                  onTap: () {
                    Get.offAllNamed(Routes.createCompanyProfileScreen,
                        arguments: {
                          "updationCondition": false,
                          "skipBtnHide": false,
                        });
                  },
                  text: "Skip",
                ),
                const SizedBox(height: 5),
              ],
              CustomButton(
                borderClr: Colors.transparent,
                onTap: () async {
                  await controller.addPaymentMethod();
                  if (fromSignUp && controller.errorMessage == null) {
                    Get.offAllNamed(Routes.createCompanyProfileScreen,
                        arguments: {
                          "updationCondition": false,
                          "skipBtnHide": false,
                        });
                  }
                },
                text: "Add Secure Card",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
