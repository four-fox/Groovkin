import 'package:flutter_stripe/flutter_stripe.dart';

class StripeConfigService {
  static const returnUrl = 'groovkin://stripe-redirect';

  Future<void> configureStripe({
    required String publishableKey,
  }) async {
    if (Stripe.publishableKey == publishableKey) return;
    Stripe.publishableKey = publishableKey;
    Stripe.urlScheme = 'groovkin';
    await Stripe.instance.applySettings();
  }

  Future<void> resetCustomer() async {
    await Stripe.instance.resetPaymentSheetCustomer();
  }
}
