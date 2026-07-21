# Flutter Payment Implementation Report

## 2026-07-20 Update: Event Payment Journey + Wallet

### UI gaps found before this update

- Event Detail had no payment journey section and ignored `payment_overview`.
- Remaining-balance / completion / counter / final-auth actions were not driven by backend `permissions` / `next_action`.
- Wallet screen was a developer placeholder with no `/api/wallet/*` integration.
- No deep links for `events/{id}/payment` or wallet routes.

### What was implemented

1. **Payment journey API** — typed models, mapper, controller, repository method, Event Detail section.
2. **Role-based actions** from `next_action.code` and `permissions` (not `event.status`).
3. **Completion / counters / resume / retry** wired through journey primary actions + existing payment APIs.
4. **Timeline** rendered from backend events only.
5. **Wallet** — EO Earnings & Payouts / VM Payments & Refunds with summary, paginated transactions, detail, Connect transfers.
6. **Payout copy** — bank tracking disabled messaging; never claims bank arrival.
7. **Refresh** — open, resume, pull-to-refresh, after actions, deep links, bounded polling for processing stages.
8. **Deep links / notification routing** for payment lifecycle types (refresh only; no invented notification backend).

### Files added

- `lib/payment/journey/payment_journey_models.dart`
- `lib/payment/journey/payment_journey_mapper.dart`
- `lib/payment/journey/payment_journey_controller.dart`
- `lib/payment/journey/payment_journey_widgets.dart`
- `lib/payment/wallet/wallet_models.dart`
- `lib/payment/wallet/wallet_controller.dart`
- `lib/payment/wallet/wallet_screens.dart`
- `test/payment_journey_test.dart`
- `test/wallet_models_test.dart`
- `docs/FLUTTER_EVENT_PAYMENT_JOURNEY.md`
- `docs/FLUTTER_WALLET_TRANSACTION_IMPLEMENTATION.md`

### Backend note

`docs/EVENT_PAYMENT_JOURNEY_API.md` documents stages and next-action codes but does not include a full JSON example. Flutter parsers accept nested sections (`readiness`, `agreement`, `totals`, `down_payment`, `completion`, `final_payment`, `cancellation`, `permissions`, `next_action`, `timeline`) with defensive field aliases matching existing payment money-field conventions. If staging field names differ, adjust parsers only — do not invent endpoints.

---

## 2026-07 Update: Connect Return, Payouts UI, and Add Secure Card Fixes

This update was made after the backend verified the Stripe Connect return pages, Connect status endpoint, SetupIntent response, and stable event-acceptance error codes.

### Root Causes Fixed

1. **Placeholder "Confirmed / The backend has confirmed this workflow." screen.** `PaymentStateView` replaced the entire screen body with a generic message state whenever a controller reached `PaymentWorkflowState.success`. Since `StripeConnectController` mapped `onboarding_complete: true` to `success`, the Payment & Payouts screen never rendered its real status card. `success` now renders the real screen content, and the placeholder copy was deleted.
2. **No OS-level deep-link listener.** The app had deep-link *parsing* (`PaymentDeepLink.parse`) but nothing listening for OS links; only FCM payloads reached the parser, and the Android manifest only registered the `stripe-redirect` host. The new backend return page (`groovkin://stripe-connect/return?status=success`) therefore never reached the app. A `PaymentDeepLinkService` built on `app_links` now handles cold-start and runtime links, and the manifest registers the `stripe-connect`, `payments`, `events`, and `cancellations` hosts.
3. **"Please check your connection" on Add Secure Card.** Three problems: (a) `API().getApi` crashed on pure network errors (`e.response!` null assertion), (b) the shared `_guard` mapped every non-`PaymentApiException` (including `StripeException` and PaymentSheet cancellation) to the generic connection message, and (c) the wallet screen's button routed into the card flow without user-friendly error mapping. The flow now checks the auth token first ("Please log in again."), logs safe debug info in dev builds (HTTP status, backend code, message, endpoint — never `client_secret`), maps `stripe_configuration_missing` to "Payment setup is temporarily unavailable.", treats PaymentSheet dismissal as a silent cancel, surfaces Stripe-localized card errors, and uses "Could not add payment method. Please try again." for unknown failures.

### Deep-Link Return Handling

- `groovkin://stripe-connect/return?status=success` → Payment & Payouts screen → "Checking Stripe setup..." → `GET /api/stripe/connect/status` → real status rendered. The deep link alone never marks onboarding complete.
- `groovkin://stripe-connect/refresh?status=expired` → same screen with an expired-session note and "Continue Stripe Setup" (requests a fresh Account Link).
- `groovkin://stripe-redirect` → Stripe SDK return; Connect status re-checked on resume.
- Connect status also refreshes on screen open, app resume, pull to refresh, after browser return, and before event acceptance.

### Payment & Payouts Screen

Role-aware UI driven by `GET /api/stripe/connect/status`:

- EO incomplete: "Complete Payout Setup" / complete: "Payout Setup Complete" with the corresponding descriptions.
- VM incomplete: "Complete Payment Account Setup" / complete: "Payment Setup Complete".
- Status rows: Verification (Complete / Action needed / Pending), Charges enabled, Payouts enabled, Requirements due (safe labels), masked account ID.
- Buttons: Complete/Continue Stripe Setup, Refresh Status, and for VM: Add Secure Card and View Payment Methods.
- Non-blocking note: "Transaction history will appear here after payments are processed."

### Add Secure Card Flow

1. `POST /api/payment-methods/setup-intent` with bearer token.
2. Stripe initialized from the response `publishable_key`.
3. PaymentSheet presented in setup mode with the SetupIntent `client_secret`.
4. After confirmation, `GET /api/payment-methods` is refreshed (backend is the source of truth).
5. If no default exists, `POST /api/payment-methods/default` promotes the first card.
6. Saved card metadata (brand, last4, expiry, default badge) renders on screen.

### Event Acceptance Prerequisites

`EventAcceptanceCoordinator` checks, in order: VM Connect complete → VM has a reusable card → payment summary → `POST /api/events/{event}/accept`. Backend codes `vm_connect_onboarding_incomplete`, `eo_connect_onboarding_incomplete`, `connect_onboarding_incomplete`, `payment_method_required`, and `stripe_configuration_missing` map to dedicated blocker UI. A VM without a card is routed to Payment Methods with "Add a secure card to continue accepting this event." and returns to the acceptance flow after adding one.

### Wallet Decision

Wallet transaction history remains deferred; no wallet endpoint is called and nothing blocks onboarding, card setup, or acceptance. The developer-note copy about unverified backend endpoints was removed from the UI.

### Files Changed In This Update

- `pubspec.yaml` (added `app_links`)
- `android/app/src/main/AndroidManifest.xml`
- `lib/main.dart`
- `lib/Components/Network/API.dart`
- `lib/payment/payment_deep_links.dart`
- `lib/payment/payment_controller.dart`
- `lib/payment/payment_widgets.dart`
- `lib/payment/payment_screens.dart`
- `lib/payment/stripe_connect_controller.dart`
- `lib/payment/stripe_connect_models.dart`
- `lib/payment/stripe_connect_widgets.dart`
- `lib/payment/event_acceptance_coordinator.dart`
- `lib/View/paymentMethod/addCardDetails.dart`
- `lib/View/paymentMethod/transectionHistoryScreen.dart`
- `test/stripe_connect_test.dart`
- `test/payment_widgets_test.dart` (new)

---

## Architecture Used

- Existing Flutter app architecture was preserved.
- State management: GetX controllers and `GetBuilder`.
- Navigation: existing GetX named routes in `Routes` / `AppPages`.
- Networking: existing Dio wrapper in `lib/Components/Network/API.dart`.
- Persistence: existing `GetStorage`.
- UI: existing `CustomButton`, app bars, `DynamicColor`, Poppins typography, cards, bottom sheets, and `BotToast`.

## Root Cause Confirmed

The backend correctly blocked `POST /api/events/{event}/accept` when EO or VM Stripe Connect onboarding was incomplete, but the Flutter app had no user-facing Connect onboarding screen, dashboard entry points, or acceptance prerequisite flow. VM acceptance still used the legacy `accept-event-request` endpoint in some screens and never called the verified payment accept API with Connect readiness checks.

## Packages Added

- `flutter_stripe: 13.0.0`

No new state-management or networking package was introduced.

## Files Created

- `lib/payment/payment_models.dart`
- `lib/payment/payment_repository.dart`
- `lib/payment/payment_controller.dart`
- `lib/payment/payment_widgets.dart`
- `lib/payment/payment_screens.dart`
- `lib/payment/payment_polling_service.dart`
- `lib/payment/payment_deep_links.dart`
- `lib/payment/stripe_config_service.dart`
- `lib/payment/stripe_connect_models.dart`
- `lib/payment/stripe_connect_controller.dart`
- `lib/payment/stripe_connect_widgets.dart`
- `lib/payment/event_acceptance_coordinator.dart`
- `test/payment_models_test.dart`
- `test/stripe_connect_test.dart`

## Files Modified

- `pubspec.yaml`
- `pubspec.lock`
- `lib/Components/Network/API.dart`
- `lib/Routes/app_pages.dart`
- `lib/Routes/app_routes.dart`
- `lib/View/authView/autController.dart`
- `lib/View/bottomNavigation/homeController.dart`
- `lib/View/bottomNavigation/homeScreen.dart`
- `lib/View/bottomNavigation/settingView/settingScreen.dart`
- `lib/View/bottomNavigation/homeTabs/eventsFlow/cancelResonScreen.dart`
- `lib/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart`
- `lib/View/bottomNavigation/homeTabs/eventsFlow/pendingEventFlow/pendingDetailsScreen.dart`
- `lib/View/bottomNavigation/homeTabs/upcomingScreen.dart`
- `lib/View/GroovkinManager/managerController.dart`
- `lib/View/paymentMethod/addCardDetails.dart`
- `lib/View/paymentMethod/paymentMethod.dart`
- `lib/View/paymentMethod/showSelectedBottomSheetCard.dart`
- `lib/View/paymentMethod/transectionHistoryScreen.dart`
- `lib/firebase/notification_services.dart`
- `lib/main.dart`
- `android/app/build.gradle.kts`
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/kotlin/com/gologonow/groovkin/MainActivity.kt`
- `ios/Runner/Info.plist`

## Stripe Connect Mobile Experience

### Status Model

`StripeConnectStatus` parses:

- `account_id`
- `charges_enabled`
- `payouts_enabled`
- `details_submitted`
- `requirements_due`
- `onboarding_complete` (authoritative)

### Role-Aware Copy

`StripeConnectCopy` uses the authenticated active role from `GetStorage` (`eventOrganizer` / `eventManager`):

- EO: "Complete Payout Setup"
- VM: "Complete Payment Account Setup"

### Screens And Components

- `ConnectOnboardingScreen` — full status UI, pull-to-refresh, requirements-due labels, verified state, external browser onboarding launch
- `StripeConnectBanner` — dashboard/settings banner when onboarding is incomplete
- `StripeConnectStatusCard` — reusable status card
- `OrganizerConnectIncompleteView` — VM-facing EO-not-ready state

### Navigation Entry Points

- EO settings: `Payments & Payouts`
- VM settings: `Payments & Payouts`, `Payment Methods`
- EO home dashboard banner
- VM home dashboard banner
- Payment activity / wallet screen
- Secure payment methods screen banner
- VM event acceptance flow
- Push/deep-link return to Connect status screen

### Browser Return Flow

1. App requests `POST /api/stripe/connect/onboarding-link`
2. Opens `onboarding.url` in external browser
3. Stripe returns through backend HTTPS bridge to `groovkin://stripe-redirect` or push/deep link `groovkin://stripe-connect/status`
4. App navigates to `ConnectOnboardingScreen`
5. Shows "Checking verification status"
6. Calls `GET /api/stripe/connect/status`
7. Renders backend result only; browser return alone does not mark completion

App resume also refreshes status when onboarding was launched and the user returns without a deep link.

### Event Acceptance Prerequisite Flow

VM acceptance now uses `EventAcceptanceCoordinator`:

1. Refresh VM Connect status
2. If VM incomplete, open Connect onboarding
3. Refresh reusable payment methods
4. If no default card, open secure payment methods
5. Load payment summary and show `EventAcceptPaymentScreen`
6. Call `POST /api/events/{event}/accept`
7. If backend returns `connect_onboarding_incomplete` while VM is complete, show EO-not-ready UI
8. Backend remains authoritative for all final states

Legacy `accept-event-request` is no longer used for paid VM acceptance in home, pending details, or upcoming event flows.

## Legacy Payment Migration

- Removed mobile use of `POST /api/add-card`.
- Removed mobile use of `POST /api/delete-card`.
- Replaced raw card entry with Stripe PaymentSheet SetupIntent.
- Replaced safe card display with `/api/payment-methods` metadata.
- Replaced direct `cancelled-event` flow with quote review and confirmation workflow.

## Screens Implemented

- Stripe Connect onboarding/status with role-aware copy and requirements-due UI.
- Secure payment method list.
- Secure add payment method.
- Event accept/payment summary/PaymentSheet processing with Connect prerequisites.
- Payment status and authentication resume.
- Completion status, submit, approve, counter create.
- Cancellation policy/quote/confirmation.
- Cancellation status entry through deep links.
- Payment activity screen with Connect setup entry and transaction-history backend blocker notice.

## Endpoints Integrated

- `POST /api/stripe/connect/onboarding-link`
- `GET /api/stripe/connect/status`
- `POST /api/payment-methods/setup-intent`
- `GET /api/payment-methods`
- `POST /api/payment-methods/default`
- `DELETE /api/payment-methods/{card}`
- `GET /api/events/{event}/payment-summary`
- `POST /api/events/{event}/accept`
- `GET /api/payments/{payment}`
- `POST /api/payments/{payment}/resume-authentication`
- `POST /api/payments/{payment}/retry`
- `POST /api/events/{event}/completion`
- `POST /api/events/{event}/completion/approve`
- `GET /api/events/{event}/completion/status`
- `GET /api/events/{event}/completion/history`
- `POST /api/events/{event}/completion/escalate`
- `POST /api/events/{event}/completion/counters`
- `POST /api/completion-counters/{counter}/revise`
- `POST /api/completion-counters/{counter}/accept`
- `POST /api/completion-counters/{counter}/reject`
- `GET /api/events/{event}/cancellation-policy`
- `POST /api/events/{event}/cancellations/quote`
- `POST /api/cancellations/{cancellation}/confirm`
- `GET /api/events/{event}/cancellations/current`
- `GET /api/cancellations/{cancellation}`
- `GET /api/cancellations/{cancellation}/history`
- `POST /api/cancellations/{cancellation}/resume-payment`
- `POST /api/cancellations/{cancellation}/retry-payment`
- `POST /api/cancellations/{cancellation}/force-majeure/respond`

## Statuses And Error Codes

Handled payment statuses:
`created`, `processing`, `requires_action`, `succeeded`, `failed`, `cancelled`, `manual_review`, `partially_refunded`, `refunded`, `disputed`.

Handled completion statuses:
`requested`, `countered`, `approved`, `auto_approved`, `payment_processing`, `payment_requires_action`, `payment_failed`, `support_review`, `manual_review`, `financially_settled`, `cancelled`.

Handled cancellation statuses:
`quote_created`, `confirmed`, `payment_required`, `payment_processing`, `payment_requires_action`, `payment_failed`, `refund_pending`, `refund_processing`, `transfer_reversal_pending`, `support_review`, `manual_review`, `financially_settled`, `cancelled`.

Handled stable error codes:
`cancellation_quote_confirmation_required`, `deprecated_raw_card_api`, `legacy_cancellation_flow_disabled`, `connect_onboarding_incomplete`, `payment_method_required`, `payment_requires_action`, `payment_failed`, `unauthorized_payment_access`, `invalid_minor_amount`, `completion_amount_prohibited`, `counter_amount_exceeds_event_principal`.

## Deep Links

Configured and parsed:

- `groovkin://stripe-redirect`
- `groovkin://payments/{paymentId}`
- `groovkin://events/{eventId}/completion`
- `groovkin://events/{eventId}/counter`
- `groovkin://cancellations/{cancellationId}`
- `groovkin://stripe-connect/status`

Push notification routing now opens payment, completion/counter, cancellation, and Connect status screens by safe identifiers and fetches backend state.

## Known Limitations And Blockers

- Wallet transaction history is deferred; the wallet screen shows a non-blocking "Transaction history will appear here after payments are processed." note instead of calling unverified endpoints.
- No verified "Notify Organizer" API exists for EO-incomplete acceptance. The VM UI shows Try Again / Back only.
- Live Stripe PaymentSheet and Connect onboarding require backend test credentials and device QA.
- Apple Pay / Google Pay merchant setup was not enabled because product scope did not provide merchant identifiers.
- Cold-start and runtime deep links are now handled by `PaymentDeepLinkService` (`app_links`); universal HTTPS links (App Links / Universal Links) are not configured because the backend bridge uses the custom `groovkin://` scheme.

## Release Steps

1. Configure backend Stripe publishable key responses.
2. Verify Android and iOS return URL handling on real devices.
3. Run the manual QA matrix in `docs/FLUTTER_PAYMENT_TESTING_GUIDE.md`.
4. Confirm Stripe webhooks are live and reachable.
5. Verify no raw card endpoint is used in mobile traffic.
6. QA EO and VM Connect onboarding from settings, dashboard banners, and VM acceptance.
