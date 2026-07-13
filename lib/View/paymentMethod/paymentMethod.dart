import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/payment/payment_screens.dart';

class PaymentMethodScreen extends StatelessWidget {
  PaymentMethodScreen({super.key});

  final int paymentMethodVal = Get.arguments?['paymentMethod'] ?? 1;

  @override
  Widget build(BuildContext context) {
    return SecurePaymentMethodScreen();
  }
}

class ViewPaymentMethod extends StatelessWidget {
  const ViewPaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return SecurePaymentMethodScreen();
  }
}
