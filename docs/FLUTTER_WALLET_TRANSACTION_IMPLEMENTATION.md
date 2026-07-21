# Flutter Wallet / Transaction Implementation

Groovkin does **not** implement a stored-value wallet balance.

| Role | Screen title | Settings label |
|------|--------------|----------------|
| EO | Earnings & Payouts | Earnings & Payouts |
| VM | Payments & Refunds | Payments & Refunds |

Shared route may still be referred to as Wallet in deep links (`groovkin://wallet`).

## Endpoints

| Method | Path | Flutter |
|--------|------|---------|
| GET | `/api/wallet/summary` | `WalletController.refreshSummary` |
| GET | `/api/wallet/transactions` | paginated list + filters |
| GET | `/api/wallet/transactions/{id}` | detail screen |
| GET | `/api/wallet/payouts` | transfers section |

## Files

- `lib/payment/wallet/wallet_models.dart`
- `lib/payment/wallet/wallet_controller.dart`
- `lib/payment/wallet/wallet_screens.dart`
- Routes: `walletHomeScreen`, `walletTransactionsScreen`, `walletTransactionDetailScreen`

## Summary cards

**EO:** net earnings, transferred to Stripe, pending transfer, Groovkin commission, refunded/reversed, manual review, completed/pending events.

**VM:** event principal paid, Stripe fees paid, total charged, refunds received, pending refunds, active commitments, events paid.

Multi-currency buckets under `currencies[]` are shown separately and never summed across currencies.

## Transactions

- Infinite scroll pagination (`page`, `per_page`)
- Filters: status / type chips (succeeded, processing, failed, refund)
- Pull to refresh
- Empty copy: "Transaction history will appear here after payments are processed."
- Category labels are role-aware (EO earnings vs VM down payment / final payment)
- Stripe fee and Groovkin commission are always separate fields

## Payouts / transfers

When `actual_bank_payout_tracking_enabled` is `false` (current staging):

> Groovkin has transferred these proceeds to your Stripe account. Bank payout timing is managed by Stripe.

Only platform → Connect transfers are listed. The app never claims bank arrival.

## Deep links

- `groovkin://wallet`
- `groovkin://wallet/transactions/{transactionId}`

## Errors

Mapped: `unauthorized_wallet_access`, `transaction_not_found`, `payout_tracking_unavailable`.
