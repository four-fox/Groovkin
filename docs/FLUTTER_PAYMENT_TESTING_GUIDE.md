# Flutter Payment Testing Guide

## Automated Tests

Run:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter build apk --debug
```

The tests mock model-level contracts only. Do not call live Stripe in automated tests.

## Manual QA Matrix

### Stripe Connect

- Open Connect status screen.
- Start EO onboarding.
- Start VM onboarding.
- Return from browser to `groovkin://stripe-redirect`.
- Refresh backend status.
- Verify requirements due, charges disabled, payouts disabled, and complete states.

### Payment Methods

- Add Visa test card through Stripe PaymentSheet.
- Add 3DS test card.
- Try declined card.
- Set default card.
- Delete non-default card.
- Verify only safe card metadata is displayed.
- Logout/login and confirm Stripe customer state resets.

### Acceptance

- Load payment summary for 0%, 1%, 25%, 50%, 75%, and 100% down events.
- Accept 0% down without PaymentSheet.
- Accept payment-required event with PaymentSheet.
- Cancel PaymentSheet.
- Duplicate accept tap.
- App close during PaymentSheet.
- Network timeout after Stripe completion.
- Confirm final status only after `GET /api/payments/{payment}` returns terminal backend status.

### Final Payment Authentication

- Load payment requiring action.
- Tap resume authentication.
- Complete `handleNextAction`.
- Poll backend status.
- Retry failed payment with stable idempotency key.

### Completion

- EO submits completion.
- VM approves.
- Verify 48-hour countdown.
- Create counter with `proposed_principal_minor`.
- Accept/reject counter.
- Verify support review after expiry.

### Cancellation

- Load cancellation policy.
- Create normal quote.
- Create force-majeure quote.
- Confirm quote with idempotency key.
- Additional cancellation payment requires action.
- Retry failed cancellation payment.
- Refund pending/refund processing.
- Transfer reversal pending.
- Manual review/support review.
- Quote expiry.

### Deep Links And Notifications

- `groovkin://payments/{paymentId}`
- `groovkin://events/{eventId}/completion`
- `groovkin://events/{eventId}/counter`
- `groovkin://cancellations/{cancellationId}`
- `groovkin://stripe-connect/status`
- `groovkin://stripe-redirect`

Every deep-linked screen must fetch backend state before rendering actions.

## Non-Negotiable Security Checks

- No mobile call to `POST /api/add-card`.
- No mobile call to `POST /api/delete-card`.
- No raw card number, expiry, or security code sent to Laravel.
- No Stripe secret key in Flutter.
- No mobile-calculated cancellation tier.
- No frontend decimal amount fields for payment workflows.
