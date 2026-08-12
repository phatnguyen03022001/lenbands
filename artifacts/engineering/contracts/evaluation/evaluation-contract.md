# Evaluation Contract

Canonical metadata is in `evaluation-contract.meta.yaml`.

Canonical engineering implementation contract for evaluation request/result/audit/quality-state. It implements the capability and invariants from the Blueprint; it does not replace `blueprint/03-features.md`, `blueprint/06-engines.md`, or the IELTS Framework. P0 uses it for Writing; the schema is designed to extend to W/S/Pron when scope and evidence exist.

## Ownership

This file is the canonical owner for the evaluation request/result/audit/quality-state schema and the engineering-facing criterion enum (`task_response|coherence_cohesion|lexical_resource|grammar`), mapped 1:1 to the Framework code `criterion_impact` (see Criterion mapping). The IELTS Framework remains the SSOT for domain enums; this contract owns only the engineering schema namespace and does not replace the Framework. `engineering/contracts/writing-task-2/evaluation-contract.md` is a scoped delta: it defines the evaluator DTO for Writing, must preserve the criterion enum, and must not expand the schema contrary to this contract. If the schema must change, bump this contract's version first.

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
  rubric_version: string         # band descriptor version
  prompt_template_id: string     # vd writing_evaluation_v1
  prompt_template_hash: string   # hash template body (immutability)
  context_budget:
    input_tokens: integer        # hard envelope from llm-routing-context-contract
    output_tokens: integer
```

## Output contract

```yaml
evaluation_result:
  evaluation_id: string
  request_id: string
  model_version: string          # adapter/model version (provider-adapter-contract)
  rubric_version: string
  criteria:
    task_response:
      band: number               # 0-9, step 0.5
      confidence: number         # 0-1
      evidence_refs: [string]    # sentence/section refs trong submission
      issues:                    # error list
        - error_id: string       # from error-taxonomy.md
          evidence_ref: string
          severity: high | medium | low
    coherence_cohesion: {...}
    lexical_resource: {...}
    grammar: {...}
  overall_band: number           # avg of 4, rounded to nearest 0.5 (.25→.5, .75→up — IELTS rule)
  overall_confidence: number
  quality_status: accepted | low_confidence | insufficient_evidence | invalid
  usage:
    input_tokens_actual: integer
    output_tokens_actual: integer
  created_at: timestamp
```

## Quality policy

| Condition | quality_status | Behavior |
|---|---|---|
| All criteria have ≥1 evidence and overall confidence meets founder-approved threshold | `accepted` | Show band + learner feedback |
| Any criterion is below the founder-approved confidence threshold OR has `insufficient_evidence` | `low_confidence` | Flag "Needs review", learner may select "This feedback is incorrect"; do not use as a strong readiness signal |
| Schema validation fail | `invalid` | `EVALUATION_UNAVAILABLE`, retry under failure contract, do NOT best-effort score |

## Confidence scoring

`overall_confidence` = weighted average of criterion confidence. Weight and threshold are versioned policies approved by the founder; the draft has no active numeric value.

Confidence does not mean “the band is correct”; it means “the engine is confident in the output”. Low confidence → backend governance flag, not necessarily an incorrect band. The thresholds in the table are candidate policy, not benchmarked/approved thresholds.

## Audit trail (required)

Each evaluation emits an audit record (immutable):
```yaml
audit:
  evaluation_id, request_id
  contract_version, rubric_version
  prompt_template_id, prompt_template_hash
  model_version, adapter_version
  input_token_count, output_token_count
  provider_call_id (internal)
  created_at
```

Do not log: chain-of-thought, full raw prompt, or learner essay text (log `submission_ref` only).

## Anti-gaming

The evaluation engine checks the submission before scoring:
- Similarity vs known sample corpus (Cambridge published samples) > threshold → flag `anti_gaming_flag: sample_match`
- AI-generated detector score > threshold → flag `anti_gaming_flag: ai_generated`
- Flag → still score but do not record the band in history (or record it with a flag); notify the learner lightly.

## Benchmark regression

Before changing prompt/model/rubric: run the benchmark corpus (gold-standard examiner-graded) and apply the numeric threshold approved by the founder. `MAE < 0.5 band` is only a candidate example in the draft, not a result or active release gate. Failure → block route change.

## P0 scope

- Writing only.
- 1 prompt template (`writing_evaluation_v1`).
- Confidence + evidence + audit are required.
- Anti-gaming basic (similarity + detector).
- Benchmark: the founder must curate/approve the gold-standard corpus and threshold; there is not yet a sufficient run/corpus to claim calibration.

## Cross-refs

- Writing slice §7 (inline version): `experience/specs/vertical-slices/writing-task-2.md`.
- LLM routing: `engineering/contracts/runtime/llm-routing-context-contract.md`.
- Provider adapter: `engineering/contracts/runtime/provider-adapter-contract.md`.
- Governance: `blueprint/06-engines.md` § Governance.
- Band descriptor (rubric): `blueprint/framework/band-descriptor-map.md`.
- Error taxonomy: `blueprint/framework/error-taxonomy.md`.
