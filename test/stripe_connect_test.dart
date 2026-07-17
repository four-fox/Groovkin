import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/payment/event_acceptance_coordinator.dart';
import 'package:groovkin/payment/payment_deep_links.dart';
import 'package:groovkin/payment/payment_models.dart';
import 'package:groovkin/payment/stripe_connect_models.dart';

void main() {
  group('StripeConnectStatus', () {
    test('parses complete connect status JSON', () {
      final status = StripeConnectStatus.fromJson({
        'account_id': 'acct_1234567890',
        'charges_enabled': true,
        'payouts_enabled': true,
        'details_submitted': true,
        'onboarding_complete': true,
        'requirements_due': [],
      });

      expect(status.accountId, 'acct_1234567890');
      expect(status.chargesEnabled, isTrue);
      expect(status.payoutsEnabled, isTrue);
      expect(status.onboardingComplete, isTrue);
      expect(connectStatusIsReady(status), isTrue);
    });

    test('parses incomplete status with requirements due', () {
      final status = StripeConnectStatus.fromJson({
        'account_id': 'acct_abc',
        'charges_enabled': false,
        'payouts_enabled': false,
        'details_submitted': false,
        'onboarding_complete': false,
        'requirements_due': ['individual.email', 'external_account'],
      });

      expect(status.onboardingComplete, isFalse);
      expect(status.requirementsDue, ['individual.email', 'external_account']);
      expect(connectStatusNeedsAction(status), isTrue);
    });
  });

  group('StripeOnboardingLink', () {
    test('parses onboarding link envelope', () {
      final link = StripeOnboardingLink.fromJson({
        'account_id': 'acct_123',
        'onboarding': {
          'url': 'https://connect.stripe.com/setup/e/acct_123/abcdef',
        },
      });

      expect(link.accountId, 'acct_123');
      expect(
        link.url,
        'https://connect.stripe.com/setup/e/acct_123/abcdef',
      );
      expect(isValidStripeOnboardingUrl(link.url), isTrue);
    });

    test('rejects malformed onboarding URLs', () {
      expect(isValidStripeOnboardingUrl(null), isFalse);
      expect(isValidStripeOnboardingUrl(''), isFalse);
      expect(
          isValidStripeOnboardingUrl('http://connect.stripe.com/x'), isFalse);
      expect(isValidStripeOnboardingUrl('https://example.com'), isFalse);
    });
  });

  group('StripeConnectCopy', () {
    test('uses EO payout copy when incomplete', () {
      expect(
        StripeConnectCopy.title(StripeConnectRole.eventOrganizer),
        'Complete Payout Setup',
      );
      expect(
        StripeConnectCopy.primaryButton(StripeConnectRole.eventOrganizer),
        'Complete Payout Setup',
      );
      expect(
        StripeConnectCopy.description(StripeConnectRole.eventOrganizer),
        'Connect your Stripe account so Groovkin can securely transfer event earnings to you.',
      );
    });

    test('uses EO payout copy when complete', () {
      expect(
        StripeConnectCopy.completeTitle(StripeConnectRole.eventOrganizer),
        'Payout Setup Complete',
      );
      expect(
        StripeConnectCopy.completeDescription(StripeConnectRole.eventOrganizer),
        'Your Stripe payout setup is complete and your account is ready for Groovkin payment workflows.',
      );
    });

    test('uses VM payment setup copy when incomplete', () {
      expect(
        StripeConnectCopy.title(StripeConnectRole.venueManager),
        'Complete Payment Account Setup',
      );
      expect(
        StripeConnectCopy.primaryButton(StripeConnectRole.venueManager),
        'Complete Payment Setup',
      );
      expect(
        StripeConnectCopy.description(StripeConnectRole.venueManager),
        'Complete secure Stripe verification before accepting and paying for events through Groovkin.',
      );
    });

    test('uses VM payment setup copy when complete', () {
      expect(
        StripeConnectCopy.completeTitle(StripeConnectRole.venueManager),
        'Payment Setup Complete',
      );
      expect(
        StripeConnectCopy.completeDescription(StripeConnectRole.venueManager),
        'Your Stripe payment account setup is complete. Add a secure card before accepting event requests.',
      );
    });
  });

  group('Verification row label', () {
    test('is Complete when onboarding complete', () {
      final status = StripeConnectStatus.fromJson({
        'onboarding_complete': true,
        'details_submitted': true,
      });
      expect(connectVerificationLabel(status), 'Complete');
    });

    test('is Action needed when requirements are due', () {
      final status = StripeConnectStatus.fromJson({
        'onboarding_complete': false,
        'details_submitted': true,
        'requirements_due': ['individual.email'],
      });
      expect(connectVerificationLabel(status), 'Action needed');
    });

    test('is Pending while Stripe reviews submitted details', () {
      final status = StripeConnectStatus.fromJson({
        'onboarding_complete': false,
        'details_submitted': true,
        'requirements_due': [],
      });
      expect(connectVerificationLabel(status), 'Pending');
      expect(connectVerificationLabel(null), 'Pending');
    });
  });

  group('StripeConnectRequirementLabel', () {
    test('maps known requirements to safe labels', () {
      expect(
        StripeConnectRequirementLabel.labelFor('individual.email'),
        'Email address',
      );
    });

    test('falls back for unknown requirements', () {
      expect(
        StripeConnectRequirementLabel.labelFor('custom.unknown_field'),
        'Unknown Field',
      );
    });
  });

  group('Event acceptance blockers', () {
    test('blocks VM when VM connect is incomplete', () {
      expect(
        resolveAcceptanceBlocker(
          vmOnboardingComplete: false,
          errorCode: 'connect_onboarding_incomplete',
        ),
        EventAcceptanceBlocker.vmConnectIncomplete,
      );
    });

    test('blocks EO when VM is complete but backend still rejects connect', () {
      expect(
        resolveAcceptanceBlocker(
          vmOnboardingComplete: true,
          errorCode: 'connect_onboarding_incomplete',
        ),
        EventAcceptanceBlocker.eoConnectIncomplete,
      );
    });

    test('maps stable vm/eo connect error codes directly', () {
      expect(
        resolveAcceptanceBlocker(
          vmOnboardingComplete: true,
          errorCode: 'vm_connect_onboarding_incomplete',
        ),
        EventAcceptanceBlocker.vmConnectIncomplete,
      );
      expect(
        resolveAcceptanceBlocker(
          vmOnboardingComplete: false,
          errorCode: 'eo_connect_onboarding_incomplete',
        ),
        EventAcceptanceBlocker.eoConnectIncomplete,
      );
    });

    test('maps stripe_configuration_missing to a dedicated blocker', () {
      expect(
        resolveAcceptanceBlocker(
          vmOnboardingComplete: true,
          errorCode: 'stripe_configuration_missing',
        ),
        EventAcceptanceBlocker.stripeConfigurationMissing,
      );
    });

    test('distinguishes network failure from backend validation errors', () {
      expect(
        resolveAcceptanceBlocker(
          vmOnboardingComplete: true,
          errorCode: null,
          httpStatus: 0,
        ),
        EventAcceptanceBlocker.networkError,
      );
      expect(
        resolveAcceptanceBlocker(
          vmOnboardingComplete: true,
          errorCode: null,
          httpStatus: 422,
        ),
        EventAcceptanceBlocker.validationError,
      );
    });

    test('allows acceptance when VM connect and payment method are ready',
        () async {
      final status = StripeConnectStatus.fromJson({
        'onboarding_complete': true,
        'charges_enabled': true,
        'payouts_enabled': true,
      });
      final cards = [
        PaymentMethodCard(
          id: 1,
          paymentMethodId: 'pm_123',
          brand: 'visa',
          last4: '4242',
          expMonth: 12,
          expYear: 2030,
          isDefault: true,
        ),
      ];

      expect(
        await EventAcceptanceCoordinator.evaluateVmReadiness(
          vmStatus: status,
          paymentMethods: cards,
        ),
        EventAcceptanceBlocker.none,
      );
    });

    test('requires payment method when connect is ready but card missing',
        () async {
      final status = StripeConnectStatus.fromJson({
        'onboarding_complete': true,
        'charges_enabled': true,
        'payouts_enabled': true,
      });

      expect(
        await EventAcceptanceCoordinator.evaluateVmReadiness(
          vmStatus: status,
          paymentMethods: const [],
        ),
        EventAcceptanceBlocker.paymentMethodRequired,
      );
    });
  });

  group('Deep link return handling', () {
    test('parses stripe redirect and connect status links', () {
      expect(
        PaymentDeepLink.parse('groovkin://stripe-redirect')!.workflow,
        'stripe_redirect',
      );
      expect(
        PaymentDeepLink.parse('groovkin://stripe-connect/status')!.workflow,
        'stripe_connect',
      );
    });

    test('parses connect return deep link with status query', () {
      final link = PaymentDeepLink.parse(
        'groovkin://stripe-connect/return?status=success',
      )!;
      expect(link.workflow, 'stripe_connect_return');
      expect(link.status, 'success');
      expect(link.isConnectReturn, isTrue);
    });

    test('parses connect refresh deep link as expired session', () {
      final link = PaymentDeepLink.parse(
        'groovkin://stripe-connect/refresh?status=expired',
      )!;
      expect(link.workflow, 'stripe_connect_refresh');
      expect(link.status, 'expired');
      expect(link.isConnectReturn, isTrue);
    });

    test('ignores non-groovkin schemes', () {
      expect(PaymentDeepLink.parse('https://example.com/x'), isNull);
    });
  });

  group('SetupIntent parsing', () {
    test('parses successful setup-intent payload', () {
      final setupIntent = SetupIntentResponse.fromJson({
        'id': 'seti_123',
        'client_secret': 'seti_123_secret_abc',
        'customer': 'cus_123',
        'status': 'requires_payment_method',
        'publishable_key': 'pk_test_abc',
      });
      expect(setupIntent.id, 'seti_123');
      expect(setupIntent.clientSecret, 'seti_123_secret_abc');
      expect(setupIntent.customer, 'cus_123');
      expect(setupIntent.status, 'requires_payment_method');
      expect(setupIntent.publishableKey, 'pk_test_abc');
    });

    test('maps setup-intent API failure to a stable error code', () {
      final response = Response(
        requestOptions: RequestOptions(path: 'payment-methods/setup-intent'),
        statusCode: 200,
        data: {
          'status': false,
          'code': 'stripe_configuration_missing',
          'message':
              'Payment setup is temporarily unavailable. Please contact support.',
        },
      );
      final error = PaymentApiException.fromResponse(response);
      expect(error.code, 'stripe_configuration_missing');
      expect(error.message, contains('temporarily unavailable'));
    });

    test('rejects null or empty publishable_key from SetupIntent payload', () {
      expect(
        () => SetupIntentResponse.fromJson({
          'id': 'seti_123',
          'client_secret': 'seti_123_secret_abc',
          'publishable_key': null,
        }),
        throwsA(
          isA<PaymentApiException>().having(
            (e) => e.code,
            'code',
            'stripe_configuration_missing',
          ),
        ),
      );
    });

    test('marks status-0 responses as retryable network failures', () {
      final response = Response(
        requestOptions: RequestOptions(path: 'payment-methods/setup-intent'),
        statusCode: 0,
        data: {
          'status': false,
          'message': 'Network error',
        },
      );
      final error = PaymentApiException.fromResponse(response);
      expect(error.httpStatus, 0);
      expect(error.retryable, isTrue);
    });
  });

  group('Payment method states', () {
    test('reads card list metadata', () {
      final card = PaymentMethodCard.fromJson({
        'id': 3,
        'payment_method_id': 'pm_abc',
        'brand': 'mastercard',
        'last4': '4444',
        'exp_month': 4,
        'exp_year': 2031,
        'default': true,
        'status': 'active',
      });
      expect(card.brand, 'mastercard');
      expect(card.last4, '4444');
      expect(card.isDefault, isTrue);
      expect(card.isExpired, isFalse);
    });

    test('treats past expiry as expired', () {
      final card = PaymentMethodCard.fromJson({
        'id': 4,
        'payment_method_id': 'pm_old',
        'brand': 'visa',
        'last4': '0002',
        'exp_month': 1,
        'exp_year': 2020,
      });
      expect(card.isExpired, isTrue);
    });
  });

  group('Account masking', () {
    test('masks connect account id safely', () {
      expect(maskConnectAccountId('acct_1234567890'), 'acct...7890');
      expect(maskConnectAccountId(null), 'Not started');
    });
  });
}
