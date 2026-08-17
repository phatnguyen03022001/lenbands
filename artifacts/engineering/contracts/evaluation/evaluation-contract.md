# Evaluation Contract

Canonical metadata is in `evaluation-contract.meta.yaml`.

This is the canonical engineering contract for evaluation request/result/audit/quality-state semantics. It implements capability invariants from the Blueprint; it does not replace capability meaning, the IELTS Framework, the compute-policy projection, or provider/runtime contracts. P0 uses it for Writing; future Speaking/Pronunciation implementations must decompose their own subtasks before authorization.

## Ownership

This contract owns the engineering evaluation schema, score identities/scopes, criterion-result structure, evidence/provenance acceptance boundary and quality-state semantics. The IELTS Framework remains the authority for IELTS controlled vocabulary and rubric meaning.

Stable compute decision units are declared in `evaluation-contract.meta.yaml`. `artifacts/operations/execution-policy.yaml` may select/project their allowed compute mode but cannot create criteria, error IDs, score meanings, quality states or decision units.

## Core authority invariant

A probabilistic evaluator **performs inference; it does not own canonical semantics or decisions**.

```text
canonical request/task/rubric facts
  -> probabilistic inference executor
  -> typed candidate inference
  -> evidence + provenance binding
  -> deterministic evidence/schema/taxonomy validation
  -> deterministic criterion acceptance
  -> deterministic score aggregation
  -> deterministic quality-state decision
  -> immutable canonical evaluation result
```

A provider response is never a canonical `evaluation_result` merely because it parses.

## Score identity and scope

LenBands preserves four distinct identities:

- `official_ielts_score` — supplied by the learner or an authorized source; LenBands evaluation does not create it.
- `exam_simulation_estimate` — LenBands estimate from a complete exam-like simulation under the corresponding integrity policy.
- `diagnostic_estimate` — estimate from bounded/partial evidence such as one Writing task or placement.
- `learning_mastery` — learner-model state; never an IELTS band.

P0 Writing Task 2 uses `score_scope: writing_task_2` and `score_label: diagnostic_estimate`. `overall_band` means the task-level aggregate estimate for that evaluated task only and cannot be consumed as the IELTS Writing section band.

## Criterion mapping

| Framework `criterion_impact` | Engineering criterion |
|---|---|
| `TR` | `task_response` |
| `CC` | `coherence_cohesion` |
| `LR` | `lexical_resource` |
| `GRA` | `grammar` |

Models may propose findings only within the schema; canonical error identities must resolve to the Framework/LenBands controlled vocabulary through deterministic taxonomy validation. A model cannot invent a new canonical `error_id`.

## Evaluation request

```yaml
evaluation_request:
  request_id: string
  user_id: string
  submission_ref: string
  submission_version: string
  task_ref: string
  task_version: string
  task_type: string
  assessment_mode: learn | practice | retest | exam_simulation
  rubric_version: string
  prompt_template_id: string
  prompt_template_hash: string
  model_route_version: string
  context_budget:
    input_tokens: integer
    output_tokens: integer
```

`assessment_mode` is evidence provenance. Scaffolded learning success cannot be silently promoted into exam-readiness evidence.

## Typed candidate inference

The probabilistic executor returns a candidate, not a result:

```yaml
candidate_inference:
  request_id: string
  submission_ref: string
  submission_version: string
  task_ref: string
  task_version: string
  assessment_mode: learn | practice | retest | exam_simulation
  rubric_version: string
  prompt_template_id: string
  prompt_template_hash: string
  model_route_version: string
  model_version: string
  adapter_version: string
  criteria:
    task_response:
      proposed_band: number
      confidence_signal: number | null
      evidence_refs: [string]
      proposed_issues:
        - proposed_error_id: string
          evidence_ref: string
          severity: high | medium | low
    coherence_cohesion: {...}
    lexical_resource: {...}
    grammar: {...}
  usage:
    input_tokens_actual: integer
    output_tokens_actual: integer
```

Required provenance is part of the acceptance boundary, not optional telemetry. Missing/mismatched task, submission, rubric, prompt, route/model, assessment-mode or evidence provenance makes the candidate invalid or insufficiently evidenced.

## Evidence binding

Every proposed criterion must preserve:

```text
rubric/construct claim
  -> observable evidence requirement
  -> immutable submission/task snapshot
  -> evidence_ref resolving inside that snapshot
  -> candidate interpretation
  -> deterministic validation
```

A model may produce an intermediate semantic interpretation such as a likely reference-cohesion weakness. It becomes a canonical finding only when:

1. the evidence reference resolves to the immutable submission snapshot;
2. the proposed taxonomy identity exists and is permitted for the criterion/scope;
3. the finding satisfies schema/rubric/evidence constraints;
4. domain quality policy permits acceptance.

Unsafe proxy-only scoring remains forbidden: essay length, rare-word count or surface complexity cannot substitute for rubric evidence.

## Deterministic validation and aggregation

After inference, deterministic domain logic owns:

- evidence-reference resolution;
- controlled taxonomy resolution;
- criterion schema/range validation;
- task/rubric/scope consistency;
- task-level score aggregation;
- confidence-state derivation under the active policy;
- quality-state decision;
- persistence eligibility.

The model cannot define weighting, score range, score label, score scope, readiness effect or canonical persistence behavior.

## Canonical evaluation result

Only accepted/validated facts enter the canonical result:

```yaml
evaluation_result:
  evaluation_id: string
  request_id: string
  score_scope: writing_task_2
  score_label: diagnostic_estimate
  assessment_mode: learn | practice | retest | exam_simulation
  submission_ref: string
  submission_version: string
  task_ref: string
  task_version: string
  model_route_version: string
  model_version: string
  rubric_version: string
  criteria:
    task_response:
      band: number
      evidence_refs: [string]
      issues:
        - error_id: string
          evidence_ref: string
          severity: high | medium | low
    coherence_cohesion: {...}
    lexical_resource: {...}
    grammar: {...}
  overall_band: number | null
  confidence_state: unknown | provisional | stronger_evidence
  quality_status: accepted | low_confidence | insufficient_evidence | invalid
  created_at: timestamp
```

`overall_band` may be `null` when the evidence/quality policy does not justify a complete task-level estimate.

## Quality policy

| Condition | quality_status | Behavior |
|---|---|---|
| Required criteria/evidence/provenance valid and active quality policy satisfied | `accepted` | Persist bounded task-level diagnostic result and learner-safe feedback |
| Evidence exists but governed support is below ordinary-consumption policy | `low_confidence` | Preserve provisional result; do not treat as strong readiness evidence |
| Required evidence or scope coverage is missing | `insufficient_evidence` | Do not manufacture a complete estimate; provide recovery/resubmission |
| Schema/provenance/reference validation fails | `invalid` | Return governed unavailable/retry behavior; never best-effort score |

A probabilistic confidence signal cannot self-promote a result into `accepted`. The quality state is a deterministic domain decision.

## Feedback and presentation separation

Feedback priority is computed from accepted canonical findings under versioned deterministic policy; P0 makes no second model call merely to choose which error matters most.

Natural-language wording is presentation only:

```text
canonical findings + evidence + priority
  -> optional wording generator
  -> learner-facing explanation
```

Generated wording cannot change scores, error IDs, evidence refs, action priority, readiness or stored learner facts. If wording generation fails, the structured findings/reasons remain usable.

## Assessment-mode policy

| Mode | Feedback timing | Readiness meaning |
|---|---|---|
| `learn` | scaffolding may appear; teaching detail can be immediate | learning evidence only |
| `practice` | commit before answer-revealing feedback | diagnostic evidence when unscaffolded |
| `retest` | no answer-revealing scaffold before commitment | stronger evidence, especially on novel context |
| `exam_simulation` | formative feedback withheld until configured test/section completes | strongest LenBands simulation evidence when integrity conditions hold |

## Audit trail

Each accepted or rejected inference attempt records immutable provenance sufficient for audit without logging chain-of-thought or raw learner content in general telemetry:

```yaml
audit:
  evaluation_id: string | null
  request_id: string
  submission_ref: string
  submission_version: string
  task_ref: string
  task_version: string
  contract_version: string
  rubric_version: string
  score_scope: string
  score_label: string
  assessment_mode: string
  prompt_template_id: string
  prompt_template_hash: string
  model_route_version: string
  model_version: string
  adapter_version: string
  provider_call_id: string | null
  evidence_refs: [string]
  validation_disposition: accepted | low_confidence | insufficient_evidence | invalid
  input_token_count: integer
  output_token_count: integer
  created_at: timestamp
```

## Anti-gaming

Anti-gaming combines governed risk signals. Similarity or generated-submission detectors produce **candidate risk signals**, never proof of misconduct. Canonical policy decides whether a result is withheld, annotated or offered a neutral resubmission path. Detector thresholds remain inactive until approved and monitored for false positives.

## Benchmark and compute-mode promotion

Before changing prompt/model/rubric/model-route or promoting another probabilistic executor, use the approved gold/reference corpus and report at least criterion/task exact and ±0.5 agreement, absolute-error distributions, suitable ordinal agreement, repeated-run stability, task/proficiency slices, confidence calibration, and regression versus the currently promoted route.

A compute-mode change is governed architecture. “The model seems better” is not evidence. Promotion requires evidence that lower sufficient modes cannot meet the declared semantic inference contract plus privacy/cost/latency/reliability review.

## P0 scope

- Writing only.
- One prompt template (`writing_evaluation_v1`).
- One bounded governed semantic-inference route at a time, with approved fallback only inside the same scorer-route policy.
- Evidence/provenance binding, deterministic validation/aggregation, confidence/quality state and audit are required.
- Feedback priority performs no second inference call.
- No sufficient benchmark corpus/run currently exists to claim calibration or production readiness.

## Cross-references

- Capability meaning: `blueprint/03-features.md`.
- Compute boundary: `blueprint/06-engines.md`.
- Compute projection: `artifacts/operations/execution-policy.yaml`.
- Probabilistic routing: `artifacts/engineering/contracts/runtime/llm-routing-context-contract.md`.
- Provider adapter: `artifacts/engineering/contracts/runtime/provider-adapter-contract.md`.
- Band descriptor: `blueprint/framework/band-descriptor-map.md`.
- Error taxonomy: `blueprint/framework/error-taxonomy.md`.
- Evidence integrity: `artifacts/operations/evidence-integrity.yaml`.
