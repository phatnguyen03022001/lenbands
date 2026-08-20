# Daily Action Contract

Canonical metadata is in the sibling `daily-action-contract.meta.yaml`.

P0-03 chooses one useful next action from current learner evidence without an LLM. The plan is derived state; it never becomes a source of truth for goal, evaluation, review or readiness.

## Inputs and ownership

The deterministic planner reads only bounded, versioned inputs:

```yaml
target_profile_ref: string
learner_evidence_state_ref: string
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

Changing this vocabulary is an API/analytics contract change, not a copy tweak. Learner-facing prose is rendered from these codes and may be localized without changing routing semantics.

A candidate that fails authorization, content rights/status, exposure/novelty, quota/cost, required evidence, or session-state constraints is removed before ranking.

## Deterministic ranking

P0 uses a versioned deterministic policy. It does not ask an LLM to inspect learner history and choose an action.

Ranking considers, in controlled order:

1. recoverable active work and learner continuity;
2. due review/retest obligations whose evidence remains valid;
3. expected learning value from admitted evidence;
4. evidence uncertainty/information value for under-observed target-relevant constructs;
5. target relevance and coverage balance;
6. transfer/maintenance need;
7. exposure novelty and anti-contamination constraints;
8. available time/energy and recent cognitive load;
9. stable deterministic tie-break.

Exact numeric weights/windows are versioned policy only after pilot evidence. Until then, implementation uses explicit ordered rules/constraints rather than invented coefficients.

### Anti-tunnel-vision invariant

Recent plan history must prevent one observed error or content type from monopolizing all target-relevant study. A supported weakness may outrank neutral practice, but it cannot suppress required evidence collection, overdue review, eligible transfer/retest, or neglected target coverage indefinitely.

## Data contract

```yaml
daily_plan_snapshot:
  plan_id: string
  plan_version: string
  evidence_state_version: string
  target_profile_version: integer
  plan_state: ready | fallback_offered | no_plan | plan_stale | plan_unavailable | plan_replaced
  actions:
    - action_id: string
      capability_id: string
      intent: CONTINUE | REVIEW_DUE | RETEST | REMEDIATE | COLLECT_EVIDENCE | GOAL_COVERAGE | FALLBACK
      reason_code: resume_active_session | due_review | eligible_retest | admitted_error | evidence_gap | target_coverage_gap | deterministic_fallback
      source_evidence_refs: [string]
      estimated_minutes: integer
  generated_at: timestamp
  expires_at: timestamp

study_session:
  session_id: string
  action_id: string
  state: started | paused | completed | abandoned
  version: integer
```

The API may return up to three reasoned alternatives, but the primary learner surface shows one next action.

## Canonical API

The only HTTP authority is `artifacts/engineering/api/openapi.yaml`; typed payloads are owned by `artifacts/engineering/api/schema-contract.yaml`.

| operationId | Method/path | Rule |
|---|---|---|
| `getTodayPlan` | `GET /v1/today` | return current deterministic snapshot or truthful fallback/no-plan state |
| `recordTodayCheckIn` | `POST /v1/today/check-in` | idempotently capture time/energy and recompute derived plan without mutating target/evidence truth |
| `startStudySession` | `POST /v1/study/sessions` | selected action must belong to a valid current snapshot |
| `updateStudySession` | `PATCH /v1/study/sessions/{sessionId}` | versioned/idempotent pause/resume/complete/abandon transition |

Retired split OpenAPI files are not implementation inputs and must not reappear as authorities.

## Failure/recovery

| Condition | Behavior |
|---|---|
| no target/placement prerequisite | `no_plan`; route to the missing prerequisite rather than fabricate a recommendation |
| stale evidence/plan version | `plan_stale`; recompute from canonical source state |
| planner/cache/dependency degraded | `plan_unavailable` or `fallback_offered`; fallback remains deterministic |
| insufficient evidence for claimed weakness | remove `REMEDIATE`; prefer `COLLECT_EVIDENCE` or another eligible action |
| retest exposure/novelty ineligible | do not count a retest candidate; preserve error/review state |
| quota prevents paid evaluation | preserve free review/fix/eligible deterministic alternatives |
| duplicate session mutation | return prior semantic effect; do not duplicate completion/events |

## Cost/privacy

- `max_llm_calls: 0` for P0 routing.
- Query compact evidence/projection state; never send full learner history to a model.
- Planner telemetry uses opaque refs/reason codes and no raw essay/answer/private note content.
- Cache is optional optimization only; cache failure cannot change plan semantics.

## Acceptance boundary

Before P0-03 becomes implementation-eligible/ready as applicable:

- [ ] same versioned inputs produce the same candidate eligibility/ranking result;
- [ ] missing evidence never produces a weakness label;
- [ ] every returned action carries one valid closed intent/reason-code pair;
- [ ] due review cannot consume the entire study plan under the configured coverage/load policy;
- [ ] repeated/revealed content cannot qualify as novel retest/transfer evidence;
- [ ] completing a session cannot directly change IELTS readiness/mastery;
- [ ] low-time/low-energy check-in reduces burden without changing scoring/evidence semantics;
- [ ] no eligible action returns an honest fallback/no-plan state;
- [ ] P0 planner performs zero LLM calls;
- [ ] canonical API operation/schema validation passes;
- [ ] daily-action acceptance run exists and is bound to the exact candidate.

## References

- `blueprint/03-features.md` — P0-03 capability identity.
- `blueprint/06-engines.md` — recommendation/evidence boundary.
- `artifacts/engineering/api/openapi.yaml` + `schema-contract.yaml` — HTTP/payload authority.
- `artifacts/operations/problem-risk-registry.yaml` — applicable risk coverage/blockers.
- `artifacts/experience/specs/vertical-slices/daily-action.md` — learner interaction summary.
