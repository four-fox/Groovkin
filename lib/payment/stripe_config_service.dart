import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeConfigService {
  static const returnUrl = 'groovkin://stripe-redirect';

  /// Cached locally because reading [Stripe.publishableKey] throws
  /// [StripeConfigException] when the key has never been set.
  String? _configuredPublishableKey;

  Future<void> configureStripe({
    required String publishableKey,
  }) async {
    final key = publishableKey.trim();
    if (!_isValidPublishableKey(key)) {
      throw StripeConfigException(
        'Publishable key is missing or invalid. Payment setup is temporarily unavailable.',
      );
    }

    // Skip applySettings only when this exact key is already configured.
    // Never compare against Stripe.publishableKey before it has been set —
    // the getter throws "Publishable key is not set".
    if (_configuredPublishableKey == key) {
      return;
    }

    Stripe.publishableKey = key;
    Stripe.urlScheme = 'groovkin';
    await Stripe.instance.applySettings();
    _configuredPublishableKey = key;

    if (kDebugMode) {
      debugPrint(
        '[Stripe] Configured publishable key '
        '${key.substring(0, key.length < 12 ? key.length : 12)}...',
      );
    }
  }

  Future<void> resetCustomer() async {
    await Stripe.instance.resetPaymentSheetCustomer();
  }

  static bool _isValidPublishableKey(String key) {
    return key.startsWith('pk_test_') || key.startsWith('pk_live_');
  }
}
