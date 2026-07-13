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
- `AndroidManifest.xml` has `groovkin://stripe-redirect` intent filter.

No Google Pay configuration was added because no product scope or merchant config was provided.

## iOS

Configured:

- Podfile deployment target: iOS 15.0
- `Info.plist` includes `groovkin` URL scheme.
- Swift Package Manager is disabled in `pubspec.yaml` config; CocoaPods remains primary.

No Apple Pay merchant ID or entitlement was added because no merchant identifier was provided.

## Deep Link Behavior

The app parses:

- `groovkin://stripe-redirect`
- `groovkin://payments/{paymentId}`
- `groovkin://events/{eventId}/completion`
- `groovkin://events/{eventId}/counter`
- `groovkin://cancellations/{cancellationId}`
- `groovkin://stripe-connect/status`

Screens fetch Laravel state before rendering actions.

## Security Notes

- Flutter does not store client secrets beyond the current operation.
- Flutter does not store raw card data.
- Flutter does not calculate financial authority values.
- Final payment/refund/settlement states come from Laravel.
