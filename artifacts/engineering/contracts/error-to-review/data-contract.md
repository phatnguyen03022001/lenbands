# Error-to-Review Data Contract

Canonical metadata is in `data-contract.meta.yaml`.

This contract owns P0-05 learner remediation entities. It does not copy scorer truth, framework truth or raw essay content into review state.

## 1. LearningError

```yaml
LearningError:
  error_id: string
  user_id: string
  source_finding_id: string
  source_evaluation_id: string
  error_pattern: string                    # framework ID; unknown is explicit
  criterion: task_response | coherence_cohesion | lexical_resource | grammar
  evidence_refs: [string]
  status: open | in_review | improved | dismissed
  remediation_unit_ref: string | null
  retest_family_ref: string | null
  reviewability_state: reviewable | not_reviewable | unknown
  reviewability_policy_version: string
  resolve_policy_version: string
  created_at: timestamp
  updated_at: timestamp
```

Rules:

- creation requires learner confirmation of an actionable source finding;
- evidence refs resolve to protected learner-owned evidence but are not copied into events/analytics;
- no required raw confidence field exists on the learner error;
- unknown taxonomy mapping cannot be replaced with an invented ID;
- `improved` is derived by resolution policy, never manually authored.

## 2. ReviewCard

A ReviewCard exists only for a stable, bounded, meaningfully retrievable review unit.

```yaml
ReviewCard:
  card_id: string
  user_id: string
  source_error_id: string
  content_ref: string
  content_type: grammar | vocabulary | collocation | pattern | error_concept | pronunciation_target
  review_unit_kind: string
  due_at: timestamp
  stability: number
  difficulty: number
  reps: integer
  lapses: integer
  state: new | learning | review | relearning
  last_rating: again | hard | good | easy | null
  last_review_at: timestamp | null
  algorithm_version: string
  version: integer
  created_at: timestamp
```

Do not use `content_type=error` as a catch-all for complex Writing constructs without a bounded retrievable unit.

FSRS state is scheduling/memory state, not Writing mastery/readiness.

## 3. RetestAttempt

```yaml
RetestAttempt:
  retest_id: string
  user_id: string
  source_error_id: string
  retest_family_ref: string
  task_ref: string
  task_version: string
  exposure_policy_version: string
  novelty_state: eligible | familiar | invalid | unknown
  operation_id: string | null
  evaluation_id: string | null
  result_validity: accepted | limited_evidence | insufficient_evidence | invalid | integrity_review | null
  evidence_state: pending | passed | failed | insufficient_evidence | invalid
  created_at: timestamp
  completed_at: timestamp | null
```

Raw retest text remains in protected Writing draft/submission storage. This entity stores references/provenance only.

## 4. Error Graph projection

`Error Graph` is a read projection, never a second SSOT.

| Projection node | Canonical source | Important edge |
|---|---|---|
| learner error | `LearningError` | source finding/evaluation + pattern/criterion |
| optional review | `ReviewCard` | bounded remediation unit for error |
| retest | `RetestAttempt` | verifies target error on eligible content |
| taxonomy | framework error node | classifies/remediates when resolvable |

No projection contains copied private evidence text.

## 5. Reviewability policy

```yaml
ReviewabilityDecision:
  error_id: string
  state: reviewable | not_reviewable | unknown
  review_unit_ref: string | null
  rationale_code: string
  policy_version: string
```

Typical `reviewable` units:

- vocabulary/collocation;
- grammar form/rule;
- punctuation/error concept;
- bounded sentence pattern.

Typical `not_reviewable_as_fsrs_mastery` findings:

- Task Response;
- Coherence & Cohesion;
- overall Writing quality;
- broad idea development without a stable retrieval unit.

These may still receive drills/rewrite/retest without a ReviewCard.

## 6. Resolution policy

Resolution is versioned per error/remediation family.

```yaml
ResolutionDecision:
  error_id: string
  policy_version: string
  admitted_retest_refs: [string]
  independent_evidence_count: integer
  recurrence_state: reduced | recurring | unknown
  decision: improved | remain_active | insufficient_evidence
```

Rules:

- only novelty/exposure-eligible evidence counts as configured independent evidence;
- result validity must be admitted by the owning evidence policy;
- review-card state may support memory evidence but is not universally required;
- no global fixed `90% accuracy`, `three submissions` or `card_state=review` rule becomes canonical without calibrated family-specific evidence;
- missing evidence is not negative evidence.

## 7. Invariants

1. `LearningError` requires source finding/evaluation and learner ownership.
2. ReviewCard creation requires `reviewability_state=reviewable` and a non-null bounded `content_ref`.
3. One active card per `(source_error_id, content_ref, algorithm/policy identity)` unless an explicit migration says otherwise.
4. `novelty_state!=eligible` cannot prove independent transfer/improvement.
5. Retest/evaluation failure preserves the error/remediation state.
6. Duplicate mutations converge through canonical idempotency semantics.
7. Raw learner content never appears in general telemetry/event payloads.
8. Algorithm/policy versions are audit references.

## 8. Versioning / migration

Legacy fields require explicit migration rather than silent reinterpretation:

- `confidence` on LearningError → remove from learner error; keep restricted scorer/audit uncertainty where needed;
- inline copied `resolve_when` numeric thresholds → replace with `resolve_policy_version`;
- generic `content_type=error` ReviewCard → migrate to a bounded review unit or no-card state;
- `RetestAttempt.submitted_text` → protected Writing content reference;
- `result_band/improved` scalar shortcut → evaluation ref + result validity + resolution decision.

## 9. Canonical API gap

Canonical web API currently needs reviewed operations for learner-confirmed error, fix evidence and retest lifecycle before P0-05 is implementation-ready. This data contract does not authorize scoped legacy endpoints as substitutes.

## Cross-references

- `blueprint/05-content.md` — exposure/content boundary.
- `blueprint/06-engines.md` — FSRS/evaluation/evidence boundary.
- `blueprint/framework/error-taxonomy.md` and `review-mapping.md`.
- Writing data/evaluation contracts for source evaluation and retest scoring.