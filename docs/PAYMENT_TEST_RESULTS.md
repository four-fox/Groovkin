# Payment Test Results

Last updated: 2026-07-17

## Focused Payment Regression

Command:

```bash
php artisan test tests/Unit/PaymentMoneyServiceTest.php tests/Unit/CancellationPolicyEngineTest.php tests/Feature/MarketplacePaymentAcceptanceTest.php tests/Feature/StripeWebhookIdempotencyTest.php tests/Feature/PaymentAuditRemediationTest.php tests/Feature/StripeConnectAndPaymentMethodsTest.php
```

Result:

- Status: passed
- Tests: 39 passed (262 assertions)
- Duration: ~12s
- New coverage in `StripeConnectAndPaymentMethodsTest`:
  - onboarding return page returns HTML with deep link
  - onboarding refresh page returns HTML with deep link
  - connect status complete/incomplete payloads with role context
  - SetupIntent mobile-friendly response
  - SetupIntent missing Stripe config safe error
  - payment methods list empty state
  - default payment method update
  - acceptance error when VM Connect incomplete
  - acceptance error when EO Connect incomplete
  - acceptance error when both Connect incomplete

## Full Verification

- `composer validate`: passed, `./composer.json is valid`.
- `php artisan migrate:status`: failed because the configured MySQL server refused the connection to `127.0.0.1:3306` / `groovkin_db`.
- Safe test migration: passed on SQLite in-memory; `2026_07_07_000001_create_payment_settlement_module` ran successfully.
- `php artisan test`: passed, 39 tests, 262 assertions, ~12s.
- `vendor/bin/pint --test` on touched PHP files: passed.
- `php artisan route:list --path=stripe`: passed, 7 Stripe routes.
- `php artisan schedule:list`: passed, 3 scheduled commands.

## Coverage Added In Audit Remediation

- Completion amount tampering rejected.
- Counter requests require `proposed_principal_minor`.
- Counter amounts cannot exceed accepted event principal.
- Cancellation quote rejects client-supplied `initiator_role` and `event_timezone`.
- Cancellation shortcut returns `cancellation_quote_confirmation_required`.
- Duplicate event acceptance reuses the same payment record and Stripe idempotency key.
- Duplicate `payment_intent.succeeded` webhooks do not double-count settlement totals or duplicate EO transfers.
- `account.updated` webhook synchronizes Connect flags.
- Pending refunds prevent `financially_settled`.
- Auto-approval and counter-expiration scheduler commands are covered.

## Coverage Added In Connect And Payment Methods Fix

- Public Connect return/refresh routes return HTML, not JSON.
- Deep links `groovkin://stripe-connect/return?status=success` and `groovkin://stripe-connect/refresh?status=expired`.
- Connect status includes `role`, `title`, `can_receive_payouts`, `can_accept_payments`.
- SetupIntent response trimmed to mobile-friendly fields with `publishable_key`.
- `stripe_configuration_missing` when `STRIPE_KEY` or `STRIPE_SECRET` absent.
- Acceptance readiness errors: `vm_connect_onboarding_incomplete`, `eo_connect_onboarding_incomplete`, `connect_onboarding_incomplete`.

## Remaining Manual/Sandbox Coverage

- Real Stripe PaymentSheet UI behavior.
- Real off-session SCA bank/card behavior.
- Stripe balance insufficiency for refunds and transfer reversals.
- Mobile app restart/resume behavior.
- iOS and Android Flutter integration checks.
- Wallet transaction history (optional; not required for onboarding or acceptance).
