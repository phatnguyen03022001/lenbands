# Writing Task 2 — Data Contract

## Boundary

Runtime entities are learner-owned or system-owned for a learner; none is a Knowledge Asset or Artifact. Canonical ownership follows `blueprint/02-architecture.md` § Runtime Entity Ownership.

| Entity | Owner | Write authority | Read scope | Privacy | Retention trigger |
|---|---|---|---|---|---|
| WritingDraft | Learner | learner/session | owner | learning | delete account / draft policy |
| WritingSubmission | System for learner | submission service | owner | assessment | assessment retention policy |
| WritingEvaluation | System for learner | evaluation pipeline | owner + aggregate governance | assessment | assessment retention policy |
| FeedbackFinding | WritingEvaluation | evaluation normalizer | owner via source evaluation | assessment | assessment retention policy |
| LearningError | Learner | evaluation + learner action | owner | learning | improved/dismissed/deletion policy |
| ReviewCard | Learner | review service | owner | learning | FSRS/review deletion policy |
| EvaluationAudit | System | evaluation pipeline | authorized governance only | derived assessment | audit policy |

## Invariants

- A submission references one immutable draft version and one published `task_ref`.
- Raw `text` is only available through learner-scoped services; events/logs store references, never text.
- An evaluation is immutable after `quality_status=accepted`; recalibration creates a new evaluation version, never overwrites evidence.
- A `FeedbackFinding` belongs to exactly one evaluation and is immutable after persistence. It is the normalized learner-facing finding; it is not a second rubric or taxonomy SSOT.
- A `LearningError` must reference both `source_finding_id` and `source_evaluation_id`; it is created only after learner confirmation.
- A ReviewCard references a LearningError, not a copied essay sentence as a second mutable source.
- Deletion/export follows the account/privacy policy and must cascade through learner-owned entities.

## Entity: WritingDraft

```yaml
draft_id: string
user_id: string
task_ref: string
task_version: string
version: integer
text: string                         # learner-scoped; never event/log payload
word_count: integer
created_at: timestamp
updated_at: timestamp
```

## Entity: WritingSubmission

```yaml
submission_id: string
user_id: string
draft_id: string
draft_version: integer                # immutable snapshot reference
task_ref: string
task_version: string                  # must be published at submit time
status: submitted | processing | scored | low_confidence | delayed | unavailable
current_evaluation_id: string | null
submitted_at: timestamp
updated_at: timestamp
```

## Entity: WritingEvaluation

```yaml
evaluation_id: string
submission_id: string
attempt: integer                      # bounded attempt number for one submission
evaluation_state: submitted | processing | scored | low_confidence | invalid | anti_gaming_review | failed
quality_status: accepted | low_confidence | insufficient_evidence | invalid
rubric_version: string
model_version: string
prompt_template_id: string
prompt_hash: string
workflow_run_id: string
criteria:
  - criterion: task_response | coherence_cohesion | lexical_resource | grammar
    band_estimate: number
    confidence: number
    evidence_refs: [string]
overall_band_estimate: number | null
overall_confidence: number
anti_gaming_status: clear | action_required
supersedes_evaluation_id: string | null
created_at: timestamp
```

The accepted result is immutable. A retry/recalibration creates another `WritingEvaluation` for the same submission; it does not mutate the prior evidence. `current_evaluation_id` is the submission's projection pointer, not a second evaluation source.

## Versioning and migration

- Schema migration must be additive/backward compatible during an active app release.
- `rubric_version`, `model_version`, `algorithm_version` and `task_version` are required audit references.
- Entity references are opaque runtime IDs; capability IDs never substitute for entity IDs.

## Entity: FeedbackFinding

```yaml
finding_id: string
evaluation_id: string
criterion: task_response | coherence_cohesion | lexical_resource | grammar
error_pattern: string                 # framework-resolved; unknown_* blocks learner action
severity: high | medium | low
evidence_refs: [string]               # at least one for actionable finding
explanation: string
recommended_fix_ref: string
priority: integer                     # 1 is the first learner action
actionability: actionable | insufficient_evidence
created_at: timestamp
```

The evaluator DTO may contain finding text nested under a criterion, but runtime normalizes it once into `FeedbackFinding`. Storage and API must not maintain a second mutable copy of the same finding.
