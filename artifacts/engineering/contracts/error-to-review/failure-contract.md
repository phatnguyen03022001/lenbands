# Error-to-Review Failure Contract

Canonical metadata is in `failure-contract.meta.yaml`.

Map failure → user-facing state according to the shared runtime failure taxonomy. The user does not see stack traces/codes.

| Failure | User-facing state | Recovery |
|---|---|---|
| Save error fail (network) | `Saving locally` | Retry sync, error remains local |
| Review card rating fail | `Unable to save rating` | Idempotent retry (same card_id + rating) |
| FSRS algorithm error | `Recalculating review schedule` | Default interval fallback, card is retained |
| Retest submit fail | `Unable to submit retest` | Idempotent retry, retain text |
| Retest evaluation timeout | `Evaluating retest` | Safe leave, notify when complete |
| Retest evaluation unavailable | `Unable to evaluate right now` | Retry, retain submission |
| Source error is retired | `Original task is no longer available` | Retain card, optional evidence_ref; or dismiss with a reason |
| Low confidence error | `Needs review` | Learner confirms/rejects before save |

Do not display: FSRS algorithm internals, technical error codes, or provider names.

## Retry/idempotency

- Rating: idempotent on (card_id, rating, occurred_at bucket) — do not create two duplicate history records.
- Retest submit: idempotency key as in Writing submission.
- Save error: local-first, sync delta when online.

## Cross-refs

- Runtime failure taxonomy: `06-engines.md` § Failure Contract (SSOT registry: `engineering/contracts/runtime/failure-taxonomy-contract.md`).
- Writing slice failure: `experience/specs/vertical-slices/writing-task-2.md` §10.
- Event contract: `event-contract.md` (this file's sibling).
