# Flutter Payment And Cancellation API Guide

Flutter source is not in this repository. This guide describes the Laravel APIs implemented here.

## Architecture

- Laravel calculates all money server-side in minor units.
- Flutter never sends raw card data to Laravel.
- Flutter uses Stripe SDK for SetupIntent, PaymentSheet, and `requires_action` confirmation.
- Laravel webhooks are the source of truth for payment, refund, cancellation settlement, and payout state.
- Mobile callbacks may update the screen to "processing" only.

## Dependencies

Use the official Flutter Stripe package:

```yaml
dependencies:
  flutter_stripe: ^latest
  dio: ^latest
```

Android and iOS must follow the Stripe Flutter SDK setup for minimum SDK, manifest, URL schemes, Apple Pay if used, and return URL/deep link handling.

## Deep Links

Configure a return URL such as:

```text
groovkin://stripe-redirect
```

Use the same return URL in Stripe SDK initialization and PaymentSheet configuration.

## Response Envelope

Success:

```json
{ "status": true, "data": {}, "message": "..." }
```

Error:

```json
{ "status": false, "data": "message", "message": "message" }
```

Validation errors may include `errors`.

## Connect Onboarding

Create onboarding link:

```http
POST /api/stripe/connect/onboarding-link
Authorization: Bearer <token>
```

Response data:

```json
{
  "account_id": "acct_...",
  "onboarding": { "url": "https://connect.stripe.com/..." }
}
```

Open `onboarding.url` in an external browser or in-app browser.

Check status:

```http
GET /api/stripe/connect/status
```

Require `onboarding_complete: true` for EO and VM before acceptance.

## SetupIntent And Payment Methods

Create SetupIntent:

```http
POST /api/payment-methods/setup-intent
```

Use `data.client_secret` with Stripe SDK:

```dart
final setup = await api.post('/payment-methods/setup-intent');
await Stripe.instance.confirmSetupIntent(
  paymentIntentClientSecret: setup.data['data']['client_secret'],
  params: const PaymentMethodParams.card(
    paymentMethodData: PaymentMethodData(),
  ),
);
```

After confirmation, set default:

```http
POST /api/payment-methods/default
Content-Type: application/json

{ "payment_method_id": "pm_..." }
```

List methods:

```http
GET /api/payment-methods
```

Delete:

```http
DELETE /api/payment-methods/{card}
```

## Trusted Payment Summary

```http
GET /api/events/{event}/payment-summary
```

Important response fields:

```json
{
  "event_principal_minor": 100000,
  "down_payment_percentage": "25.0000",
  "down_payment_principal_minor": 25000,
  "remaining_principal_minor": 75000,
  "estimated_down_payment_stripe_fee_minor": 776,
  "target_total_groovkin_commission_minor": 10000
}
```

Display these server values. Do not recalculate final amounts in Flutter.

## Accept Event And Down Payment

```http
POST /api/events/{event}/accept
Content-Type: application/json

{ "payment_method_id": "pm_optional" }
```

If `payment_required` is `true`, confirm the returned `client_secret`:

```dart
final response = await api.post('/events/$eventId/accept');
final data = response.data['data'];

if (data['payment_required'] == true) {
  await Stripe.instance.initPaymentSheet(
    paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: data['client_secret'],
      merchantDisplayName: 'Groovkin',
      returnURL: 'groovkin://stripe-redirect',
    ),
  );
  await Stripe.instance.presentPaymentSheet();
  await pollPayment(data['payment']['id']);
}
```

If down payment is `0%`, `payment_required` is `false`. Still show backend status from the response.

Polling:

```http
GET /api/payments/{payment}
```

Terminal UI states should come from backend status, not the Stripe SDK callback.

## Final Off-Session Authentication

When final payment needs authentication, backend payment status becomes `requires_action`.

Resume:

```http
POST /api/payments/{payment}/resume-authentication
```

Response:

```json
{
  "payment_id": 123,
  "uuid": "...",
  "status": "requires_action",
  "client_secret": "pi_..._secret_..."
}
```

Flutter:

```dart
await Stripe.instance.confirmPayment(
  paymentIntentClientSecret: data['client_secret'],
  data: const PaymentMethodParams.card(
    paymentMethodData: PaymentMethodData(),
  ),
);
await pollPayment(data['payment_id']);
```

Retry failed final payment:

```http
POST /api/payments/{payment}/retry
```

## Completion

EO submits completion:

```http
POST /api/events/{event}/completion

{}
```

Completion submit does not accept an amount. The accepted event principal is used unless a counter is mutually accepted.

VM approves:

```http
POST /api/events/{event}/completion/approve
```

Status/countdown:

```http
GET /api/events/{event}/completion/status
```

Response includes `auto_approve_seconds_remaining`. Flutter should render the 48-hour countdown from this server value.

History:

```http
GET /api/events/{event}/completion/history
```

Support escalation:

```http
POST /api/events/{event}/completion/escalate
```

## Counter Flow

Create:

```http
POST /api/events/{event}/completion/counters

{ "proposed_principal_minor": 95000, "message": "Sound issue adjustment" }
```

Revise:

```http
POST /api/completion-counters/{counter}/revise
```

Accept:

```http
POST /api/completion-counters/{counter}/accept
```

Reject:

```http
POST /api/completion-counters/{counter}/reject
```

Status includes `counter_seconds_remaining`. Unresolved counters move to support review after seven days.

## Cancellation Quote

Get policy:

```http
GET /api/events/{event}/cancellation-policy
```

Create quote:

```http
POST /api/events/{event}/cancellations/quote

{
  "reason_type": "normal",
  "reason_message": "Schedule conflict",
  "force_majeure": false
}
```

Quote response includes:

```json
{
  "policy_version": "groovkin-cancellation-v1",
  "event_timezone_snapshot": "America/New_York",
  "days_before_event": 14,
  "tier": "vm_14_to_31_days",
  "event_principal_minor": 100000,
  "deposit_minor": 25000,
  "paid_principal_minor": 25000,
  "cancellation_liability_minor": 25000,
  "additional_principal_due_minor": 0,
  "principal_refund_due_minor": 0,
  "estimated_stripe_fee_minor": 0,
  "commission_adjustment_minor": 0,
  "transfer_reversal_minor": 0,
  "manual_review_reasons": []
}
```

Show all quote fields to the user before confirmation.

## Cancellation Confirmation

```http
POST /api/cancellations/{cancellation}/confirm
Idempotency-Key: <uuid>
```

Confirmation makes the cancellation operationally effective. Financial status can still be `payment_processing`, `payment_requires_action`, `refund_pending`, `support_review`, `manual_review`, or `financially_settled`.

Current cancellation:

```http
GET /api/events/{event}/cancellations/current
```

Show cancellation:

```http
GET /api/cancellations/{cancellation}
```

History:

```http
GET /api/cancellations/{cancellation}/history
```

## Additional Cancellation Charge

If confirmation returns a payment in `requires_action`, resume:

```http
POST /api/cancellations/{cancellation}/resume-payment
```

Then confirm with Stripe SDK using the returned `client_secret`.

Retry:

```http
POST /api/cancellations/{cancellation}/retry-payment
```

Poll the cancellation and payment endpoints until backend status changes.

## Refund Status

Refunds are represented in cancellation history as `type: refund` and in cancellation status. Do not mark a refund complete from Stripe SDK or mobile callback.

## Force Majeure

Force-majeure quotes normally enter `support_review`.

Respond:

```http
POST /api/cancellations/{cancellation}/force-majeure/respond

{ "response": "provide_evidence", "message": "Evidence sent to support." }
```

Valid responses: `accept`, `reject`, `counter`, `provide_evidence`.

## Error Codes

- `410`: raw-card API deprecated.
- `409`: direct cancellation API deprecated.
- `422`: validation or invalid workflow transition.
- `403`: unauthorized participant/payment access.
- `400`: invalid Stripe webhook.

## Migration From Raw Card APIs

Stop using:

```http
POST /api/add-card
```

Use:

```http
POST /api/payment-methods/setup-intent
POST /api/payment-methods/default
GET /api/payment-methods
DELETE /api/payment-methods/{card}
```

## Test Matrix

Flutter QA should test:

- EO Connect onboarding,
- VM Connect onboarding,
- SetupIntent card save,
- default card selection,
- 0% down acceptance,
- 25%, 50%, 100% down acceptance,
- down payment success/failure,
- final off-session success,
- final off-session `requires_action`,
- 48-hour countdown,
- VM approval,
- counter create/revise/accept/reject,
- 7-day support escalation,
- VM cancellation tiers,
- EO cancellation,
- force majeure support review,
- additional cancellation payment,
- refund/manual review statuses,
- duplicate polling and app restart recovery.

## Final Post-Audit Flutter Contract

This section supersedes earlier examples that use decimal amount fields.

### Universal Rules

- Send `Authorization: Bearer <token>` on all mobile endpoints except the Stripe webhook.
- Send money only as integer minor units with `_minor` field names.
- Do not send `requested_principal`, `requested_principal_minor`, `initiator_role`, `event_timezone`, event date, cancellation tier, refund amount, or transfer amount unless the endpoint below explicitly lists that field.
- Treat webhooks as the source of truth. After PaymentSheet callbacks, poll Laravel status endpoints.
- Send `Idempotency-Key` on cancellation confirmation and payment retry actions.

### SetupIntent

```http
POST /api/payment-methods/setup-intent
```

Response:

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

### Payment Methods

```http
GET /api/payment-methods
```

Response:

```json
{
  "status": true,
  "data": [
    {
      "id": 44,
      "payment_method_id": "pm_123",
      "brand": "visa",
      "last4": "4242",
      "exp_month": 12,
      "exp_year": 2030,
      "default": true,
      "status": "active"
    }
  ],
  "message": "Payment methods retrieved."
}
```

### Connect Onboarding Incomplete

Acceptance fails until both EO and VM have `charges_enabled=true` and `payouts_enabled=true`.

```json
{
  "status": false,
  "data": "Both Event Organizer and Venue Manager must complete Stripe Connect onboarding before acceptance.",
  "message": "Both Event Organizer and Venue Manager must complete Stripe Connect onboarding before acceptance."
}
```

### Accept Event With 0% Down

```http
POST /api/events/{event}/accept
```

Request:

```json
{
  "payment_method_id": "pm_optional_override"
}
```

Response:

```json
{
  "status": true,
  "data": {
    "payment_required": false,
    "payment": {
      "installment_type": "down_payment",
      "status": "succeeded"
    },
    "summary": {
      "event_principal_minor": 100000,
      "down_payment_principal_minor": 0,
      "remaining_principal_minor": 100000
    }
  },
  "message": "Event accepted and payment prepared."
}
```

### Accept Event Requiring PaymentSheet

```json
{
  "status": true,
  "data": {
    "payment_required": true,
    "client_secret": "pi_123_secret_abc",
    "publishable_key": "pk_test_...",
    "payment": {
      "id": 55,
      "uuid": "payment-uuid",
      "status": "processing",
      "installment_type": "down_payment",
      "installment_principal_minor": 25000,
      "vm_stripe_fee_top_up_minor": 1030,
      "charge_amount_minor": 26030
    }
  },
  "message": "Event accepted and payment prepared."
}
```

### Payment Requires Action

```http
POST /api/payments/{payment}/resume-authentication
```

```json
{
  "status": true,
  "data": {
    "payment_id": 55,
    "uuid": "payment-uuid",
    "status": "requires_action",
    "client_secret": "pi_123_secret_abc",
    "publishable_key": "pk_test_..."
  },
  "message": "Payment authentication resume payload retrieved."
}
```

### Payment Processing, Failure, Retry

Poll:

```http
GET /api/payments/{payment}
```

Retry final balance:

```http
POST /api/payments/{payment}/retry
Idempotency-Key: retry-final-<uuid>
```

Stable statuses: `created`, `processing`, `requires_action`, `succeeded`, `failed`, `cancelled`, `manual_review`, `partially_refunded`, `refunded`, `disputed`.

### Completion

Submit completion:

```http
POST /api/events/{event}/completion

{}
```

Create or revise counter:

```json
{
  "proposed_principal_minor": 95000,
  "message": "Adjusted scope."
}
```

Completion statuses: `requested`, `countered`, `approved`, `auto_approved`, `payment_processing`, `payment_requires_action`, `payment_failed`, `support_review`, `manual_review`, `financially_settled`, `cancelled`.

### Cancellation Quote And Confirm

Quote:

```http
POST /api/events/{event}/cancellations/quote

{
  "reason_type": "normal",
  "reason_message": "Schedule conflict.",
  "force_majeure": false
}
```

Confirm:

```http
POST /api/cancellations/{cancellation}/confirm
Idempotency-Key: cancel-<uuid>

{}
```

The disabled shortcut returns:

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

Cancellation statuses: `quote_created`, `confirmed`, `payment_required`, `payment_processing`, `payment_requires_action`, `payment_failed`, `refund_pending`, `refund_processing`, `transfer_reversal_pending`, `support_review`, `manual_review`, `financially_settled`, `cancelled`.

### Stable Error Codes

- `cancellation_quote_confirmation_required`
- `deprecated_raw_card_api`
- `legacy_cancellation_flow_disabled`
- `connect_onboarding_incomplete`
- `payment_method_required`
- `payment_requires_action`
- `payment_failed`
- `unauthorized_payment_access`
- `invalid_minor_amount`
- `completion_amount_prohibited`
- `counter_amount_exceeds_event_principal`
