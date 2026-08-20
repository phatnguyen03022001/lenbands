# Daily Action Contract

Canonical metadata is in the sibling `daily-action-contract.meta.yaml`.

P0-03 chooses one useful next action from current learner evidence without an LLM. The plan is derived state; it never becomes a source of truth for goal, evaluation, review or readiness.

The learner-facing contract is intentionally smaller than the internal capability graph:

```text
Where am I?
  -> What is blocking my target?
  -> What one thing should I do now?
  -> Why this?
  -> What evidence will verify improvement?
```

## Inputs and ownership

The deterministic planner reads only bounded, versioned inputs:

```yaml
target_profile_ref: string
learner_evidence_state_ref: string
target_feasibility_ref: string | null
diagnosis_cause_refs: [string]
content_coverage_state_ref: string
open_learning_error_refs: [string]
due_review_refs: [string]
retest_eligibility_refs: [string]
active_session_ref: string | null
recent_action_history_ref: string | null
check_in:
  minutes_available: integer | null
  energy: low | normal | high | skipped
```

Rules:

- `TargetProfile` is the goal constraint. Do not reduce it to one `target_band` scalar.
- Missing evidence is not weakness.
- A learner-visible action reason must resolve to a controlled intent/reason code; free-form model reasoning is not a routing authority.
- P0 plan generation performs `max_llm_calls: 0`.
- Completion of an action is not mastery/readiness evidence by itself.
- The planner distinguishes supported `english_foundation`, `ielts_technique`, `integrated_performance`, `mixed`, and `evidence_needed` causes instead of routing all deficits into generic practice.
- Target feasibility is planning context only; it is never interpreted as a probability or guarantee of official-band attainment.
- An action is not eligible unless the content system can supply the required governed teaching/practice asset and, when improvement is to be verified, an independent/retest path.

## Minimal learner-path invariant

The internal plan may contain multiple eligible candidates, but the primary learner experience must expose:

1. one current target/status summary;
2. one primary action;
3. one concise `Why this?` reason;
4. one verification statement (`how we will know this helped`);
5. at most one lighter alternative when time/energy makes the primary action unsuitable.

Do not make the learner choose among a catalog of lessons, drills, queues, analytics and scoring tools before the planner has produced this compressed path.

The app may expose deeper planning detail on request, but deeper detail cannot become a prerequisite to knowing what to do next.

## Candidate intents and reason codes

The planner generates eligible candidates before ranking them. P0 keeps one closed reason code per primary intent so analytics, UI copy and acceptance tests do not infer meaning from free text.

| Intent | Reason code | Eligible when | Must not mean |
|---|---|---|---|
| `CONTINUE` | `resume_active_session` | a resumable learner-owned session exists and is still valid | unfinished work is always highest priority regardless of state/expiry |
| `REVIEW_DUE` | `due_review` | a retrievable ReviewCard is due and source evidence remains valid | FSRS maturity proves IELTS mastery |
| `RETEST` | `eligible_retest` | an active error has a governed retest path and exposure/novelty gate is eligible | reuse the source prompt after feedback exposure |
| `REMEDIATE` | `admitted_error` | admitted evidence supports a specific actionable error and remediation mapping exists | infer a weakness from missing data |
| `COLLECT_EVIDENCE` | `evidence_gap` | a target-relevant construct is under-observed and an eligible diagnostic/practice action can reduce uncertainty | label the learner weak before observation |
| `GOAL_COVERAGE` | `target_coverage_gap` | target-relevant practice is eligible and recent plans would otherwise over-concentrate elsewhere | optimize content completion for its own sake |
| `FALLBACK` | `deterministic_fallback` | no higher-value eligible candidate or planner dependency is degraded | fabricate personalization |

Cause classification refines candidate selection without multiplying learner-facing intents:

```text
english_foundation      -> REMEDIATE / foundation teaching-practice
ielts_technique         -> REMEDIATE / task-method practice
integrated_performance  -> RETEST / independent application practice
mixed                   -> choose smallest blocking component first, preserve the other as queued evidence
                           only when policy can justify the ordering
evidence_needed         -> COLLECT_EVIDENCE
```

Changing intent/reason vocabulary is an API/analytics contract change, not a copy tweak. Learner-facing prose is rendered from these codes and may be localized without changing routing semantics.

## Eligibility filters

A candidate is removed before ranking when any of these fail:

- authorization/ownership;
- content rights/lifecycle/module eligibility;
- prerequisite state;
- exposure/novelty policy;
- quota/cost policy;
- required evidence/result-validity policy;
- session state/version;
- target relevance;
- curriculum sufficiency for the intended intervention/verification;
- challenge-level appropriateness.

### No-over-band rule

The planner optimizes the **minimum sufficient challenge** for the learner's current evidence and target.

It must not route advanced/beyond-target content simply because:

- a higher-band asset exists;
- a learner asked for a high target but lacks prerequisites;
- harder content appears more impressive;
- more difficult practice increases engagement time.

Above-current or above-target content is eligible only when at least one explicit rule applies:

1. it is a prerequisite bridge required for the target path;
2. authentic exam exposure necessarily includes that complexity;
3. transfer/robustness verification requires a harder/new context;
4. the learner has already demonstrated the lower-level requirement and the target actually requires the next level.

If a suitable target-level intervention does not exist, return `content_gap` through planner state/telemetry and do not substitute unrelated harder content.

## Deterministic ranking

P0 uses a versioned deterministic policy. It does not ask an LLM to inspect learner history and choose an action.

Ranking considers, in controlled order:

1. recoverable active work and learner continuity;
2. due review/retest obligations whose evidence remains valid;
3. supported cause severity and expected learning value;
4. evidence uncertainty/information value for under-observed target-relevant constructs;
5. target feasibility blockers and goal relevance;
6. target coverage balance;
7. transfer/maintenance need;
8. exposure novelty and anti-contamination constraints;
9. minimum sufficient challenge / prerequisite fit;
10. available time/energy and recent cognitive load;
11. stable deterministic tie-break.

Exact numeric weights/windows are versioned policy only after pilot evidence. Until then, implementation uses explicit ordered rules/constraints rather than invented coefficients.

### Anti-tunnel-vision invariant

Recent plan history must prevent one observed error or content type from monopolizing all target-relevant study. A supported weakness may outrank neutral practice, but it cannot suppress required evidence collection, overdue review, eligible transfer/retest, or neglected target coverage indefinitely.

### Feasibility response

Planner behavior by target-feasibility state:

| Feasibility | Planner behavior |
|---|---|
| `insufficient_evidence` | prioritize minimum useful evidence collection; do not reassure or alarm with invented pace |
| `on_track` | continue highest-value target action; do not claim guaranteed attainment |
| `at_risk` | prioritize the highest-leverage actionable blocker and show one concise risk reason |
| `current_constraints_insufficient` | do not create an impossible-looking daily plan; surface one constraint decision such as more time, later exam date, changed target, or narrower minimum while preserving learner agency |
| `target_met` | shift to maintenance/transfer/exam-readiness evidence rather than unnecessary higher-band progression |

## Data contract

```yaml
daily_plan_snapshot:
  plan_id: string
  plan_version: string
  evidence_state_version: string
  target_profile_version: integer
  target_feasibility_state: insufficient_evidence | on_track | at_risk | current_constraints_insufficient | target_met | null
  plan_state: ready | fallback_offered | no_plan | plan_stale | plan_unavailable | plan_replaced | content_gap
  primary_action_id: string | null
  actions:
    - action_id: string
      capability_id: string
      intent: CONTINUE | REVIEW_DUE | RETEST | REMEDIATE | COLLECT_EVIDENCE | GOAL_COVERAGE | FALLBACK
      reason_code: resume_active_session | due_review | eligible_retest | admitted_error | evidence_gap | target_coverage_gap | deterministic_fallback
      diagnosis_cause: english_foundation | ielts_technique | integrated_performance | mixed | evidence_needed | null
      source_evidence_refs: [string]
      verification_rule_ref: string | null
      estimated_minutes: integer
  generated_at: timestamp
  expires_at: timestamp

study_session:
  session_id: string
  action_id: string
  state: started | paused | completed | abandoned
  version: integer
```

The API may expose the primary action and at most one lighter alternative on the primary learner surface. Internal candidate lists remain server-side/diagnostic unless a dedicated advanced view is later justified.

## Canonical API

The only HTTP authority is `artifacts/engineering/api/openapi.yaml`; typed payloads are owned by `artifacts/engineering/api/schema-contract.yaml`.

| operationId | Method/path | Rule |
|---|---|---|
| `getTodayPlan` | `GET /v1/today` | return current deterministic snapshot or truthful fallback/no-plan/content-gap state |
| `recordTodayCheckIn` | `POST /v1/today/check-in` | idempotently capture time/energy and recompute derived plan without mutating target/evidence truth |
| `startStudySession` | `POST /v1/study/sessions` | selected action must belong to a valid current snapshot |
| `updateStudySession` | `PATCH /v1/study/sessions/{sessionId}` | versioned/idempotent pause/resume/complete/abandon transition |

Retired split OpenAPI files are not implementation inputs and must not reappear as authorities.

## Failure/recovery

| Condition | Behavior |
|---|---|
| no target/placement prerequisite | `no_plan`; route to the missing prerequisite rather than fabricate a recommendation |
| stale evidence/plan version | `plan_stale`; recompute from canonical source state |
| planner dependency degraded | `plan_unavailable` or `fallback_offered`; fallback remains deterministic |
| insufficient evidence for claimed weakness | remove `REMEDIATE`; prefer `COLLECT_EVIDENCE` or another eligible action |
| retest exposure/novelty ineligible | do not count a retest candidate; preserve error/review state |
| quota prevents paid evaluation | preserve free review/fix/eligible deterministic alternatives |
| selected cause has no eligible teaching/practice + verification coverage | `content_gap`; do not route to unrelated content |
| target constraints are currently insufficient | surface one constraint decision; do not pretend ordinary daily completion is enough |
| duplicate session mutation | return prior semantic effect; do not duplicate completion/events |

## Cost/privacy

- `max_llm_calls: 0` for P0 routing.
- Query compact evidence/projection state; never send full learner history to a model.
- Planner telemetry uses opaque refs/reason codes and no raw essay/answer/private note content.
- Cache is optional optimization only; cache failure cannot change plan semantics.
- Reducing learner choice overload is also a cost control: do not generate multiple model-authored alternative plans when one deterministic path is sufficient.

## Acceptance boundary

Before P0-03 becomes implementation-eligible/ready as applicable:

- [ ] same versioned inputs produce the same candidate eligibility/ranking result;
- [ ] missing evidence never produces a weakness label;
- [ ] supported diagnosis causes route to a materially appropriate intervention family;
- [ ] every returned action carries one valid closed intent/reason-code pair;
- [ ] primary learner surface exposes one action + one reason + one verification statement + at most one lighter alternative;
- [ ] planner never requires browsing the feature catalog to know what to do next;
- [ ] due review cannot consume the entire study plan under the configured coverage/load policy;
- [ ] repeated/revealed content cannot qualify as novel retest/transfer evidence;
- [ ] completing a session cannot directly change IELTS readiness/mastery;
- [ ] low-time/low-energy check-in reduces burden without changing scoring/evidence semantics;
- [ ] `current_constraints_insufficient` never appears as a band-failure certainty and never produces an impossible-looking normal plan;
- [ ] advanced/beyond-target content is excluded unless one explicit no-over-band exception applies;
- [ ] missing curriculum/retest coverage returns `content_gap` rather than harder/unrelated content;
- [ ] no eligible action returns an honest fallback/no-plan state;
- [ ] P0 planner performs zero LLM calls;
- [ ] canonical API operation/schema validation passes;
- [ ] daily-action acceptance run exists and is bound to the exact candidate.

## References

- `blueprint/03-features.md` — P0-03 capability identity.
- `blueprint/05-content.md` — content eligibility/curriculum sufficiency.
- `blueprint/06-engines.md` — recommendation/evidence boundary.
- `artifacts/engineering/contracts/placement-diagnosis-contract.md` — feasibility/cause semantics.
- `artifacts/engineering/api/openapi.yaml` + `schema-contract.yaml` — HTTP/payload authority.
- `artifacts/operations/problem-risk-registry.yaml` — applicable risk coverage/blockers.
- `artifacts/experience/specs/vertical-slices/daily-action.md` — learner interaction summary.
