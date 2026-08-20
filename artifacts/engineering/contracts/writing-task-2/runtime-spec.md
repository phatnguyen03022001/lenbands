# P0-04 Writing Evaluation Runtime Specification

## 0. Status and authority

This contract owns the P0 Writing Task 2 processing order, durable state transitions, component responsibilities, recovery and acceptance boundary.

Status: `review`. It is not build-ready until the benchmark route, rights-approved tasks, acceptance tests and runtime evidence exist.

Canonical dependencies:

- product/capabilities: `blueprint/01-product.md`, `blueprint/03-features.md`;
- experience: `artifacts/experience/specs/vertical-slices/writing-task-2.md`;
- canonical HTTP operations: `artifacts/engineering/api/openapi.yaml`;
- canonical request/response semantics: `artifacts/engineering/api/schema-contract.yaml`;
- runtime invariants: `artifacts/engineering/runtime-contract.yaml`;
- scoped data/evaluation contracts: sibling `data-contract.md` and `evaluation-contract.md`;
- failure taxonomy: canonical runtime failure contract/registry;
- evaluation route/governance: `blueprint/06-engines.md` + activated benchmark/release evidence.

Legacy `artifacts/engineering/contracts/**/openapi.yaml` files are migration-only and are not implementation/codegen authorities.

## 1. Learner outcome

The slice proves one loop:

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

A Writing Task 2 result is a `diagnostic_estimate` for this task. It is never presented as an official IELTS Writing section score.

## 2. Component boundary

| Component | Owns | Must not |
|---|---|---|
| Learner | own draft, submit intent, feedback confirmation, fix/retest | access another learner's objects |
| Writing API | authz, validation, idempotency, typed projection | call model/provider directly |
| Submission service | immutable snapshot, quota reservation, durable operation creation | perform scoring judgment |
| Evaluation orchestrator | stage order, deadlines, bounded escalation, route provenance | author readiness/mastery |
| Deterministic precheck | task/word/language/basic format facts | infer rubric band |
| Primary scorer adapter | bounded rubric judgment | write domain entities directly |
| Evidence validator/normalizer | schema, rubric, evidence and result-validity admission | invent unsupported evidence |
| Escalation scorer | independent stronger/specialist pass for hard cases only | run on every submission |
| Feedback mapper | evidence-backed finding → framework error/remediation candidate | publish framework IDs not already valid |
| Review service | confirmed error, fix, FSRS scheduling where suitable, retest | equate review maturity with Writing mastery |
| Read projection/notification | learner-safe status/results | become SSOT |

There is no runtime human examiner dependency. Models/providers/prompts are mechanisms, not principals or product authority.

## 3. Canonical entities

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

- retries do not create duplicate submissions or duplicate charges;
- published task/rubric/prompt versions referenced by evidence remain immutable;
- an evaluation result is immutable; governed re-evaluation creates another result/version;
- raw essay text never enters general telemetry, queue metadata or analytics;
- `LearningError` is created only from a learner-confirmed actionable finding;
- retest content must satisfy the configured novelty/exposure rule.

## 4. State model

Transport/processing state and result trustworthiness are separate axes.

### 4.1 Draft state

```text
drafting <-> syncing
  -> local_only | conflict
  -> submitted_snapshot
```

`local_only`/`conflict` preserve learner text and provide recovery; they are not evaluation states.

### 4.2 Submission state

Submission reflects durable acceptance, not score quality:

```text
submitted -> processing
processing -> completed | delayed | unavailable
```

A completed operation may contain an accepted or limited result according to result validity. Do not add `low_confidence`/`invalid` as submission lifecycle states.

### 4.3 Durable evaluation operation

Canonical runtime states:

```text
accepted -> processing -> succeeded | delayed | unavailable | failed | cancelled
```

Provider timeout/outage affects operation state. It does not manufacture an evaluation result.

### 4.4 Result validity

```text
accepted
limited_evidence
insufficient_evidence
invalid
integrity_review
```

Only result states admitted by the evaluation/evidence policy may feed learner state/readiness. Raw model confidence does not define this state by itself.

## 5. Exact evaluation pipeline

```text
immutable submission snapshot
  -> deterministic precheck
  -> scorer route selection
  -> primary structured scorer
  -> schema + rubric + evidence validation
  -> uncertainty/disagreement/risk policy
       -> ordinary case: normalize
       -> hard case: independent stronger/specialist scorer
  -> reconciliation / result-validity admission
  -> immutable WritingEvaluation
  -> deterministic/framework-valid finding mapping
  -> optional learner-facing wording/detail generation
```

### Stage A — deterministic precheck

Before paid inference:

- verify task status/version/module;
- verify submission ownership/idempotency;
- compute deterministic word count and basic input integrity;
- reject empty/invalid/unsupported input;
- reserve/check quota/budget;
- create bounded compact context only if evaluation requires it.

Do not call an LLM for facts already available from schema/rules.

### Stage B — primary scorer

The primary scorer receives only the task, essay snapshot, rubric/version and minimum bounded context required by the scorer contract.

It returns structured criterion judgments + evidence candidates; it does not write band/readiness/history directly.

### Stage C — validation

The domain validates:

- output schema/version;
- criterion enum;
- band value/range/rounding policy;
- evidence references actually resolve to learner submission spans/features;
- score scope=`writing_task_2` / label=`diagnostic_estimate`;
- required provenance;
- unsupported/hallucinated findings;
- integrity signals.

Invalid structure/evidence cannot become an ordinary result.

### Stage D — escalation policy

A stronger/second scorer runs only when a versioned policy marks the case high-risk/high-uncertainty/disagreement-worthy and budget allows the approved route.

Escalation is not a generic retry. It is independently metered and has a hard maximum.

### Stage E — result admission

Reconciliation produces one immutable normalized result with a separate `result_validity`.

No scorer/model writes learner readiness/mastery directly. Downstream evidence admission remains domain-owned.

### Stage F — feedback

Default feedback is progressive:

```text
evidence
  -> meaning/criterion
  -> one highest-leverage fix
  -> verification/retest
  -> optional deeper explanation
```

Reusable remediation/explanations are precomputed/cached when semantically safe. Runtime generation is reserved for genuinely personalized wording/analysis.

## 6. Submission orchestration

1. Learner saves/version-controls draft.
2. Submit validates ownership, task version, input and quota.
3. One transaction writes submission snapshot reference + idempotency result + durable evaluation operation/outbox handoff.
4. Return accepted operation/submission reference only after durable commit.
5. Worker/orchestrator claims the operation and executes staged pipeline.
6. Result + findings + usage/cost provenance are committed before success acknowledgement/event.
7. Outbox/events reconcile after canonical domain state; duplicate delivery is harmless.

No internal failure may charge the learner twice for one logical evaluation.

## 7. Learner result behavior

The UI/API exposes truthful state:

- `processing` / `delayed` when no result exists yet;
- `unavailable` when no approved result can be produced;
- accepted task-scoped estimate when admitted;
- scoped wording such as `limited evidence` / `insufficient evidence` when appropriate;
- no scientific-looking raw confidence percentage unless separately validated for learner interpretation.

Learner-facing copy says what the estimate represents before numeric precision.

## 8. Error → remediation → review → retest

1. Normalizer creates immutable `FeedbackFinding` with evidence.
2. Learner confirms/selects an actionable finding.
3. Service resolves controlled `error_pattern` and remediation mapping; unresolved required mapping does not invent a taxonomy ID.
4. Persist `LearningError`.
5. Select the smallest useful intervention.
6. Create an FSRS card only when the remediation unit is meaningfully retrievable (grammar form, phrase, rule/error concept, etc.).
7. FSRS controls review timing only.
8. Retest uses sufficiently novel eligible content for the same underlying error/construct.
9. `improved` requires the versioned retest/evidence rule; repeated/revealed success alone is insufficient.
10. Complex Writing mastery/readiness is updated only through its owning evidence policy, not card maturity.

## 9. Integrity / anti-gaming

P0 integrity handling is risk-based, not detector-as-proof.

Prefer deterministic/provenance signals where available:

- known-sample similarity;
- copied prompt/passage overlap;
- exposure/provenance anomalies;
- impossible/invalid submission behavior.

AI-generated-text detection, if used, is a weak signal only. It cannot alone declare cheating or permanently suppress a score. Material unresolved cases use `result_validity=integrity_review` and a neutral resubmission/recovery path.

## 10. API boundary

Canonical operation IDs and schemas are owned by `artifacts/engineering/api/*`.

This slice must consume, not redefine, the canonical operations for:

- get Writing task;
- save Writing draft;
- create/get Writing submission;
- get Writing evaluation;
- submit learner feedback;
- create/fix/retest learner error where those operations are active;
- rate review item where active.

All durable mutations use the canonical idempotency contract. Cross-user object access fails closed. API errors contain no essay/provider payload/stack trace.

If the canonical schema still carries a legacy combined `state`/`quality_status`, implementation eligibility remains blocked until schema-contract migration separates `operation_state` and `result_validity`.

## 11. Cost policy

Each evaluation records at least:

```yaml
cost:
  primary_route_units:
  escalation_route_units:
  feedback_generation_units:
  retries:
  total_cost_units:
  cost_policy_version:
```

Policies:

- no inference before deterministic eligibility checks;
- no automatic second pass for ordinary cases;
- default to concise actionable feedback;
- expensive deep feedback is on-demand and quota-bound;
- reusable remediation content is precomputed;
- retry ceilings are hard;
- measure `cost_per_accepted_evaluation` and downstream `cost_per_verified_improvement`;
- cheaper route cannot bypass benchmark quality floor.

## 12. Privacy and observability

Allowed general telemetry: opaque IDs, stage name, route/version, timing, failure/result-validity class, usage/cost units and derived aggregate quality metrics.

Forbidden general telemetry: raw essay, transcript, private notes, prompt body containing learner content, provider full response, secrets/tokens.

Benchmark/research access uses its own function-scoped principal and approved de-identified/reference corpus; it does not inherit arbitrary learner-content access.

## 13. Required acceptance cases

Build readiness requires executable proof for at least:

1. published/right-approved task only;
2. autosave/network recovery without text loss;
3. duplicate submit → one submission/charge;
4. deterministic invalid input → zero scorer calls;
5. primary accepted route → immutable task-scoped diagnostic result;
6. malformed/hallucinated evidence → invalid/insufficient result, not score promotion;
7. hard-case escalation executes at most configured maximum;
8. provider timeout → durable delayed/unavailable with submission preserved;
9. no unbenchmarked scorer fallback;
10. raw learner content absent from general telemetry;
11. learner A cannot read learner B submission/evaluation;
12. finding requires resolvable evidence before learner can save error;
13. FSRS card only for suitable retrievable remediation unit;
14. retest cannot reuse disallowed exposed source prompt;
15. repeated/revealed success does not count as independent transfer;
16. result validity controls downstream evidence admission;
17. cost attribution separates primary/escalation/deep-feedback work;
18. no model/provider output can update readiness/entitlement directly.

## 14. Release boundary

This slice remains `not ready` while any of the following is missing:

- rights-approved Writing Task 2 content;
- canonical API/schema alignment;
- benchmark-approved scorer route;
- evaluation/result-validity evidence policy;
- bounded cost/quota configuration;
- privacy/idempotency/recovery tests;
- independent retest content/policy;
- acceptance evidence from the same candidate commit.