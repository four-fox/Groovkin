# Event Payment Journey API

## Endpoint

```http
GET /api/events/{event}/payment-journey
Authorization: Bearer <token>
```

Role is derived from the authenticated user and event ownership. Flutter must not send `user_id` or `role`.

Authorized callers:

- Event Organizer (`event.user_id`)
- Venue Manager (`event.venue.user_id` or `event.accepted_by`)

Unauthorized callers receive:

```json
{
  "status": false,
  "code": "unauthorized_event_payment_access",
  "message": "You are not authorized to view payment information for this event."
}
```

## Purpose

One role-aware read model for:

- down payment paid vs remaining balance
- completion / counter / final payment state
- transfer state
- permissions and next action
- ordered timeline

Flutter must not infer financial permissions from `event.status` alone.

## Journey stages

Central constants live in `App\Services\Payments\PaymentJourneyStages`.

| Stage | Meaning |
|-------|---------|
| `proposal_created` | Proposal exists |
| `awaiting_connect_onboarding` | EO or VM Connect incomplete |
| `awaiting_payment_method` | VM needs reusable default card |
| `awaiting_acceptance` | Ready for VM accept |
| `down_payment_processing` | Down payment PI processing |
| `down_payment_requires_action` | Down payment needs SCA |
| `down_payment_failed` | Down payment failed |
| `event_in_progress` | Accepted; remaining balance pending completion |
| `completion_requested` | EO submitted completion; 48h timer running |
| `counter_negotiation` | Open/revised counter |
| `support_review` | Escalated / expired counter |
| `completion_approved` | VM approved completion |
| `completion_auto_approved` | Auto-approved after 48h |
| `final_payment_processing` | Final PI processing |
| `final_payment_requires_action` | Final payment needs SCA |
| `final_payment_failed` | Final payment failed |
| `final_transfer_pending` | Final payment succeeded; Connect transfer pending |
| `financially_settled` | Settlement complete |
| `cancellation_processing` | Cancellation financial work in progress |
| `cancelled` | Cancelled / cancellation settled |
| `manual_review` | Manual review |
| `disputed` | Dispute present |

## Next-action codes

| Code | Typical UI |
|------|------------|
| `complete_connect_onboarding` | Open Connect onboarding |
| `add_payment_method` | SetupIntent flow |
| `review_and_accept` | Accept event |
| `complete_down_payment` | Resume/retry down payment |
| `wait_for_event` | Informational |
| `submit_completion` | EO completion submit |
| `review_completion` | VM approve / counter |
| `review_counter` | Counter actions |
| `resume_final_payment` | Resume authentication |
| `retry_final_payment` | Retry final payment |
| `view_support_review` | Support UI |
| `view_cancellation` | Cancellation detail |
| `view_settlement` | Settled summary |
| `none` | No action |

## Role | Journey stage | UI state | Allowed action | Endpoint

| Role | Journey stage | UI state | Allowed action | Endpoint |
|------|---------------|----------|----------------|----------|
| VM | `awaiting_connect_onboarding` | Setup required | Start Connect | `POST /api/stripe/connect/onboarding-link` |
| VM | `awaiting_payment_method` | Add card | Create SetupIntent | `POST /api/payment-methods/setup-intent` |
| VM | `awaiting_acceptance` | Ready to accept | Accept event | `POST /api/events/{event}/accept` |
| VM | `down_payment_requires_action` | Authenticate | Resume payment | `POST /api/payments/{payment}/resume-authentication` |
| EO/VM | `event_in_progress` | In progress | EO: submit completion | `POST /api/events/{event}/completion` |
| VM | `completion_requested` | Review completion | Approve / counter | `POST .../completion/approve`, `POST .../counters` |
| EO/VM | `counter_negotiation` | Counter open | Accept/revise/reject | `POST /api/completion-counters/{counter}/...` |
| VM | `final_payment_requires_action` | Authenticate final | Resume | `POST /api/payments/{payment}/resume-authentication` |
| VM | `final_payment_failed` | Retry | Retry | `POST /api/payments/{payment}/retry` |
| EO/VM | `financially_settled` | Settled | View wallet | `GET /api/wallet/summary` |

## Compact Event Detail field

`GET /api/event-details/{id}` may include:

```json
"payment_overview": {
  "journey_stage": "event_in_progress",
  "settlement_status": "down_payment_succeeded",
  "down_payment_percentage": "20.0000",
  "down_payment_paid_minor": 20000,
  "remaining_principal_minor": 80000,
  "next_action_code": "wait_for_event",
  "has_payment_activity": true
}
```

Only present for EO/VM participants. Use `/payment-journey` for the full payload.

## Money units

All money fields are integer minor units. Do not recalculate totals in Flutter.
