# Event Schema Pack

Canonical metadata is in `event-schema-pack.meta.yaml`.

This registry defines canonical event payload boundaries. Events are immutable facts and compact projections of already-governed domain state; they do not become a second source of truth for TargetProfile, scores, feasibility, diagnosis, readiness or content.

## Envelope

```yaml
event:
  event_type: string
  event_version: semver
  event_id: uuid
  trace_id: string
  occurred_at: timestamp
  user_id_hash: string | null
  session_id: string | null
  schema_version: semver
  source: service | offline_sync | backfill
  entity_refs: map
  properties: map
  privacy_class: account | learning | assessment | audio | billing | system | derived
  schema_hash: string
```

General event payloads contain no raw essay/audio/transcript/private-note/answer/provider payload, credential or hidden reasoning.

## P0 canonical events

### Identity / placement / target

- `account_created` — `{account_ref, acquisition_source_code}`
- `consent_recorded` — `{consent_ref, policy_version, decision}`
- `privacy_export_requested` — `{request_ref, scope_code}`
- `privacy_deletion_requested` — `{request_ref, scope_code}`
- `goal_set` — `{goal_ref, target_profile_ref, goal_version}`
- `placement_started` — `{attempt_ref, configuration_ref, configuration_version}`
- `placement_completed` — `{attempt_ref, result_ref, result_validity, termination_reason, diagnosis_cause_classes, target_feasibility_state, evidence_coverage_ref}`

Rules:

- `goal_set` does not duplicate scalar target-band truth into analytics.
- `placement_completed` contains no raw confidence/probability and no raw responses.
- diagnosis cause/feasibility values are server-derived governed state; event existence does not imply a successful numeric estimate.

### Study orchestration

- `daily_plan_generated` — `{plan_ref, plan_version, plan_state, target_feasibility_state, primary_intent, reason_code, verification_rule_ref, estimated_minutes}`
- `session_started` — `{session_ref, action_ref, intent, planned_minutes}`
- `session_paused` — `{session_ref, reason_code}`
- `session_resumed` — `{session_ref}`
- `session_abandoned` — `{session_ref, reason_code}`
- `session_completed` — `{session_ref, action_ref, duration_seconds, evidence_produced}`
- `first_meaningful_session_completed` — `{session_ref, outcome_ref}`
- `next_best_action_shown` — `{action_ref, intent, reason_code, verification_rule_ref}`
- `next_best_action_taken` — `{action_ref, intent}`

Rules:

- plan/action events do not emit an internal candidate list;
- one action event does not prove mastery/readiness;
- `target_feasibility_state` is planning state, never official-band probability;
- `reason_code` is controlled routing semantics, not free learner text.

### Writing loop

- `writing_task_opened` — `{task_ref, task_version, task_type}`
- `writing_draft_saved` — `{draft_ref, draft_version, word_count}`
- `writing_submission_started` — `{submission_ref, task_ref, task_version}`
- `writing_submission_accepted` — `{submission_ref, operation_ref}`
- `evaluation_submitted` — `{operation_ref, submission_ref, scorer_route_version}`
- `evaluation_scored` — `{evaluation_ref, submission_ref, score_label, score_scope, result_validity, rubric_version, scorer_route_version, usage_ref}`
- `evaluation_failed` — `{operation_ref, failure_code, retryable}`
- `evaluation_delayed` — `{operation_ref, retry_after_seconds}`
- `writing_feedback_viewed` — `{evaluation_ref, criterion_code}`
- `learning_error_saved` — see error-to-review event owner
- `learning_error_fix_started` — `{error_ref}`
- `learning_error_fix_completed` — `{error_ref, fix_evidence_ref}`
- `practice_started` — `{action_ref, source_ref, intent}`
- `retest_completed` — see error-to-review event owner

Rules:

- `evaluation_scored` does not emit raw model confidence, `quality_status`, raw essay or provider response;
- result validity is explicit and separate from operation state;
- numeric score detail remains in the governed result resource rather than general analytics unless a separately approved aggregate purpose requires it.

### Review

- `review_queue_opened` — `{due_count}`
- `review_card_created` — see error-to-review event owner
- `review_card_rated` — see error-to-review event owner
- `review_completed` — `{card_ref, rating, review_outcome}`
- `retest_started` — `{retest_ref, source_error_ref, task_ref, exposure_policy_version}`
- `review_card_graduated` — see error-to-review event owner
- `learning_error_resolved` — see error-to-review event owner

A review event never means IELTS mastery. `retest_completed` must retain novelty/result-validity semantics in its owning contract before it can support verified improvement.

### Quota / subscription

- `quota_warning_shown` — `{action_type, remaining, window_code}`
- `quota_exceeded` — `{action_type, entitlement_code, window_code}`
- `upgrade_cta_shown` — `{trigger_code}` (P1)
- `upgrade_completed` — `{prior_entitlement_code, new_entitlement_code}` (P1)

### Governance internal

- `benchmark_run_completed` — `{benchmark_run_ref, scorer_route_version, required_slice_status, promotion_decision}`
- `drift_threshold_exceeded` — `{metric_code, observed_value, threshold_ref}`
- `anti_gaming_flagged` — `{evaluation_ref, flag_type, risk_disposition}`

Rules:

- aggregate MAE alone is not a scorer promotion event contract;
- benchmark event points to the governed run/slices rather than reproducing corpus labels;
- anti-gaming events carry risk disposition, never a cheating verdict from one detector score.

## Quality rules

- Every event has a unique `event_id`; consumers deduplicate retries.
- Event types use `snake_case`; semantic changes bump `event_version`.
- `entity_refs` use opaque references only.
- `properties` contains controlled derived fields required by declared consumers.
- Learner-created raw content is prohibited in general event payloads.
- UI clicks alone do not count as learning outcomes.
- `source=backfill` records the backfill/reason boundary and cannot unintentionally trigger learner notifications/recommendations.
- Deletion/anonymization follows the retention registry.
- Consumers tolerate additive unknown fields but do not reinterpret existing fields.
- New event fields require a declared consumer/decision; analytics curiosity alone is not enough for sensitive data.

## Outcome interpretation

```text
session_completed       != mastery
evaluation_scored       != accepted evidence unless result_validity permits it
review_completed         != transfer
retest_completed         != improvement unless novelty + result validity + owning resolve policy pass
placement_completed      != precise band when evidence is insufficient
daily_plan_generated     != guaranteed target attainment
```

## Consumers

- analytics/outcome measurement: governed aggregates and funnels;
- personalization: only admitted compact facts needed by deterministic planning;
- governance: benchmark/drift/integrity/cost controls;
- notification: explicit subscribed facts only, never wildcard learner-content access.

Do not subscribe domain consumers to wildcard events when a narrower contract is possible.

## P0 vs later

P0 registers only facts needed to operate/measure the closed Writing outcome loop. Speaking/Mock/Search and broader product events are added when their capabilities activate and their privacy/decision consumers are defined.

## Canonical references

- Blueprint event identity: `blueprint/03-features.md`.
- Writing events: `artifacts/engineering/contracts/writing-task-2/event-contract.md`.
- Error-to-review events: `artifacts/engineering/contracts/error-to-review/event-contract.md`.
- API payload/domain semantics: `artifacts/engineering/api/schema-contract.yaml`.
- Privacy deny list: `artifacts/operations/data-retention-registry.yaml`.
