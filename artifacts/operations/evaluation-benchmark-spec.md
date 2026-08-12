# Evaluation Benchmark Specification

## Purpose

Measure whether `EVAL.Writing` is useful, calibrated and stable enough for learner-facing use. Benchmark artifacts reference authorized data/evidence later; they do not embed learner essays in this repository. The executable intake/run boundary is in `operations/benchmark/` and `tools/run-writing-benchmark.sh`.

## Dataset classes

| Class | Purpose | Required provenance |
|---|---|---|
| Gold standard | Compare rubric alignment to qualified reference labels | rights, source, label method, version |
| Edge cases | Test short text, off-topic, mixed-language, prompt mismatch | creation/provenance, expected safe response |
| Regression cases | Prevent known failures returning | issue reference, expected behavior |
| Adversarial cases | Test anti-gaming and prompt injection resilience | safe source, expected containment |

## Evaluation dimensions

- Criterion-level agreement: Task Response, Coherence & Cohesion, Lexical Resource, Grammar.
- Overall-band agreement and calibration, reported as range/confidence rather than false precision.
- Evidence coverage: percentage of learner-visible findings with valid evidence references.
- Actionability: percentage of findings mapped to one concrete fix.
- Safety: invalid/low-confidence cases correctly withheld from readiness.
- Latency and cost per accepted evaluation.

## Required output per benchmark run

```yaml
benchmark_run_id:
dataset_version:
rubric_version:
model_version:
prompt_template_id:
quality_metrics: {}
latency_metrics: {}
cost_metrics: {}
failure_cases: []
decision: promote | hold | rollback
reviewed_by:
reviewed_at:
```

## Promotion rule

Candidate numeric thresholds are typed in `operations/benchmark/numeric-threshold-policy.yaml`, but remain `armed: false` until founder approval, an authorized corpus and a baseline run exist. The runner blocks before those conditions; no change may claim improvement solely from aggregate score. It must show no regression in evidence coverage, safety, latency and cost.

## Current gate state

- Corpus manifest: `missing` — 0 gold cases, no rights/label evidence.
- Threshold policy: `review` / `pending_founder` / `armed: false`.
- Benchmark run: not run; `tools/run-writing-benchmark.sh` exits blocked until all gates are true.
- Acceptance: P0 test IDs are declared in `operations/acceptance/p0-acceptance-manifest.yaml`; no runtime result exists.

## Regression policy

- Every learner-reported incorrect feedback becomes a candidate regression case after triage.
- Prompt/model/provider changes require baseline comparison before promotion.
- A material regression freezes release and activates rollback/fallback in the Evaluation Contract.
