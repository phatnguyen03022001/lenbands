# Vertical Slice — Error to Review

`P0-05` turns one learner-confirmed, evidence-backed Writing finding into the smallest useful remediation and verifies whether the error decreases on eligible new evidence.

The slice is **not** "create an FSRS card for every error". FSRS is used only when the remediation unit is meaningfully retrievable.

## 1. Learner outcome

```text
confirmed finding
  -> LearningError
  -> choose smallest useful intervention
  -> optional FSRS review when retrievable
  -> sufficiently novel retest
  -> evidence admission
  -> improved | remains active | insufficient evidence
```

Completion, card maturity and success on a revealed source item are not verified improvement by themselves.

## 2. Entry boundary

Entry requires:

- learner owns the source evaluation/finding;
- source evaluation result is admitted by the owning evidence policy for remediation use;
- finding has resolvable learner evidence;
- learner confirms/selects the finding;
- required `error_pattern`/remediation mapping resolves, or the finding remains informational instead of inventing a taxonomy ID.

`limited_evidence` may still support a learning action when policy allows, but it must not silently become strong readiness evidence.

## 3. State axes

Keep independent axes rather than one giant state machine.

### LearningError

```text
open -> in_review -> improved
  \-> dismissed
```

### ReviewCard

```text
none | new -> learning -> review <-> relearning
```

`none` is valid when the intervention is not a retrievable review unit.

### Retest

```text
pending -> processing -> passed | failed | insufficient_evidence | invalid
```

### Novelty/exposure

```text
eligible | familiar | invalid | unknown
```

Only an eligible retest may count as configured independent/transfer evidence.

## 4. Intervention selection

Use deterministic/framework mappings when available:

```text
error_pattern + criterion + evidence
  -> remediation family
  -> smallest useful intervention
```

Examples:

- article/preposition/punctuation error → short explanation + independent sentence fix + optional review card;
- collocation/lexical precision → contrast/example + retrieval card where appropriate;
- weak topic sentence pattern → guided contrast + independent paragraph rewrite; card only for a bounded pattern if useful;
- Task Response/Coherence problem → structured drill/rewrite/retest, **not** a generic FSRS mastery card.

An LLM may help explain a valid finding where needed, but it does not own the error taxonomy, review eligibility or resolution rule.

## 5. FSRS suitability gate

Before creating a ReviewCard, the review service evaluates a deterministic `reviewability` rule.

```yaml
reviewability:
  state: reviewable | not_reviewable | unknown
  review_unit_ref: string | null
  rationale_code: string
  policy_version: string
```

Create a card only when `reviewable` and a stable bounded unit exists.

FSRS owns scheduling/ratings. It does not prove Writing Task Response, Coherence, overall skill mastery or exam readiness.

## 6. Retest policy

Retest must:

- target the same underlying error/construct;
- use an eligible task/prompt according to exposure policy;
- not reveal the answer/fix before learner commitment;
- preserve task/rubric/evaluation provenance;
- produce a result whose `result_validity` is separately evaluated;
- avoid claiming transfer when the prompt/item is familiar or recently revealed.

If no eligible retest content exists, keep the error active and offer another valid learning action. Do not fake progress with the source item.

## 7. Resolution rule

`LearningError.status=improved` is derived by a versioned policy, not a manual endpoint.

A P0 resolution policy may consider:

- target error absent/reduced on eligible retest evidence;
- result validity/admission;
- recurrence history where enough evidence exists;
- review result only as supporting memory evidence when a review card exists.

It must **not** require an arbitrary FSRS `review` state for errors where FSRS is not suitable.

No universal `90% accuracy + 3 submissions` constant is canonical until calibrated/approved for the specific error family.

## 8. API boundary

Canonical API currently exposes review queue/rating operations but does not yet expose every learner-error/fix/retest mutation required by this slice.

Therefore P0-05 remains `not ready` until canonical API owners add/review operations for:

- save learner-confirmed Writing error;
- save fix evidence;
- start/get retest lifecycle.

Scoped legacy endpoints in old contracts do not become canonical merely because this slice mentions them.

All mutations are idempotent and owner-scoped.

## 9. Events

Existing canonical events are used where registered:

- `learning_error_saved`;
- `review_card_created` only when a card exists;
- `review_card_rated` / `review_completed`;
- `retest_started` / `retest_completed`;
- `learning_error_resolved` only after resolution policy passes.

No event contains raw essay/error evidence text.

A future dedicated verified-improvement event requires canonical event governance before emission; until then, outcome measurement derives it from admitted retest + error state.

## 10. Cost / privacy

- FSRS/rating and novelty/exposure checks are deterministic.
- Do not call a model to decide review intervals.
- Retest eligibility/quota is checked before costly evaluation.
- Reuse governed remediation assets before generating new explanation.
- General telemetry contains opaque refs/pattern IDs/outcome classes only.
- Track cost per verified improvement, including retest evaluation cost and any generated feedback/remediation cost.

## 11. Failure behavior

| Condition | Recovery |
|---|---|
| no evidence/mapping | keep finding informational; no fake error/card |
| remediation unavailable | keep error open; offer another valid action |
| not reviewable | skip FSRS; proceed to appropriate fix/retest path |
| review save failure | idempotent retry; preserve card state |
| no eligible novel retest | keep error active; do not reuse invalid exposed task as proof |
| retest evaluation delayed | preserve retest/submission; show truthful delayed state |
| insufficient retest evidence | remain active; explain next verification action |
| quota unavailable | allow zero-cost review/fix where possible; retain progress |

## 12. Acceptance evidence

P0-05 needs executable proof for:

1. no evidence → no LearningError/card;
2. learner confirmation required;
3. retrievable grammar/pattern error can create one idempotent FSRS card;
4. complex criterion finding can skip FSRS without blocking remediation;
5. duplicate rating does not create duplicate history;
6. familiar/revealed retest is rejected as independent proof;
7. eligible novel retest can resolve the error when the policy passes;
8. insufficient/invalid retest does not resolve the error;
9. raw learner evidence absent from general events/logs;
10. cost attribution includes retest and optional generated remediation;
11. canonical API operations exist before implementation eligibility.

This slice remains `review/not ready` until those contracts/runs exist.