# Payment Policy Blockers

This file lists only unresolved policy decisions for the Groovkin payment, completion, counter, and cancellation module.

## Deposit Above Tier Liability

The cancellation matrix examples support the delta model:

```text
additional_principal_due = max(0, cancellation_liability - paid_principal)
principal_refund_due = max(0, paid_principal - cancellation_liability)
```

This implementation uses that model and does not retain principal above the tier liability. Client sign-off is still needed for a written policy statement because the matrix text does not explicitly say how deposits above tier liability should be handled.

## EO Force-Majeure Deposit Meaning

The matrix phrase `Forfeit Agreed deposit` for Event Organizer force majeure is ambiguous. It does not clearly state which party forfeits the deposit. The implementation routes EO force-majeure cancellations to `support_review`.

## Processor-Fee Reimbursement

The matrix does not confirm:

- whether original VM Stripe fee top-ups are refunded,
- who absorbs unrecovered Stripe fees,
- whether EO cancellation creates processor-fee liability,
- whether force majeure changes processor-fee liability.

Principal cancellation flow remains operational, but unresolved fee reimbursement reasons are surfaced for support/manual review.

## Groovkin Commission On Cancellation Liability

Earlier client confirmation says commission adjusts to the final approved amount. The implementation treats cancellation liability as the final principal for commission true-up. This rule is configurable through `GROOVKIN_COMMISSION_ON_CANCELLATION_LIABILITY`.

## Tax Treatment

No signed source in this repository defines tax collection, remittance, invoice fields, or tax refund policy for payments, cancellations, disputes, or processor-fee top-ups.

## Force-Majeure Evidence And Resolution

No signed source defines required evidence, support SLA, decision makers, appeal flow, or final financial resolution for force-majeure cases.

## Resolved In Post-Audit Implementation

These are no longer policy blockers:

- Mobile money units are integer minor units only.
- EO cannot change completion principal by submitting `requested_principal`.
- Cancellation role, timezone, event date, and tier are server-derived.
- The one-shot cancellation shortcut is disabled for mobile.
- Duplicate accept and cancellation additional-charge attempts use deterministic idempotency keys.
- Pending refunds and incomplete transfer reversals prevent `financially_settled`.
