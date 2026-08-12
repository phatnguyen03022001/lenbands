# Writing Task 2 — Failure Contract Extension

Concrete internal codes are owned by `runtime/failure-taxonomy-contract.md`; this file only defines Writing Task 2 state behavior.

This contract refines the canonical failure behavior in `blueprint/06-engines.md`. Technical codes remain internal; UI uses only `processing`, `delayed`, `unavailable` or `action_required`.

| Internal class | User state | Data safety | Allowed action | Retry policy |
|---|---|---|---|---|
| `DRAFT_SYNC_FAILED` | processing | local text retained | keep writing / retry sync | background retry with backoff |
| `DRAFT_VERSION_CONFLICT` | action_required | neither version deleted | review/merge draft | explicit client reconciliation |
| `SUBMISSION_NETWORK_FAILED` | action_required | draft retained, no duplicate submit | retry submit | same idempotency key |
| `QUOTA_EXCEEDED` | action_required | draft retained | see alternatives / upgrade | no automatic retry |
| `EVAL_TIMEOUT` | delayed | submission retained | leave and await result | queued retry under budget |
| `EVAL_INFERENCE_FAILED` | unavailable | submission retained | retry later | explicit idempotent retry |
| `EVAL_LOW_CONFIDENCE` | evaluation state `low_confidence`; error state `action_required` | result retained + flagged | inspect evidence / feedback | no score promotion to readiness |
| `CONTENT_UNAVAILABLE` | action_required | existing draft retained | choose replacement task | no implicit task swap |

Every failure emits telemetry with reason class, retry count, latency and cost reference; it must not emit learner raw content.

`evaluation_state` and user-safe failure `state` are separate axes: the former describes the evaluation resource lifecycle, while the latter describes the recovery action shown to the learner.
