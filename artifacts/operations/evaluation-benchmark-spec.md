# Evaluation Benchmark Specification

## Purpose

Measure whether `EVAL.Writing` is useful, calibrated and stable enough for learner-facing use. Benchmark artifacts reference authorized data/evidence later; they do not embed learner essays in this repository. The executable intake/run boundary is in `operations/benchmark/` and the benchmark runner.

This specification separates **benchmark design** from **benchmark evidence**. The slice policy must exist before scorer approval; the actual corpus/run is release evidence and must not be invented before implementation.

## Dataset classes

| Class | Purpose | Required provenance |
|---|---|---|
| Gold standard | Compare rubric alignment to qualified reference labels | rights, source, label method, version |
| Edge cases | Test short text, off-topic, mixed-language, prompt mismatch | creation/provenance, expected safe response |
| Regression cases | Prevent known failures returning | issue reference, expected behavior |
| Adversarial cases | Test anti-gaming and prompt injection resilience | safe source, expected containment |

No corpus may infer a sensitive learner attribute from essay text in order to manufacture a fairness slice. A demographic or user-group slice may be used only when the attribute is lawfully collected/authorized for benchmark purposes and the evaluation question is explicitly approved.

## Evaluation dimensions

- Criterion-level agreement: Task Response, Coherence & Cohesion, Lexical Resource, Grammar.
- Overall-band agreement and calibration, reported without false precision.
- Evidence coverage: proportion of learner-visible findings with valid evidence references.
- Actionability: proportion of accepted findings mapped to one concrete fix.
- Validity behavior: insufficient/invalid/integrity-review cases are handled correctly and do not promote readiness.
- Latency and cost per accepted evaluation.
- Escalation rate and primary-versus-escalation quality/cost.
- Slice health: required slices are reported independently; aggregate quality cannot hide a material slice failure.

## Required slice plan

Every scorer candidate declares a versioned `slice_plan` before benchmark promotion. P0 Writing must cover at least the dimensions below when the authorized corpus contains sufficient cases:

| Dimension | Required purpose |
|---|---|
| rubric criterion | detect a route that is good overall but weak on one criterion |
| reference score range | detect floor/ceiling and band-range regression |
| task/prompt family | detect prompt-specific or task-family overfitting |
| response length / completion class | distinguish valid complete responses from short/partial/off-task behavior |
| language-mix / unusual-input class | verify safe validity behavior rather than forced scoring |
| benchmark source / label cohort | expose source-specific label or sampling drift |

Future Speaking/Pronunciation adds governed slices for audio quality and relevant speech/acoustic conditions; it must not simply reuse Writing slice dimensions.

A slice is marked `insufficient_sample` rather than silently merged when the corpus cannot support a meaningful comparison. The system must not claim fairness from an underpowered slice.

## Slice threshold policy

Each slice has one of:

- `critical` — failure blocks learner-visible scorer promotion;
- `guardrail` — regression requires review/hold according to the armed policy;
- `observational` — reported for learning only; cannot be presented as a passed fairness guarantee.

Numeric thresholds remain external, versioned and unarmed until approved evidence exists. Agents must not invent sample-size, agreement or disparity thresholds.

## Required output per benchmark run

```yaml
benchmark_run_id:
dataset_version:
slice_plan_version:
rubric_version:
scorer_route_version:
model_version:
prompt_template_id:
quality_metrics: {}
slice_metrics:
  - slice_id:
    policy: critical | guardrail | observational
    sample_count:
    sample_state: sufficient | insufficient_sample
    metrics: {}
    decision: pass | hold | insufficient_sample
validity_metrics: {}
latency_metrics: {}
cost_metrics: {}
failure_cases: []
decision: promote | hold | rollback
reviewed_by:
reviewed_at:
```

## Promotion rule

Candidate numeric thresholds are typed in `operations/benchmark/numeric-threshold-policy.yaml`, but remain `armed: false` until founder approval, an authorized corpus and a baseline run exist. The runner blocks before those conditions; no change may claim improvement solely from aggregate score.

Promotion requires all armed critical dimensions/slices to pass. Aggregate agreement cannot override a failed critical slice, evidence-validity regression, rights/provenance failure or unsafe validity behavior.

## Reproducibility and deprecation

Every run binds dataset, rubric, prompt and scorer-route identities. Historical results may have different reproducibility levels:

- `exact` — the same immutable evaluator components remain executable;
- `semantic` — exact provider/model reproduction is unavailable, but a governed equivalent route can rerun the same task/rubric semantics;
- `audit_only` — the historical result remains attributable to immutable inputs/version identities but cannot be faithfully rerun.

A retired model/provider never authorizes rewriting an old learner result. A governed re-evaluation creates a new result linked to the prior result and records the route used.

## Current gate state

- Corpus manifest: `missing` — 0 gold cases, no rights/label evidence.
- Threshold policy: `review` / `pending_founder` / `armed: false`.
- Benchmark run: not run; runner remains blocked until required inputs are real.
- Acceptance: P0 test IDs may be declared, but no runtime result may be fabricated.

## Regression policy

- Every learner-reported incorrect feedback becomes a candidate regression case after triage.
- Prompt/model/provider changes require baseline comparison before promotion.
- A material aggregate or required-slice regression freezes release and activates rollback/fallback in the Evaluation Contract.
