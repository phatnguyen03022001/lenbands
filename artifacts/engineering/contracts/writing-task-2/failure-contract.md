# Writing Task 2 — Failure Contract Extension

Concrete internal failure codes are owned by `runtime/failure-taxonomy-contract.md`. This file only specializes Writing Task 2 recovery behavior.

Technical/runtime failure and result validity are separate axes.

## Failure behavior

| Internal class | User state | Data safety | Allowed action | Retry policy |
|---|---|---|---|---|
| `DRAFT_SYNC_FAILED` | `processing` | local text retained | keep writing / retry sync | bounded background retry |
| `DRAFT_VERSION_CONFLICT` | `action_required` | neither version silently deleted | reconcile draft | explicit client reconciliation |
| `SUBMISSION_NETWORK_FAILED` | `action_required` | draft retained; no duplicate submit | retry submit | same idempotency key |
| `QUOTA_EXCEEDED` | `action_required` | draft retained | see allowance/valid alternative | no automatic provider retry |
| `EVAL_TIMEOUT` | `delayed` | submission retained | leave/revisit safely | bounded durable retry under budget |
| `EVAL_INFERENCE_FAILED` | `unavailable` | submission retained | retry later if offered | approved compatible route or explicit retry |
| `EVAL_SCHEMA_INVALID` | `delayed` or `unavailable` | submission retained; invalid provider output not promoted | governed escalation/retry | bounded by evaluation policy |
| `EVAL_EVIDENCE_INVALID` | `delayed` or `unavailable` | unsupported evidence not promoted | governed escalation/resubmit | bounded by evidence policy |
| `MODEL_VERSION_UNAVAILABLE` | `delayed` or `unavailable` | submission/version provenance retained | wait/retry | no unbenchmarked fallback |
| `CONTENT_UNAVAILABLE` | `action_required` | existing draft retained | choose/await eligible task | no implicit task swap |

Every technical failure emits redacted telemetry with reason class, retry count, latency and cost reference; never raw learner content.

## Result-validity behavior — not failures

These are completed-result semantics rather than runtime failure codes:

| `result_validity` | Learner behavior |
|---|---|
| `accepted` | show task-scoped diagnostic estimate + evidence-backed feedback |
| `limited_evidence` | show scoped limitation + next verification action; downstream evidence policy decides admissibility |
| `insufficient_evidence` | prefer no fabricated numeric estimate; explain what additional evidence is needed |
| `invalid` | do not present ordinary score/feedback; offer appropriate resubmission/recovery |
| `integrity_review` | neutral action-required/resubmission guidance; no detector-based accusation |

There is deliberately no `EVAL_LOW_CONFIDENCE` failure path and no persisted Writing lifecycle state called `low_confidence`.

Raw scorer confidence may be restricted governance/routing data. It cannot directly determine learner-facing correctness probability.

## Retry / cost rules

- one logical submission/evaluation is charged at most once according to quota policy;
- provider retries/escalations are separately attributed but do not multiply learner charges;
- deterministic precheck failures incur zero scorer calls;
- hard-case escalation has a hard maximum;
- retry ownership belongs to one runtime layer;
- no fallback to an unbenchmarked scorer to improve availability.

## Data safety

- accepted learner draft/submission survives provider/workflow failure;
- raw essay does not enter failure detail, logs or general analytics;
- terminal operation failure does not mutate an existing immutable evaluation result;
- a governed retry/re-evaluation creates a new audited operation/result where applicable.

## Cross-references

- canonical failure registry: `artifacts/engineering/contracts/runtime/failure-taxonomy-contract.md`;
- operation/result semantics: `artifacts/engineering/runtime-contract.yaml`;
- evaluation/result validity: sibling `evaluation-contract.md`;
- learner experience: Writing vertical slice.