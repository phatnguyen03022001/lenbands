# Placement & Diagnosis Contract

Canonical metadata is in the sibling `placement-diagnosis-contract.meta.yaml`.

Minimum contract for P0-02: goal, placement attempt, provisional diagnosis, and initial path. This is a contract candidate in `review`; no calibration run exists, so it must not be understood as an official IELTS score or build-ready.

## Boundary and ownership

- `LearnerGoal` is owned by the authenticated learner; placement service reads only that learner's goal.
- `PlacementAttempt` is written by placement service; retry uses an idempotency key and does not create a duplicate attempt.
- `PlacementResult` is written by diagnosis service; the result always has `configuration_version`, `calibration_status`, `confidence`, `provisional`, evidence coverage, and termination reason.
- `InitialPath` is created by plan service from the persisted goal + gap; do not infer it when data is missing.
- Consent must be `consented` before processing responses; the auth/consent boundary references `auth-identity-contract.md`.
- Placement output is a **diagnostic estimate**. It is not an official IELTS result, and it must remain distinguishable from a complete exam-simulation estimate and from learner-model mastery.

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

`answer_refs` is only a reference to learner-owned storage; do not put response text into analytics events. `current_band: null` when evidence is insufficient, the configuration is invalid, or the configured policy does not permit a defensible aggregate estimate.

`confidence` is an internal model/policy output. It must not be displayed as a probability that the band is correct unless that interpretation has been empirically calibrated. Learner-facing language uses the governed confidence state and evidence scope.

## Placement measurement policy

### Construct coverage

Every published placement configuration has a versioned blueprint declaring the constructs/content families it intends to sample. A placement may not claim whole-test diagnostic coverage from a narrow subset without an explicit scope label.

For each result:

- required constructs come from the published configuration;
- observed constructs are derived only from valid learner responses;
- repeated exposure to the same item does not create independent evidence;
- an item recently shown with its answer/explanation cannot be counted as fresh transfer evidence;
- missing required constructs remain visible in `evidence_coverage`.

### Termination

Placement termination is explicit rather than implied by item count.

1. `precision_and_coverage_met` — only when the versioned coverage policy and founder-approved precision/evidence policy are both satisfied.
2. `max_burden_reached` — configured item/time burden reached before sufficient evidence; this does **not** automatically justify a numeric band.
3. `learner_stopped` — preserve progress and explain that the estimate may be unavailable or narrower in scope.
4. `insufficient_evidence` — return `current_band: null` when the available evidence cannot support the configured estimate.
5. `invalid_configuration` — fail closed; do not diagnose from an invalid or unpublished configuration.

No numeric precision threshold is active until calibration evidence and a founder-approved policy exist.

### Adaptive selection boundary

Computer-adaptive placement requires more than choosing an easier/harder next item. A future calibrated adaptive policy must define:

- construct/content balancing;
- item-selection or information criterion;
- item exposure control;
- stopping/precision rule;
- maximum learner burden;
- calibration/version provenance.

Until calibrated item parameters and validation evidence exist, P0 uses an auditable fixed or deterministic rule-based blueprint. It must not claim CAT-level measurement precision.

## Selected logical API surface (OpenAPI candidate)

Per the API ownership contract (`api-ownership-bff-contract.md:18-23`), `writing-task-2/openapi.yaml` (v0.5.0, review) is the selected logical candidate surface for the P0 loop; the root `contracts/openapi.yaml` is the selected logical identity surface. One unified canonical OpenAPI authority does not yet exist, and neither live spec alone is a complete build input. The three OpenAPI endpoints below are the candidate P0-02 paths:
- `POST /v1/placement` (operationId `startPlacement`) — creates a placement attempt with optional `goal_ref`; captures GOAL.Target + PLACE.Test
- `POST /v1/placement/{attemptId}/responses` (operationId `submitPlacementResponse`) — submits one item response
- `GET /v1/placement/{attemptId}` (operationId `getPlacementAttempt`) — returns `PlacementAttempt` (state, module, `result_ref`). PLACE.BandEstimation, PLACE.GapDetection, PLACE.InitialPath, PLACE.SkillDiagnosis, and BAND.Current are internal-command/event-projection capabilities surfaced via this endpoint per `transport-classification.yaml`

The API table in this contract (§ API and idempotency) uses a different path/method design (`/v1/placement/attempts`, `PUT .../{attemptId}`, `POST .../submit`, `GET /v1/placement/results/{attemptId}`) that does not match the OpenAPI. This is an identified/triaged, unresolved, implementation-blocked conflict; it does not create a second canonical authority. The smallest safe resolution aligns this contract's API table to the OpenAPI candidate paths — the OpenAPI is the selected logical candidate surface per the ownership contract. Until reconciled, both document sets are live; neither may be treated as the sole build input. See `artifacts/engineering/decisions/openapi-unification-review-packet.md` for the complete P0-02 conflict matrix.

## API and idempotency

| Operation | Owner | Rule |
|---|---|---|
| `POST /v1/placement/attempts` | placement service | `Idempotency-Key` required; configuration must be `published` |
| `PUT /v1/placement/attempts/{attemptId}` | placement service | optimistic `version`; owner read/write only |
| `POST /v1/placement/attempts/{attemptId}/submit` | placement service | submit once; retry returns the same result/job |
| `GET /v1/placement/results/{attemptId}` | diagnosis service | return only the learner's result; scope/provisional/confidence state must be displayed |

## Events and failure

Canonical owned events: `placement_started`, `placement_completed`, `goal_set`. Placement emits `placement_completed`; the P0-03 plan service consumes that event and owns `daily_plan_generated`. Do not allow the SPA to emit analytics directly. Events contain only refs, status, coverage/confidence class, and termination reason; no raw answers.

| Failure | Persisted state | Learner behavior |
|---|---|---|
| No published configuration | `placement_ready` | retry/contact; do not generate a random task |
| Insufficient response signal | `insufficient_data` | explain missing evidence/section and allow retry |
| Required coverage missing at max burden | `insufficient_data` | do not fabricate an aggregate band; offer a targeted continuation |
| Stale version/conflict | unchanged | reload latest attempt, do not overwrite |
| Consent/auth unavailable | unchanged | deny-by-default; return to consent/auth |

## Acceptance and evidence gap

- [ ] Resume does not create a duplicate attempt or event.
- [ ] Result always records configuration/calibration version.
- [ ] Result records scope, termination reason, evidence coverage, and confidence state.
- [ ] Repeated/revealed items do not increase independent-evidence count.
- [ ] Missing required coverage can terminate as `insufficient_data`; max burden alone never forces a numeric estimate.
- [ ] No real placement calibration run exists; the founder must provide evidence before moving the artifact to `approved`/`ready`.

## References

- `blueprint/03-features.md` — P0-02 Diagnosis.
- `blueprint/08-roadmap.md` — P0 closed pilot.
- `artifacts/engineering/contracts/runtime/auth-identity-contract.md`.
- `artifacts/experience/research/learning-assessment-experience-audit.md` — evidence-informed placement/measurement constraints; not scoring authority.
