# Vertical Slice — Today & Daily Action

## Outcome and scope

The learner opens the app and receives exactly one useful next action, with a reason and a fallback option. Scope: `STUDY.DailyPlan`, `STUDY.CheckIn`, `STUDY.MicroSession`, `PERSONAL.NextBestAction`.

**In scope:** plan snapshot, time/energy check-in, deterministic priority, micro session, stale/empty-plan recovery. **Out of scope:** LLM recommendation P0, notification center, cross-device offline sync, advanced insights.

## Roles, entry and exit

- Role: authenticated learner; service computes only from learner-owned goal/review/session state.
- Entry: a consented learner opens Today or resumes a session; without placement, route to P0-02 and do not create a fake plan.
- Exit: the learner starts or completes an action; the plan snapshot does not mutate the goal, evaluation, or review source.

## Decision and state model

```text
no_plan → plan_generating → plan_ready → action_started → action_completed
plan_ready → plan_stale → plan_generating
plan_generating → plan_unavailable → fallback_offered
```

Priority is deterministic: due review with evidence → active Writing recovery/retest → placement incomplete → scheduled plan item → one bounded practice alternative. It must return a reason and at most three choices; it cannot claim personal insight absent data.

| Surface | Primary action | Required states |
|---|---|---|
| Today | Start next action | loading, no plan, stale, unavailable |
| Check-in | Choose time/energy | skip, saved, validation |
| Micro session | Complete one action | in progress, pause, complete |

## Screen behavior detail

### Today

| State | UI behavior | Copy rule | Decision |
|---|---|---|---|
| plan_ready | Show one next action, why now, estimated time and skill | "Best action today" not "dashboard" | start action |
| no_plan | Show placement or goal CTA | Explain why no plan exists | no fake recommendation |
| stale | Show last plan dimmed + regenerate action | "New data is available" | recompute from source |
| unavailable | Show fallback micro-session | "The plan cannot be calculated right now" | deterministic fallback |
| quota_limited | Show free review/fix option | do not hide existing work | no LLM call |

### Check-in

| State | UI behavior | Copy rule | Decision |
|---|---|---|---|
| default | Ask time/energy using quick controls | optional, skippable | adjust action length |
| skipped | Continue with normal plan | no penalty language | use default budget |
| low_energy | Offer micro-session first | affirm limited energy | never expand workload |
| saved | Update Today action without a page-reload feel | "Adjusted" | recompute deterministic |

### Micro-session

| State | UI behavior | Copy rule | Decision |
|---|---|---|---|
| start | One small task with expected outcome | outcome not streak | start session |
| paused | Save checkpoint | "You can return later" | resume |
| completed | Show proof and next due/retest | one next step | update progress/review |

## Runtime boundary and events

| Entity | Canonical source | Privacy | Event |
|---|---|---|---|
| CheckIn | learner choice | learning | `session_started` where session begins |
| DailyPlanSnapshot | plan service derived state | learning | `daily_plan_generated` |
| ActionStart/Completion | relevant slice service | learning | `session_started`, `first_meaningful_session_completed` when rule satisfied |

- Plan is derived; it never overwrites goal, evaluation, review card or learner choice.
- Cache is 5-minute deterministic compute only; cache failure reads source and offers fallback.
- A stale plan is regenerated from current state and does not requeue already completed actions.

Required contracts: plan decision/data/API/event/failure contract, session idempotency and quota/cost boundary. P0 generation has no LLM cost; cache miss falls back to deterministic source computation.

## Quality, cost and acceptance

- No LLM call for P0 plan generation. Rules and ordered inputs are versioned/auditable.
- [ ] New learner with no placement sees Placement CTA, not an empty dashboard.
- [ ] Learner with due review and valid error evidence sees review before optional practice.
- [ ] No eligible action produces one honest alternative, not fake personalization.
- [ ] Check-in/session retry does not duplicate completion events.
- [ ] Today remains useful when recommendation/cache service is unavailable.
- [ ] Returning learner sees a useful action within one screen without opening Learn/Practice.
- [ ] Low-energy check-in reduces scope but keeps learning outcome measurable.
- [ ] Quota limit never blocks review/fix of existing learner work.

## Readiness

Required next contracts: plan decision/ranking version, data/API/event/failure contract and session idempotency. **Ready for Source Code: no.**
