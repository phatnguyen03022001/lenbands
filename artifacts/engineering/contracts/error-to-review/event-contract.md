# Error-to-Review Event Contract

Canonical metadata is in `event-contract.meta.yaml`.

P0-05 events use the canonical Blueprint event envelope. Payloads contain opaque references and controlled IDs only; never raw essay/error evidence text.

## `learning_error_saved`

Producer: review/remediation service after learner confirmation.

Payload:

```yaml
error_id:
source_finding_id:
source_evaluation_id:
error_pattern:
criterion:
reviewability_state: reviewable | not_reviewable | unknown
```

Rules:

- evaluator does not auto-create learner-owned errors;
- no raw confidence/probability is required in the event;
- save requires the source result/finding to be admissible for remediation under current policy.

## `review_card_created`

Emit **only** when a bounded retrievable review unit exists.

```yaml
card_id:
source_error_id:
content_ref:
content_type:
review_unit_kind:
due_at:
algorithm_version:
```

No-card is a valid path and emits no fake `review_card_created` event.

## `review_card_rated`

```yaml
card_id:
rating: again | hard | good | easy
prev_state:
new_state:
new_due:
algorithm_version:
```

Emit after durable idempotent transition.

## `review_completed`

```yaml
card_id:
rating:
review_outcome:
```

This is a review-completion fact, not mastery/verified-improvement evidence by itself.

## `review_card_graduated`

Optional supporting event for the first transition into stable review state.

```yaml
card_id:
algorithm_version:
```

It must not trigger `LearningError=improved` without the resolution policy/evidence gate.

## `retest_started`

```yaml
retest_id:
source_error_id:
task_ref:
task_version:
exposure_policy_version:
novelty_state:
```

`novelty_state` must be determined from exposure policy/runtime facts rather than LLM opinion.

## `retest_completed`

```yaml
retest_id:
source_error_id:
evaluation_ref:
result_validity:
novelty_state:
evidence_state: passed | failed | insufficient_evidence | invalid
```

Do not put `result_band` or a simple `improved` boolean in this event as the sole resolution truth. The resolution policy consumes the retest/evaluation evidence and derives error state separately.

## `learning_error_resolved`

Emit only after the versioned resolution policy changes the learner error to `improved`.

```yaml
error_id:
error_pattern:
resolution_policy_version:
retest_refs: []
independent_evidence_count:
resolved_via:
```

This event may feed outcome measurement/personalization. It is not emitted from card graduation alone.

## Privacy / idempotency

- raw essay/sentence/fix/retest text is forbidden;
- hashed learner identity belongs only in the canonical envelope;
- duplicate producer delivery must converge on stable entity/event identity;
- backfilled events must not trigger unintended learner notifications/recommendations.

## Forbidden patterns

- `learning_error_saved` directly from model output without learner confirmation;
- `review_card_created` for a non-reviewable complex Writing criterion;
- `learning_error_resolved` from FSRS state alone;
- familiar/revealed retest emitted as independent transfer proof;
- raw model confidence used as event-level truth;
- evidence text in analytics payload.

## Verified improvement metric

Until a dedicated canonical `verified_improvement_recorded` event is registered by the Blueprint event owner, compute pilot verified improvement from:

```text
learning_error_saved
  + eligible retest_completed
  + admitted result/evidence
  + learning_error_resolved
```

Do not invent a new event name locally.

## Versioning

Semantic payload changes require the normal event-version migration policy. Deprecated events/fields remain compatible until consumers migrate; do not silently reinterpret old `improved`/confidence fields.