# Flutter Payment API Integration Map

| Method | Route | Request Model | Response Model | Repository Method | Controller/Screen | Error Codes | Test Coverage |
|---|---|---|---|---|---|---|---|
| POST | `/api/stripe/connect/onboarding-link` | empty | `StripeOnboardingLink` | `createConnectOnboardingLink` | `launchConnectOnboarding`, `ConnectOnboardingScreen` | 401, 403, connect_onboarding_incomplete | manual QA |
| GET | `/api/stripe/connect/status` | none | `StripeConnectStatus` | `getConnectStatus` | `refreshConnectStatus`, `ConnectOnboardingScreen` | 401, 403 | model parse via analyzer |
| POST | `/api/payment-methods/setup-intent` | empty | `SetupIntentResponse` | `createSetupIntent` | `addPaymentMethod`, `AddCardDetails`, `SecurePaymentMethodScreen` | payment_method_required, 401, 422 | widget flow manual QA |
| GET | `/api/payment-methods` | none | `List<PaymentMethodCard>` | `getPaymentMethods` | `refreshPaymentMethods` | 401, 403 | card model through UI/analyzer |
| POST | `/api/payment-methods/default` | `payment_method_id` | envelope | `setDefaultPaymentMethod` | card tile set default | 401, 403, 422 | manual QA |
| DELETE | `/api/payment-methods/{card}` | path id | envelope | `deletePaymentMethod` | card delete | 401, 403, 422 | manual QA |
| GET | `/api/events/{event}/payment-summary` | path event | `PaymentSummary` | `getPaymentSummary` | `EventAcceptPaymentScreen` | unauthorized_payment_access, 404 | `payment_models_test.dart` |
| POST | `/api/events/{event}/accept` | optional `payment_method_id` | `EventAcceptanceResult` | `acceptEvent` | `acceptEvent` | connect_onboarding_incomplete, payment_method_required, payment_failed | `payment_models_test.dart` |
| GET | `/api/payments/{payment}` | path id | `PaymentRecord` | `getPayment` | `PaymentStatusScreen`, poller | payment_requires_action, payment_failed | status enum tests |
| POST | `/api/payments/{payment}/resume-authentication` | empty | `ResumeAuthenticationResult` | `resumeAuthentication` | `resumeAuthentication` | payment_requires_action | manual QA |
| POST | `/api/payments/{payment}/retry` | `Idempotency-Key` | `PaymentRecord` | `retryPayment` | retry payment | payment_method_required, payment_failed | idempotency code path |
| POST | `/api/events/{event}/completion` | empty | envelope | `submitCompletion` | `CompletionWorkflowScreen` | completion_amount_prohibited | manual QA |
| POST | `/api/events/{event}/completion/approve` | empty | envelope | `approveCompletion` | `CompletionWorkflowScreen` | payment_failed, payment_requires_action | manual QA |
| GET | `/api/events/{event}/completion/status` | path event | `CompletionStatusResponse` | `getCompletionStatus` | `CompletionWorkflowScreen` | 401, 403, 404 | status enum tests |
| GET | `/api/events/{event}/completion/history` | path event | list | `getCompletionHistory` | `CompletionWorkflowScreen` | 401, 403 | manual QA |
| POST | `/api/events/{event}/completion/escalate` | empty | envelope | `escalateCompletion` | support escalation | support_review | manual QA |
| POST | `/api/events/{event}/completion/counters` | `proposed_principal_minor`, `message` | `CompletionCounter` | `createCounter` | counter create | counter_amount_exceeds_event_principal | manual QA |
| POST | `/api/completion-counters/{counter}/revise` | `proposed_principal_minor`, `message` | `CompletionCounter` | `reviseCounter` | future revise action | counter_amount_exceeds_event_principal | repository mapped |
| POST | `/api/completion-counters/{counter}/accept` | empty | envelope | `acceptCounter` | counter accept | payment_failed | manual QA |
| POST | `/api/completion-counters/{counter}/reject` | empty | envelope | `rejectCounter` | counter reject | 422 | manual QA |
| GET | `/api/events/{event}/cancellation-policy` | path event | `CancellationPolicy` | `getCancellationPolicy` | `CancellationWorkflowScreen` | 401, 403, 404 | manual QA |
| POST | `/api/events/{event}/cancellations/quote` | `reason_type`, `reason_message`, `force_majeure` | `CancellationQuote` | `createCancellationQuote` | quote review | 422 | `payment_models_test.dart` |
| POST | `/api/cancellations/{cancellation}/confirm` | `Idempotency-Key`, empty body | `CancellationDetail` | `confirmCancellation` | quote confirm | cancellation_quote_confirmation_required | idempotency code path |
| GET | `/api/events/{event}/cancellations/current` | path event | `CancellationDetail?` | `getCurrentCancellation` | deep link/status | 404 | repository mapped |
| GET | `/api/cancellations/{cancellation}` | path id | `CancellationDetail` | `getCancellation` | cancellation status/poller | payment_failed, support_review | status enum tests |
| GET | `/api/cancellations/{cancellation}/history` | path id | list | `getCancellationHistory` | history timeline | 401, 403 | manual QA |
| POST | `/api/cancellations/{cancellation}/resume-payment` | empty | `ResumeAuthenticationResult` | `resumeCancellationPayment` | cancellation auth | payment_requires_action | manual QA |
| POST | `/api/cancellations/{cancellation}/retry-payment` | `Idempotency-Key` | `CancellationDetail` | `retryCancellationPayment` | cancellation retry | payment_failed | idempotency code path |
| POST | `/api/cancellations/{cancellation}/force-majeure/respond` | `response`, `message` | `CancellationDetail` | `respondForceMajeure` | support review response | support_review, manual_review | manual QA |

## Backend Blocker

No final transaction/payout history endpoint is verified in `docs/PAYMENT_API_REFERENCE.md`. The Flutter implementation does not invent one.
