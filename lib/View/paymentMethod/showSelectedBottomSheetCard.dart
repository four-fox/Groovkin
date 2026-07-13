import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/payment/payment_controller.dart';
import 'package:groovkin/payment/payment_widgets.dart';

Future<bool?> showBottomSelectedCardSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return const Showselectedbottomsheetcard();
    },
  );
  return result ?? false;
}

class Showselectedbottomsheetcard extends StatefulWidget {
  const Showselectedbottomsheetcard({super.key});

  @override
  State<Showselectedbottomsheetcard> createState() =>
      _ShowselectedbottomsheetcardState();
}

class _ShowselectedbottomsheetcardState
    extends State<Showselectedbottomsheetcard> {
  late final PaymentController _paymentController;

  @override
  void initState() {
    super.initState();
    _paymentController = Get.isRegistered<PaymentController>()
        ? Get.find<PaymentController>()
        : Get.put(PaymentController());
    _paymentController.refreshPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("assets/grayClor.png"),
          fit: BoxFit.fill,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: GetBuilder<PaymentController>(
        builder: (controller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: DynamicColor.yellowClr,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text(
                "Select Card",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: controller.paymentMethods.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(18),
                        child: Text(
                          'No secure payment methods saved.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.paymentMethods.length,
                        itemBuilder: (context, index) {
                          final card = controller.paymentMethods[index];
                          return PaymentMethodCardTile(
                            card: card,
                            onSetDefault: () async {
                              await controller.setDefaultPaymentMethod(card);
                              if (context.mounted) Navigator.pop(context, true);
                            },
                            onDelete: null,
                          );
                        },
                      ),
              ),
              const SizedBox(height: 8),
              CustomButton(
                borderClr: Colors.transparent,
                onTap: () async {
                  await controller.addPaymentMethod();
                  if (context.mounted) Navigator.pop(context, true);
                },
                text: 'Add Secure Card',
              ),
            ],
          );
        },
      ),
    );
  }
}
