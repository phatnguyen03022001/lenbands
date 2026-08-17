# Evaluation Contract

Canonical metadata is in `evaluation-contract.meta.yaml`.

Canonical engineering implementation contract for evaluation request/result/audit/quality-state. It implements the capability and invariants from the Blueprint; it does not replace `blueprint/03-features.md`, `blueprint/06-engines.md`, or the IELTS Framework. P0 uses it for Writing; the schema is designed to extend to W/S/Pron when scope and evidence exist.

## Ownership

This file is the canonical owner for the evaluation request/result/audit/quality-state schema and the engineering-facing criterion enum (`task_response|coherence_cohesion|lexical_resource|grammar`), mapped 1:1 to the Framework code `criterion_impact` (see Criterion mapping). The IELTS Framework remains the SSOT for domain enums; this contract owns only the engineering schema namespace and does not replace the Framework. `engineering/contracts/writing-task-2/evaluation-contract.md` is a scoped delta: it defines the evaluator DTO for Writing, must preserve the criterion enum, and must not expand the schema contrary to this contract. If the schema must change, bump this contract's version first.

## Score identity and scope

LenBands evaluation output is a **diagnostic estimate**, not an official IELTS result.

The system must preserve these identities separately:

- `official_ielts_score` — a real result supplied by the learner or an authorized source; this contract does not create it.
- `exam_simulation_estimate` — a LenBands estimate from a complete exam-like simulation under the corresponding integrity policy.
- `diagnostic_estimate` — an estimate from partial evidence such as one Writing task or placement.
- `learning_mastery` — a LenBands learner-model state; never an IELTS band.

P0 Writing Task 2 uses `score_scope: writing_task_2` and `score_label: diagnostic_estimate`. The existing `overall_band` field is retained for schema compatibility and means **the task-level aggregate estimate for this evaluated task only**. It must not be presented or consumed as the IELTS Writing section band. A future Writing-section aggregation must keep Task 1 and Task 2 as separate scored tasks and implement the public IELTS weighting rule in its own versioned contract.

## Criterion mapping (controlled vocabulary)

The IELTS Framework `error-taxonomy.md` uses the short code `criterion_impact`; this contract uses the full enum. Mapping is 1:1:

| Framework `criterion_impact` | Contract criterion enum |
|---|---|
| `TR` | `task_response` |
| `CC` | `coherence_cohesion` |
| `LR` | `lexical_resource` |
| `GRA` | `grammar` |

Consumer contracts must use the full enum; the short code is valid only in the Framework taxonomy. (The `FC`/`PR` codes — Speaking — along with `answer-key`, `strategy`, `TR_TASK1`, `TR_LR` are outside this Writing Task 2 contract's scope.)

## Input contract

```yaml
evaluation_request:
  request_id: string
  user_id: string
  submission_ref: string         # WritingSubmission/SpeakingSubmission
  task_ref: string               # WritingTask (published version)
  task_type: string              # from writing-task-framework.md
  assessment_mode: learn | practice | retest | exam_simulation
  rubric_version: string         # band descriptor version
  prompt_template_id: string     # e.g. writing_evaluation_v1
  prompt_template_hash: string   # hash template body (immutability)
  context_budget:
    input_tokens: integer        # hard envelope from llm-routing-context-contract
    output_tokens: integer
```

`assessment_mode` is evidence context. A scaffolded `learn` attempt may receive evaluation feedback, but it must not be treated as equivalent to an unscaffolded retest or exam-simulation attempt when readiness is computed.

## Output contract

```yaml
evaluation_result:
  evaluation_id: string
  request_id: string
  score_scope: writing_task_2
  score_label: diagnostic_estimate
  assessment_mode: learn | practice | retest | exam_simulation
  model_version: string          # adapter/model version (provider-adapter-contract)
  rubric_version: string
  criteria:
    task_response:
      band: number               # 0-9, step 0.5
      confidence: number         # internal 0-1 signal; not a calibrated correctness probability by default
      evidence_refs: [string]    # sentence/section refs in submission
      issues:
        - error_id: string       # from error-taxonomy.md
          evidence_ref: string
          severity: high | medium | low
    coherence_cohesion: {...}
    lexical_resource: {...}
    grammar: {...}
  overall_band: number           # task-level aggregate diagnostic estimate; NOT full Writing-section band
  overall_confidence: number
  confidence_state: unknown | provisional | stronger_evidence
  quality_status: accepted | low_confidence | insufficient_evidence | invalid
  usage:
    input_tokens_actual: integer
    output_tokens_actual: integer
  created_at: timestamp
```

## Evidence-centered scoring boundary

Every scored criterion must preserve the chain:

```text
rubric/construct claim
  -> observable evidence required
  -> task/submission contains or fails to contain that evidence
  -> scorer cites evidence_refs
  -> criterion judgment
  -> task-level diagnostic estimate
```

The scorer must not award or penalize a criterion solely from a proxy that is not evidence for that construct. Examples of unsafe proxy-only behavior include using essay length, rare-word count, or surface complexity as a substitute for rubric judgment.

When required evidence cannot be established, use `insufficient_evidence` or a lower-confidence state according to policy; do not manufacture a precise criterion score to satisfy the schema.

## Quality policy

| Condition | quality_status | Behavior |
|---|---|---|
| All required criteria have evidence and the founder-approved quality policy is met | `accepted` | Show task-level estimate + learner feedback with scope |
| Any criterion falls below the governed confidence/evidence policy | `low_confidence` | Show a provisional/limited-evidence state; learner may report incorrect feedback; do not use as a strong readiness signal |
| Required input/evidence is missing | `insufficient_evidence` | Do not invent a complete diagnostic estimate; explain recovery/resubmission |
| Schema validation fail | `invalid` | `EVALUATION_UNAVAILABLE`, retry under failure contract, do NOT best-effort score |

## Confidence and uncertainty

`overall_confidence` is an internal governance signal calculated from criterion confidence according to a versioned policy. Weight and threshold are founder-approved policies; this draft has no active numeric threshold.

Confidence does **not** mean “probability that the band is correct” unless a benchmark explicitly calibrates that interpretation. Learner UI must not expose an uncalibrated raw percentage as scientific precision. It may show governed language such as `provisional estimate` or `limited evidence` according to `confidence_state` and `quality_status`.

A low-confidence output is not automatically wrong; it means the system has less support for ordinary consumption. Low-confidence and insufficient-evidence results must have recovery paths and must not silently become normal readiness evidence.

## Feedback-mode policy

Evaluation and coaching surfaces must respect assessment mode:

| Mode | Feedback timing | Readiness meaning |
|---|---|---|
| `learn` | scaffolding/hints may appear; teaching detail can be immediate | learning evidence only; scaffolded success is weak readiness evidence |
| `practice` | commit an answer/draft before answer-revealing feedback; then evidence -> one fix -> optional detail | diagnostic evidence when unscaffolded |
| `retest` | no answer-revealing scaffold before commitment; concise result before deeper explanation | stronger evidence, especially on novel context |
| `exam_simulation` | no formative hints/feedback until the configured section/test is complete | strongest LenBands simulation evidence when integrity conditions hold |

This does not require all modes in P0. It prevents future surfaces from mixing learning assistance with exam-like evidence without preserving provenance.

## Audit trail (required)

Each evaluation emits an audit record (immutable):

```yaml
audit:
  evaluation_id, request_id
  contract_version, rubric_version
  score_scope, score_label, assessment_mode
  prompt_template_id, prompt_template_hash
  model_version, adapter_version
  input_token_count, output_token_count
  provider_call_id (internal)
  created_at
```

Do not log: chain-of-thought, full raw prompt, or learner essay text (log `submission_ref` only).

## Anti-gaming

The evaluation engine checks the submission before scoring:
- Similarity vs known sample corpus above a governed threshold → flag `anti_gaming_flag: sample_match`.
- Generated-submission risk signal above a governed threshold → flag `anti_gaming_flag: ai_generated`.
- A flag is a risk signal, not proof. Apply the canonical anti-gaming policy, preserve a neutral explanation/resubmission path, and do not silently use flagged results as normal readiness evidence.

No detector threshold is active in this contract until approved and monitored for false positives.

## Benchmark regression and promotion suite

Before changing prompt/model/rubric, run the founder-approved gold-standard corpus. Promotion evidence should report at least:

1. criterion-level exact agreement with reference ratings;
2. criterion-level agreement within `±0.5` band;
3. task-level exact and `±0.5` agreement;
4. mean and median absolute error as descriptive metrics;
5. an ordinal agreement statistic suitable for band ratings;
6. repeated-run stability for identical inputs;
7. performance by task/prompt and proficiency region;
8. subgroup slices only where sample size, consent, and governance support meaningful interpretation;
9. confidence calibration — whether low-confidence outputs are actually more error-prone;
10. regression versus the currently promoted scorer/model version.

A single aggregate MAE is not sufficient to establish validity, fairness, calibration, or stability. Numeric pass/fail thresholds are versioned policies approved by the founder; none are activated here without benchmark evidence.

## P0 scope

- Writing only.
- One prompt template (`writing_evaluation_v1`).
- Criterion evidence + task-level scope + confidence + audit are required.
- Anti-gaming is a governed risk signal, not proof of misconduct.
- Benchmark: the founder must curate/approve the gold-standard corpus and thresholds; there is not yet a sufficient run/corpus to claim calibration.

## Cross-refs

- Writing slice §7 (inline version): `experience/specs/vertical-slices/writing-task-2.md`.
- LLM routing: `engineering/contracts/runtime/llm-routing-context-contract.md`.
- Provider adapter: `engineering/contracts/runtime/provider-adapter-contract.md`.
- Governance: `blueprint/06-engines.md` § Governance.
- Band descriptor (rubric): `blueprint/framework/band-descriptor-map.md`.
- Error taxonomy: `blueprint/framework/error-taxonomy.md`.
- Evidence-informed audit: `artifacts/experience/research/learning-assessment-experience-audit.md`.
