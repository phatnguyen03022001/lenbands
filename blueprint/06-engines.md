# 06 — Engines (Learning Engine Layer)

This file owns the implementation contracts for learning/evaluation/recommendation engines behind the Capability Layer. Provider/model/speech/runtime mechanisms are replaceable adapters; they do not own product truth.

```text
Learning Engine
  ├── Evaluation Engine     → EVAL.*
  ├── Recommendation Engine → PERSONAL.* / STUDY.DailyPlan
  ├── Review Engine         → REVIEW.FSRS
  ├── Quality & Cost Plane  → OPS.*
  └── Governance Engine     → GOVERNANCE.*
```

## 1. Engine-wide intelligence rule

LenBands is **deterministic-first**.

Before invoking model/speech inference, ask:

1. Can typed rules, answer keys, formulas, state machines, SQL, controlled mappings or a maintained library meet the quality contract?
2. Can a governed reusable/precomputed result meet it?
3. If inference is required, what is the smallest bounded semantic/acoustic operation needed?
4. Does the judgment materially affect assessment integrity or learner outcome enough to require a stronger approved route?
5. What safe state applies when no approved route exists?

A provider response becomes usable only after schema, provenance, domain, evidence and quality validation.

## 2. Learner evidence model boundary

The engine must preserve these distinct concepts:

```text
activity completion
review scheduling state
observed task performance
independent retest evidence
transfer evidence
maintenance evidence
readiness / learner-model state
```

No layer may promote one into another merely because it is convenient.

Repeated/revealed/familiar success may teach or maintain an item; it does not by itself prove transfer.

Missing evidence is not weakness.

## 3. Diagnosis cause boundary

Recommendation/remediation may classify a supported target gap into:

```text
english_foundation
ielts_technique
integrated_performance
mixed
evidence_needed
```

This classification exists only when it changes intervention behavior.

Rules:

- `english_foundation` requires language evidence, not a low generic score alone;
- `ielts_technique` requires task/rubric/method evidence;
- `integrated_performance` means component knowledge appears available but independent application under task constraints is the blocker;
- `mixed` requires more than one materially supported cause;
- insufficient support returns `evidence_needed`;
- cause classification never changes the underlying observed score/evidence fact.

## 4. Target feasibility boundary

`TargetFeasibility` is a deterministic planning projection, not a prediction of the official exam result.

Allowed states:

```text
insufficient_evidence
on_track
at_risk
current_constraints_insufficient
target_met
```

Potential inputs:

- TargetProfile;
- admitted current evidence/readiness state;
- exam date;
- declared study capacity;
- recent adherence/pace where available;
- active curriculum + independent verification coverage;
- current policy version.

P0 must not invent:

- official-band success probability;
- universal hours per band;
- weeks-to-band regression;
- guaranteed target date.

If evidence is inadequate, return `insufficient_evidence`.

## 5. Evaluation Engine

Learner-facing Writing/Speaking/Pronunciation evaluation is automated at runtime. Offline examiner-rated or otherwise qualified reference data may be required for benchmark/calibration when rights/provenance allow it.

The evaluator is an engine, not a persona or source of curriculum truth.

### Score identity

Always distinguish:

- `official_ielts_score`;
- `exam_simulation_estimate`;
- `diagnostic_estimate`;
- criterion/micro-skill evidence;
- learner-model/readiness state.

A Writing Task 2 result is a task-scoped diagnostic estimate unless an owning full-section simulation contract explicitly says otherwise.

### Operation versus result validity

```text
operation_state:
  accepted -> processing -> succeeded | delayed | unavailable | failed | cancelled

result_validity:
  accepted | limited_evidence | insufficient_evidence | invalid | integrity_review
```

Transport/processing state and trustworthiness never collapse into one `confidence` status.

### Common pipeline

```text
immutable submission/task snapshot
  ↓
deterministic validation / cheap features
  ↓
approved scorer route + exact config
  ↓
minimum required model/speech operation
  ↓
structured candidate judgment
  ↓
rubric/evidence/schema validation
  ↓
uncertainty / disagreement / integrity policy
  ↓
optional stronger independent route only when justified
  ↓
immutable governed result
  ↓
deterministic cause/remediation mapping
  ↓
optional learner-facing language rendering
```

### Writing

Deterministic precheck owns task/version, word count, empty/invalid input, ownership, quota and obvious exact facts.

The primary scorer returns structured rubric candidate judgments/evidence for:

- Task Response / Achievement where applicable;
- Coherence & Cohesion;
- Lexical Resource;
- Grammatical Range & Accuracy.

The model payload does **not** author domain provenance or `result_validity`. Runtime binds provider/model/config provenance; domain validation admits/rejects the candidate.

A stronger scorer runs only for policy-defined hard/high-risk cases. Feedback wording cannot modify an already-governed score.

### Speaking

Speaking is staged:

```text
Audio/prompt snapshot
  -> audio quality/integrity
  -> STT
  -> deterministic timing/fluency features where valid
  -> lexical/grammar evidence
  -> specialist pronunciation/acoustic evidence where required
  -> rubric judgment
  -> evidence aggregation/result validity
```

A general LLM must not be the sole measurement mechanism for phoneme/stress/intonation claims requiring specialist evidence.

### Pronunciation

```text
Audio
  -> signal gate
  -> alignment/acoustic/speech features
  -> pronunciation evidence
  -> governed interpretation
  -> explanation/drill recommendation
```

### Examiner boundary

`EVAL.Examiner` generates/chooses Speaking follow-up questions under a bounded conversation state. It is separate from scoring authority.

### Learner-facing uncertainty

Do not show raw uncalibrated probability as scientific confidence. Prefer scoped language such as:

- limited evidence;
- provisional estimate;
- more evidence required;
- unavailable/delayed.

### Evaluation result minimum

Every governed result records at least:

- score scope/label;
- rubric/task versions;
- scorer-route/config version;
- runtime model/provider provenance where applicable;
- result validity;
- evidence refs;
- quality/integrity flags;
- cost/latency/retry/escalation attribution.

Only evidence admitted by the owning policy may update readiness.

## 6. Assessment integrity

`GOVERNANCE.AntiGaming` is an integrity-risk mechanism, not a cheating oracle.

Prefer auditable signals:

1. known sample/corpus similarity;
2. copied prompt/passage overlap;
3. exposure/familiarity state;
4. repeated/template similarity;
5. reliable provenance anomalies;
6. generated-text detector only as an optional weak signal.

A weak detector cannot alone label cheating or permanently corrupt learner history.

## 7. Recommendation Engine

The Recommendation Engine turns governed learner state into candidate actions. It never asks an LLM to inspect raw history and invent a learning path.

### Inputs

At minimum:

- TargetProfile/module/minima/exam relevance;
- TargetFeasibility state/blockers;
- admitted evidence + uncertainty/coverage;
- diagnosis cause refs;
- independent/transfer/maintenance state;
- open errors/remediation state;
- due review/retest eligibility;
- exposure/novelty;
- curriculum coverage/content rights;
- prerequisite/challenge fit;
- time/energy/recent workload;
- entitlement/quota/cost constraints.

### Candidate pipeline

```text
canonical learner state
  ↓
derive target-relevant gaps / evidence needs
  ↓
derive supported cause class
  ↓
generate candidate interventions
  ↓
filter hard constraints
  - auth / rights / module
  - prerequisite
  - curriculum sufficiency
  - independent verification path
  - exposure novelty
  - target relevance
  - minimum sufficient challenge
  - time / entitlement / quota
  ↓
rank deterministically
  ↓
ONE primary action
  + at most ONE lighter alternative
  ↓
reason code + verification rule
```

### Cause-to-action policy

```text
english_foundation
  -> smallest language remediation that unlocks target work

ielts_technique
  -> task/question/rubric/timing method practice

integrated_performance
  -> independent application/retest/transfer

mixed
  -> choose the smallest blocking component first only when the ordering is evidence-supported

evidence_needed
  -> collect the smallest target-relevant evidence
```

Do not expose these internal labels when simpler learner copy communicates the same decision.

### Feasibility policy

- `insufficient_evidence` -> evidence collection;
- `on_track` -> highest-value current target action;
- `at_risk` -> highest-leverage actionable blocker;
- `current_constraints_insufficient` -> surface one constraint decision, not a normal impossible plan;
- `target_met` -> maintenance/transfer/readiness, not forced higher-band study.

### No-over-band policy

Recommendation chooses the **minimum sufficient challenge**.

Harder/higher-band content is excluded unless:

1. prerequisite bridge requires it;
2. authentic IELTS task complexity requires it;
3. transfer/robustness policy intentionally needs a harder/new context;
4. lower requirement is already demonstrated and the next level is actually target-relevant.

A high target does not justify skipping prerequisites. A reached target does not justify automatically pushing toward the next band.

### Curriculum sufficiency

A candidate requiring learning/remediation is eligible only when the content contract exposes a governed path from intervention to independent verification.

If no such path exists:

```text
planner_state = content_gap
```

Do not substitute unrelated or harder content to avoid an empty state.

### Anti-tunnel vision

Balance:

- supported weakness;
- uncertainty/evidence need;
- coverage;
- due review/retest;
- target relevance;
- transfer/maintenance;
- exposure novelty;
- learner load.

One weakness cannot monopolize the entire plan indefinitely.

### Outputs

| Capability | Engine contract |
|---|---|
| `PERSONAL.NextBestAction` | one high-value eligible action + controlled reason + verification + optional lighter alternative |
| `PERSONAL.GapAnalysis` | target-vs-evidence gap + cause/uncertainty, not band subtraction alone |
| `PERSONAL.AdaptivePlan` | versioned recomputation from target/evidence/constraints; cannot preserve stale priorities for engagement |
| `PERSONAL.WeaknessPractice` | practice only from admitted weakness/cause and eligible content |
| `PERSONAL.Insights` | derived fact/pattern; prose is secondary rendering |

## 8. Review Engine / FSRS

FSRS answers:

> When should this retrievable unit be reviewed again?

It does not answer:

> Has the learner mastered a complex IELTS construct?

Suitable units include vocabulary, collocations, grammar forms/rules, pronunciation targets, sentence patterns and traceable error concepts.

Review success updates scheduler state only. Transfer/readiness requires separate evidence.

P0 uses validated default/cohort parameters; per-learner optimization requires sample sufficiency and measured benefit.

## 9. Quality & Cost Plane

Mechanism ladder:

```text
rule/library/SQL
  -> reusable/precomputed result
  -> small/specialist bounded inference
  -> benchmark-approved stronger route
  -> safe degraded state
```

Cost controls:

- no model inference for deterministic placement/daily routing;
- no model-generated alternative plans merely to increase choice;
- stronger scoring only when quality policy requires it;
- reusable remediation/explanation content is versioned/precomputed;
- context is minimum necessary;
- retry/escalation is bounded;
- track cost per evaluation and cost per verified improvement together with quality.

## 10. Governance Engine

Governance owns:

- route promotion/retirement;
- benchmark regression and slice quality;
- drift detection;
- result-validity/evidence admission policy;
- integrity-risk handling;
- experimentation guardrails;
- kill switch/rollback.

Governance never turns a missing benchmark into a positive quality claim.

## 11. Outcome claim policy

Engine outputs may support readiness and planning. They must not generate marketing truth such as guaranteed official-band attainment.

A future attainment model/claim requires:

- an explicit population/cohort;
- starting evidence state;
- target definition;
- adherence/study exposure definition;
- observation window;
- missing-data/attrition treatment;
- uncertainty/calibration;
- governed validation and release approval.

Until then, the product guarantees the governed process, not a specific official result.

## 12. Failure behavior

Failure is product behavior:

- preserve learner-created work;
- retry in one owning layer with bounded attempts/deadline;
- never double-charge a logical operation because of internal retry;
- do not expose provider stack traces/raw payloads;
- no unbenchmarked scorer fallback;
- no recommendation fallback that fabricates personalization;
- missing content coverage returns `content_gap`;
- missing evidence returns evidence collection, not weakness;
- no approved evaluation route returns delayed/unavailable rather than a fake score.

## 13. Context minimization

Model-assisted operations receive bounded relevant context, not unrestricted history.

```yaml
learner_state_snapshot:
  target_profile_ref: string
  current_task_ref: string
  relevant_construct_refs: []
  relevant_recent_evidence_refs: []
  current_intervention_ref: string | null
  exposure_state_ref: string | null
```

Raw history enters inference only when explicitly required by the operation/privacy contract.

## 14. Engine acceptance invariants

- deterministic facts are never delegated to an LLM merely for convenience;
- missing evidence cannot become weakness;
- cause classification changes intervention only when evidence supports it;
- feasibility is never rendered as official-band probability/guarantee;
- recommendation returns one primary action + at most one lighter alternative;
- recommendation cannot outrun curriculum/retest coverage;
- advanced/beyond-target content requires explicit eligibility justification;
- reaching the target routes to maintenance/readiness, not automatic higher-band progression;
- activity/card completion cannot directly promote complex-skill readiness;
- provider/model output cannot directly grant learner-state authority;
- scoring route changes require benchmark/release governance;
- raw learner content stays outside general telemetry.
