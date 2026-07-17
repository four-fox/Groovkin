import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:groovkin/payment/payment_models.dart';
import 'package:groovkin/payment/payment_widgets.dart';
import 'package:groovkin/payment/stripe_connect_models.dart';
import 'package:groovkin/payment/stripe_connect_widgets.dart';

Widget _wrap(Widget child) {
  return GetMaterialApp(
    home: Scaffold(body: child),
  );
}

void main() {
  group('PaymentStateView', () {
    testWidgets('success state renders real content, not placeholder copy',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const PaymentStateView(
          state: PaymentWorkflowState.success,
          child: Text('REAL CONTENT'),
        ),
      ));

      expect(find.text('REAL CONTENT'), findsOneWidget);
      expect(find.text('Confirmed'), findsNothing);
      expect(
          find.text('The backend has confirmed this workflow.'), findsNothing);
    });

    testWidgets('empty state shows payment-method empty copy', (tester) async {
      await tester.pumpWidget(_wrap(
        PaymentStateView(
          state: PaymentWorkflowState.empty,
          onRetry: () {},
          child: const SizedBox.shrink(),
        ),
      ));

      expect(find.text('No payment method added'), findsOneWidget);
      expect(
        find.text(
          'Add a secure card before accepting event requests. Your card details are handled securely by Stripe.',
        ),
        findsOneWidget,
      );
      expect(find.text('Add Secure Card'), findsOneWidget);
      expect(find.text('No payment data yet'), findsNothing);
    });

    testWidgets('failure state shows the real backend message', (tester) async {
      await tester.pumpWidget(_wrap(
        PaymentStateView(
          state: PaymentWorkflowState.validationError,
          message: 'Payment setup is temporarily unavailable.',
          onRetry: () {},
          child: const SizedBox.shrink(),
        ),
      ));

      expect(
        find.text('Payment setup is temporarily unavailable.'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Please check your connection'),
        findsNothing,
      );
    });
  });

  group('StripeConnectStatusCard', () {
    testWidgets('renders EO complete state with status rows', (tester) async {
      final status = StripeConnectStatus.fromJson({
        'account_id': 'acct_1234567890',
        'charges_enabled': true,
        'payouts_enabled': true,
        'details_submitted': true,
        'onboarding_complete': true,
        'requirements_due': [],
      });

      await tester.pumpWidget(_wrap(
        SingleChildScrollView(
          child: StripeConnectStatusCard(
            status: status,
            role: StripeConnectRole.eventOrganizer,
          ),
        ),
      ));

      expect(find.text('Payout Setup Complete'), findsOneWidget);
      expect(
        find.text(
          'Your Stripe payout setup is complete and your account is ready for Groovkin payment workflows.',
        ),
        findsOneWidget,
      );
      expect(find.text('Verification'), findsOneWidget);
      expect(find.text('Complete'), findsOneWidget);
      expect(find.text('Charges enabled'), findsOneWidget);
      expect(find.text('Payouts enabled'), findsOneWidget);
      expect(find.text('Yes'), findsNWidgets(2));
      expect(find.text('Requirements due'), findsOneWidget);
      expect(find.text('None'), findsOneWidget);
      expect(find.text('acct...7890'), findsOneWidget);
      expect(find.text('Confirmed'), findsNothing);
      expect(
          find.text('The backend has confirmed this workflow.'), findsNothing);
    });

    testWidgets('renders VM incomplete state with requirements due',
        (tester) async {
      final status = StripeConnectStatus.fromJson({
        'account_id': 'acct_abcdefgh1234',
        'charges_enabled': false,
        'payouts_enabled': false,
        'details_submitted': false,
        'onboarding_complete': false,
        'requirements_due': ['individual.email', 'external_account'],
      });

      await tester.pumpWidget(_wrap(
        SingleChildScrollView(
          child: StripeConnectStatusCard(
            status: status,
            role: StripeConnectRole.venueManager,
            onPrimaryAction: () {},
          ),
        ),
      ));

      expect(find.text('More information required'), findsOneWidget);
      expect(find.text('Action needed'), findsOneWidget);
      expect(find.text('Charges enabled'), findsOneWidget);
      expect(find.text('No'), findsNWidgets(2));
      expect(find.text('• Email address'), findsOneWidget);
      expect(find.text('• Bank account for payouts'), findsOneWidget);
      expect(find.text('Continue Stripe Setup'), findsOneWidget);
    });

    testWidgets('renders VM incomplete copy without requirements',
        (tester) async {
      final status = StripeConnectStatus.fromJson({
        'charges_enabled': false,
        'payouts_enabled': false,
        'details_submitted': true,
        'onboarding_complete': false,
        'requirements_due': [],
      });

      await tester.pumpWidget(_wrap(
        SingleChildScrollView(
          child: StripeConnectStatusCard(
            status: status,
            role: StripeConnectRole.venueManager,
            onPrimaryAction: () {},
          ),
        ),
      ));

      expect(find.text('Complete Payment Account Setup'), findsOneWidget);
      expect(
        find.text(
          'Complete secure Stripe verification before accepting and paying for events through Groovkin.',
        ),
        findsOneWidget,
      );
      expect(find.text('Complete Payment Setup'), findsOneWidget);
    });
  });
}
