# Stripe Configuration Guide

## Environment

Set these values outside source control:

```env
STRIPE_KEY=pk_test_...
STRIPE_SECRET=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
STRIPE_CONNECT_COUNTRY=US
STRIPE_CONNECT_REFRESH_URL=https://api.example.com/api/stripe/onboarding/refresh
STRIPE_CONNECT_RETURN_URL=https://api.example.com/api/stripe/onboarding/return
STRIPE_CONNECT_RETURN_DEEP_LINK=groovkin://stripe-connect/return?status=success
STRIPE_CONNECT_REFRESH_DEEP_LINK=groovkin://stripe-connect/refresh?status=expired
GROOVKIN_PAYMENT_CURRENCY=usd
GROOVKIN_COMMISSION_BASIS_POINTS=1000
GROOVKIN_COMMISSION_ON_CANCELLATION_LIABILITY=true
GROOVKIN_STRIPE_PERCENT_BASIS_POINTS=290
GROOVKIN_STRIPE_FIXED_FEE_MINOR=30
GROOVKIN_DEFAULT_EVENT_TIMEZONE=UTC
```

## Dashboard Setup

1. Enable Stripe Connect Express.
2. Enable card payments.
3. Configure platform webhook endpoint: `POST https://api.example.com/api/stripe/webhook`.
4. Subscribe to:
   - `account.updated`
   - `capability.updated`
   - `setup_intent.succeeded`
   - `setup_intent.setup_failed`
   - `setup_intent.requires_action`
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
5. Copy the webhook signing secret into `STRIPE_WEBHOOK_SECRET`.

## Connect Accounts

Both EO and VM use `POST /api/stripe/connect/onboarding-link`.

The Account Link `return_url` and `refresh_url` must point to the public Laravel routes:

- `GET /api/stripe/onboarding/return` — HTML success page with deep link `groovkin://stripe-connect/return?status=success`
- `GET /api/stripe/onboarding/refresh` — HTML expired-session page with deep link `groovkin://stripe-connect/refresh?status=expired`

Configure deep links via `STRIPE_CONNECT_RETURN_DEEP_LINK` and `STRIPE_CONNECT_REFRESH_DEEP_LINK`.

The API requires `charges_enabled` and `payouts_enabled` before event acceptance. Although VM is the payer in this implementation, VM onboarding remains required by confirmed product policy.

## Payment Method Collection

Flutter must use SetupIntent and Stripe SDK. Do not send raw card numbers or CVC to Laravel.

## Charge Model

Groovkin uses separate charges and transfers:

- VM is charged on the platform.
- Groovkin commission remains on the platform.
- EO net proceeds are transferred to EO's connected account after webhook-confirmed success.
- Refunds and transfer reversals are executed separately for cancellation and disputes.

## Webhook Source Of Truth

Mobile callbacks can update UI state, but final payment, refund, cancellation settlement, and payout state must come from Laravel after webhook processing.

Webhook processing failures return a server error after persisting the failed record so Stripe retries the event. Signature failures return `400`.

## Dashboard Changes Required After Audit

- Add the expanded webhook event list above to the platform endpoint.
- Verify Connect Express is enabled for both card payments and transfers.
- Verify webhook signing secret is configured as `STRIPE_WEBHOOK_SECRET`.
- Verify platform balance alerting is enabled; refund and reversal failures move records to manual review and require operations follow-up.
