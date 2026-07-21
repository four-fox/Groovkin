# Flutter Stripe Platform Setup

## Package

The app uses:

```yaml
flutter_stripe: 13.0.0
```

The package is pinned exactly. No Stripe secret key is stored in Flutter.

## Stripe Initialization

Stripe is initialized in `StripeConfigService`:

- `Stripe.publishableKey` comes from Laravel responses.
- `Stripe.urlScheme = 'groovkin'`.
- Return URL: `groovkin://stripe-redirect`.
- On logout, `Stripe.instance.resetPaymentSheetCustomer()` is called.

## Android

Configured:

- `minSdk = 23`
- `ndkVersion = "28.2.13676358"`
- `MainActivity` extends `FlutterFragmentActivity`
- `AndroidManifest.xml` has intent filters for:
  - `groovkin://stripe-redirect` (Stripe SDK return)
  - `groovkin://stripe-connect` (Connect onboarding return/refresh)
  - `groovkin://payments`, `groovkin://events`, `groovkin://cancellations` (workflow links)

No Google Pay configuration was added because no product scope or merchant config was provided.

## iOS

Configured:

- Podfile deployment target: iOS 15.0
- `Info.plist` includes `groovkin` URL scheme.
- Swift Package Manager is disabled in `pubspec.yaml` config; CocoaPods remains primary.

No Apple Pay merchant ID or entitlement was added because no merchant identifier was provided.

## Stripe Connect Onboarding Flow

1. App calls `POST /api/stripe/connect/onboarding-link`.
2. App opens `data.onboarding.url` in the external browser via `url_launcher`.
3. Stripe-hosted onboarding completes or requests more information.
4. Backend return page (`GET /api/stripe/onboarding/return`) shows a mobile-friendly HTML page and deep-links back to `groovkin://stripe-connect/return?status=success`. The refresh page (`GET /api/stripe/onboarding/refresh`) deep-links to `groovkin://stripe-connect/refresh?status=expired`.
5. `PaymentDeepLinkService` (built on `app_links`) receives the link, whether the app is running or cold-started, and navigates to `ConnectOnboardingScreen`.
6. App shows "Checking Stripe setup...".
7. App calls `GET /api/stripe/connect/status`.
8. UI renders backend `onboarding_complete`, `charges_enabled`, `payouts_enabled`, and `requirements_due`.

Important:

- Browser return alone does not mark onboarding complete. The deep-link `status` query is informational only; the backend status endpoint is always re-queried.
- `groovkin://stripe-connect/refresh?status=expired` shows an "expired session" note and offers "Continue Stripe Setup", which requests a fresh Account Link.
- Onboarding URLs are not persisted permanently.
- App resume also refreshes Connect status when the user returns from the browser without a deep link.
- Connect status is additionally refreshed on screen open, pull to refresh, and before event acceptance.

## Deep Link Behavior

`PaymentDeepLinkService` (package `app_links`) listens for both the cold-start initial link and the running-app link stream. The app parses:

- `groovkin://stripe-redirect`
- `groovkin://stripe-connect/return?status=success`
- `groovkin://stripe-connect/refresh?status=expired`
- `groovkin://stripe-connect/status`
- `groovkin://payments/{paymentId}`
- `groovkin://events/{eventId}/payment`
- `groovkin://events/{eventId}/completion`
- `groovkin://events/{eventId}/counter`
- `groovkin://wallet`
- `groovkin://wallet/transactions/{transactionId}`
- `groovkin://cancellations/{cancellationId}`

Screens fetch backend state before rendering actions.

Push notification types also routed to Connect refresh:

- `connect_onboarding_incomplete`
- `stripe_connect_status`

## Security Notes

- Flutter does not store client secrets beyond the current operation.
- Flutter does not store raw card data.
- Flutter does not calculate financial authority values.
- Final payment/refund/settlement states come from Laravel.
- Connect account IDs are masked in UI when displayed.
