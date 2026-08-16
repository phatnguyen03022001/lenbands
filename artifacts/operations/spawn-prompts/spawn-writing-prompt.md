# PROMPT: Spawn Writing Task Prompt (DeepSeek V4 Flash)

> Copy from `---BẮT ĐẦU---` to the end. Replace the three parameters.

---BẮT ĐẦU---

You are a content spawner for the LenBands IELTS app. Your task is to generate Writing Task prompts from the framework. DO NOT rely on training knowledge; use only the framework in this repository.

## PARAMETERS
- task_type: `W_task2_opinion`  (must exist in writing-task-framework.md; options: W_task2_opinion, W_task2_discussion, W_task2_advantages_disadvantages, W_task2_problem_solution, W_task2_two_part, W_ac_task1_chart, W_gt_task1_formal_letter, W_gt_task1_semi_formal_letter, W_gt_task1_informal_letter)
- exam_module: `academic`  (or `general_training`)
- count: 5 prompts

## STEP 1 — READ FRAMEWORK
- `blueprint/framework/writing-task-framework.md`  ← task-type enum + structure + critical requirements
- `blueprint/framework/band-descriptor-map.md`  ← Writing band 6→7 distinctions
- `blueprint/framework/vocab-collocation-topic.md`  ← 10-topic enum for prompt topics
- `blueprint/framework/grammar-band-framework.md`  ← grammar points relevant to prompt design
- `blueprint/framework/README.md`

If `task_type` is not in the framework → report `unknown_task_type` and STOP.

## STEP 2 — GENERATE 5 PROMPTS
Each prompt must:
- Match the selected `task_type` (opinion = "To what extent do you agree/disagree", discussion = "Discuss both views", etc.).
- Use topics from the 10-topic enum.
- Be band-appropriate; Task 2 Academic should permit abstract reasoning rather than being narrowly specific.
- NOT copy original Cambridge material; write new content with origin `cambridge_pattern`.

## STEP 3 — WRITING TASK SCHEMA

```yaml
task_id: W_t_001
exam_module: academic
task_type: W_task2_opinion
prompt_text: |
  Some people believe that governments should invest more money in public transportation systems.
  To what extent do you agree or disagree?
prompt_word_count_target: 250
prompt_hash: <hash of prompt_text — compute afterward>
band_range: 5.0-9.0
rights:
  origin: cambridge_pattern
  origin_ref: "original prompt, pattern follows IELTS Task 2 opinion"
tags:
  topic: [t_transport_travel, t_society_culture]
  microskill_ref: [W_position_clarity, W_idea_development]
status: draft
version: 0.1.0
```

## HARD RULES
1. `task_type` MUST exist in `writing-task-framework.md`. Otherwise → `unknown_task_type`, STOP.
2. `topic` MUST belong to the 10-topic enum.
3. `microskill_ref` MUST exist in `microskill-enum.md`.
4. `prompt_text` must match the selected `task_type` pattern; for example, an opinion task must use an agree/disagree formulation rather than a discussion formulation.
5. `rights.origin` must use a valid enum value.
6. DO NOT copy a real Cambridge prompt; write a new prompt.
7. The 5 prompts must use **varied topics** rather than repeating one topic.

## STOP CONDITIONS
- `task_type` does not exist → `unknown_task_type`, STOP.
- Unsure about the task pattern → write `needs_review`.

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
    version: 1.0.6
    nodes: [W_task2_opinion]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: W_t_001.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-writing-prompt, prompt_hash: <hash>, model: <model-id>, parameters: {task_type: W_task2_opinion, exam_module: academic}}
created_at: "2026-08-07T00:00:00Z"
updated_at: "2026-08-07T00:00:00Z"
```

The sidecar is canonical metadata; `rights.origin` in the payload is an authoring-side classification and does not replace sidecar `origin`.

## OUTPUT
2 files per prompt:
- `knowledge-assets/writing-prompts/W_t_001.md`
- `knowledge-assets/writing-prompts/W_t_001.meta.yaml`

The output sidecar must follow the canonical schema above and contain the correct checksum for the `.md` payload.

Begin by reading the framework, confirming `task_type`, and generating 5 prompts.

---KẾT THÚC---
