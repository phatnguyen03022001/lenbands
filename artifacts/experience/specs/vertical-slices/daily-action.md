# Vertical Slice — Today & Daily Action

## Outcome and scope

The learner opens Today and receives one useful next action, one short reason, one verification statement and at most one lighter alternative. Scope: `STUDY.DailyPlan`, `STUDY.CheckIn`, `STUDY.MicroSession`, `PERSONAL.NextBestAction`.

P0 routing is deterministic and evidence-aware. It does not call an LLM to decide what the learner should study.

## Entry and exit

- Actor: authenticated learner acting on their own target/evidence/review/session state.
- Entry: Today open, optional time/energy check-in, or resume from an unfinished valid session.
- Missing prerequisite: show goal/evidence prerequisite rather than fake personalization.
- Exit: learner starts, pauses, completes or abandons one action. Session completion does not directly set mastery/readiness.

## Primary learner contract

The Today surface answers:

```text
Where am I relative to my target?
What one thing should I do now?
Why this?
How will we verify that it helped?
```

The learner must not need to choose among separate primary cards for Learning Path, Smart Queue, Insights, Practice, Review and Progress before receiving this answer.

## Planner intents

Canonical intents:

`CONTINUE | REVIEW_DUE | RETEST | REMEDIATE | COLLECT_EVIDENCE | GOAL_COVERAGE | FALLBACK`

Rules:

- `REMEDIATE` requires admitted evidence for a specific actionable issue.
- `COLLECT_EVIDENCE` is used when target-relevant evidence is missing.
- `RETEST` requires an eligible independent/novel route.
- `REVIEW_DUE` applies only to retrievable units with valid source evidence.
- `FALLBACK` is honest and never pretends to be personalized.

Supported cause modifies intervention:

```text
english_foundation      -> foundation remediation
ielts_technique         -> task-method practice
integrated_performance  -> independent application/retest
mixed                   -> smallest evidence-supported blocking component first
evidence_needed         -> evidence collection
```

## Target feasibility

Today consumes the derived feasibility state:

| State | Today behavior |
|---|---|
| `insufficient_evidence` | collect the minimum useful missing evidence |
| `on_track` | continue highest-value target action; no guarantee copy |
| `at_risk` | show the highest-leverage actionable blocker |
| `current_constraints_insufficient` | show one constraint decision rather than an impossible normal plan |
| `target_met` | maintenance/transfer/readiness evidence; do not auto-push a higher band |

Feasibility is not a probability of the official exam result.

## State model

```text
no_plan -> plan_ready -> action_started -> action_completed
plan_ready -> plan_stale -> plan_ready
no_plan -> content_gap
no_plan -> plan_unavailable -> fallback_offered
plan_ready -> plan_replaced
```

UI loading states may exist but do not create a second domain lifecycle.

## Today surface

Show, in order:

1. concise target/feasibility status when it changes today's decision;
2. one primary next action;
3. controlled `Why this?` copy from reason/cause/evidence state;
4. `How we verify this`;
5. estimated time;
6. at most one lighter alternative when time/energy makes the primary action unsuitable.

Do not display multiple equivalent recommendations merely because the internal planner produced candidates.

Copy must distinguish:

- `we have evidence this needs work`;
- `we need more evidence here`;
- `your current time/date constraints need a decision`;
- `we do not yet have suitable governed content for this gap`.

## Check-in

Time/energy adjusts burden/ranking only. It does not modify target, rubric, score, evidence validity, diagnosis cause or readiness.

- skipped → normal configured budget;
- low time/energy → lighter eligible action;
- saved → recompute deterministic plan from the same canonical evidence state plus check-in.

## No-over-band behavior

Today chooses the minimum sufficient challenge.

Advanced/beyond-target content is excluded unless:

- prerequisite bridge requires it;
- authentic IELTS task complexity requires it;
- transfer/robustness verification intentionally requires a harder/new context;
- the lower requirement is already demonstrated and the next level is target-relevant.

If no appropriate intervention exists, show `content_gap`; do not fill the plan with harder/unrelated material.

## Micro session

- Start from one observable outcome.
- Pause/resume preserves exact action identity.
- Complete stores activity state only; improvement requires downstream evidence admission.
- Quota limits do not hide already-created free review/fix work.

## Canonical API boundary

Use only:

- `getTodayPlan`;
- `recordTodayCheckIn`;
- `startStudySession`;
- `updateStudySession`.

HTTP/payload owners are `artifacts/engineering/api/openapi.yaml` and `schema-contract.yaml`.

Expected DailyPlan semantics include:

- target-feasibility state;
- one `primary_action_id`;
- action reason/cause;
- verification rule;
- `content_gap` plan state when curriculum/verification coverage is missing.

## Quality, cost and privacy

- P0 planner: zero LLM calls.
- Same versioned inputs produce the same eligibility/ranking result.
- Recent history/coverage guards prevent tunnel vision.
- Repeated/revealed items do not create independent transfer evidence.
- No model-generated alternative-plan spam.
- Planner telemetry contains opaque refs, intent/reason/cause/feasibility classes and no raw private content.

## Acceptance

- [ ] Under-observed learner sees evidence collection instead of guessed weakness.
- [ ] Supported cause routes to the appropriate intervention family.
- [ ] Today shows one primary action + one reason + one verification statement + at most one lighter alternative.
- [ ] Learner does not need to browse the feature catalog to know what to do next.
- [ ] `current_constraints_insufficient` yields an actionable constraint decision and no guaranteed-band copy.
- [ ] `target_met` does not automatically route to a higher band.
- [ ] Advanced/beyond-target content requires explicit justification.
- [ ] Missing curriculum/retest coverage yields `content_gap`.
- [ ] Low time/energy reduces burden without altering scoring/evidence semantics.
- [ ] Refresh/network retry does not duplicate completion effects.
- [ ] Session completion alone cannot mark IELTS mastery/readiness.
- [ ] Planner performs zero LLM calls.

## Readiness

The learner interaction contract is aligned with canonical placement/planner/API semantics. Implementation/release remains governed by risk/readiness and exact-candidate acceptance evidence; prose completeness is not release readiness.
