# Vertical Slice — Placement, Goal & Initial Plan

## Outcome

The learner leaves onboarding knowing:

1. the IELTS target and current constraints;
2. what LenBands knows versus does not yet know;
3. whether the current target plan is `insufficient_evidence`, `on_track`, `at_risk`, `current_constraints_insufficient`, or `target_met` under the current planning policy;
4. whether the supported blocker is English foundation, IELTS technique, integrated performance, mixed, or evidence-needed;
5. one useful first action, why it matters, and how improvement will be verified.

Scope: `GOAL.Target`, `PLACE.Test`, `PLACE.BandEstimation`, `PLACE.GapDetection`, `PLACE.InitialPath`, `PLACE.SkillDiagnosis`, `BAND.Current`.

Success is not "show a band quickly" and not "promise the target is achievable". False precision is worse than a narrower/insufficient result.

## 1. Target setup

Target uses `TargetProfile`, not one mandatory band scalar.

Ask only what changes planning:

- Academic or General Training;
- target overall band if known;
- per-skill minima when relevant;
- exam date if known;
- daily study capacity;
- optional purpose/context when it materially changes planning.

Target does not change scorer generosity or observed evidence.

## 2. Placement behavior

P0 placement uses a published deterministic/fixed/rule-based configuration. No model inference is required in the default route.

```text
TargetProfile saved
  -> minimum useful placement evidence
  -> admitted diagnostic result
  -> evidence coverage
  -> supported cause or evidence-needed
  -> target feasibility
  -> one first action + why + verification
```

Persisted attempt state remains:

`new | in_progress | paused | submitted | diagnosed | insufficient_data`.

Screen-only loading/transitions do not create a second domain lifecycle.

## 3. Placement intro

Show:

- expected maximum burden/time as a configuration property, not a guarantee;
- what this placement can sample;
- that it produces diagnostic evidence, not an official IELTS result;
- that LenBands may return `not enough evidence yet`;
- that target feasibility is planning guidance, not a probability of exam success.

If no right-approved published configuration exists, provide a goal-only safe next action/retry. Do not generate arbitrary assessment content at runtime.

## 4. Attempt UX

| State | UI behavior | Rule |
|---|---|---|
| `in_progress` | one task/item at a time; clear save/progress state | answer stored idempotently |
| network loss | keep recoverable local state where possible | no duplicate response/evidence after sync |
| pause | save and leave safely | resume exact attempt/config version |
| submit guard | state what evidence remains | learner may continue or submit under termination policy |
| exposure conflict | another eligible item or explain limitation | familiar/revealed evidence is not fresh independent proof |

Do not infer whole-skill mastery from answer correctness alone.

## 5. Result UX

Always show **scope before number**.

Preferred hierarchy:

1. diagnostic scope/estimate when defensible;
2. what evidence was sampled;
3. what remains unknown;
4. supported cause or evidence-needed;
5. target-feasibility state + concise blocker copy;
6. one first action + Why + Verification.

Result validity:

| State | UI |
|---|---|
| `accepted` | allowed scoped estimate + coverage/cause/feasibility |
| `limited_evidence` | only defensible estimate(s) + limitation + evidence action |
| `insufficient_evidence` | no fabricated aggregate number; one minimum evidence action |
| `invalid` | no score/gap/cause; configuration/attempt recovery |

Do not show raw model/statistical confidence percentages unless separately validated.

## 6. Gap and cause language

A missing observation is not a weakness.

UI distinguishes:

- supported performance gap;
- needs evidence;
- not required by target;
- currently supported strength when evidence policy permits it.

When a gap is supported, cause may be:

- **English foundation** — language competence is the primary supported blocker;
- **IELTS technique** — task/question/rubric/timing method is the primary blocker;
- **Integrated performance** — knowledge appears available but independent application is the blocker;
- **Mixed** — multiple supported causes materially contribute;
- **Needs evidence** — cause cannot yet be defended.

Do not show “Speaking is weak” merely because Speaking evidence is absent.

## 7. Target feasibility UX

| State | Learner meaning | Primary response |
|---|---|---|
| `insufficient_evidence` | not enough evidence to judge the plan | collect smallest missing evidence |
| `on_track` | no known current pace/coverage blocker under policy | continue; never guarantee official outcome |
| `at_risk` | material actionable blocker exists | show highest-leverage blocker/action |
| `current_constraints_insufficient` | current date/capacity/coverage cannot form a credible target path | offer one constraint decision at a time |
| `target_met` | readiness policy is satisfied by admitted evidence | maintain/transfer/exam-prep, not forced higher-band study |

Forbidden:

- success probability without validated calibration;
- universal hours/weeks-to-band;
- “follow the plan and you will get Band X”.

## 8. Initial plan

The first plan may use the canonical intents, but the learner sees a compressed path:

```text
Target status
  -> one supported priority/cause
  -> one smallest useful action
  -> Why this?
  -> How we verify it
  -> at most one lighter alternative
```

Examples:

```text
evidence_needed          -> COLLECT_EVIDENCE
english_foundation       -> REMEDIATE with foundation unit
ielts_technique          -> REMEDIATE with task-method practice
integrated_performance   -> RETEST / independent application
mixed                    -> smallest evidence-supported blocking component first
```

Rules:

- deterministic/rules-first;
- no LLM path invention from free-form history;
- no advanced/beyond-target material without explicit prerequisite/exam-authenticity/transfer justification;
- if no governed intervention + independent verification path exists, return `content_gap` rather than unrelated/harder content.

## 9. API/runtime boundary

Canonical operations:

- `getMyGoal`;
- `putMyGoal`;
- `startPlacement`;
- `submitPlacementResponse`;
- `submitPlacement`;
- `getPlacementAttempt`.

Canonical payload semantics live in `artifacts/engineering/api/schema-contract.yaml`.

Runtime ownership:

| Entity | Write authority | Privacy |
|---|---|---|
| LearnerGoal/TargetProfile | learner through application API | learning |
| PlacementAttempt | placement domain | assessment/learning |
| PlacementResult | diagnosis domain | assessment/derived |
| TargetFeasibility | Goal/Placement planning policy | derived/learning |
| Initial plan | daily-action/planning domain | learning |

## 10. Cost boundary

P0 placement should have zero model calls in the normal route.

Use deterministic:

- answer keys/normalization where objective;
- config/coverage/exposure rules;
- evidence/cause/feasibility policy;
- templated learner explanation.

Do not add generated placement insight until measured learner outcome justifies the cost/privacy/complexity.

## 11. Recovery

| Condition | Experience |
|---|---|
| no config | unavailable + safe goal/evidence fallback |
| insufficient evidence | missing scope + one continuation option |
| max burden reached | stop burden; do not force score/cause |
| network interruption | preserve/resume exact attempt |
| stale version | reload/reconcile |
| module-ineligible content | reject; no semantic substitution |
| no cause evidence | show evidence-needed |
| current constraints insufficient | one actionable target/time/capacity decision |
| no intervention/retest coverage | `content_gap`; do not over-band |

## 12. Acceptance evidence

- [ ] TargetProfile supports module + optional overall/per-skill minima.
- [ ] Target never alters observed scoring truth.
- [ ] placement can produce no aggregate band when evidence is insufficient.
- [ ] missing evidence is never shown as weakness.
- [ ] cause classification requires admitted evidence and changes intervention when used.
- [ ] missing cause evidence returns evidence-needed.
- [ ] target feasibility never exposes guaranteed-band probability/hours-to-band.
- [ ] `current_constraints_insufficient` offers an actionable constraint decision.
- [ ] first plan exposes one action + reason + verification + at most one lighter alternative.
- [ ] missing curriculum/retest path produces `content_gap`.
- [ ] advanced/beyond-target content requires explicit justification.
- [ ] repeated/revealed item does not increase independent evidence.
- [ ] normal P0 placement performs zero model calls.
- [ ] no raw answers enter general telemetry.
- [ ] calibration evidence exists before calibrated-quality claims.

## Readiness

Contract completeness does not equal release evidence. Implementation/release state remains governed by the canonical Build Readiness Matrix, risk registry, API validation and exact-candidate acceptance evidence.
