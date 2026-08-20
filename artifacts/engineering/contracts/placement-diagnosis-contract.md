# Placement & Diagnosis Contract

Canonical metadata is in the sibling `placement-diagnosis-contract.meta.yaml`.

P0-02 creates a learner TargetProfile, collects a bounded baseline under a published placement configuration, and produces only the diagnostic and planning claims that available evidence supports.

Status: `review`. Implementation eligibility is governed separately from release evidence. Real calibration/outcome evidence is required before a `calibrated`, accuracy, or attainment claim, but its absence is not a circular prerequisite for implementing this deterministic contract against fixtures/right-approved pilot content.

## 1. Product boundary

Placement is **diagnosis/evidence collection for planning**, not a mini mock test, not an AI conversation, and not a promise that a future official IELTS score is guaranteed.

P0 principles:

- deterministic/fixed or auditable rule-based blueprint;
- explicit construct/content coverage;
- exposure-aware evidence;
- explicit termination reason;
- no numeric estimate when evidence is insufficient;
- TargetProfile informs planning/content eligibility, not scoring truth;
- output is `diagnostic_estimate`, never official IELTS score or learner mastery;
- diagnosis separates **English foundation**, **IELTS task technique**, and **missing evidence** instead of routing every problem into generic practice;
- target feasibility is a planning state with explicit limits, never a probability of exam success.

## 2. TargetProfile

The learner goal uses the canonical API `TargetProfile`:

```yaml
target_profile:
  exam_module: academic | general_training
  target_overall_band: half_band_0_9 | null
  skill_minimums:
    listening: half_band_0_9 | null
    reading: half_band_0_9 | null
    writing: half_band_0_9 | null
    speaking: half_band_0_9 | null
  exam_date: date | null
  purpose: string | null
```

Study-time budget remains goal/orchestration state rather than scoring evidence.

Rules:

- learner may have per-skill minima without one overall target;
- a target value never increases/decreases an observed diagnostic score;
- exam module filters eligible content/configuration;
- shared content may be reused only when format semantics permit it;
- changing TargetProfile does not rewrite historical attempts/results;
- no product surface may state or imply that setting a target makes it attainable under current time/evidence constraints.

## 3. Planning-feasibility state

`TargetFeasibility` answers a narrow planning question:

> Given the target, admitted evidence, time remaining, stated study capacity and available governed learning/retest coverage, is the current plan supportable without pretending certainty?

It does **not** answer:

> What is the probability this learner will obtain the official target band?

Canonical states:

```text
insufficient_evidence
on_track
at_risk
current_constraints_insufficient
target_met
```

Interpretation:

- `insufficient_evidence` — there is not enough admitted current-state/pace evidence to make a defensible planning judgment;
- `on_track` — the currently approved planning policy finds no known target/pace/coverage blocker under current constraints; this is not an exam guarantee;
- `at_risk` — target-relevant evidence/pace/coverage shows one or more material blockers that can still be acted on;
- `current_constraints_insufficient` — under the current exam date/study capacity/content availability, the planner cannot construct a credible target path without changing at least one constraint;
- `target_met` — admitted readiness evidence satisfies the owning readiness policy; it is still not an official IELTS result.

P0 may implement only auditable rule-based feasibility. Do not invent a percentage, probability of success, weeks-to-band regression, or universal hours-per-band rule without validated outcome evidence.

Minimum inputs when available:

```yaml
target_feasibility_inputs:
  target_profile_ref: string
  learner_evidence_state_ref: string
  exam_date: date | null
  planned_study_minutes_per_week: integer | null
  recent_adherence_summary_ref: string | null
  content_coverage_state_ref: string
  policy_version: string
```

If a required input is missing, prefer `insufficient_evidence` over a reassuring estimate.

## 4. Diagnosis cause model

A gap must identify the **smallest useful cause class** that changes the intervention. Learner-facing wording remains simple.

```yaml
diagnosis_cause:
  cause_class: english_foundation | ielts_technique | integrated_performance | mixed | evidence_needed
  evidence_refs: [string]
  affected_construct_refs: [string]
  intervention_family_ref: string | null
```

Meaning:

- `english_foundation` — language competence such as comprehension, grammar, vocabulary, lexical control or pronunciation is the primary supported blocker;
- `ielts_technique` — task/question mechanics, response method, timing, organization, rubric use or exam strategy is the primary supported blocker;
- `integrated_performance` — component knowledge exists but applying it independently under realistic task constraints is the supported blocker;
- `mixed` — more than one supported cause materially contributes and one cannot be reduced safely to the other;
- `evidence_needed` — current observations do not justify a cause claim.

Rules:

- missing evidence never becomes `english_foundation` or `ielts_technique` by default;
- a cause claim requires evidence references and an intervention family that can act on it;
- a learner may have different cause classes across skills/constructs;
- the cause class is not an IELTS score and must not alter observed scoring facts;
- if classification does not change intervention/routing, do not create extra taxonomy merely for reporting.

## 5. Ownership

- `LearnerGoal`/TargetProfile: authenticated learner-owned state.
- `PlacementAttempt`: placement service writes only for owner and exact published config/version.
- `PlacementResult`: diagnosis domain writes immutable/versioned result from admitted observations.
- `InitialPath`: plan service consumes persisted TargetProfile + admitted evidence/gaps + cause + feasibility; it does not fabricate missing evidence.
- `TargetFeasibility`: derived planning state owned by Goal/Placement planning policy; it is recalculated when target, evidence, time/capacity or content coverage materially changes.
- required consent/auth is checked before processing private responses.

## 6. Runtime data

```yaml
placement_attempt:
  attempt_id: string
  user_id: string
  configuration_ref: string
  configuration_version: string
  state: new | in_progress | paused | submitted | diagnosed | insufficient_data
  answer_refs: [string]
  item_exposure_refs: [string]
  version: integer
```

Raw response content remains learner-scoped storage and never general telemetry.

```yaml
placement_result:
  result_id: string
  attempt_id: string
  score_label: diagnostic_estimate
  score_scope: placement
  result_validity: accepted | limited_evidence | insufficient_evidence | invalid
  current_band: half_band_0_9 | null
  skill_estimates:
    listening: half_band_0_9 | null
    reading: half_band_0_9 | null
    writing: half_band_0_9 | null
    speaking: half_band_0_9 | null
  evidence_coverage:
    required_constructs: [string]
    observed_constructs: [string]
    missing_constructs: [string]
    independent_evidence_count: integer
  diagnosis_causes: [diagnosis_cause]
  target_feasibility:
    state: insufficient_evidence | on_track | at_risk | current_constraints_insufficient | target_met
    blocker_codes: [string]
    policy_version: string
  calibration_status: provisional | calibrated | unavailable
  termination_reason: precision_and_coverage_met | max_burden_reached | learner_stopped | insufficient_evidence | invalid_configuration
  learner_uncertainty_copy: string | null
  configuration_version: string
  policy_version: string
  created_at: timestamp
```

No learner-facing/raw `confidence` probability is required. Internal statistical precision/uncertainty may exist in restricted measurement records when it has a valid interpretation.

## 7. Published placement configuration

Every selectable configuration declares:

```yaml
placement_configuration:
  configuration_ref: string
  configuration_version: string
  exam_module: academic | general_training | shared
  lifecycle_state: published
  calibration_status: provisional | calibrated
  required_constructs: [string]
  ordered_or_rule_based_item_families: []
  max_items: integer
  max_minutes: integer
  stopping_policy_version: string
  exposure_policy_version: string
  rights_state: approved
```

P0 must not generate a random placement task at runtime to avoid missing content/configuration.

## 8. Measurement/evidence policy

### Coverage

- required constructs come from the published configuration/version;
- observed constructs come only from valid responses admitted by item/evidence rules;
- repeated/revealed/familiar items do not increase independent-evidence count as fresh proof;
- missing constructs remain visible;
- one sampled skill/construct cannot be mislabeled as full IELTS coverage.

### Result validity

- `accepted`: configured diagnostic scope has sufficient admitted evidence under approved policy;
- `limited_evidence`: useful narrower estimate exists but downstream consumers must preserve its limitation;
- `insufficient_evidence`: do not fabricate a numeric estimate for unsupported scope;
- `invalid`: configuration/input/integrity makes the result unusable.

### Termination

1. `precision_and_coverage_met` — only after configured coverage + currently approved precision/evidence rule pass.
2. `max_burden_reached` — burden cap reached; may still yield limited/insufficient evidence, not forced band.
3. `learner_stopped` — preserve attempt and return the narrowest defensible result or insufficient evidence.
4. `insufficient_evidence` — no defensible configured estimate.
5. `invalid_configuration` — fail closed.

No universal numeric precision threshold is active before calibration/approval.

## 9. P0 selection algorithm

P0 selection is deterministic/auditable. It may use:

- fixed blueprint order with conditional skips;
- explicit rule branches based on already observed deterministic facts;
- content balancing rules;
- exposure exclusions;
- burden limits.

It does **not** claim computerized-adaptive-testing precision.

Future adaptive placement requires calibrated item parameters/information policy, content balancing, exposure control, stopping policy and validation evidence before activation.

## 10. Gap derivation

A learner gap is not `target_band - current_band` arithmetic alone.

Gap facts are derived only where both target requirement and admitted current evidence exist.

```text
TargetProfile requirement
  + construct evidence / uncertainty
  -> gap | evidence_needed | no_target_requirement
  -> supported cause class
  -> smallest eligible intervention family
```

Missing evidence is `evidence_needed`, not automatically weakness.

The planner must distinguish:

```text
Need more evidence
English foundation blocker
IELTS technique blocker
Integrated-performance blocker
Mixed blocker
```

This distinction is mandatory for P0-03 recommendation so the planner can choose evidence collection, foundation teaching, technique practice or transfer/retest rather than generic practice.

## 11. Initial-path contract

The initial path is intentionally compressed. It must expose only what the learner needs next, while retaining full internal traceability.

```text
Target
  -> minimum evidence
  -> feasibility state
  -> highest-value supported gap/cause
  -> one smallest useful intervention
  -> independent verification action
```

Rules:

- one primary priority at a time;
- at most one learner-facing lighter alternative;
- the path cannot require advanced/beyond-target material merely because it exists;
- prerequisite/foundation work may precede target-band technique when evidence supports it;
- if no governed content + independent verification path exists for the selected gap, return a truthful `content_gap` blocker rather than an empty recommendation;
- path recomputation follows evidence/target changes and does not preserve obsolete priorities for streak/engagement reasons.

## 12. Canonical HTTP API

The only HTTP authority is `artifacts/engineering/api/openapi.yaml` + its typed schema registry.

P0-02 operations:

| operationId | HTTP purpose |
|---|---|
| `getMyGoal` | read TargetProfile/study goal |
| `putMyGoal` | create/replace TargetProfile/study goal |
| `startPlacement` | create one versioned attempt |
| `submitPlacementResponse` | submit one item response idempotently |
| `submitPlacement` | request diagnosis/termination under the configured policy |
| `getPlacementAttempt` | read attempt + scoped result projection |

Retired split OpenAPI files are not implementation inputs and must not reappear as authorities.

## 13. Idempotency/recovery

- `startPlacement`: same logical idempotency request produces at most one attempt.
- response submission: duplicate same item/version/logical response does not double-count evidence.
- submit placement: duplicate submit does not create multiple diagnosis results/events.
- pause/network loss: accepted responses remain durable; resume exact attempt/version.
- configuration cannot change beneath an active attempt; new config applies to a new attempt/version.

## 14. Events

Canonical events:

- `goal_set` — TargetProfile/study goal persisted;
- `placement_started` — attempt durably created;
- `placement_completed` — terminal result/termination persisted.

`placement_completed` should carry refs + result validity + coverage/termination + cause/feasibility classes only. It does not carry raw responses or raw statistical/model confidence.

P0-03 consumes admitted placement/evidence state rather than treating every `placement_completed` as a reliable weakness map.

## 15. Failure/recovery

| Condition | Result/recovery |
|---|---|
| no published/right-approved configuration | no attempt; explain unavailable/retry/fallback goal-only action |
| invalid config | fail closed; no diagnosis |
| network response failure | idempotent retry; preserve accepted responses |
| max burden with missing coverage | limited/insufficient result; do not force band |
| learner stops early | preserve state; narrow result or insufficient evidence |
| exposure-ineligible item | exclude from independent evidence; continue/replace when policy permits |
| stale version | reject conflicting mutation; reload current attempt |
| insufficient evidence for cause | `evidence_needed`; do not guess foundation/technique |
| infeasible current constraints | preserve target; show actionable constraint choices without promising attainment |
| missing remediation/retest coverage | return `content_gap`; do not route to unrelated or over-target content |

## 16. Cost

P0 placement should normally incur **zero LLM/scorer model cost**.

Costs are primarily:

- managed API/database/storage;
- content authoring/review/calibration;
- deterministic scoring/aggregation.

Do not add model inference for placement explanation/routing until deterministic templated copy/rules demonstrably fail learner outcome requirements.

## 17. Acceptance evidence required

The contract may be implemented with deterministic fixtures before these release runs exist. Promotion to calibrated learner-facing use requires applicable evidence below:

- [ ] TargetProfile supports module + optional overall/per-skill minima without forcing one target band.
- [ ] Target values do not alter scoring observations.
- [ ] feasibility never appears as an exam-success probability or guarantee.
- [ ] missing feasibility inputs produce `insufficient_evidence` rather than reassuring precision.
- [ ] foundation/technique/integrated/mixed cause claims require admitted evidence.
- [ ] missing cause evidence produces `evidence_needed`.
- [ ] initial path exposes one primary priority + at most one lighter alternative.
- [ ] no selected intervention lacks a governed independent verification/retest path unless the response is explicitly `content_gap`.
- [ ] over-target/advanced content is not selected without prerequisite, transfer or authentic-exam justification.
- [ ] resume produces one attempt/history.
- [ ] duplicate response/submit does not double-count evidence or result.
- [ ] repeated/revealed items do not increase independent evidence.
- [ ] missing coverage can produce `current_band=null`.
- [ ] max burden never forces numeric estimate.
- [ ] module-ineligible content is rejected.
- [ ] result records config/policy/calibration versions, result validity, coverage and termination reason.
- [ ] raw answers absent from general telemetry.
- [ ] deterministic P0 route produces zero model calls.
- [ ] real calibration/precision evidence exists before any `calibrated` claim.
- [ ] official-band attainment claims remain prohibited until separately validated outcome evidence and policy authorize them.

## References

- canonical API: `artifacts/engineering/api/`;
- `blueprint/05-content.md` — content/exposure/curriculum-sufficiency boundary;
- `blueprint/framework/README.md` — TargetProfile/framework boundary;
- `artifacts/engineering/contracts/daily-action-contract.md` — one-action planner boundary;
- learning-assessment research artifact — advisory evidence only.
