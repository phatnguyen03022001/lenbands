# Failure Taxonomy Contract — P0

Canonical metadata is in the sibling `failure-taxonomy-contract.meta.yaml`.

This is the SSOT registry for internal failure classes and mappings to public error states. Internal codes are used for retry, quota, and observability; public codes are used for learner/API surfaces. Do not create ad hoc codes in individual contracts.

## Canonical internal registry

| Internal code | When it occurs | Retry/fallback | Data/quota rule |
|---|---|---|---|
| `EVAL_TIMEOUT` | Scoring exceeds latency budget | bounded retry; retain submission | no score; retry does not charge again |
| `EVAL_INFERENCE_FAILED` | Model/provider failure | queue retry or approved route | do not write a valid result |
| `EVAL_LOW_CONFIDENCE` | Result below confidence policy | retain flagged result; resubmit/feedback | do not feed readiness as normal |
| `EVAL_SCHEMA_INVALID` | Output fails schema | retry under policy; no best-effort score | invalid result; reservation handled under quota contract |
| `AUDIO_INVALID` | File corrupt/unsupported | upload/record again | do not charge evaluation |
| `TRANSCRIPT_FAILED` | Transcript lacks sufficient evidence | retry or learner confirmation | do not score when evidence is missing |
| `QUOTA_EXCEEDED` | Quota or budget exhausted | no retry loop | reject request, do not charge |
| `MODEL_VERSION_UNAVAILABLE` | Model/rubric version unavailable | compatible route or delayed | retain submission version |
| `RECOMMENDATION_FAILED` | Rule/service cannot create plan | deterministic fallback | do not block session |
| `SYNC_CONFLICT` | Client/server versions differ | explicit reconcile | do not lose draft/attempt |
| `DRAFT_SYNC_FAILED` | Draft cannot sync after local write | bounded retry/backoff | retain local draft; do not create a fake server copy |
| `DRAFT_VERSION_CONFLICT` | Client/server versions differ during draft sync | explicit reconcile | do not lose draft/attempt |
| `SUBMISSION_NETWORK_FAILED` | Network fails before durable submission confirmation | retry with the same idempotency key | do not create a duplicate submission |
| `CONTENT_UNAVAILABLE` | Item unpublished/rights/media failure | equivalent gated item | do not count completion |

## Public projection

| Public code | Internal source | User state | Learner action |
|---|---|---|---|
| `EVALUATION_DELAYED` | `EVAL_TIMEOUT` | `delayed` | wait or retry under `Retry-After` |
| `EVALUATION_UNAVAILABLE` | `EVAL_INFERENCE_FAILED`, `EVAL_SCHEMA_INVALID` | `unavailable` | retain submission, explicit retry |
| `EVALUATION_LOW_CONFIDENCE` | `EVAL_LOW_CONFIDENCE` | `action_required` | view evidence/feedback; do not promote score |
| `QUOTA_EXCEEDED` | `QUOTA_EXCEEDED` | `action_required` | xem quota reset/alternative |
| `SYNC_CONFLICT` | `SYNC_CONFLICT`, `DRAFT_VERSION_CONFLICT` | `action_required` | merge/reconcile |
| `DRAFT_SYNC_UNAVAILABLE` | `DRAFT_SYNC_FAILED` | `processing` | continue writing; retry sync |
| `SUBMISSION_UNAVAILABLE` | `SUBMISSION_NETWORK_FAILED` | `action_required` | retry with the same idempotency key |
| `CONTENT_UNAVAILABLE` | `CONTENT_UNAVAILABLE` | `action_required` | choose another published task |

Public codes do not expose internal provider details. Every new mapping must bump `version`, update the API contract, and receive release review.

## Evidence gap

- [ ] Provider-specific failure mapping has no exit exercise run.
- [ ] Evaluation threshold/retry cost is not founder-approved; the registry is not an evidence run.

## References

- `blueprint/06-engines.md` — failure envelope.
- `artifacts/engineering/contracts/runtime/api-governance-contract.md` — HTTP projection.
- `artifacts/engineering/contracts/writing-task-2/failure-contract.md` — slice behavior.
