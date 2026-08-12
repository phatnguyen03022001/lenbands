# Owner Runtime Spec — PLACEMENT.Diagnosis

## Identity

- `family_id`: `PLACEMENT.Diagnosis`
- `family_version`: `1.0.0`
- `lifecycle`: `ACTIVE`
- `build_status`: `candidate`
- `owner`: product

## Purpose and non-goals

Collect a learner goal and a bounded baseline, estimate current ability, identify gaps, and create an initial path. It does not claim official IELTS band equivalence without calibration evidence.

## Actors and commands

Learner commands: `SetGoal`, `StartPlacement`, `SubmitPlacementResponse`, `RetryPlacement`, `AcceptInitialPath`. Runtime commands: `ScorePlacement`, `CreateGapProfile`, `CreateInitialPath`.

## Interaction path

Goal selection → placement instructions → response submission → deterministic/contracted scoring → sufficient-evidence decision → band estimate and gap profile → initial path. Insufficient evidence ends in an explicit retry state.

## Runtime boundary and state

Canonical persisted placement attempt status (placement-diagnosis-contract.md): `new | in_progress | paused | submitted | diagnosed | insufficient_data`. `scoring`, `diagnosing` are transition/workflow states, not persisted statuses; `insufficient_data` is the persisted status when signal is insufficient.

An attempt is immutable after submission. Retry creates a new attempt linked to the prior attempt.

## Entities and ownership

`Goal`, `PlacementAttempt`, `PlacementResponse`, `BandEstimate`, `GapProfile`, `InitialPath`. Placement owns the attempt and derived results; Framework owns IELTS vocabulary and conversion semantics.

## API/contract references

`artifacts/engineering/contracts/placement-diagnosis-contract.md`.

Every score includes configuration version, evidence refs, and scoring status. No score is emitted when evidence is insufficient.

## Events

`goal_set`, `placement_started`, `placement_completed` (canonical owned events per placement-diagnosis-contract.md §Events).

Events contain aggregate refs and result status, not free-text responses. The `insufficient_data` status is transmitted through the status field of `placement_completed`; a separate `placement_insufficient_evidence` event is unnecessary (it is not a canonical owned event).

## Failure and recovery

`CONFIG_NOT_PUBLISHED` blocks scoring and explains retry later. `SCORING_UNAVAILABLE` preserves the attempt. `INSUFFICIENT_EVIDENCE` returns a safe state and required next action.

## Acceptance

- submitted attempt cannot be silently mutated;
- duplicate submit is idempotent;
- insufficient evidence never produces a confident band;
- initial path references the exact goal and gap profile versions;
- provider/runtime failure preserves retryability.

## Executor dossier — permission, data, UI, observability, adapter

- **Permission**: `learner:read` + `learner:write` (goal, attempt, responses); placement service reads only the authenticated learner's own goal/attempt. No cross-user access.
- **Data read/write**: learner writes `Goal`, `PlacementAttempt`, `PlacementResponse`; diagnosis service writes `BandEstimate`, `GapProfile`, `InitialPath`. `answer_refs` are references to learner-owned storage; response text never enters analytics events. Privacy class `learning` (manifest P0-02 canonical).
- **API**: `POST /v1/placement/attempts` (Idempotency-Key required), `PUT /v1/placement/attempts/{id}` (optimistic version), `POST /v1/placement/attempts/{id}/submit`, `GET /v1/placement/results/{id}` (provisional disclosure).
- **Events**: producer `goal_set`, `placement_started`, `placement_completed`; consumer `account_created`. `insufficient_data` transmitted via `placement_completed` status field as specified in §Runtime boundary and state; separate `placement_insufficient_evidence` event is NOT canonical (not in canonical owned events list). Verify event ownership registry for any registration conflict.
- **UI/UX states**: per `placement-and-plan.md` — goal setup (default/invalid/saved), placement intro (ready/no_config/resumed), attempt (in_progress/network_loss/pause/submit_guard), result (diagnosed/insufficient_data/plan_ready). No "official score" label; `BAND.Current` always shows source, config version, confidence/calibration status, timestamp. WCAG AA, keyboard.
- **Observability**: configuration/calibration version on every result; no raw response text in logs/telemetry.
- **Rollback/kill-switch**: placement config versioned; a bad config rolls back via published-config reference (no attempt data loss); retry creates new attempt linked to prior, never duplicate.
- **Provider adapter boundary**: placement scoring is deterministic/rule-based for P0 (`max_llm_calls: 0` baseline); any later model route must go through benchmark + provider-adapter-contract.md, not direct.
- **Non-goals**: official IELTS score claim, full four-skill exam simulation, adaptive practice engine, free-form placement inference.
- **Deferred**: `BAND.Readiness`/`BAND.ExamReadiness`/`BAND.Map` (P1/deferred); P0 only `BAND.Current`.

## Evidence and dependencies

Evidence: placement calibration run and acceptance run. Dependencies: `IDENTITY.Core`, published placement configuration, framework exam-module and band/question-type references.
