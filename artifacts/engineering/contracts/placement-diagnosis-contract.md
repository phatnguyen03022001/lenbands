# Placement & Diagnosis Contract

Canonical metadata is in the sibling `placement-diagnosis-contract.meta.yaml`.

P0-02 creates a learner TargetProfile, collects a bounded baseline under a published placement configuration, and produces only the diagnostic claims that available evidence supports.

Status: `review`. No real calibration/acceptance run exists, so the contract is not build-ready or evidence that LenBands placement is accurate.

## 1. Product boundary

Placement is **diagnosis/evidence collection**, not a mini mock test and not an AI conversation.

P0 principles:

- deterministic/fixed or auditable rule-based blueprint;
- explicit construct/content coverage;
- exposure-aware evidence;
- explicit termination reason;
- no numeric estimate when evidence is insufficient;
- TargetProfile informs planning/content eligibility, not scoring truth;
- output is `diagnostic_estimate`, never official IELTS score or learner mastery.

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
- changing TargetProfile does not rewrite historical attempts/results.

## 3. Ownership

- `LearnerGoal`/TargetProfile: authenticated learner-owned state.
- `PlacementAttempt`: placement service writes only for owner and exact published config/version.
- `PlacementResult`: diagnosis domain writes immutable/versioned result from admitted observations.
- `InitialPath`: plan service consumes persisted TargetProfile + admitted evidence/gaps; it does not fabricate missing evidence.
- required consent/auth is checked before processing private responses.

## 4. Runtime data

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
  calibration_status: provisional | calibrated | unavailable
  termination_reason: precision_and_coverage_met | max_burden_reached | learner_stopped | insufficient_evidence | invalid_configuration
  learner_uncertainty_copy: string | null
  configuration_version: string
  policy_version: string
  created_at: timestamp
```

No learner-facing/raw `confidence` probability is required. Internal statistical precision/uncertainty may exist in restricted measurement records when it has a valid interpretation.

## 5. Published placement configuration

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

## 6. Measurement/evidence policy

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

## 7. P0 selection algorithm

P0 selection is deterministic/auditable. It may use:

- fixed blueprint order with conditional skips;
- explicit rule branches based on already observed deterministic facts;
- content balancing rules;
- exposure exclusions;
- burden limits.

It does **not** claim computerized-adaptive-testing precision.

Future adaptive placement requires calibrated item parameters/information policy, content balancing, exposure control, stopping policy and validation evidence before activation.

## 8. Gap derivation

A learner gap is not `target_band - current_band` arithmetic alone.

Gap facts are derived only where both target requirement and admitted current evidence exist.

```text
TargetProfile requirement
  + construct evidence / uncertainty
  -> gap | evidence_needed | no_target_requirement
```

Missing evidence is `evidence_needed`, not automatically weakness.

This distinction is mandatory for P0-03 recommendation so the planner can choose between remediation and evidence collection.

## 9. Canonical HTTP API

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

Legacy scoped/root OpenAPI files are migration-only and cannot override these operations.

## 10. Idempotency/recovery

- `startPlacement`: same logical idempotency request produces at most one attempt.
- response submission: duplicate same item/version/logical response does not double-count evidence.
- submit placement: duplicate submit does not create multiple diagnosis results/events.
- pause/network loss: accepted responses remain durable; resume exact attempt/version.
- configuration cannot change beneath an active attempt; new config applies to a new attempt/version.

## 11. Events

Canonical events:

- `goal_set` — TargetProfile/study goal persisted;
- `placement_started` — attempt durably created;
- `placement_completed` — terminal result/termination persisted.

`placement_completed` should carry refs + result validity + coverage/termination classes only. It does not carry raw responses or raw statistical/model confidence.

P0-03 consumes admitted placement/evidence state rather than treating every `placement_completed` as a reliable weakness map.

## 12. Failure/recovery

| Condition | Result/recovery |
|---|---|
| no published/right-approved configuration | no attempt; explain unavailable/retry/fallback goal-only action |
| invalid config | fail closed; no diagnosis |
| network response failure | idempotent retry; preserve accepted responses |
| max burden with missing coverage | limited/insufficient result; do not force band |
| learner stops early | preserve state; narrow result or insufficient evidence |
| exposure-ineligible item | exclude from independent evidence; continue/replace when policy permits |
| stale version | reject conflicting mutation; reload current attempt |

## 13. Cost

P0 placement should normally incur **zero LLM/scorer model cost**.

Costs are primarily:

- managed API/database/storage;
- content authoring/review/calibration;
- deterministic scoring/aggregation.

Do not add model inference for placement explanation/routing until deterministic templated copy/rules demonstrably fail learner outcome requirements.

## 14. Acceptance evidence required

- [ ] TargetProfile supports module + optional overall/per-skill minima without forcing one target band.
- [ ] Target values do not alter scoring observations.
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

## References

- canonical API: `artifacts/engineering/api/`;
- `blueprint/05-content.md` — content/exposure boundary;
- `blueprint/framework/README.md` — TargetProfile/framework boundary;
- learning-assessment research artifact — advisory evidence only.