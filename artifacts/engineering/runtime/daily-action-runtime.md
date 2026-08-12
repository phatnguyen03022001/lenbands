# Owner Runtime Spec — STUDY.DailyAction

## Identity

- `family_id`: `STUDY.DailyAction`
- `family_version`: `1.0.0`
- `lifecycle`: `ACTIVE`
- `build_status`: `candidate`
- `owner`: product

## Purpose and non-goals

Give a learner one reasoned action for today and execute it as a recoverable study session. It is not a general recommendation engine or adaptive planner.

## Actors and commands

Learner: `OpenToday`, `StartAction`, `PauseSession`, `ResumeSession`, `CompleteSession`, `ChooseAlternative`. Runtime: `GenerateDailyPlan`, `SelectNextAction`, `RestoreSession`.

## Interaction path

Open Today → load learner/goal/recent evidence → generate deterministic plan → show reason and action → start session → pause/resume or complete → persist outcome → publish next state.

## Runtime boundary and state

Plan: `no_plan → plan_ready → stale | replaced`. Session: `started → paused → completed | abandoned` (states per OpenAPI). `not_started` and `active` are UX-only render states, not canonical persisted states.

## Entities and ownership

`DailyPlan`, `NextAction`, `StudySession`, `SessionCheckpoint`. Study owns plan/session state; recommendation inputs remain references to owned evidence.

## API/contract references

`artifacts/engineering/contracts/daily-action-contract.md` and shared runtime event contracts.

Plan generation is idempotent per learner/date/config version. Resume uses the latest checkpoint, never replays a completed action.

## Events

`daily_plan_generated`, `session_started`, `session_paused`, `session_resumed`, `session_completed`, `session_abandoned`.

No learner content is emitted.

## Failure and recovery

`NO_ELIGIBLE_ACTION` offers up to three reasoned alternatives. `STALE_PLAN` regenerates with a new version. `SESSION_RESTORE_FAILED` preserves the last durable checkpoint and exposes recovery.

## Acceptance

- same learner/date returns the same plan version until invalidated;
- pause/resume does not duplicate completion;
- stale plan is not silently applied;
- empty action set has a safe fallback;
- completed session cannot regress to active.

## Evidence and dependencies

Evidence: daily-action acceptance run. Dependencies: `IDENTITY.Core`, `PLACEMENT.Diagnosis`, learner goal and recent activity facts.

## Executor dossier — permission, data, UI, observability, adapter

- **Permission**: `learner:read` (Today plan) + `learner:write` (session mutation) per auth-identity-contract.md. Plan service reads learner-owned goal/review facts only.
- **Data read/write**: reads learner state (goal, review due, recent activity refs); writes `DailyPlanSnapshot` (derived, not SSOT), `StudySession`, `CheckIn`. Never writes raw learner content; snapshot holds references + reason_code only.
- **API**: `GET /v1/today` (plan_state: `plan_ready|no_plan|plan_stale|plan_unavailable|fallback_offered`), `POST /v1/today/check-in`, `POST /v1/study-sessions`, `POST /v1/study-sessions/{id}/complete`.
- **Events**: producer `daily_plan_generated`, `session_started/paused/resumed/completed/abandoned`, `first_meaningful_session_completed`, `next_best_action_shown/taken`; consumer `placement_completed`, `goal_set`, `review_completed`, `retest_completed`.
- **UI/UX states**: Today screens per `daily-action.md` — plan loading/empty (`no_plan` → route to P0-02), stale (`plan_stale` → regenerate), unavailable (`plan_unavailable` → deterministic fallback), fallback (`fallback_offered` → ≤ 3 reasoned alternatives). Error/resume: `SESSION_RESTORE_FAILED` preserves last checkpoint; WCAG AA, keyboard, reduced-motion.
- **Observability**: rules version + ordered inputs auditable; `max_llm_calls: 0` for P0 plan routing; plan/session trace via observability contract.
- **Rollback/kill-switch**: plan generator rules versioned; a bad rule version rolls back via config (no data loss); session completion idempotent (kill-switch blocks new sessions, not in-flight durable effects).
- **Provider adapter boundary**: none — P0 daily action is deterministic rules, no provider call. Adapter boundary applies only if a later recommendation engine is introduced (then per provider-adapter-contract.md).
- **Non-goals**: not a general recommendation engine, not adaptive planner, no LLM routing in P0.
- **Deferred**: `PERSONAL.Insights`/`PERSONAL.GapAnalysis`/full `STUDY.Session` suite (P1); P0 uses `STUDY.DailyPlan`/`STUDY.CheckIn`/`STUDY.MicroSession` + deterministic `PERSONAL.NextBestAction` baseline.
