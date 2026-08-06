# Flutter Event Payment Journey

## Endpoint

`GET /api/events/{event}/payment-journey`

Flutter never infers financial actions from `event.status` alone. Actions come from `permissions` and `next_action.code`.

## Architecture

| Layer | File |
|-------|------|
| Models / enums | `lib/payment/journey/payment_journey_models.dart` |
| UI mapper | `lib/payment/journey/payment_journey_mapper.dart` |
| Controller | `lib/payment/journey/payment_journey_controller.dart` |
| Widgets | `lib/payment/journey/payment_journey_widgets.dart` |
| Repository | `PaymentRepository.getPaymentJourney` |
| Event Detail embed | `EventPaymentJourneySection` in `pendingDetailsScreen.dart` |

## Event Detail section

Inserted after the Price row for EO/VM participants:

**Payment & Event Status**

Shows:

- Event total / down payment paid (%) / remaining balance
- Stage title, explanation, badge
- VM: Stripe processing fee + total charged
- EO: Groovkin commission + organizer proceeds + transfer status
- Settlement status
- Auto-approval countdown when completion is requested
- Open counter block with accept/reject when permitted
- Backend timeline (never invents financial events)
- Refresh + primary next-action button

## Journey stages

All stages in `PaymentJourneyStages` have title, explanation, icon, badge, and optional primary action via `PaymentJourneyMapper`.

## Next-action routing

| Code | Flutter action |
|------|----------------|
| `complete_connect_onboarding` | Connect onboarding screen |
| `add_payment_method` | Secure payment methods |
| `review_and_accept` | `EventAcceptanceCoordinator` |
| `complete_down_payment` / `resume_final_payment` | `resumeAuthentication` |
| `retry_final_payment` | `retryPayment` |
| `submit_completion` | `POST /events/{id}/completion` with confirm dialog |
| `review_completion` / `review_counter` | Completion workflow screen |
| `view_cancellation` | Cancellation workflow screen |
| `view_settlement` / `view_support_review` | Wallet home |

## Refresh strategy

Journey refreshes on:

- Event Detail open
- pull to refresh (Event Detail)
- app resume
- after every financial action (approve, retry, resume auth, counters)
- Stripe / PaymentSheet return (via resume + action completion)
- deep link `groovkin://events/{id}/payment`
- bounded polling while stage is `final_payment_processing`, `final_transfer_pending`, **or `manual_review`**

Polling stops for: `financially_settled`, `final_payment_failed`, `final_payment_requires_action`, `cancelled`, `disputed`. Duplicate polling loops are prevented. Poll window is bounded to ~15 minutes with backoff, since the backend's transfer-reconciliation job typically completes within ~10 minutes.

Push notification text is never authoritative; taps open the event/wallet screen and re-fetch Laravel.

## Settlement vs final payment

`final_payment.status == succeeded` is **not** financially settled.

Show **Payment complete** only when `settlement_status == financially_settled`.

**`final_transfer_pending` and `manual_review` are not errors.** The backend automatically retries/reconciles the EO Stripe Connect transfer and the journey self-resolves to `financially_settled` in the background (typically within ~10 minutes). The app must never show a failure screen, a retry button, or a "contact support" prompt for these two stages — only a calm "finalizing" message, and it must keep refreshing until settlement completes.

| State | Title | Notes |
|-------|-------|-------|
| Final processing | Final payment processing | Poll |
| Requires action | Payment authentication required | Resume auth |
| Failed | Final payment failed | Retry + Update Payment Method |
| Transfer pending | Payment successful | Self-resolving; poll; not settled; no action |
| Manual review | Payment completed | Self-resolving; poll; not settled; no action |
| Transfer succeeded | Transferred to Stripe account | Never "Paid to bank" |
| Settled | Payment complete | Refresh wallet summary + transactions |

Old events with a succeeded final payment and a missing/failed EO transfer must not trigger another VM charge. The backend transfer-reconciliation job (or support, for edge cases) recovers the Connect transfer — Flutter only displays state and never re-charges the VM.

Raw backend status strings (e.g. `manual_review`, `final_transfer_pending`, `failed`) are never shown to users verbatim — see `PaymentJourneyMapper.friendlySettlementStatusLabel` / `friendlyTransferStatusLabel`.

## Partial payments

Supports any down-payment percentage from the backend totals. Flutter does not recalculate principal, fees, or commission.

## Bank payouts

Not claimed. EO transfer rows use Connect transfer status (`totals.eo_proceeds_transferred_minor`, `transfer_status`) from the journey / wallet APIs only. Copy is **Transferred to Stripe account**, never **Paid to bank**.
