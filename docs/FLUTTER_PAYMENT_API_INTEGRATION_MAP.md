# Flutter Payment API Integration Map

| Method | Route | Request Model | Response Model | Repository Method | Controller/Screen | Error Codes | Test Coverage |
|---|---|---|---|---|---|---|---|
| POST | `/api/stripe/connect/onboarding-link` | empty | `StripeOnboardingLink` | `createConnectOnboardingLink` | `StripeConnectController` | 401, 403 | `stripe_connect_test.dart` |
| GET | `/api/stripe/connect/status` | none | `StripeConnectStatus` | `getConnectStatus` | Connect screens / banners | 401, 403 | `stripe_connect_test.dart` |
| POST | `/api/payment-methods/setup-intent` | empty | `SetupIntentResponse` | `createSetupIntent` | `addPaymentMethod` | `stripe_configuration_missing` | `stripe_connect_test.dart` |
| GET | `/api/payment-methods` | none | `List<PaymentMethodCard>` | `getPaymentMethods` | Payment Methods | 401 | card tests |
| POST | `/api/payment-methods/default` | `payment_method_id` | envelope | `setDefaultPaymentMethod` | card tile | 422 | manual QA |
| DELETE | `/api/payment-methods/{card}` | path id | envelope | `deletePaymentMethod` | card delete | 422 | manual QA |
| GET | `/api/events/{event}/payment-summary` | path | `PaymentSummary` | `getPaymentSummary` | Accept screen | 403 | `payment_models_test.dart` |
| GET | `/api/events/{event}/payment-journey` | path | `PaymentJourney` | `getPaymentJourney` | `PaymentJourneyController`, Event Detail | `unauthorized_event_payment_access` | `payment_journey_test.dart` |
| POST | `/api/events/{event}/accept` | optional pm | `EventAcceptanceResult` | `acceptEvent` | Acceptance coordinator | connect / pm codes | `stripe_connect_test.dart` |
| GET | `/api/payments/{payment}` | path | `PaymentRecord` | `getPayment` | status / poller | `payment_requires_action` | status tests |
| POST | `/api/payments/{payment}/resume-authentication` | empty | `ResumeAuthenticationResult` | `resumeAuthentication` | journey + status | `payment_requires_action` | manual QA |
| POST | `/api/payments/{payment}/retry` | Idempotency-Key | `PaymentRecord` | `retryPayment` | journey failed final | `payment_failed` | manual QA |
| POST | `/api/events/{event}/completion` | `{}` | envelope | `submitCompletion` | journey EO action | `completion_not_available` | journey mapper tests |
| POST | `/api/events/{event}/completion/approve` | empty | envelope | `approveCompletion` | journey VM action | payment codes | manual QA |
| GET | `/api/events/{event}/completion/status` | path | `CompletionStatusResponse` | `getCompletionStatus` | completion screen | 404 | status enums |
| POST | `/api/events/{event}/completion/counters` | minor + message | `CompletionCounter` | `createCounter` | completion / journey | counter codes | journey counter parse |
| POST | `/api/completion-counters/{counter}/revise` | minor + message | `CompletionCounter` | `reviseCounter` | journey controller | counter codes | repository mapped |
| POST | `/api/completion-counters/{counter}/accept` | empty | envelope | `acceptCounter` | journey counter UI | payment codes | journey tests |
| POST | `/api/completion-counters/{counter}/reject` | empty | envelope | `rejectCounter` | journey counter UI | 422 | journey tests |
| GET | `/api/wallet/summary` | none | `WalletSummary` | `getWalletSummary` | `WalletHomeScreen` | `unauthorized_wallet_access` | `wallet_models_test.dart` |
| GET | `/api/wallet/transactions` | filters + page | `WalletTransactionPage` | `getWalletTransactions` | transactions screen | 401 | wallet tests |
| GET | `/api/wallet/transactions/{id}` | opaque id | `WalletTransactionDetail` | `getWalletTransaction` | detail screen | `transaction_not_found` | wallet tests |
| GET | `/api/wallet/payouts` | none | `WalletPayoutsResponse` | `getWalletPayouts` | wallet transfers | `payout_tracking_unavailable` | wallet tests |
| Cancellation routes | see cancellation guide | quote/confirm | cancellation models | existing repo methods | cancellation screens | cancellation codes | existing tests |

## Deep links

| Link | Screen |
|------|--------|
| `groovkin://events/{id}/payment` | Event Detail + journey refresh |
| `groovkin://payments/{id}` | Payment status |
| `groovkin://events/{id}/completion` | Completion workflow |
| `groovkin://events/{id}/counter` | Completion workflow |
| `groovkin://wallet` | Wallet home |
| `groovkin://wallet/transactions/{id}` | Transaction detail |
| `groovkin://stripe-connect/return\|refresh` | Connect status |
| `groovkin://cancellations/{id}` | Cancellation |

## Wallet decision

Wallet APIs are implemented. Bank payout tracking is disabled; UI shows Connect transfers only.
