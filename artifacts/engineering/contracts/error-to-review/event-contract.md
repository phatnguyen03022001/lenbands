# Error-to-Review Event Contract

Canonical metadata is in `event-contract.meta.yaml`.

Canonical events for P0-05. Every event uses the Blueprint envelope (trace_id, hashed user_id, occurred_at, schema_version). **Do not emit error evidence text** in events — emit id/pattern/status only.

## Events

### `learning_error_saved`
- Producer: Review service after the learner confirms a `FeedbackFinding`; evaluation does not create a learner-owned error automatically.
- Consumer: Review engine (creates ReviewCard), Analytics.
- Payload: `{error_id, source_finding_id, source_evaluation_id, error_pattern, criterion, severity, microskill_ref}`; user identity comes only from the hashed envelope.
- Quality rule: confidence below the founder-approved threshold → flag `low_confidence: true`, do not auto-save; wait for learner confirmation. No active numeric threshold exists.

### `review_card_created`
- Producer: Review engine (after the learner saves an error or adds vocabulary).
- Consumer: Analytics.
- Payload: `{card_id, content_type, source_error_id, fsrs_card_kind, micro_skill_ref, due, algorithm_version}`; user identity comes only from the hashed envelope.
- Quality rule: `source_error_id` is required when content_type=error.

### `review_card_rated`
- Producer: Review engine (learner rate Again/Hard/Good/Easy).
- Consumer: FSRS engine (update stability/difficulty/due), Analytics.
- Payload: `{card_id, rating, prev_state, new_state, new_due, stability, difficulty, reps, lapses}`
- Quality rule: rating must belong to the four-value enum.

### `review_completed`
- Producer: Review engine after the rating is persisted with the FSRS transition.
- Consumer: Analytics, retention/outcome measurement.
- Payload: `{card_id, rating, review_outcome}`.
- Quality rule: emit only after durable write; the consumer must deduplicate retries with the same `event_id`.

### `review_card_graduated`
- Producer: FSRS engine (card transitions learning→review for the first time).
- Consumer: Review engine (update resolve_when.review_card_state), Analytics.
- Payload: `{card_id, algorithm_version}`
- Quality rule: emit only once per card.

### `retest_started`
- Producer: Review engine (learner opens retest).
- Consumer: Analytics.
- Payload: `{retest_id, source_error_id, prompt_ref}`

### `retest_completed`
- Producer: Review engine (after EVAL.Writing scores retest).
- Consumer: Review engine (check resolve_when → update error status), Analytics.
- Payload: `{retest_id, source_error_id, evaluation_ref, result_band, result_error_recurring, improved}`
- Quality rule: `improved` is true only when resolve_when passes (no_recurrence + retest_accuracy + card_state).

### `learning_error_resolved`
- Producer: Review engine (when error status changes: open→improved).
- Consumer: BAND.Map (update ✓), Analytics, Personalization.
- Payload: `{error_id, error_pattern, microskill_ref, resolved_via}`
- Quality rule: emit only when resolve_when is satisfied.

## Anti-pattern (forbidden)

- Emit error evidence text (original incorrect sentence) → privacy violation.
- Emit `review_card_created` without a source → anti-orphan violation.
- Emit `learning_error_resolved` without retest → resolve_when violation.
- Emit 2 `review_card_graduated` events for 1 card → once-per-card violation.

## Versioning

- Add event: minor bump schema_version.
- Change payload field: major bump + migration.
- Do not delete an event — mark deprecated + retain consumer compatibility.
