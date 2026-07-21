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
- pull to refresh
- app resume
- after every financial action
- Stripe / PaymentSheet return (via resume + action completion)
- deep link `groovkin://events/{id}/payment`
- bounded polling while stage is processing / awaiting auto-approval / transfer pending

Push notification text is never authoritative; taps open the event/wallet screen and re-fetch Laravel.

## Partial payments

Supports any down-payment percentage from the backend totals. Flutter does not recalculate principal, fees, or commission.

## Bank payouts

Not claimed. EO transfer rows use Connect transfer status from the journey / wallet APIs only.
