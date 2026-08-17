# Placement & Diagnosis Contract

Canonical metadata is in the sibling `placement-diagnosis-contract.meta.yaml`.

Minimum contract for P0-02: goal, placement attempt, provisional diagnosis, and initial path. This artifact is in `review`; no calibration run exists, so it must not be understood as an official IELTS score or production-ready measurement system.

## Boundary and ownership

- `LearnerGoal` is owned by the authenticated learner; Placement reads only that learner's goal.
- `PlacementAttempt` is canonical placement state; retries are idempotent and do not create duplicate attempts.
- `PlacementResult` records configuration version, calibration status, confidence state, evidence coverage, scope and termination reason.
- `InitialPath` is derived from persisted goal + valid gap facts; do not infer it when required data is missing.
- Consent must permit processing before responses are evaluated.
- Placement output is a **diagnostic estimate**, distinct from an official IELTS result, complete exam-simulation estimate, or learner-model mastery.
- Stable compute decision units are declared in `placement-diagnosis-contract.meta.yaml`; the execution-policy projection cannot create Placement semantics.

## Data contract

```yaml
learner_goal:
  goal_id: string
  target_band: number
  exam_module: academic | general_training
  exam_date: date | null
  daily_minutes: integer
  version: integer

placement_attempt:
  attempt_id: string
  configuration_ref: string
  configuration_version: string
  status: new | in_progress | paused | submitted | diagnosed | insufficient_data
  answer_refs: [string]
  item_exposure_refs: [string]
  version: integer

placement_result:
  result_id: string
  attempt_id: string
  score_scope: diagnostic_estimate
  current_band: number | null
  skill_estimates:
    listening: number | null
    reading: number | null
    writing: number | null
    speaking: number | null
  gap_refs: [string]
  confidence: number | null
  confidence_state: unknown | provisional | stronger_evidence
  evidence_coverage:
    required_constructs: [string]
    observed_constructs: [string]
    missing_constructs: [string]
    independent_evidence_count: integer
  calibration_status: provisional | calibrated | unavailable
  termination_reason: precision_and_coverage_met | max_burden_reached | learner_stopped | insufficient_evidence | invalid_configuration
  provisional: boolean
  created_at: timestamp
```

`answer_refs` points to learner-owned assessment storage; raw response text does not enter general analytics events. `current_band` is `null` when evidence is insufficient, the configuration is invalid, or the configured policy cannot support the declared estimate scope.

`confidence` is an internal measurement/policy signal. It must not be presented as the probability that a band is correct unless an explicit calibration study validates that interpretation.

## Placement measurement policy

### Construct coverage

Every published placement configuration has a versioned blueprint declaring the constructs/content families it intends to sample. A placement may not claim whole-test diagnostic coverage from a narrow subset without an explicit scope label.

- required constructs come from the published configuration;
- observed constructs derive only from valid learner responses;
- repeated exposure to the same item does not create independent evidence;
- an item recently shown with its answer/explanation does not count as fresh transfer evidence;
- missing required constructs remain visible in `evidence_coverage`.

### Termination

1. `precision_and_coverage_met` — only when the versioned coverage policy and founder-approved evidence/precision policy are satisfied.
2. `max_burden_reached` — burden limit reached before sufficient evidence; this never forces a numeric band.
3. `learner_stopped` — preserve progress and explain that the result may be unavailable or narrower in scope.
4. `insufficient_evidence` — return `current_band: null` when available evidence cannot support the configured estimate.
5. `invalid_configuration` — fail closed.

No numeric precision threshold is active until calibration evidence and an approved policy exist.

### P0 compute boundary

P0 uses deterministic item selection, response-fact scoring where objective keys/rules exist, stopping logic, bounded provisional mapping, gap derivation and initial-path selection.

```text
published configuration + canonical response facts
  -> deterministic item/scoring/coverage rules
  -> deterministic stopping decision
  -> bounded provisional diagnostic mapping
  -> deterministic gap derivation
  -> deterministic initial-path policy
```

A future computer-adaptive/statistical placement mode must define construct balancing, item-information/selection criterion, exposure control, stopping/precision rule, maximum burden, parameter calibration and validation provenance. It is a governed compute-mode change, not an implementation optimization. Until such evidence exists, P0 does not claim CAT-level precision.

## Canonical API surface

HTTP transport is owned solely by `artifacts/engineering/api/openapi.yaml`; this contract does not define a competing endpoint design.

Current Placement operations are:

| Operation | operationId | Domain rule |
|---|---|---|
| `POST /v1/placement` | `startPlacement` | idempotently create a versioned placement attempt from a published configuration |
| `POST /v1/placement/{attemptId}/responses` | `submitPlacementResponse` | submit one response to the learner-owned attempt |
| `POST /v1/placement/{attemptId}/submit` | `submitPlacement` | finish diagnosis or return an explicit insufficient-evidence state |
| `GET /v1/placement/{attemptId}` | `getPlacementAttempt` | return the learner's placement attempt and diagnostic state |

All operations are owned by `PLACEMENT.Diagnosis` in the canonical operation-ownership registry. `PLACE.BandEstimation`, `PLACE.GapDetection`, `PLACE.InitialPath`, `PLACE.SkillDiagnosis` and `BAND.Current` remain domain decision/projection capabilities and do not require duplicate HTTP endpoints merely to exist.

Any transport change must start at the canonical API authority; this contract follows that owner.

## Events and failure

Canonical owned events: `placement_started`, `placement_completed`, `goal_set`. Placement emits `placement_completed`; Daily Action consumes canonical placement/goal facts to compute a plan. Events contain only refs, status, coverage/confidence class and termination reason; no raw answers.

| Failure | Persisted state | Learner behavior |
|---|---|---|
| No published configuration | unchanged/not-started | retry/contact; do not generate a random task |
| Insufficient response signal | `insufficient_data` | explain missing evidence/section and allow continuation/retry |
| Required coverage missing at max burden | `insufficient_data` | do not fabricate an aggregate band |
| Stale version/conflict | unchanged | reload latest attempt; do not overwrite |
| Consent/auth unavailable | unchanged | deny-by-default |

## Sufficiency and future mode changes

The current deterministic P0 mode is sufficient only for its declared **provisional diagnostic scope**. It is not evidence that deterministic rules can support future high-precision adaptive measurement.

A compute-mode promotion from deterministic to statistical/optimization requires evidence that the current mode fails a declared measurement/outcome contract and that the proposed estimator satisfies quality, burden, latency, privacy and calibration requirements. A generative model is not a default replacement for a calibrated statistical estimator.

## Acceptance and evidence gap

- [ ] Resume does not create a duplicate attempt or event.
- [ ] Result always records configuration/calibration version.
- [ ] Result records scope, termination reason, evidence coverage, and confidence state.
- [ ] Repeated/revealed items do not increase independent-evidence count.
- [ ] Missing coverage can terminate as `insufficient_data`; max burden alone never forces a numeric estimate.
- [ ] No real placement calibration run exists; evidence is required before the artifact becomes approved/ready.

## References

- `blueprint/03-features.md` — capability meaning.
- `blueprint/06-engines.md` — compute boundary.
- `artifacts/operations/execution-policy.yaml` — non-authoritative compute projection.
- `artifacts/engineering/api/openapi.yaml` — canonical HTTP transport.
- `artifacts/engineering/api/operation-ownership.yaml` — operation family ownership.
- `blueprint/08-roadmap.md` — P0 scope.
- `artifacts/engineering/contracts/runtime/auth-identity-contract.md`.
- `artifacts/experience/research/learning-assessment-experience-audit.md` — research input, not scoring authority.
