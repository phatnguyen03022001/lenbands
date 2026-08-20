# Vertical Slice — Placement, Goal & Initial Plan

## Outcome

The learner leaves onboarding knowing:

1. what exam target they are preparing for;
2. what LenBands currently knows versus does not yet know;
3. one useful first action based on admitted evidence or an explicit need to collect evidence.

Scope: `GOAL.Target`, `PLACE.Test`, `PLACE.BandEstimation`, `PLACE.GapDetection`, `PLACE.InitialPath`, `PLACE.SkillDiagnosis`, `BAND.Current`.

Success is not "show a band quickly". False precision is worse than a narrower/insufficient result.

## 1. Target setup

Target uses `TargetProfile`, not one mandatory band scalar.

Ask only what is useful for planning:

- Academic or General Training;
- target overall band if the learner has one;
- per-skill minimums when relevant;
- exam date if known;
- daily study time budget;
- optional purpose/context when it materially changes planning.

Learners may continue without exam date or overall target when they know only skill minima.

Copy must not imply that TargetProfile influences scorer generosity. It prioritizes planning only.

## 2. Placement behavior

P0 placement uses a published deterministic/fixed/rule-based configuration. No model inference is required in the default route.

```text
TargetProfile saved
  -> placement intro
  -> versioned attempt
  -> responses saved/resumable
  -> submit/termination policy
  -> admitted diagnostic result
       -> accepted/limited evidence
       -> insufficient evidence
       -> invalid configuration
  -> first plan/action
```

Persisted attempt state remains:

`new | in_progress | paused | submitted | diagnosed | insufficient_data`.

Screen-only states such as consent, configuration unavailable, diagnosing and initial-plan-ready are UX projections, not additional domain status values.

## 3. Placement intro

Show:

- expected maximum burden/time as a configuration property, not a guarantee;
- which skills/constructs this placement can currently sample;
- that it produces a diagnostic estimate, not an official IELTS result;
- that LenBands may return "not enough evidence yet" rather than inventing a band.

If no right-approved published configuration exists, provide a goal-only safe next action or retry. Do not generate an arbitrary assessment at runtime.

## 4. Attempt UX

| State | UI behavior | Rule |
|---|---|---|
| `in_progress` | one task/item at a time; clear save/progress state | answer stored idempotently |
| network loss | keep recoverable local state where possible | no duplicate response/evidence after sync |
| pause | save and leave safely | resume exact attempt/config version |
| submit guard | state what evidence/sections remain | learner may continue or submit under termination policy |
| exposure conflict | use another eligible item or explain limitation | familiar/revealed evidence is not counted as independent proof |

Do not use answer correctness alone to imply whole-skill mastery.

## 5. Result UX

Always show **scope before number**.

Preferred hierarchy:

1. `Initial diagnostic estimate` / narrower skill estimate;
2. what evidence/skills were sampled;
3. what remains unknown/missing;
4. learner-facing uncertainty copy;
5. first useful action and why.

Result validity behavior:

| State | UI |
|---|---|
| `accepted` | show allowed scoped estimates + evidence coverage |
| `limited_evidence` | show only defensible estimate(s) with limitation + verification action |
| `insufficient_evidence` | no fabricated aggregate number; show missing evidence and one continuation option |
| `invalid` | no score/gap; explain configuration/attempt recovery |

Do not show raw statistical/model confidence percentages unless separately calibrated for learner interpretation.

## 6. Gap language

A missing observation is not a weakness.

UI distinguishes:

- **confirmed/observed gap** — admitted evidence supports a performance gap;
- **needs evidence** — construct is under-measured;
- **not required by target** — no current target constraint;
- **strength / currently supported** — only when evidence policy permits that claim.

Avoid statements such as "Speaking is weak" merely because no Speaking evidence exists.

## 7. Initial plan

The first plan chooses among two fundamentally different intents:

```text
REMEDIATE        -> evidence supports a real gap
COLLECT_EVIDENCE -> uncertainty/missing coverage is the highest-value issue
```

P0 may also route to a safe generic Writing baseline/action when the closed pilot deliberately has narrow scope, but it must explain why.

The plan is deterministic/rules-first. It does not ask an LLM to infer the next action from free-form history.

## 8. API/runtime boundary

Canonical operations are:

- `getMyGoal`;
- `putMyGoal`;
- `startPlacement`;
- `submitPlacementResponse`;
- `submitPlacement`;
- `getPlacementAttempt`.

The canonical schemas live in `artifacts/engineering/api/schema-contract.yaml`. Legacy scoped OpenAPI files are migration-only.

Runtime owner/data:

| Entity | Write authority | Privacy |
|---|---|---|
| LearnerGoal/TargetProfile | learner through application API | learning |
| PlacementAttempt | placement service | assessment/learning |
| PlacementResult | diagnosis domain | assessment/derived |
| Initial plan | daily-action/planning domain | learning |

## 9. Cost boundary

P0 placement should have zero model calls in the normal route.

Use deterministic:

- answer keys/normalization where objective;
- config/coverage/exposure rules;
- aggregate/scoped estimate policy;
- templated learner explanation for common evidence states.

Do not add model-generated "personalized placement insight" until learner evidence shows it improves outcome enough to justify cost/privacy/complexity.

## 10. Recovery

| Condition | Experience |
|---|---|
| no config | explain unavailable + safe goal-only/fallback action |
| insufficient evidence | explain missing scope + one continuation option |
| max burden reached | stop burden; do not force a score |
| network interruption | preserve/resume exact attempt |
| stale version | reload/reconcile; do not overwrite |
| learner stops | preserve attempt; narrow/insufficient result only if policy allows |
| module-ineligible item/config | block selection; do not silently substitute incompatible semantics |

## 11. Acceptance evidence

- [ ] TargetProfile supports module + optional overall/per-skill minimums.
- [ ] UI never requires one universal target band when learner has another valid target shape.
- [ ] Target does not alter scoring truth.
- [ ] no-model P0 route is observable as zero model calls.
- [ ] resume/retry creates one logical attempt/evidence history.
- [ ] result can return no aggregate band when evidence is insufficient.
- [ ] missing evidence is shown as uncertainty/evidence-needed, not weakness.
- [ ] repeated/revealed item does not increase independent evidence.
- [ ] first plan distinguishes remediation from evidence collection.
- [ ] no raw answers enter general telemetry.
- [ ] real calibration evidence exists before calibrated-quality claims.

## Readiness

Semantic contract is reviewable, but **Ready for Source Code: no** until canonical consumers/generated API, calibration policy and executable acceptance evidence pass.