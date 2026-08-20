# Vertical Slice — Today & Daily Action

## Outcome and scope

The learner opens Today and receives one useful next action with a short reason and a safe fallback. Scope: `STUDY.DailyPlan`, `STUDY.CheckIn`, `STUDY.MicroSession`, `PERSONAL.NextBestAction`.

P0 routing is deterministic and evidence-aware. It does not call an LLM to decide what the learner should study.

## Entry and exit

- Actor: authenticated learner acting on their own goal/evidence/review/session state.
- Entry: Today open, optional time/energy check-in, or resume from an unfinished valid session.
- Missing prerequisite: show the prerequisite action (`COLLECT_EVIDENCE`/placement or goal setup) rather than fake personalization.
- Exit: learner starts, pauses, completes or abandons one action. Session completion does not directly set mastery/readiness.

## Planner intents

The interaction consumes the canonical deterministic candidates from `artifacts/engineering/contracts/daily-action-contract.md`:

`CONTINUE | REVIEW_DUE | RETEST | REMEDIATE | COLLECT_EVIDENCE | GOAL_COVERAGE | FALLBACK`

UX rules:

- `REMEDIATE` requires admitted evidence for a specific actionable error.
- `COLLECT_EVIDENCE` is used when a target-relevant area is under-observed; missing evidence is never shown as a weakness.
- `RETEST` requires an eligible independent/novel retest route.
- `REVIEW_DUE` applies only to retrievable units with valid source evidence.
- `FALLBACK` is honest about degraded/no-plan state and never pretends to be personalized.

## State model

```text
no_plan -> plan_generating -> plan_ready -> action_started -> action_completed
plan_ready -> plan_stale -> plan_generating
plan_generating -> plan_unavailable -> fallback_offered
plan_ready -> plan_replaced
```

Persisted API/domain state comes from the canonical API/schema/runtime contracts; UI-only loading/transition states do not create a second lifecycle authority.

## Surfaces

| Surface | Primary action | Required recovery |
|---|---|---|
| Today | Start primary action | no plan, stale, unavailable, quota-limited |
| Check-in | Set/skip time and energy | validation, retry without changing learning truth |
| Micro session | Continue/complete action | pause, refresh/network retry, duplicate completion |

### Today

Show, in order:

1. one primary next action;
2. controlled reason copy derived from its intent/reason code;
3. estimated time and relevant skill/construct when known;
4. at most two secondary eligible alternatives when useful.

Copy must distinguish:

- “we have evidence this needs practice” from
- “we need more evidence here.”

Do not show opaque model explanations or a fake precision score for recommendation quality.

### Check-in

Time/energy adjusts burden/ranking only. It does not modify target, rubric, score, evidence validity or readiness.

- skipped → use normal configured budget;
- low energy/time → prefer a smaller eligible action;
- saved → recompute deterministic plan from the same canonical evidence state plus check-in.

### Micro session

- Start from one observable outcome.
- Pause/resume preserves the exact session/action identity.
- Complete stores activity evidence only; any learning improvement requires the downstream review/retest/evaluation admission rule.
- Quota limits must not hide already-created free review/fix work.

## Canonical API boundary

Use only the canonical operation IDs:

- `getTodayPlan`
- `recordTodayCheckIn`
- `startStudySession`
- `updateStudySession`

The HTTP/path/payload owners are `artifacts/engineering/api/openapi.yaml` and `schema-contract.yaml`. Migration-only OpenAPI files are not implementation inputs.

## Quality, cost and privacy

- P0 planner: zero LLM calls.
- Same versioned planner inputs must produce the same eligibility/ranking result.
- Recent action history/coverage guards prevent one observed weakness or review queue from monopolizing the plan.
- Repeated/revealed items do not create independent retest/transfer evidence.
- Planner telemetry contains opaque refs, intent/reason code, latency and outcome; no raw learner essay/answer/private note text.

## Acceptance

- [ ] New/under-observed learner sees prerequisite/evidence-collection action instead of a guessed weakness.
- [ ] Valid due review/retest/remediation is selected according to deterministic policy and constraints.
- [ ] Low-energy/time check-in reduces burden without altering scoring/evidence semantics.
- [ ] Stale plan is replaced from current source state without re-queuing completed work.
- [ ] Refresh/network retry and duplicate session mutation do not duplicate completion effects.
- [ ] No eligible action yields a truthful fallback/no-plan state.
- [ ] Session completion alone cannot mark IELTS mastery/readiness.
- [ ] Planner performs zero LLM calls.

## Readiness

The behavior contract is reconciled with the canonical API and deterministic planner semantics. Implementation/release remains blocked by the applicable entries in `artifacts/operations/problem-risk-registry.yaml` and by missing acceptance evidence; prose completeness is not readiness.
