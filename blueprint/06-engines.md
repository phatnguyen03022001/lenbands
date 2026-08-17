# 06 — Learning Compute Boundaries

This document owns the **compute boundary** for review, evaluation, recommendation and evaluation-governance behavior referenced by the Capability Catalog (`03-features.md`). It does not own capability meaning, API transport, provider selection, rubric vocabulary or canonical runtime state.

The architecture principle is:

> **LenBands is a deterministic learning system with governed probabilistic inference at explicitly justified semantic boundaries.**

Four rules are normative:

1. **Domain contracts own canonical semantics and decisions.**
2. **Execution policy projects the lowest sufficient computation for exact canonical decision units.**
3. **Probabilistic components are inference executors, never canonical decision owners.**
4. **Generated presentation is non-authoritative and cannot mutate facts or decisions.**

A compute-mode change is an architectural change, not an implementation optimization. An implementation may not silently replace a deterministic rule with a classifier, embedding model, reranker, remote model/API or generative model.

The machine-readable projection is `artifacts/operations/execution-policy.yaml`. It is intentionally **not** a semantic SSOT: decision-unit identities are declared by canonical domain-owner metadata and the projection must resolve them exactly.

---

## 1. Lowest-sufficient-compute model

Select the lowest mode that satisfies the declared product outcome, quality/correctness requirement, latency, cost, privacy and reliability constraints.

| Mode | Typical LenBands use | Boundary |
|---|---|---|
| `deterministic` | SQL/querying, state machines, answer keys, FSRS, policy/ranking, aggregation | Default when stable rules and structured facts are sufficient |
| `statistical_optimization` | calibrated estimators, parameter optimization, calibration | Use only when deterministic computation cannot meet a measured decision contract |
| `specialized_model_api` | ASR, acoustic/phoneme models, bounded classifiers | Use when perception/classification requires a specialized probabilistic model |
| `generative_model` | free-form semantic inference, dialogue, rewrite, optional natural-language explanation | Highest-cost/least-deterministic mode; requires an explicitly justified semantic boundary |

The order is a selection procedure, not an ideology. Deterministic computation is not preferred when it fails the product-quality contract; generative computation is not justified merely because it appears more flexible.

### Canonical probabilistic pipeline

Any probabilistic path follows:

```text
canonical domain inputs
  -> minimum necessary provider payload
  -> inference executor
  -> typed candidate inference
  -> evidence/provenance binding
  -> deterministic validation
  -> domain decision
  -> canonical state mutation
```

No model output writes canonical learner state directly.

---

## 2. Algorithmic Core

The Algorithmic Core owns computations whose required semantics are stable, versioned and reproducible from structured facts.

### Review scheduling — `REVIEW.FSRS`

FSRS remains deterministic at runtime:

```text
prior card state + learner rating + versioned FSRS parameters
  -> FSRS transition
  -> stability/difficulty/due state
```

- Runtime review scheduling never asks a model to choose the next interval.
- MVP uses a validated global/cohort parameter set while learner data is insufficient.
- Parameter fitting/optimization is a separate statistical/optimization task and must pass validation before promotion.
- A new parameter set changes algorithm configuration; it does not change the fact that the runtime scheduling decision is deterministic.
- Review completion, queue priority and retest state remain canonical domain decisions.

### Recommendation policy

Recommendation is a **policy/ranking/selection problem by default**, not a generative problem.

For P0 `PERSONAL.NextBestAction`:

```text
goal + due review + recent independent evidence + weakness eligibility + time/energy
  -> deterministic eligibility
  -> deterministic priority policy
  -> bounded action selection
  -> controlled reason_code + evidence refs
```

`PERSONAL.WeaknessPractice`, `PERSONAL.GapAnalysis` and the fact-producing portion of `PERSONAL.Insights` remain deterministic-first when their inputs are canonical structured evidence.

A future optimizer may replace a deterministic recommendation policy only after the existing mode fails a measured outcome contract and the statistical/optimization mode demonstrates sufficient improvement under privacy/cost constraints.

### Gap, progress and readiness

Known rubric requirements, target bands, canonical learner evidence and versioned policy produce gap/progress/readiness facts through deterministic mappings and aggregation. A model must not decide that a learner is exam-ready, authorize progression or replace a known descriptor/evidence mapping merely because it can generate a plausible explanation.

### Objective scoring and aggregation

- Answer-key scoring is deterministic.
- Score aggregation/weighting is deterministic and owned by the relevant domain contract.
- Placement stopping rules and P0 provisional mapping are deterministic until a calibrated statistical measurement policy is approved.
- Quota, entitlement, authorization, idempotency and canonical lifecycle transitions are never probabilistic decisions.

---

## 3. Assessment & Semantic Inference

There is **no runtime human scorer** in the learner flow. This does not imply that every scoring operation is model-owned.

Domain contracts own rubric semantics, score identity, permitted ranges, evidence requirements, quality states, aggregation and promotion policy. Models may perform bounded semantic inference where free-form evidence cannot be evaluated adequately by lower compute modes.

### Writing — `EVAL.Writing`

P0 Writing uses governed semantic inference for free-form rubric interpretation. The inference executor returns a typed candidate only.

Required provenance includes at least:

- rubric version;
- immutable task/prompt version;
- prompt-template hash;
- scorer-route/model version;
- assessment mode;
- evidence references;
- candidate criterion findings/scores;
- confidence state.

Then deterministic code validates evidence references, resolves controlled taxonomy identities, validates criterion scope, aggregates the task-level diagnostic estimate and decides `accepted | low_confidence | insufficient_evidence | invalid`.

A model cannot redefine criterion semantics, score scope, score weighting, taxonomy IDs, readiness meaning or canonical persistence behavior.

### Speaking — future `EVAL.Speaking`

Speaking must be decomposed by subtask before implementation, for example:

```text
audio
  -> specialized ASR/acoustic processing
  -> deterministic feature normalization
  -> governed semantic inference where required
  -> evidence validation
  -> deterministic score aggregation/quality decision
  -> optional explanation
```

`EVAL.Speaking = AI` is not a valid architectural primitive.

### Pronunciation — future `EVAL.Pronunciation`

Pronunciation defaults to specialized speech/acoustic models for phoneme, stress and intonation evidence. A general-purpose generative model is not the default perception engine. Any learner-facing score/finding must still pass typed evidence validation and deterministic domain aggregation.

### Band prediction — future `EVAL.BandPrediction`

Band prediction defaults to a calibrated statistical estimator when prediction beyond direct evidence aggregation is justified. A generative model is not the default merely because it can produce a number and explanation.

### Semantic classification

A model may propose an intermediate semantic interpretation such as a likely cohesion issue. Canonical facts exist only after controlled-vocabulary resolution, evidence binding and deterministic domain acceptance.

```text
intermediate semantic interpretation
  != canonical semantic fact
```

---

## 4. Generative Assistance

Generative computation is appropriate when the product outcome itself requires language generation rather than a canonical business decision.

### Examiner dialogue — `EVAL.Examiner`

Contextual follow-up question generation is a legitimate generative boundary. Conversation state, permissions, exam mode, timing and persistence remain deterministic domain concerns.

### Rewrite suggestion — `EVAL.RewriteSuggestion`

A rewrite may be generated from canonical task/evaluation context, but it has no score authority and cannot overwrite learner work without an explicit learner action.

### Explanations and Insights

Facts and presentation stay separate:

```text
canonical fact/decision
  -> optional presentation generator
  -> learner-facing wording
```

For example, a deterministic insight may establish a recurring paraphrase-recognition weakness from evidence. A model may explain that fact in natural language, but generated wording cannot change the reason code, evidence, ranking, score, gap or readiness state.

If the presentation generator fails, the structured fact and domain decision remain usable.

---

## 5. Evaluation inference contract

Every probabilistic evaluator must return a typed candidate that is bound to evidence and provenance before acceptance.

A candidate that contains only a score or label is insufficient. It must preserve the inputs needed to validate why the inference is eligible to become a canonical result.

For Writing the engineering owner is `artifacts/engineering/contracts/evaluation/evaluation-contract.md`.

Canonical sequence:

```text
model/provider response
  -> typed candidate inference
  -> evidence_ref + rubric/task/route provenance binding
  -> deterministic schema/evidence/taxonomy validation
  -> deterministic quality decision
  -> deterministic aggregation
  -> immutable canonical result
```

Unresolved evidence, schema failure or missing required provenance cannot be converted into an ordinary score by best effort.

---

## 6. Quality & Governance

Quality/governance controls govern probabilistic workloads but are not themselves excuses to make business decisions probabilistic.

### Model route selection — `OPS.ModelRouting`

Route selection is deterministic over eligible, benchmark-approved provider-neutral routes. A model does not decide which model should handle the request.

The preferred ladder is:

```text
canonical deterministic computation if sufficient
  -> statistical/optimization when justified
  -> specialized model/API when required
  -> generative model at explicit semantic boundaries
  -> safe domain fallback
```

### Benchmark and promotion

- Gold expectations belong to the gold/reference corpus, not candidate model output.
- Benchmark metrics are computed from immutable evidence.
- Route/model/prompt/rubric changes require versioned evidence and release-gate review.
- A probabilistic component is not promoted because offline output looks plausible; it must satisfy the declared quality/outcome contract.

### Confidence

Raw model confidence is an inference signal, not automatically a calibrated probability. The domain derives the governed confidence/quality state according to versioned policy.

### Drift/bias/calibration

Drift detection, bias monitoring and calibration may use statistical computation when activated by sufficient evidence. They do not rewrite historical results silently and remain governed by release/audit policy.

### Anti-gaming

Anti-gaming may combine deterministic similarity checks and specialized/probabilistic risk signals. A probabilistic detector result is a risk signal, never proof of misconduct. Canonical policy owns whether a flagged result is withheld, annotated or routed to resubmission.

---

## 7. P0 compute profile

| P0 concern | Default compute | Model calls in decision path |
|---|---|---|
| Identity/auth/entitlement | managed identity + deterministic domain authorization | 0 |
| Placement selection/stopping/gap/initial path | deterministic | 0 |
| Daily Action / NextBestAction | deterministic policy | 0 |
| Writing semantic interpretation | governed generative inference | bounded, benchmark-gated |
| Writing evidence validation / taxonomy / aggregation / quality state | deterministic | 0 additional |
| Feedback priority | deterministic | 0 additional |
| Review card eligibility / FSRS / queue / retest | deterministic | 0 |
| Quota / cost aggregation / route selection / release gate | deterministic | 0 |

P0 is therefore already deterministic-first. The purpose of this refactor is to prevent future capability semantics from silently broadening probabilistic authority.

---

## 8. Compute-mode change gate

No probabilistic component may silently replace a deterministic decision.

A proposed mode change requires:

```text
current decision contract
  -> evidence that current compute mode is insufficient
  -> candidate higher mode
  -> quality/outcome comparison
  -> latency/cost/privacy/reliability analysis
  -> benchmark or validation evidence where applicable
  -> architecture decision + founder authorization
  -> implementation
```

“More intelligent”, “more personalized”, anticipated scale or model availability are not sufficient evidence.

---

## 9. Cross-references

- Capability meaning: `03-features.md`
- System architecture: `02-architecture.md`
- IELTS controlled vocabulary: `framework/README.md`
- Compute projection: `../artifacts/operations/execution-policy.yaml`
- Implementation eligibility: `../artifacts/operations/implementation-eligibility.yaml`
- Writing evaluation schema/policy: `../artifacts/engineering/contracts/evaluation/evaluation-contract.md`
- P0 routing/context: `../artifacts/engineering/contracts/runtime/llm-routing-context-contract.md`
- Daily Action: `../artifacts/engineering/contracts/daily-action-contract.md`
- Placement: `../artifacts/engineering/contracts/placement-diagnosis-contract.md`
- Error/review: `../artifacts/engineering/contracts/error-to-review/data-contract.md`
- Quality/economics: `../artifacts/engineering/runtime/quality-economics-runtime.md`
