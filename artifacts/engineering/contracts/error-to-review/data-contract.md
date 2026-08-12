# Error-to-Review Data Contract

Canonical metadata is in `data-contract.meta.yaml`.

Runtime entities for P0-05 (Error-to-Review loop). This is runtime data, not a Knowledge Asset. P0 scope: errors created by Writing evaluation, review through FSRS, and retest with the same error pattern.

## Entity: LearningError

```yaml
error_id: string              # uuid
user_id: string
source_finding_id: string     # learner-confirmed FeedbackFinding
source_evaluation_id: string  # original EVAL.Writing/Speaking ID
error_pattern: string         # ID from error-taxonomy.md (e.g. W_gra_relative_clause)
criterion: task_response | coherence_cohesion | lexical_resource | grammar
severity: high | medium | low
evidence_ref: string          # specific sentence/paragraph in the original submission
status: open | in_review | improved | dismissed
confidence: number            # 0-1, inherited from evaluation confidence
microskill_ref: [string]      # from microskill-enum.md
resolve_when:                 # copied from the error-taxonomy.md node (inline)
  no_recurrence_in_recent_n_submissions: 3
  retest_accuracy_pct: 90
  review_card_state: review
created_at: timestamp
updated_at: timestamp
```

Owner: Review service (created after learner confirmation) / Review engine (read+update status).
Privacy class: learning (error evidence is learner-owned content and does not enter analytics events).

## Entity: ReviewCard (FSRS card)

```yaml
card_id: string               # uuid
user_id: string
content_ref: string           # = error_id (P0) or vocab/grammar ID (later)
content_type: error | vocabulary | grammar | collocation
fsrs_card_kind: string        # from review-mapping.md (recall_meaning, apply_distractor...)
due: timestamp
stability: number
difficulty: number
reps: integer
lapses: integer
state: new | learning | review | relearning
last_rating: again | hard | good | easy | null
last_review: timestamp | null
algorithm_version: string     # fsrs version (vd "5.x")
source_error_id: string       # required when content_type=error (anti-orphan)
micro_skill_ref: [string]
created_at: timestamp
```

Owner: FSRS engine (entire lifecycle).
Protection: `source_error_id` is required when content_type=error — a card without a source violates the contract (anti-orphan rule).

## Error Graph projection

`Error Graph` is a read model/projection of the entities in this contract and evaluation output; it is not a second entity and must not become a new SSOT.

| Graph node | Canonical source | Minimum edge |
|---|---|---|
| Learning error | `LearningError.error_id` + `error_pattern` | source evaluation, criterion, microskill |
| Review card | `ReviewCard.card_id` + `source_error_id` | fixes learning error; has FSRS state |
| Retest attempt | `RetestAttempt.retest_id` + `source_error_id` | verifies recurrence/improvement |
| Taxonomy node | `error_pattern` in `error-taxonomy.md` | classifies learning error; unknown → `unknown_error` |

The read model must materialize `error → review card → retest → resolved` and trace back to `source_evaluation_id`. Do not copy learner evidence text into the graph/analytics; store only private `evidence_ref` under ownership and retention policy.

## Entity: RetestAttempt

```yaml
retest_id: string
user_id: string
source_error_id: string       # error being verified
prompt_ref: string            # new content with the same error_pattern (do not reuse the source)
submitted_text: string        # writing retest (P0)
evaluation_ref: string        # EVAL.Writing re-run
result_band: number
result_error_recurring: boolean   # whether the old error recurs
improved: boolean             # true if resolve_when is satisfied
created_at: timestamp
```

Owner: Review engine (creates retest prompt) + EVAL.Writing (scores retest).
Rule: `prompt_ref` must share the source `error_pattern` but use **new content** — do not reuse the original submission.

## Invariants

1. Every ReviewCard has `source_error_id` or is a vocab/grammar card with a clear content_ref. Orphan cards are rejected.
2. Error `status: improved` applies only when `resolve_when` is satisfied (no_recurrence + retest_accuracy + card_state). Do not mark it manually.
3. RetestAttempt never uses the same `prompt_ref` as the source submission — it must use a new prompt with the same pattern.
4. FSRS `algorithm_version` must be logged — changing the version requires benchmark regression.
5. Error evidence (original incorrect-sentence text) is private; do not emit it in analytics events (emit error_id + pattern only).

## Versioning / migration

- Add field: minor bump + migration note.
- Change `resolve_when` semantics: major bump + backfill rule (do old errors use the new rule? → configure per migration).
- Do not delete a field — mark deprecated.

## Cross-refs

- Error taxonomy + review mapping: `blueprint/framework/error-taxonomy.md`, `review-mapping.md`.
- FSRS algorithm: `blueprint/06-engines.md` § FSRS Engine.
- Writing slice (source error): `experience/specs/vertical-slices/writing-task-2.md` §7.
- Event contract: `engineering/contracts/error-to-review/event-contract.md`.
