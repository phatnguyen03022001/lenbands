# Event Schema Pack (canonical events)

Canonical metadata is in `event-schema-pack.meta.yaml`.

Registry schema for canonical events (Blueprint § Event Contract). Slice-specific events (Writing, Error-to-Review) may extend payload/producer only; do not rename outcome events.

## Envelope (applies to every event)

```yaml
event:
  event_type: string             # canonical past-tense fact
  event_version: string          # event semantics version (semver)
  event_id: string               # uuid, idempotent
  trace_id: string               # cross-service trace
  occurred_at: timestamp
  user_id_hash: string           # hashed, not raw user_id (privacy)
  session_id: string | null
  schema_version: string         # envelope schema version
  source: service | offline_sync | backfill
  entity_refs: map               # opaque ids only
  properties: map                # typed, no raw learner content
  privacy_class: account | learning | assessment | audio | billing | system | derived
  schema_hash: string
```

The envelope contains no learner content (essay/audio/error text). Payload is determined by `event_type`.

## P0 canonical events

### Identity / placement
- `account_created` — `{plan, acquisition_source}`
- `consent_recorded` — `{consent_version, purpose}`
- `placement_started` — `{section, attempt}`
- `placement_completed` — `{estimated_band, confidence, sections_scored}`
- `goal_set` — `{target_band, target_date, daily_minutes}`
- `privacy_export_requested` — `{request_id, scope}`
- `privacy_deletion_requested` — `{request_id, scope}`

### Study orchestration
- `daily_plan_generated` — `{date, items_count, estimated_minutes}`
- `session_started` — `{intent, planned_minutes}`
- `session_paused` — `{session_id, reason}`
- `session_resumed` — `{session_id}`
- `session_abandoned` — `{session_id, reason}`
- `session_completed` — `{duration_seconds, items_done}`
- `first_meaningful_session_completed` — `{session_id, outcome_ref}`
- `next_best_action_shown` — `{action_type, reason}`
- `next_best_action_taken` — `{action_type}`

### Writing loop
- `writing_task_opened` — `{task_id, task_type}`
- `writing_draft_saved` — `{draft_id, version, word_count}` (no text)
- `writing_submission_started` — `{submission_id, task_id}`
- `writing_submission_accepted` — `{submission_id}`
- `evaluation_submitted` — `{evaluation_id, submission_id, evaluation_kind}`
- `evaluation_scored` — `{evaluation_id, overall_band, overall_confidence, quality_status, usage}`
- `evaluation_failed` — `{evaluation_id, failure_class}`
- `evaluation_delayed` — `{evaluation_id, expected_delay_seconds}`
- `writing_feedback_viewed` — `{evaluation_id, criterion_viewed_first}`
- `learning_error_saved` — (xem error-to-review/event-contract.md)
- `learning_error_fix_started` — `{error_id}`
- `learning_error_fix_completed` — `{error_id, fix_evidence_ref}`
- `practice_started` — `{action_type, source_ref}`
- `retest_completed` — (xem error-to-review/event-contract.md)

### Review
- `review_queue_opened` — `{due_count}`
- `review_card_created` — (error-to-review/event-contract)
- `review_card_rated` — (error-to-review/event-contract)
- `review_completed` — `{card_id, rating, review_outcome}`
- `retest_started` — `{retest_id, source_error_id, prompt_ref}` (xem error-to-review/event-contract.md)
- `review_card_graduated` — (error-to-review/event-contract)
- `learning_error_resolved` — (error-to-review/event-contract)

### Quota / paywall
- `quota_warning_shown` — `{action_type, remaining, window}`
- `quota_exceeded` — `{action_type, plan, window}`
- `upgrade_cta_shown` — `{trigger}` (P1, Subscription/access service)
- `upgrade_completed` — `{plan_from, plan_to}` (P1, Subscription/access service)

### Governance (internal, not a learner event)
- `benchmark_run_completed` — `{corpus_id, mae, route_id}`
- `drift_threshold_exceeded` — `{metric, value, threshold}`
- `anti_gaming_flagged` — `{evaluation_id, flag_type, score}`

## Quality rules

- Every event has a unique `event_id` (idempotent consumer).
- `user_id_hash` replaces raw user_id — analytics cannot re-identify it unless joined to the auth DB (gated).
- Learner content (essay, audio, error evidence) is NOT in the payload.
- `reason`/`scope` for session/privacy events contains only controlled short codes, never learner text; the controlled value set lacks a Framework node (open gap; do not invent names).
- Bump `event_version` minor when adding a field, major when breaking; the event type must exist in the Blueprint or extension registry.
- Consumers must handle unknown fields (forward compatibility).

## Forbidden events

- Event contains raw essay/audio/error text.
- Event emitted from UI without a service (SPAs emit through the backend, not directly to analytics).
- Duplicate events (same event_id on retry) — consumer dedupes.

## Registry / consumer

- Analytics consumer: aggregate (DAU, retention, funnel).
- Personalization consumer: recommendation (reads `session_completed`, `learning_error_saved`, `retest_completed`).
- Governance consumer: benchmark/drift/anti-gaming.

Each consumer declares event subscriptions; do not subscribe to wildcards (except analytics aggregate).

## P0 vs later

- P0: the subset above, sufficient to measure activation/retention/outcome loop.
- P1: add Speaking, Mock Test, and Search events.
- P2: full event catalog.

## Cross-refs

- Blueprint Event Contract: `blueprint/03-features.md` § Event Contract (canonical outcome event list).
- Writing slice events: `experience/specs/vertical-slices/writing-task-2.md` §9.
- Error-to-Review events: `engineering/contracts/error-to-review/event-contract.md`.
- Analytics schema: generator projection (later).
