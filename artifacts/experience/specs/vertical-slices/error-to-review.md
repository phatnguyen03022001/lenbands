# Vertical Slice — Error to Review

`P0-05` connects an evidence-backed error from Writing Evaluation to a fix drill, FSRS review, and retest. This slice does not create a review card without sufficiently reliable evidence.

## Scope and permission

- Actor: an authenticated, consented learner; acts only on their own error/evaluation.
- System services: evaluation, review, and FSRS write state using the idempotency key.
- Governance: reads aggregate quality; does not read raw essay text in events/logs by default.

## Entry / exit

- Entry: `evaluation_scored` with `quality_status=accepted|low_confidence`, and an error with `error_id`, `evidence_ref`, criterion, and confidence.
- Exit success: the learner completes one fix, the review card is rated, and the retest creates outcome `retest_completed` with `improved=true|false` according to the framework rule.
- Exit safe: the learner retains the evaluation/draft when the queue, quota, or retest dependency is unavailable.

## State machine

```text
open
  ├─ no_evidence → dismissed (no card created)
  ├─ learner_saved → fix_available
  ├─ learner_declined → dismissed
fix_available → fixing → review_due → reviewing → retest_available
retest_available → retesting → improved | recurring
```

Transitions must have `error_id`, `source_evaluation_id`, actor/source, and timestamp. Retrying the same mutation must not create a second error/card/rating.

## Behavior and contracts

| Step | API/data | Event | Failure behavior |
|---|---|---|---|
| Save error | Error-to-Review data contract | `learning_error_saved` | confidence below rule → learner confirms; no auto-card |
| Fix drill | `POST /v1/writing/errors/{errorId}/fixes` | `learning_error_fix_completed` | retain progress, retry with the same idempotency key |
| Queue/card | ReviewCard + FSRS contract | `review_card_created`, `review_completed` | no evidence → no card; queue failure → retain state |
| Retest | `POST /v1/writing/errors/{errorId}/retest` | `retest_started`, `retest_completed` | quota unavailable → do not call costly eval, retain card |

`quality_status` uses the canonical enum `accepted | low_confidence | insufficient_evidence | invalid`; `needs_review` is a UI intent only, not a persisted quality value.

## Cost and privacy

- FSRS/rating is deterministic; it does not call a model.
- Retest uses quota reservation before the provider call; quota service down → retain draft/card and allow free review.
- Events contain only opaque refs, error pattern id, and outcome; they do not contain essay/error evidence text.

## Missing acceptance evidence

- Real review-scheduling and retest-outcome run.
- No-evidence/no-card test.
- Duplicate delivery/idempotency test.

The slice remains in `review`; it is not build-ready until the runs above have evidence.

## References

- `blueprint/03-features.md` P0-05 and Event Contract.
- `artifacts/engineering/contracts/error-to-review/data-contract.md`.
- `artifacts/engineering/contracts/error-to-review/event-contract.md`.
- `artifacts/engineering/contracts/error-to-review/failure-contract.md`.
