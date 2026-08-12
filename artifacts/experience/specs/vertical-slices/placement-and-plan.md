# Vertical Slice — Placement, Goal & Initial Plan

## Outcome and scope

The learner has a target, a baseline with clear reliability, and a reasoned initial plan. Scope: `GOAL.Target`, `PLACE.Test`, `PLACE.BandEstimation`, `PLACE.GapDetection`, `PLACE.InitialPath`, `PLACE.SkillDiagnosis`, `BAND.Current`.

**In scope:** target/date/time budget, published placement configuration, attempt/resume, provisional band/gap, first plan. **Out of scope:** official IELTS result, full four-skill exam simulation, adaptive practice engine, free-form placement inference.

## State and behavior

The canonical persisted placement attempt status is defined in `placement-diagnosis-contract.md`:
`new | in_progress | paused | submitted | diagnosed | insufficient_data`.

The states below are a UX-flow view that also includes screen-level states not persisted as status:

```text
new → consent_pending (UX only) → goal_collecting (UX only) → placement_ready (UX only) → placement_in_progress
consent_pending → consented → goal_collecting
placement_in_progress → submitted → diagnosing (UX transition) → diagnosed
placement_in_progress → paused → placement_in_progress
diagnosing → insufficient_data → placement_ready (UX only)
diagnosed → initial_plan_ready (UX only)
```

`consent_pending`, `goal_collecting`, `placement_ready`, `diagnosing`, and `initial_plan_ready` are UX/screen states; they are not persisted `placement_attempt.status`. Persisted status uses the canonical enum from `placement-diagnosis-contract.md`. `consent_pending` composes with `identity-consent.md`: placement configuration and learner responses are not processed until required consent is `consented`. Role is authenticated learner; service may read only that learner's goal/attempt.

| Surface | Primary action | Required recovery |
|---|---|---|
| Goal setup | Save goal | validation/date unavailable |
| Placement intro | Start baseline | no published configuration |
| Placement attempt | Continue / Submit | autosave, pause/resume, network loss |
| Result & gaps | View first plan | insufficient data, provisional disclosure |

Do not display an “official score”. `BAND.Current` always includes source, configuration version, confidence/calibration status, and timestamp.

## Screen behavior detail

### Goal setup

| State | UI behavior | Copy rule | Decision |
|---|---|---|---|
| default | Ask target band, exam module, exam date and daily time budget | Short labels; no long coaching text | If date missing, allow "no exam date yet" |
| invalid | Show field-level issue after user leaves field or submits | Say how to fix | Do not block unrelated fields |
| saved | Summarize goal and next step | "Used to create the baseline and first plan" | Move to placement intro |

### Placement intro

| State | UI behavior | Copy rule | Decision |
|---|---|---|---|
| ready | Show duration, what is measured, and provisional nature | No official-score claim | Start attempt |
| no_config | Empty state with retry/contact or fallback goal-only plan | Explain no published configuration | Do not generate random placement |
| resumed | Show saved progress and last saved time | "You can continue from question..." | Resume exact attempt |

### Placement attempt

| State | UI behavior | Copy rule | Decision |
|---|---|---|---|
| in_progress | One question/task at a time, visible progress and save status | Keep instruction near task | Autosave answer |
| network_loss | Continue locally if possible | "Your answer is being kept on this device" | sync later/idempotent |
| pause | Confirm safe pause, not abandon | "Progress saved" | return to Today or resume |
| submit_guard | Show unanswered critical items | "X questions still need answers for a better estimate" | submit or go back |

### Result and first plan

| State | UI behavior | Copy rule | Decision |
|---|---|---|---|
| diagnosed | Show band/gap with confidence and reason | "Initial estimate" if provisional | generate first Today action |
| insufficient_data | Explain which section lacks signal | one retry CTA | no band/gap persisted |
| plan_ready | Show first action and why | one primary CTA | accept plan |

## Runtime boundary

| Entity | Write authority | Privacy | Canonical events |
|---|---|---|---|
| LearnerGoal | learner | learning | goal-save contract pending |
| PlacementAttempt | placement service | learning | `placement_started`, `placement_completed` |
| PlacementResult | diagnosis service | learning | `placement_completed` |
| InitialPlan | plan service | learning | `daily_plan_generated` |

- Placement config is a future published Knowledge Asset; this slice only accepts a `published` config/version reference.
- Result generation is deterministic/rule-based for P0 unless an approved evaluation route is introduced.
- Missing/invalid responses never fabricate band/gap; show insufficient-data reason and retry path.

## Quality, cost and acceptance

- Must pass Placement Quality Gate before a configuration is selectable.
- No model call in baseline route P0; cache/resume must not alter attempt answers or band result.
- [ ] Resume produces one attempt history, not duplicates.
- [ ] Result records config/calibration version and communicates `provisional` when not calibrated.
- [ ] No valid configuration or insufficient data leads to a learner-safe retry, never random plan.
- [ ] Goal/attempt data is owner-scoped and redacted from analytics.
- [ ] Goal setup, placement attempt and result screen each have one primary CTA.
- [ ] Learner can leave placement and return to the exact saved attempt state.
- [ ] First plan explains why the first action was chosen from gap/goal data.

## Readiness

Required next contracts: placement data/API/event/failure, deterministic scoring rule and configuration publish/rights reference. **Ready for Source Code: no.**
