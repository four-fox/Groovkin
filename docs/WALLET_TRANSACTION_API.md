# Wallet / Transaction API

Groovkin does **not** implement a stored-value wallet balance.

- EO: Earnings & Payouts (menu label may still say Wallet)
- VM: Payments & Refunds

## Endpoints

All require `Authorization: Bearer <token>`. Never send `user_id`.

| Method | Path | Purpose |
|--------|------|---------|
| GET | `/api/wallet/summary` | Role-aware totals |
| GET | `/api/wallet/transactions` | Normalized history |
| GET | `/api/wallet/transactions/{transaction}` | Detail (`payment:55`) |
| GET | `/api/wallet/payouts` | Connect transfers (not bank payouts) |

Legacy `GET /api/transaction-history` remains for compatibility but is not the marketplace ledger.

## EO summary

```json
{
  "status": true,
  "data": {
    "role": "event_owner",
    "currency": "usd",
    "currencies": [],
    "total_event_principal_minor": 500000,
    "gross_earnings_minor": 500000,
    "groovkin_commission_minor": 50000,
    "net_earnings_minor": 450000,
    "transferred_to_connect_minor": 325000,
    "pending_transfer_minor": 75000,
    "refunded_or_reversed_minor": 25000,
    "disputed_minor": 0,
    "manual_review_minor": 0,
    "completed_events_count": 8,
    "pending_events_count": 2
  },
  "message": "Earnings summary retrieved."
}
```

Multi-currency totals are listed under `currencies[]`. Never add USD and CAD together.

## VM summary

```json
{
  "status": true,
  "data": {
    "role": "venue_manager",
    "currency": "usd",
    "event_principal_paid_minor": 300000,
    "stripe_fees_paid_minor": 9200,
    "total_charged_minor": 309200,
    "refunds_received_minor": 25000,
    "pending_refunds_minor": 10000,
    "disputed_minor": 0,
    "active_event_commitments_minor": 150000,
    "events_paid_count": 6
  },
  "message": "Payments summary retrieved."
}
```

## Transactions

Query params: `page`, `per_page` (max 50), `type`, `status`, `event_id`, `currency`, `date_from`, `date_to`, `direction`.

Normalized entry:

```json
{
  "id": "payment:55",
  "reference": "GK-PAY-000055",
  "event": { "id": 101, "title": "Summer Music Night" },
  "category": "down_payment",
  "direction": "debit",
  "status": "succeeded",
  "currency": "usd",
  "principal_minor": 20000,
  "stripe_fee_minor": 650,
  "groovkin_commission_minor": 0,
  "net_minor": 20650,
  "occurred_at": "2026-07-20T10:00:00+00:00",
  "detail_available": true
}
```

EO view of the same payment uses `category: event_earnings`, `direction: credit`, and net after commission.

### Categories

`down_payment`, `final_balance`, `cancellation_charge`, `event_earnings`, `eo_transfer`, `refund`, `dispute`

### Directions

`credit`, `debit`, `neutral`

Pending and failed rows are included.

## Transaction detail

Opaque IDs: `payment:{id}`, `transfer:{id}`, `refund:{id}`, `dispute:{id}`.

Never returns client secrets, raw Stripe payloads, or another user's Stripe IDs.

## Payouts / transfers

```json
{
  "actual_bank_payout_tracking_enabled": false,
  "message": "Groovkin tracks platform transfers to the connected Stripe account. Bank payout arrival is managed by Stripe and is not tracked in-app.",
  "transfers": [
    {
      "id": "transfer:12",
      "label": "Transferred to Stripe account",
      "status": "transferred",
      "amount_minor": 18000
    }
  ]
}
```

Platform → EO Connect transfers are tracked. Connected-account → bank `payout.*` events are **not** implemented.

## Error codes

| Code | HTTP |
|------|------|
| `unauthorized_wallet_access` | 403 |
| `transaction_not_found` | 404 |
| `payout_tracking_unavailable` | reserved |
