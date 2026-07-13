import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/payment/payment_deep_links.dart';
import 'package:groovkin/payment/payment_models.dart';

void main() {
  test('reads error code from direct and nested backend envelopes', () {
    expect(readErrorCode({'code': 'payment_failed'}), 'payment_failed');
    expect(
      readErrorCode({
        'data': {'code': 'cancellation_quote_confirmation_required'}
      }),
      'cancellation_quote_confirmation_required',
    );
  });

  test('formats integer minor-unit money without doubles in models', () {
    final formatter = MoneyFormatter();
    expect(formatter.formatMinor(12345, currency: 'USD'), contains('123.45'));
    expect(formatter.formatMinor(1200, currency: 'JPY'), contains('1,200'));
    expect(formatter.formatMinor(null), 'Pending');
  });

  test('parses payment summary and acceptance responses', () {
    final summary = PaymentSummary.fromJson({
      'event_principal_minor': 100000,
      'down_payment_percentage': '25.0000',
      'down_payment_principal_minor': 25000,
      'remaining_principal_minor': 75000,
      'estimated_down_payment_stripe_fee_minor': 776,
      'target_total_groovkin_commission_minor': 10000,
    });
    expect(summary.eventPrincipalMinor, 100000);
    expect(summary.downPaymentPrincipalMinor, 25000);

    final acceptance = EventAcceptanceResult.fromJson({
      'payment_required': true,
      'client_secret': 'pi_secret',
      'publishable_key': 'pk_test',
      'payment': {
        'id': 55,
        'status': 'processing',
        'charge_amount_minor': 26030,
      }
    });
    expect(acceptance.paymentRequired, isTrue);
    expect(acceptance.payment!.status, GroovkinPaymentStatus.processing);
  });

  test('parses cancellation quote without client-calculated fields', () {
    final quote = CancellationQuote.fromJson({
      'id': 9,
      'policy_version': 'groovkin-cancellation-v1',
      'event_timezone_snapshot': 'America/New_York',
      'days_before_event': 14,
      'tier': 'vm_14_to_31_days',
      'event_principal_minor': 100000,
      'additional_principal_due_minor': 0,
      'principal_refund_due_minor': 25000,
      'manual_review_reasons': ['force_majeure'],
    });
    expect(quote.id, 9);
    expect(quote.principalRefundDueMinor, 25000);
    expect(quote.manualReviewReasons.single, 'force_majeure');
  });

  test('parses payment deep links', () {
    expect(
      PaymentDeepLink.parse('groovkin://payments/55')!.paymentId,
      55,
    );
    expect(
      PaymentDeepLink.parse('groovkin://events/99/completion')!.eventId,
      99,
    );
    expect(
      PaymentDeepLink.parse('groovkin://cancellations/7')!.cancellationId,
      7,
    );
    expect(
      PaymentDeepLink.parse('groovkin://stripe-connect/status')!.workflow,
      'stripe_connect',
    );
  });
}
