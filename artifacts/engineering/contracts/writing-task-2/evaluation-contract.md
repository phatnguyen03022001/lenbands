# Writing Task 2 — Evaluation Contract

## Purpose

Define the safe boundary between rubric-driven evaluation, model inference and learner-facing feedback. This is not a raw prompt dump and does not store private chain-of-thought.

## Inputs

```yaml
task_ref:
task_version:
submission_ref:
essay_text_ref:
rubric_version:
learner_context:
  target_band: optional
  language_preference:
  prior_error_refs: optional, bounded
```

## Required output

```yaml
evaluation:
  rubric_version:
  model_version:
  criteria:
    - criterion: task_response | coherence_cohesion | lexical_resource | grammar
      band_estimate:
      confidence:
      evidence_refs: []
      finding: <learner-safe concise explanation>
      recommended_fix_ref:
  overall_band_estimate:
  overall_confidence:
  quality_status: accepted | low_confidence | insufficient_evidence | invalid
  anti_gaming_status: clear | action_required
```

This is the evaluator DTO. Runtime normalizes the `finding` nested in each criterion into immutable `FeedbackFinding` objects before returning the API response or allowing learner confirmation. `LearningError` must not be created directly from the DTO before learner confirmation.

## Quality policy

- Every non-empty finding must cite learner-owned evidence or use `insufficient_evidence`.
- A band is an estimate, never official IELTS result.
- `quality_status=low_confidence` cannot update readiness as a high-confidence signal.
- Model/prompt/rubric change requires benchmark regression and release gate approval.
- Learner feedback is evidence → explanation → one actionable fix; no opaque score-only response.

## Cost policy

- Validate draft before inference.
- Use one bounded evaluation call per accepted submission; retries preserve idempotency.
- Detailed follow-up is generated on demand and bounded by quota/budget.
- Store opaque `workflow_run_id`, `prompt_template_id`, `prompt_hash`, model and parameters for audit; never store hidden reasoning in runtime entity or Artifact. P0 template reference is `writing_evaluation_v1` in the sibling Prompt Specification.

## Derived contract

This file is a scoped delta of `engineering/contracts/evaluation/evaluation-contract.md` — the canonical owner for the evaluation request/result/audit schema and criterion enum (`task_response|coherence_cohesion|lexical_resource|grammar`). It defines the evaluator DTO for Writing Task 2 only; do not expand the criterion enum or redefine the envelope, and any schema change must first bump the source contract version.
