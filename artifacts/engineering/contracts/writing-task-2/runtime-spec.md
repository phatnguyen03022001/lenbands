# P0-04 Writing Evaluation Runtime Specification

## 0. Status and scope

This is the first runtime slice to implement in the closed pilot. In the repository taxonomy, Writing Evaluation is **P0-04**, not P0-01; P0-01 is Identity.

This artifact specifies **processing order, state transitions, ownership, recovery, and the acceptance boundary**. It does not replace the Blueprint, Data Contract, OpenAPI, Event Contract, Failure Contract, Prompt Specification, or Runtime Foundation Contracts. When those files define their own vocabulary/schema, this runtime must consume them.

Status: `review`. It is not considered build-ready because source code, gold corpus, benchmark runs, and real acceptance evidence are missing.

## 1. Runtime objective

For an authenticated learner with consent, the system must:

1. read exactly one published Writing Task 2;
2. save a draft version without data loss;
3. create exactly one submission for each logical submit;
4. evaluate asynchronously with auditable rubric/prompt/model versions;
5. return evidence-linked feedback or a safe state when evidence is insufficient;
6. create `LearningError` only after the learner confirms a finding;
7. continue through fix, review, and retest without creating a second source of truth.

The runtime does not promise an official IELTS score. `band_estimate` is always an estimate.

## 2. Actors and component boundary

| Actor/component | Responsibility | Must not |
|---|---|---|
| Learner | write, save, submit, view feedback, confirm errors, perform fix/retest | access another learner's resources |
| Writing API | authz, input validation, idempotency, response projection | call a provider directly |
| Submission service | snapshot the draft, quota preflight, create submission + outbox | evaluate the essay itself |
| Evaluation worker | receive the job, call the adapter, normalize, persist the result | retry outside the worker contract |
| Provider adapter | map provider-neutral request/response, timeout, usage | decide domain state or event name |
| Evaluation normalizer | validate structured output, create `WritingEvaluation` + `FeedbackFinding` | invent evidence or a band |
| Review service | learner-confirmed error, fix, FSRS, retest transition | turn an unconfirmed finding into a saved error |
| Notification/read projection | report status and expose the learner-owned read model | become the source of truth |

There is no human examiner in P0. No scheduler is required; async execution uses the existing job/worker contract.

## 3. Canonical source map

| Runtime concern | Canonical contract |
|---|---|
| Capability and scope | `blueprint/03-features.md` — `P0-04`, `EVAL.Writing` |
| Learner flow | `artifacts/experience/specs/vertical-slices/writing-task-2.md` |
| HTTP interface | `artifacts/engineering/contracts/writing-task-2/openapi.yaml` |
| Entity ownership/schema | `artifacts/engineering/contracts/writing-task-2/data-contract.md` |
| Evaluation semantics | `artifacts/engineering/contracts/writing-task-2/evaluation-contract.md` |
| Prompt | `artifacts/engineering/contracts/writing-task-2/writing_evaluation_v1.md` |
| Events | `artifacts/engineering/contracts/writing-task-2/event-contract.md` |
| Failure mapping | `artifacts/engineering/contracts/writing-task-2/failure-contract.md` |
| Async delivery | `artifacts/engineering/contracts/runtime/async-job-worker-contract.md` |
| Outbox | `artifacts/engineering/contracts/runtime/outbox-reconciliation-contract.md` |
| Provider boundary | `artifacts/engineering/contracts/runtime/provider-adapter-contract.md` |
| HTTP lifecycle | `artifacts/engineering/contracts/runtime/api-governance-contract.md` |

If the runtime needs semantics missing from the source map, implementation must stop at `blocked` and create a decision/spec change; do not invent an enum or transition.

## 4. Entity ownership and relationships

```text
Published WritingTask
        ↓ task_ref + task_version
WritingDraft (learner-owned, versioned)
        ↓ immutable draft_version
WritingSubmission (system-owned for learner)
        ↓ one or more bounded evaluation attempts
WritingEvaluation (immutable accepted quality result)
        ↓ 0..n normalized findings
FeedbackFinding (evaluation-owned, immutable)
        ↓ learner confirmation only
LearningError (learner-owned lifecycle)
        ↓ 0..1 active error review card
ReviewCard (learner-owned, FSRS lifecycle)
        ↓ 0..n
RetestAttempt (learner-owned evidence of improvement)
```

### Required identity/integrity rules

- `WritingSubmission` references exactly one immutable `draft_id + draft_version` and one published `task_ref + task_version`.
- A retry never creates a new submission; it creates a new bounded evaluation attempt for the same submission.
- Only one evaluation result can be the current accepted result for a submission. A recalibration creates a new version and points to the superseded result.
- `FeedbackFinding` belongs to one evaluation and is immutable after persistence.
- `LearningError` references `source_finding_id` and `source_evaluation_id`; it is created only from a learner-confirmed finding.
- A `ReviewCard` with `content_type=error` must reference exactly one `source_error_id`.
- A `RetestAttempt` uses new content with the same `error_pattern`; it must not reuse the source submission or prompt.
- Learner text stays behind learner-scoped storage/service boundaries. Events, logs, queues and gap/benchmark metadata contain opaque references only.

## 5. State machines

### 5.1 Draft

```text
drafting
  ├─ local_save → drafting
  ├─ sync_started → syncing
  ├─ sync_succeeded → drafting
  ├─ sync_failed → local_only
  ├─ version_conflict → conflict
  └─ submit_valid_version → submitted

local_only ── retry_sync ──> syncing
conflict ── learner_reconcile ──> drafting
```

`local_only` and `conflict` are recovery/UI states; the server must not delete local text.

### 5.2 Submission

```text
submitted
  ├─ job_started → processing
  ├─ validation_rejected → not_created
  └─ quota_denied → not_created

processing
  ├─ accepted_result → scored
  ├─ low_confidence_result → low_confidence
  ├─ insufficient_or_invalid → unavailable
  ├─ retryable_timeout → delayed
  └─ terminal_failure → unavailable

delayed ── bounded_retry ──> processing | unavailable
unavailable ── explicit_retry ──> processing | unavailable
scored ──> terminal_for_current_attempt
low_confidence ──> terminal_for_current_attempt
```

`anti_gaming_review` is an evaluation state, not a public submission state. When the adapter returns `anti_gaming_status=action_required`, the runtime permits at most one recheck route; if it does not clear, the submission is `unavailable` and the score is not exposed.

### 5.3 Evaluation

```text
submitted → processing

processing
  ├─ clear + valid evidence → scored / quality_status=accepted
  ├─ low confidence → low_confidence / quality_status=low_confidence
  ├─ insufficient evidence → invalid / quality_status=insufficient_evidence
  ├─ schema/domain invalid → failed / quality_status=invalid
  └─ anti-gaming signal → anti_gaming_review

anti_gaming_review
  ├─ recheck_clear → processing
  └─ recheck_failed → failed
```

There is no transition from `low_confidence`, `invalid`, or `failed` to accepted through manual editing. Only a new evaluation attempt can create a new result.

### 5.4 FeedbackFinding and LearningError

```text
FeedbackFinding: persisted → immutable

LearningError:
candidate (not yet a learner-owned entity)
  └─ learner_confirm → open

open → in_review → improved
  ├─ fix_evidence_saved → in_review
  ├─ retest_passed + resolve_when met → improved
  ├─ learner_dismissed → dismissed
  └─ recurrence_after_improved → in_review
```

`improved` must not be set by an arbitrary endpoint; a versioned `resolve_when` rule must determine it from retest/review evidence. Without evidence, do not create a `ReviewCard`.

### 5.5 ReviewCard and RetestAttempt

FSRS is the authority for card transitions:

```text
new → learning → review
             └→ relearning → review
```

The `again | hard | good | easy` ratings are processed by the FSRS implementation with `algorithm_version`. The runtime only validates input, persists the transition idempotently, and emits the event after the durable write.

```text
created → submitted → processing → completed
                                  └→ unavailable
```

`completed` updates `LearningError` only after the retest evaluation and `resolve_when` have been checked.

## 6. Happy path — exact orchestration

### A. Read task

1. The API authenticates the bearer subject.
2. The task service returns only a task with `status=published` and the current `task_version`.
3. The task response includes `task_ref`, `task_version`, task type, prompt, `min_word_count`, and estimated time.
4. A missing/retired task returns user-safe `404`/`CONTENT_UNAVAILABLE`; do not select another task automatically.

### B. Save draft

1. The client sends `PUT /v1/writing/drafts/{draftId}` with text and optimistic `version`.
2. The API checks ownership, max length, and version.
3. The server writes the new version; the old version is not overwritten in content.
4. Retrying the same request returns the same semantic result; conflict returns `409 version_conflict`.
5. The autosave event contains only `draft_id`, `task_ref`, version, and outcome; it contains no text.

### C. Submit

1. The API checks authz, consent, published task, draft ownership/version, and `word_count >= 250`.
2. Check quota before inference.
3. In one transaction: write `WritingSubmission`, write the idempotency result, and write the `writing_evaluation` outbox job.
4. The relay publishes the job after commit. Do not enqueue directly before commit.
5. Emit `writing_submission_accepted` after durable submission; the evaluation orchestrator emits `evaluation_submitted` when the attempt starts.
6. Return `202` with the same `submission_id`, `status=submitted`, no `evaluation_ref` yet, and `request_id`.
7. Retrying with the same idempotency key returns the same submission; a different body with the same key returns `409 idempotency_key_reused`.

### D. Evaluate

1. The worker claims the job, checks idempotency and deadline, and moves the submission/evaluation attempt to `processing`.
2. The worker calls the provider adapter at most once per attempt, with opaque `submission_ref`, rubric/task version, and deadline.
3. The normalizer parses the Evaluation Contract; a schema error is terminal failure, and no partial score is stored.
4. The normalizer checks criterion enum, band range, confidence range, evidence refs, anti-gaming status, and required versions.
5. In one transaction: write immutable `WritingEvaluation`, normalized `FeedbackFinding`, current result pointer, usage/cost reference, and idempotency effect.
6. Ack the job and emit `evaluation_scored` or a failure event only after commit.
7. `LearningError` is not created automatically. The learner must confirm a finding through `POST /v1/writing/errors`.

### E. Read result

- `GET /v1/writing/submissions/{id}` always returns the lifecycle projection.
- `GET /v1/writing/submissions/{id}/evaluation` returns `200` when a quality result exists.
- When no result exists, the endpoint returns `202` with state `submitted|processing|delayed` and a retry hint; do not create a fake evaluation.
- When the quality result is low-confidence/insufficient/invalid, the response must show the state and evidence limitation, not only a band.
- The client need not maintain an infinite polling loop: retry/backoff follows `Retry-After`; the learner can leave the screen and receive a notification/read projection.

### F. Confirm error → fix → review → retest

1. The learner selects a finding with evidence and calls `POST /v1/writing/errors`.
2. The service checks that the finding belongs to the learner's evaluation, the evidence ref exists, the pattern/criterion resolves, and idempotency holds.
3. Persist `LearningError(status=open)`; emit `learning_error_saved`.
4. The review service creates the card after the error is saved; the card must have `source_error_id`.
5. The fix endpoint stores learner-generated fix evidence; it does not mark the error improved.
6. Persist the FSRS rating transition; emit `review_completed` after the durable write.
7. Retest creates a new prompt with the same error pattern; emit `learning_error_resolved` only when the retest + resolve rule passes.

## 7. API behavior contract

OpenAPI is the canonical schema. The runtime must implement the following operations and must not add polling/streaming variants:

| Operation | Success | Required failure behavior |
|---|---|---|
| `GET /v1/writing/tasks/{taskId}` | `200 WritingTask` | unpublished/unknown → `404` |
| `PUT /v1/writing/drafts/{draftId}` | `200 WritingDraft` | version conflict → `409`; network failure preserves local text |
| `POST /v1/writing/submissions` | `202 WritingSubmission` | invalid/quota/idempotency → `400/403/409/422/429` |
| `GET /v1/writing/submissions/{id}` | `200 WritingSubmission` | cross-user → `404` |
| `POST /v1/writing/submissions/{id}/retry` | `202 WritingSubmission` | delayed/unavailable only; scored → `409` |
| `GET /v1/writing/submissions/{id}/evaluation` | `200 WritingEvaluation` or `202 EvaluationPending` | cross-user → `404` |
| `POST /v1/writing/submissions/{id}/feedback` | `201 FeedbackReceipt` | invalid label → `400`; cross-user → `404`; duplicate → `409` (idempotent) |
| `POST /v1/writing/errors` | `201 LearningError` | unconfirmed/invalid evidence → `400/422` |
| `POST /v1/writing/errors/{id}/fixes` | `201 FixEvidence` | wrong owner/state → `404/409` |
| `POST /v1/writing/errors/{id}/retest` | `202 Retest` | no eligible error → `409` |
| `POST /v1/review/cards/{id}/ratings` | `200 ReviewCardRating` | duplicate/conflict → idempotent result/`409` |

All mutations use `Idempotency-Key`; all responses use `X-Request-Id`; the error envelope contains no raw essay/provider payload/stack trace.

## 8. Failure and recovery matrix

| Failure | Durable state | Learner state | Retry |
|---|---|---|---|
| Draft sync network | local draft retained | `processing`/local-only | background retry |
| Draft version conflict | both versions retained | `action_required` | explicit reconcile |
| Submit network timeout | idempotency lookup decides | draft retained | same key |
| Quota denied | no submission/eval job | `action_required` | no auto retry |
| Worker crash before commit | submission retained | `processing`/delayed | reclaim same job safely |
| Provider timeout | submission retained, no score | `delayed` | max bounded retry |
| Provider/schema terminal error | submission retained, failed attempt | `unavailable` | explicit new attempt |
| Low confidence | immutable flagged result retained | `low_confidence` | no score promotion |
| Anti-gaming unresolved | no learner-visible score | `unavailable` | one recheck only |
| Event publish failure | domain result retained; outbox pending | result readable | reconciliation |
| Duplicate delivery | idempotency record/effect exists | unchanged | ack after lookup |

No recovery path deletes the original draft or accepted evaluation. No retry path charges quota twice.

## 9. Required runtime evidence

Each implementation run must be able to create the following observations, but they are not considered real evidence until executed:

```yaml
submission_id:
evaluation_id:
attempt:
task_version:
rubric_version:
prompt_template_id:
prompt_hash:
model_version:
evaluation_state:
quality_status:
criterion_results:
evidence_coverage:
latency_ms:
provider_usage_ref:
cost_ref:
redaction_result:
idempotency_result:
```

The benchmark runner consumes these observations/results; the runtime does not claim to meet the threshold. The threshold and corpus are in `artifacts/operations/benchmark/`.

## 10. P0-04 acceptance cases

These IDs match `artifacts/operations/acceptance/p0-acceptance-manifest.yaml`:

| ID | Given / When / Then | Evidence to record |
|---|---|---|
| `WR-01-published-task-only` | unpublished/retired task → submission is rejected; published task → submission is accepted | request/response + authorization/task fixture |
| `WR-02-draft-preserved` | autosave, reload, or failed submit → owner can still read text/version | storage/read-back + privacy result |
| `WR-03-duplicate-submit-idempotency` | submit twice with the same key → one submission, one charge/job effect | two requests + IDs + effect count |
| `WR-04-evaluation-state-recovery` | timeout/worker crash → safe delayed or unavailable state; retry does not duplicate the result | fault injection + state/event trace |
| `WR-05-evidence-linked-feedback` | accepted result → every learner-visible finding has an evidence ref; missing evidence → insufficient state | response + finding/evidence mapping |
| `WR-06-redaction` | event/log/job/telemetry inspection → no essay, finding text, or provider payload | redaction scan |
| `WR-07-low-confidence-withheld` | low-confidence/anti-gaming → do not promote score/readiness; learner sees a safe state | result + readiness query + UI/API projection |

The acceptance run remains `not_run` until source code and runtime fixtures create immutable evidence. Test IDs are not proof that tests have passed.

## 11. Implementation stopping rules

- Do not add a scheduler, compiler, graph database, or policy engine to implement this slice.
- Do not add an endpoint without a corresponding user action or acceptance case.
- Do not add an entity when the relationship can be represented by a reference to an existing canonical entity.
- Do not put business rules in the generator; runtime rules belong in the contract/domain implementation and must be tested.
- If implementation encounters an enum, ownership, or transition not defined in the canonical source, mark it `blocked` and create a decision/spec change before coding.
