# Flutter Payment Fix Instructions

This document covers **only** what the Flutter app needs to know after the backend transfer fix. The short version: **there are no breaking API changes.** The fix is server-side (how Stripe transfers are created and recovered). Your job is mostly to make sure the app handles the payment-journey statuses correctly, including the ones that now resolve automatically.

---

## Summary for the mobile team

- The backend bug where Event Owners did not receive their money ("insufficient available funds" on the transfer) is fixed on the server.
- **No endpoint, request body, or response schema changed.**
- The main app-side requirement: treat the payment journey as **eventually consistent** for the transfer step. A settlement can briefly sit in a "transfer pending / under review" state and then move to "settled" on its own — do not treat that intermediate state as a failure the user must fix.

---

## 1. Endpoint: `GET /api/events/{event}/payment-journey`

- **Old behavior:** After a successful final payment, if the EO transfer failed, `journey_stage` could get **stuck** on `final_transfer_pending` or `manual_review` and never advance. The app might have shown a permanent "processing/needs attention" state.
- **New behavior:** A background job re-drives the transfer and the journey now advances to `financially_settled` automatically (typically within ~10 minutes, sooner if run manually by ops).
- **Request format changes:** None.
- **Response format changes:** None. Same fields (`journey_stage`, `settlement_status`, `final_payment`, `totals`, `permissions`, `next_action`, `timeline`).
- **Required Flutter changes:**
  1. Make sure these `journey_stage` values are handled as **transient, non-error, waiting** states (show a neutral "Finalizing payout…" style message, not a red error, and **do not** prompt the user to retry anything):
     - `final_transfer_pending`
     - `manual_review`
  2. Allow the journey screen to refresh (pull-to-refresh or poll on resume). Because the transfer clears in the background, re-fetching will eventually show `financially_settled`.
  3. When `journey_stage == financially_settled`, show the completed/settled UI and stop any "pending payout" indicator.
- **Error handling updates:** None required. `manual_review` is **not** a user-actionable error in this flow; it now self-resolves.
- **Payment status handling:** Drive all UI from `journey_stage` + `next_action.code` (as already documented). Do **not** infer settlement from `event.status`.

---

## 2. Endpoint: `GET /api/wallet/summary` (and `GET /api/wallet/transactions`)

- **Old behavior:** For an EO, `transferred_to_connect_minor` could under-report because the failed transfer never completed.
- **New behavior:** Once the transfer clears, `transferred_to_connect_minor` reflects the real transferred amount.
- **Request format changes:** None.
- **Response format changes:** None.
- **Required Flutter changes:** None structurally. Just re-fetch wallet data after a payout is expected (or on screen focus) so the EO sees the updated transferred amount once it clears.
- **Error handling updates:** None.
- **Payment status handling:** Keep grouping/showing amounts **per currency**; never sum different currencies (unchanged rule).

---

## 3. Endpoint: `GET /api/wallet/payouts`

- **Old behavior / New behavior:** Unchanged. Still returns `actual_bank_payout_tracking_enabled: false` and a `transfers` list.
- **Required Flutter changes:** Continue to label these as **"Transferred to Stripe account"**, not "Paid to bank". Bank payout tracking is still disabled.

---

## 4. Down payment & final payment endpoints (acceptance, completion approve, resume, retry)

- **Old behavior / New behavior:** Contracts unchanged. Requires-action, failure, and retry semantics are the same:
  - `POST /api/payments/{payment}/resume-authentication` → returns `client_secret` when `requires_action`.
  - `POST /api/payments/{payment}/retry` → retries a failed payment.
- **Required Flutter changes:** None. Keep your existing handling:
  - `requires_action` → present Stripe SCA with the returned `client_secret`.
  - `failed` → allow payment-method update + retry.
  - `succeeded` → proceed; the transfer to the EO now happens reliably on the backend.

---

## Payment / journey status handling cheat-sheet

Handle these `journey_stage` values (no schema change — this is just the correct client mapping):

| journey_stage | User-facing meaning | User action needed? |
|---|---|---|
| `final_payment_processing` | Payment in progress | No — wait |
| `final_payment_requires_action` | SCA needed | **Yes** — run SCA with `client_secret` |
| `final_payment_failed` | Payment failed | **Yes** — update card / retry |
| `final_transfer_pending` | Paid; payout to EO finalizing | **No** — auto-resolves |
| `manual_review` | Payout being reconciled | **No** — auto-resolves |
| `financially_settled` | Done | No |

Key rule: **`final_transfer_pending` and `manual_review` are waiting states, not errors.** Do not block the user or show a hard error for these; just refresh until `financially_settled`.

---

## What you do NOT need to do

- No request body changes.
- No response parsing changes.
- No new headers or auth changes.
- No new endpoints to integrate for this fix.

If your current build already renders `journey_stage`/`next_action` generically and re-fetches on screen focus, **no app change is strictly required** — the fix will simply make stuck payouts complete on their own.
