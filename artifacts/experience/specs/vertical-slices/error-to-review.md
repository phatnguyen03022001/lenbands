# Vertical Slice — Error to Review

`P0-05` turns one learner-confirmed, evidence-backed Writing finding into the smallest useful remediation and verifies whether the error decreases on eligible new evidence.

The slice is **not** "create an FSRS card for every error". FSRS is used only when the remediation unit is meaningfully retrievable.

## 1. Learner outcome

```text
confirmed finding
  -> LearningError
  -> choose smallest useful intervention
  -> learner fixes/practices independently
  -> optional FSRS review when retrievable
  -> sufficiently novel retest
  -> governed evaluation/evidence admission
  -> improved | remains active | insufficient evidence
```

Completion, card maturity and success on a revealed source item are not verified improvement by themselves.

## 2. Entry boundary

Entry requires:

- learner owns the source evaluation/finding;
- source evaluation is admissible for remediation under its result-validity policy;
- finding has resolvable learner evidence;
- learner confirms/selects the finding;
- required error/remediation mapping resolves, or the finding remains informational instead of inventing a taxonomy ID.

`limited_evidence` may support a learning action when policy allows, but it must not silently become strong readiness evidence.

## 3. Learner-visible flow

```text
Feedback
  ↓
ONE priority error
  ↓
Why it matters + cited evidence
  ↓
Smallest useful fix
  ↓
Learner produces corrected work
  ↓
Review only if this is a retrievable unit
  ↓
Independent/novel retest
  ↓
Did the error reduce on admissible evidence?
  ├─ yes -> improved
  ├─ no  -> remains active + next action
  └─ insufficient -> explain what evidence is still needed
```

The learner does not choose among taxonomy nodes, scheduler settings, scorer routes or multiple remediation plans.

## 4. State axes

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

The retest relation has server-owned novelty and operation/result state. Learner-facing status follows the ordinary Writing submission/evaluation flow rather than inventing a parallel scorer lifecycle.

```text
retest created
  -> learner completes eligible new work
  -> Writing submission/evaluation
  -> accepted/limited/insufficient/invalid/integrity-review result
  -> error-resolution policy
```

### Novelty/exposure

```text
eligible | familiar | invalid | unknown
```

Only an eligible retest may count as configured independent/transfer evidence.

## 5. Intervention selection

Use deterministic/framework mappings when available:

```text
error_pattern + criterion + evidence
  -> remediation family
  -> smallest useful intervention
```

Examples:

- article/preposition/punctuation error -> short explanation + independent sentence fix + optional review card;
- collocation/lexical precision -> contrast/example + retrieval card where appropriate;
- weak topic sentence pattern -> guided contrast + independent paragraph rewrite; card only for a bounded pattern if useful;
- Task Response/Coherence problem -> structured drill/rewrite/retest, **not** a generic FSRS mastery card.

A model may help explain a valid finding where needed, but it does not own error taxonomy, review eligibility or resolution state.

## 6. FSRS suitability gate

Before creating a ReviewCard, the review domain evaluates a deterministic `reviewability` rule.

```yaml
reviewability:
  state: reviewable | not_reviewable | unknown
  review_unit_ref: string | null
  rationale_code: string
  policy_version: string
```

Create a card only when `reviewable` and a stable bounded unit exists.

FSRS owns scheduling/ratings. It does not prove Writing Task Response, Coherence, overall skill mastery or exam readiness.

## 7. Retest policy

Retest must:

- target the same underlying error/construct;
- use eligible content according to exposure policy;
- not reveal the answer/fix before learner commitment;
- preserve task/rubric/evaluation provenance;
- produce a result whose `result_validity` is evaluated separately;
- avoid claiming transfer when the prompt/item is familiar or recently revealed.

If no eligible retest content exists, keep the error active and surface `content_gap`/another valid action. Do not fake progress with the source item or unrelated harder content.

## 8. Resolution rule

`LearningError.status=improved` is derived by a versioned policy, not a client mutation or manual score override.

A P0 resolution policy may consider:

- target error absent/reduced on eligible retest evidence;
- result validity/admission;
- recurrence history where enough evidence exists;
- review result only as supporting memory evidence when a review card exists.

It must **not** require an arbitrary FSRS state for errors where FSRS is not suitable.

No universal `90% accuracy + 3 submissions` constant is canonical until calibrated/approved for the specific error family.

## 9. Canonical API boundary

Canonical mutation/review operations already exist:

- `saveWritingError` — save one learner-confirmed server-derived finding as a LearningError;
- `saveWritingErrorFix` — persist learner-produced fix evidence;
- `startWritingErrorRetest` — create/bind an eligible retest relation and task;
- `getReviewQueue` — retrieve due review units;
- `rateReviewItem` — persist one review rating/idempotent semantic effect.

The normal Writing operations remain the scoring/evaluation route for retest work:

- `getWritingTask`;
- `saveWritingDraft`;
- `createWritingSubmission`;
- `getWritingSubmission`;
- `getWritingEvaluation`.

A separate `GET retest` endpoint is **not** required merely for CRUD symmetry. The server persists the retest/error relation; learner evaluation state is obtained through the canonical Writing submission/evaluation flow. Add a standalone retrieval operation only if a real learner/admin use case cannot be served by current canonical projections.

All mutations remain owner-scoped, versioned where applicable and idempotent according to the canonical API/runtime contract.

## 10. Events and outcome measurement

Registered events include:

- `learning_error_saved`;
- `learning_error_fix_completed`;
- `review_card_created` only when a card exists;
- `review_card_rated` / `review_completed`;
- `retest_started` / `retest_completed`;
- `learning_error_resolved` only after resolution policy passes.

No event contains raw essay/error evidence text.

Until a dedicated verified-improvement event is canonically registered, outcome measurement derives verified improvement from admitted retest evidence + error-resolution state. Completion events alone do not prove improvement.

## 11. Cost / privacy

- FSRS/rating and novelty/exposure checks are deterministic.
- Do not call a model to decide review intervals or retest novelty when exposure facts exist.
- Retest eligibility/quota is checked before costly evaluation.
- Reuse governed remediation assets before generating a new explanation.
- General telemetry contains opaque refs/pattern IDs/outcome classes only.
- Track cost per verified improvement, including retest evaluation and optional generated remediation cost.

## 12. Failure behavior

| Condition | Recovery |
|---|---|
| no evidence/mapping | keep finding informational; no fake error/card |
| remediation unavailable | keep error open; another valid action/content-gap |
| not reviewable | skip FSRS; continue fix/retest path |
| review save failure | idempotent retry; preserve card state |
| no eligible novel retest | keep error active; never reuse exposed task as independent proof |
| retest evaluation delayed | preserve ordinary Writing submission; show truthful delayed state |
| insufficient retest evidence | remain active; show next verification action |
| invalid/integrity-review result | do not resolve; governed recovery/resubmission path |
| quota unavailable | allow zero-cost review/fix where possible; retain learner work/state |

## 13. Anti-overload rules

- feedback hands off only one priority error by default;
- one smallest useful fix is primary;
- review is inserted only when materially useful;
- retest is shown when eligible, not as another permanent dashboard card;
- no harder/higher-band substitute for missing remediation/retest coverage;
- technical state is hidden unless it changes the learner's next action.

## 14. Acceptance evidence

P0-05 needs executable proof for:

1. no evidence -> no LearningError/card;
2. learner confirmation is required;
3. save error/fix/retest operations are owner-scoped and idempotent;
4. retrievable grammar/pattern error can create one FSRS card;
5. complex criterion finding can skip FSRS without blocking remediation;
6. duplicate rating does not create duplicate history;
7. familiar/revealed retest is rejected as independent proof;
8. eligible novel retest can resolve the error only when admission/resolution policy passes;
9. insufficient/invalid/integrity-review retest does not resolve the error;
10. learner can leave/resume the retest through canonical Writing state without losing the error relation;
11. raw learner evidence is absent from general events/logs;
12. cost attribution includes retest and optional generated remediation;
13. missing remediation/retest coverage produces a truthful non-progress/content-gap path.

## Readiness

The learner flow and canonical API operations are now semantically aligned. Implementation/release remains `not ready` until exact-candidate acceptance, accessibility/network, rights/content and applicable risk evidence pass; missing runtime evidence is not an API-design blocker.
