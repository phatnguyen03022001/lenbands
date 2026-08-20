# P0-04 Writing Evaluation Runtime Specification

## Status and authority

This scoped contract connects the P0 Writing Task 2 processing order, domain entities, recovery behavior and verification boundary. It does not own HTTP operations, shared runtime lifecycle, access control, retention or release policy.

Status: `review`. The design may be implemented against fixtures once the family satisfies canonical implementation eligibility and exact-SHA authorization. Rights, benchmark, privacy/recovery and real runtime evidence remain release gates rather than circular pre-code prerequisites.

Canonical dependencies:

- product/capabilities: `blueprint/01-product.md`, `blueprint/03-features.md`;
- experience: `artifacts/experience/specs/vertical-slices/writing-task-2.md`;
- HTTP + typed API: `artifacts/engineering/api/`;
- runtime: `artifacts/engineering/runtime-contract.yaml`;
- access: `artifacts/engineering/api/access-control.md`;
- scoped data/evaluation/failure/event contracts: sibling files;
- failure taxonomy: `artifacts/engineering/contracts/runtime/failure-taxonomy-contract.md`;
- provider execution: `artifacts/engineering/contracts/runtime/provider-adapter-contract.md`;
- evaluation route/governance: `blueprint/06-engines.md` + benchmark/release policy.

Retired split OpenAPI/lifecycle/topology/worker documents are not implementation inputs and must not reappear as authorities.

## Learner outcome

```text
published Writing Task 2
  -> durable draft
  -> immutable submission
  -> staged evidence-based diagnostic evaluation
  -> one priority finding
  -> smallest useful fix
  -> retrievable review when appropriate
  -> sufficiently novel retest
  -> verified improvement or explicit remaining gap
```

A Writing Task 2 result is a `diagnostic_estimate` for this task. It is never an official IELTS Writing section score.

## Component boundary

| Component | Owns | Must not |
|---|---|---|
| Learner | own draft, submit intent, feedback confirmation, fix/retest | access another learner's objects |
| Application/API boundary | authz, validation, idempotency, typed projection | treat client/provider data as authority |
| Submission domain | immutable snapshot, quota reservation, durable operation creation | perform rubric judgment |
| Evaluation orchestration | stage order, deadline, bounded escalation, provenance binding | author readiness/mastery |
| Deterministic precheck | task/version/rights/word/input facts | infer rubric band |
| Provider adapter | execute one bounded approved provider call | write domain result or self-author provenance |
| Evidence validator/normalizer | schema, rubric, evidence and result-validity admission | invent unsupported evidence |
| Escalation route | independent approved pass for governed hard cases only | run on every submission |
| Feedback mapper | admitted finding → controlled remediation candidate | invent framework IDs |
| Review/retest domain | confirmed error, retrievable review timing, novel retest | equate review maturity with Writing mastery |
| Read projection/notification | learner-safe status/result rendering | become SSOT |

There is no runtime human examiner dependency. Models/providers/prompts are replaceable mechanisms, not principals or product authority.

## Canonical entities

```text
WritingTask(versioned published content)
  -> WritingDraft(versioned learner work)
  -> WritingSubmission(immutable snapshot reference)
  -> DurableEvaluationOperation(operation state)
  -> WritingEvaluation(result validity + rubric evidence)
  -> FeedbackFinding(normalized learner-safe finding)
  -> learner confirmation
  -> LearningError
  -> optional ReviewCard
  -> RetestAttempt
```

Rules:

- retries cannot create duplicate submissions/domain effects/logical charges;
- published task/rubric/prompt versions referenced by evidence remain immutable;
- governed re-evaluation creates a new evaluation/result reference rather than rewriting history;
- raw essay text never enters general telemetry or transport metadata;
- `LearningError` is created only from an owned actionable admitted finding under the learner remediation policy;
- retest content must satisfy configured exposure/novelty rules.

## State model

### Draft

```text
drafting <-> syncing
  -> local_only | conflict
  -> submitted_snapshot
```

Local recovery state preserves learner text and is not evaluation truth.

### Submission projection

```text
submitted -> processing -> completed | delayed | unavailable
```

Submission state reflects durable learner operation progress, never score confidence/validity.

### Durable evaluation operation

Canonical shared states:

```text
accepted -> processing -> succeeded | delayed | unavailable | failed | cancelled
```

### Result validity

```text
accepted | limited_evidence | insufficient_evidence | invalid | integrity_review
```

Provider timeout/outage affects operation state. Evidence insufficiency/integrity affects result validity. Raw model confidence owns neither axis.

## Evaluation pipeline

```text
immutable submission snapshot
  -> deterministic precheck
  -> approved scorer-route selection
  -> primary provider adapter call
  -> candidate schema + rubric + evidence validation
  -> uncertainty/disagreement/integrity policy
       -> ordinary case: normalize
       -> governed hard case: independent approved escalation
  -> immutable WritingEvaluation with result_validity
  -> deterministic/framework-valid finding mapping
  -> optional learner-facing wording/detail generation
```

### Deterministic precheck

Before paid inference:

- resolve owner, task/version/module/status/rights;
- validate idempotency/submission state;
- compute word count/basic input integrity;
- reject unsupported/invalid input;
- reserve/check quota/cost policy;
- create deterministic evidence-span references;
- build only minimum operation-required context.

### Primary scorer

The scorer receives task, immutable essay snapshot, rubric/version and minimum bounded context. It returns candidate rubric judgments and supplied evidence references according to `evaluation-contract.md`; it does not return authoritative provider provenance or `result_validity`.

### Validation and provenance binding

The domain/runtime validates:

- candidate schema/version/criterion/value rules;
- evidence references resolve to deterministically supplied learner-owned spans/features;
- score scope=`writing_task_2` and score label=`diagnostic_estimate`;
- task/rubric/prompt/route/provider/model provenance is complete and independently bound by runtime;
- unsupported/hallucinated findings;
- insufficiency/integrity signals.

Invalid evidence cannot be silently removed while preserving the same confident claim.

### Escalation

A second/stronger/specialist route executes only when the versioned policy identifies a material hard case. It has a hard maximum and independent cost/provenance. No approved compatible route means preserve the operation/submission and expose delayed/unavailable rather than silently lowering quality.

### Result admission

Domain normalization creates one immutable `WritingEvaluation` using `band_estimate`/`overall_band_estimate` and separate `result_validity`. Only downstream evidence policy can update readiness/mastery.

### Feedback

```text
evidence
  -> criterion meaning
  -> one highest-leverage action
  -> verification/retest
  -> optional deeper explanation
```

Reusable remediation content is versioned/precomputed where possible. Optional generated prose cannot mutate score/evidence truth.

## Durable submission orchestration

1. Save/version learner draft.
2. Validate submit ownership/task/input/quota/idempotency.
3. Commit immutable submission snapshot reference + stable idempotency effect + durable evaluation operation using the selected managed transactional/durable mechanism.
4. Return accepted references only after canonical state is durable.
5. Orchestration executes the staged evaluation through the approved provider adapter.
6. Commit result/findings/usage-cost provenance before marking the durable operation succeeded.
7. Any event/notification projection is emitted/reconciled from canonical state and remains replay-safe.

The exact queue/workflow/provider mechanism is replaceable. No custom outbox, Redis stream, worker fleet, Go service or Python service is required by this contract.

## Learner result behavior

The UI/API exposes truthful state:

- `processing` / `delayed` when no admitted result exists;
- `unavailable` when no approved route can produce a valid result;
- accepted task-scoped estimate when admitted;
- explicit `limited evidence` / `insufficient evidence` wording when appropriate;
- no raw-confidence percentage unless separately validated for learner interpretation.

Scope/meaning is presented before numeric precision.

## Error → remediation → review → retest

1. Normalizer creates immutable `FeedbackFinding` with resolvable evidence.
2. Learner selects/confirms an actionable owned finding.
3. Server derives controlled criterion/error/remediation mapping; unresolved taxonomy is not invented.
4. Persist `LearningError`.
5. Select smallest useful intervention.
6. Create FSRS card only for meaningfully retrievable remediation units.
7. FSRS controls review timing only.
8. Retest uses exposure-eligible sufficiently novel content for the same underlying error/construct.
9. `improved` requires the versioned retest/evidence rule; repeated/revealed success is insufficient.
10. Writing readiness/mastery remains owned by its broader evidence policy.

## Integrity

Prefer deterministic/provenance signals: known-sample similarity, copied prompt/passage overlap, exposure history and invalid interaction provenance where reliable. AI-generated-text detectors, if used, are weak supporting signals only. They cannot alone label cheating or permanently suppress history. Material unresolved cases use `result_validity=integrity_review` plus neutral recovery/resubmission.

## API boundary

This slice consumes canonical operation IDs/schemas/access annotations from `artifacts/engineering/api/`; it never redefines them. Durable mutations use canonical idempotency. Cross-user access fails closed. Public failures use RFC9457 and contain no raw essay/provider payload/stack trace.

The canonical API validator must prove Writing score field/result-validity semantics before implementation eligibility is claimed.

## Cost policy

Each logical evaluation attributes primary, escalation, optional feedback-generation, retry waste and policy version separately. Rules:

- zero paid inference before deterministic eligibility;
- no unconditional second pass;
- default concise actionable feedback;
- deep feedback is on-demand/quota-bound;
- reusable remediation content is precomputed;
- retry/escalation ceilings are bounded;
- cheaper routes cannot bypass benchmark quality floor;
- measure accepted-evaluation economics and downstream cost per verified improvement.

## Privacy and observability

General telemetry may carry opaque IDs, stage, route/version, timings, failure/result-validity class and usage/cost aggregates. It must not carry raw essay, private note, prompt body containing learner content, full provider response, secret/token or hidden reasoning.

Benchmark/research access uses a separately scoped principal and approved corpus; ordinary admin/colab access does not imply production learner-assessment browsing.

## Implementation verification boundary

Before source implementation is called eligible, repository-level contracts/validators must prove at least:

- canonical API/schema/access/operation ownership agree;
- Writing candidate vs admitted-result field/provenance semantics agree;
- operation state and result validity remain separate;
- no implementation-blocking risk remains for the family;
- the scoped owner contracts are sufficient to avoid inventing behavior.

These are design/repository checks, not claims that learner-facing quality works in production.

## Release evidence boundary

Candidate-bound executable evidence is additionally required before real learner release, including as applicable:

- rights-approved tasks;
- autosave/network/idempotency/cross-user/privacy tests;
- approved benchmark corpus + required quality/fairness slices;
- benchmark-approved primary/escalation route;
- evidence/result-validity admission tests;
- provider outage/recovery behavior;
- independent retest content/policy and verified-improvement run;
- accessibility/network critical-path acceptance;
- armed cost/quota thresholds and rollback/disable path;
- legal/processing/provider eligibility for real learner data.

Absence of post-code evidence keeps release `not ready`; it does not force implementation to invent an alternate architecture.
