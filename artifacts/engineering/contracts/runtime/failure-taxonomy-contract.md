# Failure Taxonomy Contract — P0

Canonical metadata is in the sibling `failure-taxonomy-contract.meta.yaml`.

This is the SSOT registry for **technical/runtime failure classes** and their public recovery projection. Result uncertainty/evidence validity is not a failure taxonomy concern.

## Boundary

Keep these axes separate:

```text
technical/runtime failure
  -> retry / unavailable / action-required recovery

result_validity
  -> accepted | limited_evidence | insufficient_evidence | invalid | integrity_review
```

A low raw model confidence or limited evidence may trigger escalation/result-validity policy, but it is not itself an HTTP/runtime failure code.

## Canonical internal registry

| Internal code | When it occurs | Retry/fallback | Data/quota rule |
|---|---|---|---|
| `EVAL_TIMEOUT` | evaluation exceeds runtime deadline/budget | bounded retry; retain submission | retry does not double-charge logical evaluation |
| `EVAL_INFERENCE_FAILED` | approved scorer/provider execution fails | approved compatible route or durable retry | no valid result written from failed call |
| `EVAL_SCHEMA_INVALID` | scorer output fails required structure | bounded policy retry/escalation | invalid provider output never becomes result truth |
| `EVAL_EVIDENCE_INVALID` | claimed evidence refs/content cannot be validated | approved escalation or unusable result | do not silently keep unsupported score/feedback |
| `AUDIO_INVALID` | file corrupt/unsupported | upload/record again | no evaluation charge |
| `TRANSCRIPT_FAILED` | speech transcription pipeline fails technically | bounded retry or unavailable | no score without required evidence |
| `QUOTA_EXCEEDED` | quota/budget reservation unavailable | no retry loop until entitlement/window changes | reject before provider cost |
| `MODEL_VERSION_UNAVAILABLE` | required approved route/version unavailable | approved compatible route or delayed | retain submission/version provenance |
| `RECOMMENDATION_FAILED` | deterministic planner/service cannot create plan | deterministic safe fallback | do not block unrelated study access |
| `SYNC_CONFLICT` | client/server versions differ | explicit reconcile | preserve both relevant versions |
| `DRAFT_SYNC_FAILED` | draft cannot sync after local write | bounded retry/backoff | retain local draft |
| `DRAFT_VERSION_CONFLICT` | draft optimistic-version mismatch | explicit reconcile | do not discard learner content |
| `SUBMISSION_NETWORK_FAILED` | network fails before durable acceptance confirmation | retry same idempotency key | no duplicate submission |
| `CONTENT_UNAVAILABLE` | content unpublished/rights/media dependency unavailable | eligible alternative when policy allows | do not count completion/evidence |
| `RETEST_NO_ELIGIBLE_CONTENT` | no exposure-eligible retest task exists | keep learner error active | do not substitute familiar content as independent proof |

## Public projection

| Public code | Internal source | User state | Learner action |
|---|---|---|---|
| `EVALUATION_DELAYED` | `EVAL_TIMEOUT`, `MODEL_VERSION_UNAVAILABLE` when retry is pending | `delayed` | leave safely / wait / retry when offered |
| `EVALUATION_UNAVAILABLE` | `EVAL_INFERENCE_FAILED`, terminal `EVAL_SCHEMA_INVALID`, terminal `EVAL_EVIDENCE_INVALID`, route unavailable | `unavailable` | retain submission; retry/resubmit when appropriate |
| `QUOTA_EXCEEDED` | `QUOTA_EXCEEDED` | `action_required` | view reset/allowance/valid alternative |
| `SYNC_CONFLICT` | `SYNC_CONFLICT`, `DRAFT_VERSION_CONFLICT` | `action_required` | merge/reconcile |
| `DRAFT_SYNC_UNAVAILABLE` | `DRAFT_SYNC_FAILED` | `processing` | continue locally; retry sync |
| `SUBMISSION_UNAVAILABLE` | `SUBMISSION_NETWORK_FAILED` | `action_required` | retry same logical submit |
| `CONTENT_UNAVAILABLE` | `CONTENT_UNAVAILABLE`, `RETEST_NO_ELIGIBLE_CONTENT` | `action_required` | choose/await another eligible task/action |

There is deliberately **no `EVALUATION_LOW_CONFIDENCE` public failure code**. Learner-facing limited/insufficient evidence belongs to the successful result payload's `result_validity`/uncertainty copy, not RFC9457 failure semantics.

## Result-validity handoff

Examples that do not belong in this registry:

- scorer uncertainty after successful execution;
- a valid task-scoped estimate with limited evidence;
- insufficient evidence for a numeric estimate;
- integrity review based on unresolved risk signals.

Those cases are governed by evaluation/evidence contracts. They may coexist with HTTP 200 for a completed result resource.

## Telemetry / cost

Every technical failure records bounded reason class, operation/route version, retry count, latency and cost units without raw learner content/provider payload. A technical retry cannot create multiple learner charges for one logical operation.

## Evidence gap

- [ ] Provider-specific failure mapping/exit exercise not run.
- [ ] Retry/escalation cost ceilings not empirically armed.

## References

- `blueprint/06-engines.md` — engine/failure boundary.
- `artifacts/engineering/runtime-contract.yaml` — operation/result axes.
- `artifacts/engineering/api/type-system.yaml` — public failure-code projection.
- Writing/Error-to-review failure contracts — slice-specific recovery.