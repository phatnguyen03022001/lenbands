# PROMPT: Spawn Writing Task Prompt (DeepSeek V4 Flash)

> Copy from `---BẮT ĐẦU---` to the end. Replace the three parameters.

---BẮT ĐẦU---

You are a content spawner for the LenBands IELTS app. Generate original Writing task assets from the governed framework. Do not invent IELTS scoring rules from training knowledge.

## PARAMETERS
- task_type: `W_task2_opinion`
- exam_module: `academic`
- count: 5 prompts

## STEP 1 — READ FRAMEWORK
- `blueprint/framework/writing-task-framework.md`  ← official-derived Writing requirements + LenBands task taxonomy
- `blueprint/framework/band-descriptor-map.md`  ← operational descriptor summaries; official source remains normative
- `blueprint/framework/vocab-collocation-topic.md`  ← LenBands topic taxonomy
- `blueprint/framework/grammar-band-framework.md`  ← optional curriculum tags only; not official band requirements
- `blueprint/framework/microskill-enum.md`  ← controlled micro-skill IDs
- `blueprint/framework/README.md`  ← authority classes

If a controlled ID is missing, return the relevant `unknown_*` value and stop.

## STEP 2 — GENERATE ORIGINAL PROMPTS
Each prompt must:
- Match the selected LenBands `task_type` while remaining faithful to the public IELTS task format.
- Use an appropriate topic from the LenBands topic taxonomy.
- Be answerable without specialist knowledge.
- Be original; do not copy or closely paraphrase a published IELTS/Cambridge prompt.
- Avoid embedding a target band or named grammar structure as a requirement for the learner.

`task_type` is an internal authoring taxonomy. It must not be described as an official exhaustive IELTS taxonomy.

## STEP 3 — WRITING TASK SCHEMA

```yaml
task_id: W_t_001
exam_module: academic
task_type: W_task2_opinion
prompt_text: |
  Some cities are considering reducing the amount of space available for private cars in their centres.
  To what extent do you agree or disagree with this approach?
minimum_response_words: 250
prompt_hash: <sha256 of prompt_text>
rights:
  origin: generated
  origin_ref: "original LenBands prompt following the public IELTS Writing Task 2 interaction pattern"
tags:
  topic: [t_transport_travel, t_society_culture]
  microskill_ref: [W_position_clarity, W_idea_development]
status: draft
version: 0.1.0
```

Do not use `band_range` on a prompt as if the prompt itself guarantees or measures a band. If the product later needs calibrated item-difficulty metadata, it must come from a separate reviewed/calibrated field and evidence source.

## HARD RULES
1. `task_type` MUST exist in `writing-task-framework.md`.
2. `topic` MUST belong to the LenBands topic enum.
3. `microskill_ref` MUST exist in `microskill-enum.md`.
4. Prompt wording must satisfy the selected task contract and exam module.
5. The asset must be original and must not reproduce a real published prompt.
6. `rights.origin` must use a valid provenance enum.
7. Do not add a fixed paragraph count, memorized phrase, vocabulary list, grammar structure, or synthetic band cap as a learner requirement.
8. Do not infer a Writing section band from this prompt or from one task response; scoring is handled by the evaluation contract.

## STOP CONDITIONS
- Unknown controlled ID → return the appropriate `unknown_*` value and STOP.
- Uncertain format fidelity or rights/provenance → `needs_review`.
- Candidate is substantially similar to known published material → reject and generate a different original concept.

## SIDECAR META.YAML SCHEMA (canonical)
```yaml
type: knowledge-asset
asset_kind: writing_prompt
asset_id: KA-NNNNNN
status: draft
version: 0.1.0
owner: colab
derived_from: [KA.Exercise]
framework_refs:
  - file: writing-task-framework
    version: 1.0.7
    nodes: [W_task2_opinion]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: W_t_001.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-writing-prompt, prompt_hash: <hash>, model: <model-id>, parameters: {task_type: W_task2_opinion, exam_module: academic}}
created_at: "2026-08-17T00:00:00Z"
updated_at: "2026-08-17T00:00:00Z"
```

The sidecar is canonical metadata. All generated assets remain `draft` until content/rights review.

## OUTPUT
Two files per prompt:
- `knowledge-assets/writing-prompts/W_t_001.md`
- `knowledge-assets/writing-prompts/W_t_001.meta.yaml`

Validate framework references, duplicate/similarity risk, provenance, and payload checksum before completion.

---KẾT THÚC---
