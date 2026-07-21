import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/payment/wallet/wallet_models.dart';

void main() {
  group('Wallet summary', () {
    test('parses EO summary cards', () {
      final summary = WalletSummary.fromJson({
        'role': 'event_owner',
        'currency': 'usd',
        'net_earnings_minor': 450000,
        'transferred_to_connect_minor': 325000,
        'pending_transfer_minor': 75000,
        'groovkin_commission_minor': 50000,
        'refunded_or_reversed_minor': 25000,
        'manual_review_minor': 0,
        'completed_events_count': 8,
        'pending_events_count': 2,
      });

      expect(summary.isEventOwner, isTrue);
      expect(summary.netEarningsMinor, 450000);
      expect(summary.transferredToConnectMinor, 325000);
      expect(summary.completedEventsCount, 8);
    });

    test('parses VM summary cards', () {
      final summary = WalletSummary.fromJson({
        'role': 'venue_manager',
        'currency': 'usd',
        'event_principal_paid_minor': 300000,
        'stripe_fees_paid_minor': 9200,
        'total_charged_minor': 309200,
        'refunds_received_minor': 25000,
        'pending_refunds_minor': 10000,
        'active_event_commitments_minor': 150000,
        'events_paid_count': 6,
      });

      expect(summary.isVenueManager, isTrue);
      expect(summary.totalChargedMinor, 309200);
      expect(summary.stripeFeesPaidMinor, 9200);
    });

    test('keeps multi-currency buckets separate', () {
      final summary = WalletSummary.fromJson({
        'role': 'event_owner',
        'currency': 'usd',
        'net_earnings_minor': 1000,
        'currencies': [
          {'currency': 'cad', 'net_earnings_minor': 2000},
          {'currency': 'eur', 'net_earnings_minor': 3000},
        ],
      });

      expect(summary.currencies.length, 2);
      expect(summary.currencies.first.currency, 'CAD');
      expect(summary.currencies.last.netEarningsMinor, 3000);
      // Never combine currencies into one total.
      expect(summary.netEarningsMinor, 1000);
    });
  });

  group('Wallet transactions', () {
    test('parses empty list', () {
      final page = WalletTransactionPage.fromJson([]);
      expect(page.items, isEmpty);
      expect(page.hasMore, isFalse);
    });

    test('parses paginated history', () {
      final page = WalletTransactionPage.fromJson({
        'data': [
          {
            'id': 'payment:55',
            'reference': 'GK-PAY-000055',
            'event': {'id': 101, 'title': 'Summer Music Night'},
            'category': 'down_payment',
            'direction': 'debit',
            'status': 'succeeded',
            'currency': 'usd',
            'principal_minor': 20000,
            'stripe_fee_minor': 650,
            'groovkin_commission_minor': 0,
            'net_minor': 20650,
            'occurred_at': '2026-07-20T10:00:00+00:00',
            'detail_available': true,
          }
        ],
        'current_page': 1,
        'last_page': 3,
        'per_page': 20,
        'total': 45,
      });

      expect(page.items.length, 1);
      expect(page.hasMore, isTrue);
      expect(page.items.first.category, WalletTransactionCategory.downPayment);
      expect(page.items.first.netMinor, 20650);
    });

    test('uses role-aware category labels', () {
      expect(
        walletCategoryLabel(
          WalletTransactionCategory.downPayment,
          role: WalletRole.venueManager,
        ),
        'Down payment',
      );
      expect(
        walletCategoryLabel(
          WalletTransactionCategory.eventEarnings,
          role: WalletRole.eventOwner,
        ),
        'Event earnings',
      );
      expect(
        walletCategoryLabel(
          WalletTransactionCategory.eoTransfer,
          role: WalletRole.eventOwner,
        ),
        'Organizer transfer',
      );
    });

    test('builds filter query params', () {
      final query = WalletTransactionFilters(
        status: 'succeeded',
        type: 'refund',
        eventId: 10,
        currency: 'usd',
      ).toQuery(page: 2, perPage: 20);

      expect(query['page'], 2);
      expect(query['status'], 'succeeded');
      expect(query['type'], 'refund');
      expect(query['event_id'], 10);
    });
  });

  group('Transaction detail', () {
    test('parses detail with transfer and support fields', () {
      final detail = WalletTransactionDetail.fromJson({
        'id': 'payment:55',
        'reference': 'GK-PAY-000055',
        'category': 'final_balance',
        'direction': 'debit',
        'status': 'succeeded',
        'principal_minor': 80000,
        'stripe_fee_minor': 2400,
        'groovkin_commission_minor': 0,
        'net_minor': 82400,
        'transfer_status': 'pending',
        'support_reference': 'SUP-1',
        'timeline': [
          {'title': 'Final payment succeeded'},
        ],
      });

      expect(detail.category, WalletTransactionCategory.finalBalance);
      expect(detail.transferStatus, 'pending');
      expect(detail.timeline.single['title'], 'Final payment succeeded');
    });
  });

  group('Payouts', () {
    test('parses bank payout tracking disabled response', () {
      final payouts = WalletPayoutsResponse.fromJson({
        'actual_bank_payout_tracking_enabled': false,
        'message':
            'Groovkin tracks platform transfers to the connected Stripe account.',
        'transfers': [
          {
            'id': 'transfer:12',
            'label': 'Transferred to Stripe account',
            'status': 'transferred',
            'amount_minor': 18000,
          }
        ],
      });

      expect(payouts.actualBankPayoutTrackingEnabled, isFalse);
      expect(payouts.transfers.single.amountMinor, 18000);
      expect(payouts.transfers.single.status, 'transferred');
    });
  });
}
