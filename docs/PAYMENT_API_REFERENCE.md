# Payment API Reference

All authenticated routes use Sanctum bearer tokens and return:

```json
{ "status": true, "data": {}, "message": "..." }
```

Validation and workflow errors return `status: false`.

## Connect And Payment Methods

`POST /api/stripe/connect/onboarding-link`

Creates or reuses the authenticated user's Express account and returns an onboarding link.

`GET /api/stripe/connect/status`

Returns Connect readiness for the authenticated user:

```json
{
  "status": true,
  "data": {
    "account_id": "acct_...",
    "charges_enabled": true,
    "payouts_enabled": true,
    "details_submitted": true,
    "requirements_due": [],
    "onboarding_complete": true,
    "role": "event_owner",
    "title": "Payout Setup",
    "can_receive_payouts": true,
    "can_accept_payments": true
  },
  "message": "Stripe Connect status retrieved."
}
```

`GET /api/stripe/onboarding/return` (public)

Stripe Account Link return URL. Returns a mobile-friendly HTML page (not JSON) with:

- "Stripe setup complete"
- "You can now return to Groovkin"
- an "Open Groovkin App" button linking to `groovkin://stripe-connect/return?status=success`

The page auto-attempts the deep link after 1.5 seconds.

`GET /api/stripe/onboarding/refresh` (public)

Stripe Account Link refresh URL. Returns a mobile-friendly HTML page with:

- "Stripe setup session expired"
- "Please return to Groovkin and try again"
- an "Open Groovkin App" button linking to `groovkin://stripe-connect/refresh?status=expired`

`POST /api/payment-methods/setup-intent`

Returns a mobile-friendly SetupIntent payload:

```json
{
  "status": true,
  "data": {
    "id": "seti_...",
    "client_secret": "seti_..._secret_...",
    "customer": "cus_...",
    "status": "requires_payment_method",
    "publishable_key": "pk_test_..."
  },
  "message": "SetupIntent created."
}
```

If Stripe is not configured, returns:

```json
{
  "status": false,
  "code": "stripe_configuration_missing",
  "message": "Payment setup is temporarily unavailable. Please contact support."
}
```

`GET /api/payment-methods`

Lists safe card metadata only: `id`, `payment_method_id`, `brand`, `last4`, `exp_month`, `exp_year`, `default`, `status`.

`POST /api/payment-methods/default`

```json
{ "payment_method_id": "pm_..." }
```

Attaches the method to the Stripe Customer if needed and stores safe metadata.

`DELETE /api/payment-methods/{card}`

Soft-removes a stored reusable payment method. The only default method cannot be removed if no replacement exists.

## Proposal And Acceptance

`GET /api/events/{event}/payment-summary`

Returns server-calculated principal, deposit, remaining balance, fee estimate, and commission target in minor units.

`POST /api/events/{event}/accept`

```json
{ "payment_method_id": "pm_optional_default_override" }
```

Requires both EO and VM Connect onboarding and a reusable VM payment method. If down payment is greater than zero, returns `client_secret` for Flutter confirmation. If down payment is zero, acceptance succeeds without a PaymentIntent.

Connect readiness errors return stable `code` values:

```json
{
  "status": false,
  "code": "vm_connect_onboarding_incomplete",
  "message": "Complete your Stripe account setup before accepting this event.",
  "data": {
    "vm_connect_ready": false,
    "eo_connect_ready": true
  }
}
```

Other codes: `eo_connect_onboarding_incomplete`, `connect_onboarding_incomplete`.

`GET /api/payments/{payment}`

Returns payment status and stored ledger fields.

`POST /api/payments/{payment}/resume-authentication`

Returns `client_secret` for an off-session payment in `requires_action`.

`POST /api/payments/{payment}/retry`

Retries supported failed final-balance payments.

## Completion And Counters

`POST /api/events/{event}/completion`

```json
{}
```

EO submits completion. The final principal is the accepted event principal unless a counter is mutually accepted later.

`POST /api/events/{event}/completion/approve`

VM approves completion and starts final payment.

`POST /api/events/{event}/completion/counters`

```json
{ "proposed_principal_minor": 95000, "message": "..." }
```

Creates a counter and pauses auto-settlement. `proposed_principal_minor` must be an integer.

`POST /api/completion-counters/{counter}/revise`

Revises an open counter.

`POST /api/completion-counters/{counter}/accept`

Accepts a counter and starts final payment against the counter principal.

`POST /api/completion-counters/{counter}/reject`

Rejects a counter.

`GET /api/events/{event}/completion/status`

Returns current completion request, latest counter, 48-hour countdown seconds, and counter countdown seconds.

`GET /api/events/{event}/completion/history`

Returns completion requests and counters.

`POST /api/events/{event}/completion/escalate`

Moves the completion workflow to support review.

## Cancellation

`GET /api/events/{event}/cancellation-policy`

Returns active policy version and event principal/deposit snapshot.

`POST /api/events/{event}/cancellations/quote`

```json
{
  "reason_type": "normal",
  "reason_message": "Schedule changed",
  "force_majeure": false
}
```

Returns quote amounts, policy snapshot, expiration, and manual-review reasons.

`POST /api/events/{event}/cancellations`

Compatibility shortcut that quotes then confirms in one request. New clients should use explicit quote then confirm.

`GET /api/events/{event}/cancellations/current`

Returns the latest cancellation for an event.

`GET /api/cancellations/{cancellation}`

Returns cancellation details.

`POST /api/cancellations/{cancellation}/confirm`

Confirms a non-expired quote and makes the cancellation operationally effective.

`POST /api/cancellations/{cancellation}/resume-payment`

Returns `client_secret` for additional cancellation payment authentication.

`POST /api/cancellations/{cancellation}/retry-payment`

Retries additional cancellation payment.

`POST /api/cancellations/{cancellation}/force-majeure/respond`

```json
{ "response": "provide_evidence", "message": "Uploaded evidence in support chat." }
```

`GET /api/cancellations/{cancellation}/history`

Returns immutable cancellation transactions.

## Webhook

`POST /api/stripe/webhook`

Public Stripe webhook. Requires `Stripe-Signature`. Processes:

- `payment_intent.succeeded`
- `payment_intent.payment_failed`
- `payment_intent.requires_action`
- `charge.dispute.created`
- `charge.dispute.updated`
- `charge.dispute.closed`

Webhook IDs are unique and replay-safe.

## Deprecated

- `POST /api/add-card` returns `410 Gone`.
- `POST /api/cancelled-event` returns `409 Conflict`.
- `auto:charge-hourly-events` is disabled.

## Post-Audit Final Contract

This section supersedes older examples in this file where field names differ.

### Money Units

All mobile-facing financial amounts are integer minor units. Request and response fields use the `_minor` suffix:

- `event_principal_minor`
- `requested_principal_minor`
- `proposed_principal_minor`
- `deposit_principal_minor`
- `stripe_fee_minor`
- `total_charge_minor`
- `refund_minor`
- `transfer_minor`

Do not send floats such as `1000.00` in payment, completion, counter, cancellation, refund, or transfer workflows. Deprecated decimal fields such as `requested_principal` and `proposed_principal` are rejected with `422`.

### Completion

`POST /api/events/{event}/completion`

Request body:

```json
{}
```

EO cannot submit an amount. The requested principal is the accepted event settlement principal stored on the server.

`POST /api/events/{event}/completion/counters`

```json
{
  "proposed_principal_minor": 95000,
  "message": "Mutually agreed adjustment."
}
```

`proposed_principal_minor` must be an integer and cannot exceed the accepted event principal. A mutually accepted counter is the only mobile workflow that changes final principal.

### Cancellation

`POST /api/events/{event}/cancellations/quote`

```json
{
  "reason_type": "normal",
  "reason_message": "Schedule conflict.",
  "force_majeure": false
}
```

Flutter must not send `initiator_role`, `event_timezone`, event date, tier, or amounts. The server derives role from the authenticated user and event relationship, timezone from stored event data, and tier from the database event date.

`POST /api/events/{event}/cancellations` is disabled for the mobile app and returns:

```json
{
  "status": false,
  "data": {
    "code": "cancellation_quote_confirmation_required",
    "quote_endpoint": "POST /api/events/{event}/cancellations/quote",
    "confirm_endpoint": "POST /api/cancellations/{cancellation}/confirm"
  },
  "message": "Cancellation requires quote review and explicit confirmation."
}
```

`POST /api/cancellations/{cancellation}/confirm` requires an `Idempotency-Key` header. Repeating the same key after confirmation returns the existing cancellation/payment result.

### PaymentSheet Responses

SetupIntent:

```json
{
  "status": true,
  "data": {
    "id": "seti_123",
    "client_secret": "seti_123_secret_abc",
    "customer": "cus_123",
    "status": "requires_payment_method",
    "publishable_key": "pk_test_..."
  },
  "message": "SetupIntent created."
}
```

Acceptance with 0% down:

```json
{
  "payment_required": false,
  "payment": { "installment_type": "down_payment", "status": "succeeded" },
  "summary": { "event_principal_minor": 100000, "remaining_principal_minor": 100000 }
}
```

Acceptance requiring PaymentSheet:

```json
{
  "payment_required": true,
  "client_secret": "pi_123_secret_abc",
  "publishable_key": "pk_test_...",
  "payment": {
    "status": "processing",
    "installment_type": "down_payment",
    "charge_amount_minor": 2604
  }
}
```

Requires action:

```json
{
  "payment_id": 10,
  "uuid": "payment-uuid",
  "status": "requires_action",
  "client_secret": "pi_123_secret_abc",
  "publishable_key": "pk_test_..."
}
```

### Stable Error Codes

- `cancellation_quote_confirmation_required`
- `deprecated_raw_card_api`
- `legacy_cancellation_flow_disabled`
- `connect_onboarding_incomplete`
- `vm_connect_onboarding_incomplete`
- `eo_connect_onboarding_incomplete`
- `stripe_configuration_missing`
- `payment_method_required`
- `payment_requires_action`
- `payment_failed`
- `unauthorized_payment_access`
- `invalid_minor_amount`
- `completion_amount_prohibited`
- `counter_amount_exceeds_event_principal`

### Wallet (Optional)

Wallet transaction history is not required for Connect onboarding, card setup, event acceptance, or down payment. Wallet endpoints may be absent without blocking payment flows.

### Webhook Events

Implemented domain handlers:

- `account.updated`
- `capability.updated`
- `setup_intent.succeeded`
- `setup_intent.setup_failed` (verified no-op)
- `setup_intent.requires_action` (verified no-op)
- `payment_intent.processing`
- `payment_intent.succeeded`
- `payment_intent.payment_failed`
- `payment_intent.requires_action`
- `refund.created`
- `refund.updated`
- `refund.failed`
- `charge.refunded`
- `charge.dispute.created`
- `charge.dispute.updated`
- `charge.dispute.closed`
- `transfer.created`
- `transfer.updated`
- `transfer.reversed`

All webhook events require a valid Stripe signature and are deduplicated by Stripe event ID. Processing failures are persisted and return a retryable server error to Stripe.
