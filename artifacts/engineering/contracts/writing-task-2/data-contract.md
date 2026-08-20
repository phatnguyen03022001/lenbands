# Writing Task 2 — Data Contract

## Boundary

Runtime entities are learner-owned or system-owned for one learner. They are not Knowledge Assets, framework nodes or Artifacts.

This contract keeps three concepts separate:

1. durable operation/submission lifecycle;
2. evaluation result validity/trustworthiness;
3. learner evidence/remediation state.

Do not collapse them into one status enum.

## Entity ownership

| Entity | Owner | Write authority | Read scope | Privacy |
|---|---|---|---|---|
| `WritingDraft` | learner | learner/session | owner | assessment |
| `WritingSubmission` | system for learner | submission service | owner | assessment |
| `DurableEvaluationOperation` | system | evaluation orchestrator | owner via projection + operations metadata | derived/assessment refs |
| `WritingEvaluation` | system for learner | evaluation normalizer/admission | owner + aggregate governance | assessment |
| `FeedbackFinding` | evaluation | normalizer/feedback mapper | owner via evaluation | assessment |
| `LearningError` | learner | learner-confirmation/remediation service | owner | learning |
| `ReviewCard` | learner | review service | owner | learning |
| `RetestAttempt` | learner | retest/evaluation services | owner | assessment |
| `EvaluationAudit` | system | governed pipeline | authorized governance only | derived |

Internal workers use function-scoped service authorization; no generic service credential grants blanket access across these entities.

## Core invariants

- Submission references exactly one immutable draft snapshot and one published task version.
- Raw essay text stays in protected learner-scoped content/storage and is referenced by opaque IDs elsewhere.
- `operation_state` never expresses result quality.
- `result_validity` never expresses queue/provider lifecycle.
- Evaluation results/findings are immutable; governed re-evaluation creates another result/version.
- A model/provider response never directly writes learner mastery/readiness.
- A `LearningError` requires learner confirmation of an actionable evidence-backed finding.
- FSRS card maturity does not become Writing mastery/readiness.
- Retest eligibility checks exposure/novelty policy deterministically.
- Historical data retains exact task/rubric/scorer/prompt versions.

## WritingDraft

```yaml
WritingDraft:
  draft_id: string
  user_id: string
  task_ref: string
  task_version: string
  version: integer
  protected_text_ref: string
  word_count: integer
  sync_state: drafting | syncing | local_only | conflict | submitted_snapshot
  created_at: timestamp
  updated_at: timestamp
```

`protected_text_ref` resolves only inside the authorized learner/submission/evaluation path. Raw text is never an analytics/event field.

## WritingSubmission

```yaml
WritingSubmission:
  submission_id: string
  user_id: string
  draft_id: string
  draft_version: integer
  immutable_snapshot_ref: string
  task_ref: string
  task_version: string
  assessment_mode: practice | retest
  submission_state: submitted | processing | completed | delayed | unavailable
  current_operation_id: string
  current_evaluation_id: string | null
  submitted_at: timestamp
  updated_at: timestamp
```

`completed` means the durable evaluation operation finished; clients inspect the linked result's `result_validity` before interpreting the evaluation.

## DurableEvaluationOperation

```yaml
DurableEvaluationOperation:
  operation_id: string
  submission_id: string
  operation_state: accepted | processing | succeeded | delayed | unavailable | failed | cancelled
  attempt: integer
  absolute_deadline_at: timestamp
  scorer_route_version: string
  internal_function_scope: evaluation_worker
  idempotency_key_hash: string
  retry_count: integer
  escalation_count: integer
  created_at: timestamp
  updated_at: timestamp
```

Operation retry/replay follows the canonical runtime contract. A new audited operation may supersede a terminal failed/unavailable attempt; it never mutates a terminal evaluation result.

## WritingEvaluation

```yaml
WritingEvaluation:
  evaluation_id: string
  submission_id: string
  operation_id: string
  result_version: integer

  score_label: diagnostic_estimate
  score_scope: writing_task_2
  assessment_mode: practice | retest
  result_validity: accepted | limited_evidence | insufficient_evidence | invalid | integrity_review

  rubric_version: string
  scorer_route_version: string
  prompt_template_id: string
  prompt_hash: string

  criteria:
    - criterion: task_response | coherence_cohesion | lexical_resource | grammar
      band_estimate: number | null
      evidence_refs: [string]
      finding_refs: [string]

  overall_band_estimate: number | null
  learner_uncertainty_copy: string | null

  primary_model_id: string
  primary_provider_id: string
  escalation_route_ref: string | null
  cost_ref: string

  supersedes_evaluation_id: string | null
  created_at: timestamp
```

Raw model confidence may exist in restricted evaluation-audit/routing data. It is not required in the learner result entity and must not be exposed as correctness probability without calibration.

## FeedbackFinding

```yaml
FeedbackFinding:
  finding_id: string
  evaluation_id: string
  criterion: task_response | coherence_cohesion | lexical_resource | grammar
  evidence_refs: [string]
  error_pattern: string              # controlled framework ID or unknown_error
  severity: high | medium | low | null
  explanation: string
  priority: integer
  actionability: actionable | informational | insufficient_evidence
  remediation_unit_ref: string | null
  retest_family_ref: string | null
  created_at: timestamp
```

Actionable findings require at least one resolvable evidence reference. Unknown taxonomy mapping remains explicit and must not trigger invented error IDs.

## LearningError

```yaml
LearningError:
  error_id: string
  user_id: string
  source_evaluation_id: string
  source_finding_id: string
  error_pattern: string
  criterion: task_response | coherence_cohesion | lexical_resource | grammar
  status: open | in_review | improved | dismissed
  remediation_unit_ref: string | null
  retest_family_ref: string | null
  resolve_policy_version: string
  created_at: timestamp
  updated_at: timestamp
```

A `LearningError` is learner-owned remediation state, not a copy of the essay or a second scorer result.

## ReviewCard

Create only when the remediation unit is meaningfully retrievable.

```yaml
ReviewCard:
  card_id: string
  user_id: string
  source_error_id: string
  content_ref: string
  content_type: grammar | vocabulary | collocation | pattern | error_concept | pronunciation_target
  state: new | learning | review | relearning
  due_at: timestamp
  stability: number
  difficulty: number
  reps: integer
  lapses: integer
  algorithm_version: string
  version: integer
```

Do not create a generic `writing_skill` FSRS card merely because an evaluation had a low rubric criterion.

## RetestAttempt

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
  evidence_state: pending | passed | failed | insufficient_evidence | invalid
  created_at: timestamp
```

`improved` may be derived only after the configured resolve policy admits the retest evidence. `novelty_state!=eligible` does not become independent transfer evidence.

## EvaluationAudit / cost routing metadata

Restricted audit data may record:

```yaml
EvaluationAudit:
  operation_id: string
  primary_route_ref: string
  escalation_route_ref: string | null
  raw_confidence_metrics_ref: string | null
  integrity_signal_refs: [string]
  primary_cost_units: number
  escalation_cost_units: number
  feedback_cost_units: number
  retry_count: integer
  latency_ms: integer
  redaction_check: passed | failed
```

Do not store hidden chain-of-thought or raw provider payload as audit evidence.

## Versioning and migration

- Schema changes remain backward-compatible during an active API release or use an explicit migration/version transition.
- Task, rubric, scorer-route, prompt and algorithm versions are audit references.
- Entity IDs are opaque; capability/framework IDs never substitute for runtime entity IDs.
- Existing legacy fields such as combined `status`, `evaluation_state`, `quality_status`, `overall_confidence` or learner-facing numeric confidence require an explicit migration mapping before build eligibility.

## Retention / deletion

Retention/export/deletion resolve through the canonical data-retention registry. Raw assessment content, derived evaluation evidence and learner error/review state must not silently outlive their approved purpose/subject policy.

## Canonical API alignment gate

The canonical API schema must project these semantics before implementation:

- `WritingSubmission` exposes lifecycle/operation state without embedding result trustworthiness;
- `EvaluationResult` exposes `result_validity` separately;
- score label/scope are explicit;
- raw confidence is not required in learner-facing payloads;
- retest/exposure provenance is preserved where the operation is active.

If generated OpenAPI still projects legacy combined state enums, P0-04 remains `not ready`.