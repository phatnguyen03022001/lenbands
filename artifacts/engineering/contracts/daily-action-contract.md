# Daily Action Contract

Canonical metadata is in the sibling `daily-action-contract.meta.yaml`.

Minimum contract for P0-03: create one deterministic action from learner state, explain the reason, and recover safely when the plan is stale/unavailable. The artifact is in `review`; no acceptance run exists yet.

## Boundary and ownership

- `DailyPlanSnapshot` is derived state created by plan service; it is not the SSOT for the goal, evaluation, review card, or learner draft.
- `CheckIn` is owned by the authenticated learner; it adjusts action length only and does not change outcome/rubric.
- `StudySession` is created by session service; completion must be idempotent.
- P0 does not call an LLM for next-action routing; rule versions and ordered inputs must be auditable.

## Data contract

```yaml
daily_plan_snapshot:
  plan_id: string
  learner_id: internal_ref
  plan_version: string
  source_versions: [string]
  actions: [{action_id: string, capability_id: string, reason_code: string, estimated_minutes: integer}]
  generated_at: timestamp
  expires_at: timestamp

check_in:
  check_in_id: string
  minutes_available: integer | null
  energy: low | normal | high | skipped

study_session:
  session_id: string
  action_id: string
  status: started | paused | completed | abandoned
  version: integer
```

`capability_id` must be a capability in the P0 profile; `reason_code` is the controlled enum of the decision rule (P0 deterministic, no LLM):

| reason_code | Input rule | Meaning | Threshold (testable) |
|---|---|---|---|---|
| `placement_recent` | placement_completed in a recent window | Action based on the newly diagnosed gap | `placement_completed` ≤ 7 days + no completed session after placement |
| `review_due` | FSRS card(s) due today | Spaced-repetition review | ≥ 1 card with `due_at ≤ now` |
| `weakness_practice` | error pattern with highest frequency | Practice weak micro-skill | `error_count ≥ 2` in the last 30 days + no passed retest |
| `goal_aligned` | target band + exam date remain valid | Action aligned with long-term goal | `exam_date > now` + `target_band > current_band` |
| `continue_session` | previous session paused/incomplete | Continue the unfinished session | `StudySession.status ∈ {started, paused}` + `updated_at ≤ 24h ago` |
| `daily_goal_remaining` | daily goal not met + time remains | Complete today's goal | `daily_goal.completed_minutes < daily_goal.target_minutes` + `current_time < 23:59 local` |
| `fallback_micro_session` | no rule matches or engine degraded | Short 5-10 minute deterministic session | Always available; used when no rule matches or cache/engine is unavailable |

The enum may expand with a new decision rule; values outside the enum → `unknown_reason_code`. If no eligible action exists, return `plan_state: fallback_offered`; do not create a fake recommendation.

## Selected logical API surface (OpenAPI candidate)

Per the API ownership contract (`api-ownership-bff-contract.md:18-23`), `writing-task-2/openapi.yaml` (v0.5.0, review) is the selected logical candidate surface for the P0 loop; the root `contracts/openapi.yaml` is the selected logical identity surface. One unified canonical OpenAPI authority does not yet exist, and neither live spec alone is a complete build input. The three OpenAPI endpoints below are the candidate P0-03 paths:
- `GET /v1/today` (operationId `getTodayPlan`) — matches contract; returns DailyPlan with plan_state and up to 3 actions
- `POST /v1/study/sessions` (operationId `startStudySession`) — starts the selected daily action session
- `PATCH /v1/study/sessions/{sessionId}` (operationId `updateStudySession`) — pauses, completes, or abandons a session via state enum `[paused, completed, abandoned]`

Three documented conflicts exist against this contract:

1. **STUDY.CheckIn has no dedicated HTTP endpoint.** The contract defines `POST /v1/today/check-in` and a `check_in` data entity (`check_in_id`, `minutes_available`, `energy`). No such path or schema exists in either live OpenAPI file. The `transport-classification.yaml:101-106` maps `STUDY.CheckIn` → `startStudySession` (`POST /v1/study/sessions`), but that operation starts a session from a plan action — it does not capture check-in data. This is a contract gap: either add a check-in endpoint/schema to the OpenAPI and the manifest `data_entities`, or remove the check-in concept from the P0-03 contract and transport classification.

2. **Path format and method mismatch for sessions.** The contract uses `POST /v1/study-sessions` (hyphen) and `POST /v1/study-sessions/{sessionId}/complete`; the OpenAPI uses `POST /v1/study/sessions` (slash) and `PATCH /v1/study/sessions/{sessionId}` with `state=completed`. The completion semantics differ (dedicated endpoint vs PATCH state transition), and the OpenAPI cannot express a `started` resume (the lifecycle contract `:226` permits `paused → started`, but `UpdateSessionRequest.state` at OpenAPI `:651` is `[paused, completed, abandoned]` — `started` is not an allowed request value).

3. **DailyPlan `plan_replaced` lifecycle state absent from OpenAPI.** The lifecycle contract `:197,199` defines `plan_replaced` as a terminal state; the OpenAPI `:628` does not include it.

The API table in this contract (§ API and idempotency) uses a different path/method design that does not match the OpenAPI. This is an identified/triaged, unresolved, implementation-blocked conflict; it does not create a second canonical authority. The smallest safe resolution: align this contract's API table to the three OpenAPI candidate paths, add CheckIn resolution (endpoint + schema or concept removal), reconcile the completion method (PATCH vs POST), resolve the resume gap, and add `plan_replaced` to the OpenAPI enum. See `artifacts/engineering/decisions/openapi-unification-review-packet.md` for the complete P0-03 conflict matrix.

## API and idempotency

| Operation | Owner | Rule |
|---|---|---|
| `GET /v1/today` | plan service | return latest snapshot or fallback state |
| `POST /v1/today/check-in` | plan service | idempotency key; update new snapshot, do not mutate goal |
| `POST /v1/study-sessions` | session service | action must belong to a valid snapshot |
| `POST /v1/study-sessions/{sessionId}/complete` | session service | idempotent by session/version; one completion |

## Events and failure

Canonical events: `daily_plan_generated`, `session_started`, `session_completed`, `session_paused`, `session_resumed`, `session_abandoned`, `first_meaningful_session_completed`. Backend service is the producer; do not emit raw learner content.

| Failure | Persisted state | Learner behavior |
|---|---|---|
| No placement/goal | `no_plan` | route to P0-02, do not show a fake action |
| Stale snapshot | `plan_stale` | regenerate from the current source |
| Rule/cache unavailable | `plan_unavailable` | fallback micro-session deterministic |
| Duplicate completion | unchanged | return the prior completion snapshot |

## Cost and acceptance

- P0 plan generation has `max_llm_calls: 0`; cache miss does not open a paid route.
- [ ] One learner has only one completion per session/version.
- [ ] Plan explains at most three choices and the reason code.
- [ ] Fallback remains useful when recommendation/cache is unavailable.
- [ ] No daily-action acceptance run exists; the founder needs evidence before the pack becomes `ready`.

## References

- `blueprint/03-features.md` — P0-03 Daily action.
- `artifacts/experience/specs/vertical-slices/daily-action.md`.
