# Evaluation Benchmark Intake and Run Contract

This workflow turns an authorized Writing Task 2 corpus into an immutable benchmark run. It contains no essay or audio payloads; learner content must remain outside the repository or inside an authorized store, while the manifest keeps only opaque references, labels, and provenance required for audit.

## Current state

`gold-corpus-manifest.yaml` is `status: missing` with `gold_case_count: 0`. `numeric-threshold-policy.yaml` contains candidate numbers but has `approval_state: pending_founder` and `armed: false`. Therefore no valid benchmark run exists yet and the evaluation route remains blocked.

## Intake gate

A corpus can move to `ready` only when every case has:

- opaque `case_id` and `essay_ref`; raw essays are never committed;
- Task 2 type/version and rubric version that resolve to the framework;
- reference labels for TR/CC/LR/GRA + overall band;
- label method and qualified-reference provenance;
- immutable rights/permission evidence;
- dataset version/hash and a split that does not overlap the regression/test set.

## Run gate

`tools/run-writing-benchmark.sh` writes a run record only when the corpus is `ready`, the result file contains all case IDs, the threshold policy is `armed`, the cost ceiling is non-empty, and the caller supplies `--reviewed-by`. The tool never overwrites output; every new run record is a new snapshot.

A passing run does not itself authorize publication. Release still requires `OPS.ReleaseGate`, runtime acceptance, and owner review.

## Input/result shape

The corpus manifest stores reference labels, not raw learner content:

```yaml
cases:
  - case_id: G-WRITING-0001
    task_type: W_task2_opinion
    task_version: 0.1.0
    essay_ref: vault://approved-corpus/...
    reference:
      criteria: {task_response: 6.0, coherence_cohesion: 6.0, lexical_resource: 6.5, grammar: 6.0}
      overall_band: 6.0
```

Evaluator results use the same `case_id` and contain only structured output metrics. Raw essays, prompts, chain-of-thought, and provider payloads are forbidden.
