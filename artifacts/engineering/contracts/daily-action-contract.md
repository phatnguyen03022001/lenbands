# Daily Action Contract

Canonical metadata is in the sibling `daily-action-contract.meta.yaml`.

Minimum contract for P0-03: create one deterministic action from learner state, explain the reason, and recover safely when the plan is stale/unavailable. The artifact is in `review`; no acceptance run exists yet.

## Boundary and ownership

- `DailyPlanSnapshot` is derived state created by the Daily Action domain; it is not the SSOT for the goal, evaluation, review card, or learner draft.
- `CheckIn` is owned by the authenticated learner; it adjusts action length only and does not change outcome/rubric.
- `StudySession` is canonical study-session state; completion must be idempotent.
- P0 does not call a model for next-action routing; rule versions and ordered inputs must be auditable.
- P0 recommendation is **deterministic routing**, not proof that a personalized optimizer has been calibrated.
- Activity completion is not mastery. The plan may route learning, practice, review, or retest, but readiness changes only through canonical evidence/evaluation contracts.
- Stable compute decision units are declared in `daily-action-contract.meta.yaml`; `artifacts/operations/execution-policy.yaml` only projects their allowed compute mode and may not create Daily Action semantics.

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

`capability_id` must be a capability in the P0 profile; `reason_code` is the controlled enum of the deterministic decision rule:

| reason_code | Input rule | Meaning | Threshold (testable) |
|---|---|---|---|
| `placement_recent` | placement_completed in a recent window | Action based on the newly diagnosed gap | `placement_completed` ≤ 7 days + no completed session after placement |
| `review_due` | FSRS card(s) due today | Spaced-repetition review | ≥ 1 card with `due_at ≤ now` |
| `weakness_practice` | supported recurring error pattern | Practice a weak micro-skill | `error_count ≥ 2` in the last 30 days + no passed retest + independent-evidence guard below |
| `goal_aligned` | target band + exam date remain valid | Action aligned with long-term goal | `exam_date > now` + `target_band > current_band` |
| `continue_session` | previous session paused/incomplete | Continue the unfinished session | `StudySession.status ∈ {started, paused}` + `updated_at ≤ 24h ago` |
| `daily_goal_remaining` | daily goal not met + time remains | Complete today's goal | `daily_goal.completed_minutes < daily_goal.target_minutes` + `current_time < 23:59 local` |
| `fallback_micro_session` | no rule matches or computation is degraded | Short 5–10 minute deterministic session | Always available when no higher-priority rule matches |

The enum may expand only with a versioned decision rule. Values outside the enum are `unknown_reason_code`. If no eligible action exists, return `plan_state: fallback_offered`; do not create a fake recommendation.

## Evidence eligibility for weakness routing

A `weakness_practice` action must be based on sufficiently independent evidence. `error_count ≥ 2` remains necessary but is not sufficient by itself.

- Repeated failure on the **same item/version** does not count as two independent observations.
- Re-answering an item after seeing its answer/explanation does not create fresh diagnostic evidence.
- Duplicate/imported source items count as one evidence source when deduplication identifies them.
- A passed unscaffolded retest suppresses the weakness rule until new recurrence evidence appears under the versioned policy.
- If evidence independence is unknown, do not label the learner weak from that pattern; choose another eligible neutral/goal/review action.

P0 does not invent a mastery probability from this rule. The rule only determines whether deterministic weakness routing is eligible.

## Coverage and anti-tunnel-vision policy

The plan must not route one supported weakness forever while other required areas become unobserved. Deterministic tie-breaking considers continuity, due review load, evidence strength, under-observed goal-relevant areas, and learner time/energy. Exact recency windows, quotas and overload thresholds remain versioned policy and are not invented without pilot evidence.

A completed drill is not durable mastery. Where the construct requires generalization, the learning loop is:

```text
practice -> unscaffolded retest -> novel-context transfer check -> later maintenance
```

## Canonical API surface

HTTP transport is owned solely by `artifacts/engineering/api/openapi.yaml`; typed request/response semantics are compiled from the canonical API schema/type registries. This contract does not define a competing endpoint design.

Current Daily Action operations are:

| Operation | operationId | Domain rule |
|---|---|---|
| `GET /v1/today` | `getTodayPlan` | return latest valid plan snapshot or explicit fallback/unavailable state |
| `POST /v1/today/check-in` | `recordTodayCheckIn` | idempotently record time/energy input without mutating goal or scoring semantics |
| `POST /v1/study/sessions` | `startStudySession` | start an action that belongs to a valid plan snapshot |
| `PATCH /v1/study/sessions/{sessionId}` | `updateStudySession` | idempotently pause, resume, complete, or abandon under the session state machine |

All four operations are owned by implementation family `STUDY.DailyAction` in the canonical operation-ownership registry. Any transport change must start at the canonical API authority; this contract follows it rather than creating a second API source.

## Events and failure

Canonical events: `daily_plan_generated`, `session_started`, `session_completed`, `session_paused`, `session_resumed`, `session_abandoned`, `first_meaningful_session_completed`. Backend application logic is the producer; raw learner content is never emitted.

| Failure | Persisted state | Learner behavior |
|---|---|---|
| No placement/goal | `no_plan` | route to P0-02; do not show a fake action |
| Stale snapshot | `plan_stale` | regenerate from current canonical facts |
| Rules/cache unavailable | `plan_unavailable` | offer deterministic fallback micro-session |
| Weakness evidence not independent | unchanged | do not label weakness; choose next eligible action |
| Duplicate completion | unchanged | return prior completion snapshot |

## Compute and presentation boundary

Canonical facts and decisions are separate from presentation:

```text
learner facts
  -> deterministic eligibility/ranking/selection
  -> canonical action + reason_code + evidence refs
  -> optional presentation rendering
```

P0 uses deterministic presentation. A future generated explanation may be authorized as presentation only, but it cannot change action selection, reason code, evidence, readiness, score, goal, or session state. Presentation failure must leave the structured action usable.

## Cost and acceptance

- P0 plan generation has `max_model_calls: 0`; cache miss does not open a probabilistic route.
- [ ] One learner has only one completion per session/version.
- [ ] Plan explains at most three choices and controlled reason codes.
- [ ] `weakness_practice` does not count duplicate/revealed-item attempts as independent evidence.
- [ ] Completing a session does not directly mark durable mastery or exam readiness.
- [ ] Recent plan history can prevent one construct from monopolizing all goal-relevant practice.
- [ ] Fallback remains useful when recommendation/cache is unavailable.
- [ ] No daily-action acceptance run exists; evidence is required before the pack becomes `ready`.

## References

- `blueprint/03-features.md` — capability meaning.
- `blueprint/06-engines.md` — compute boundary.
- `artifacts/operations/execution-policy.yaml` — non-authoritative compute projection.
- `artifacts/engineering/api/openapi.yaml` — canonical HTTP transport.
- `artifacts/engineering/api/operation-ownership.yaml` — operation family ownership.
- `artifacts/experience/specs/vertical-slices/daily-action.md`.
- `artifacts/experience/research/learning-assessment-experience-audit.md` — research input, not runtime authority.
