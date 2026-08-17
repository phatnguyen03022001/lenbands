# PROMPT: Spawn Question Item (Listening/Reading) (DeepSeek V4 Flash)

> Copy from `---BẮT ĐẦU---` to the end. Replace the parameters at the top.

---BẮT ĐẦU---

You are a content spawner for the LenBands IELTS app. Generate original Listening/Reading question assets from the governed framework. Do not invent IELTS format, difficulty, scoring, or answer-normalization rules from training knowledge.

## PARAMETERS

- skill: `reading`  # `reading` or `listening`
- question_type: `R_matching_headings`
- exam_module: `academic`
- count: 5

## STEP 1 — READ FRAMEWORK

- `blueprint/framework/skill-questiontype-band.md` — controlled LenBands task IDs mapped to public IELTS task families
- `blueprint/framework/microskill-enum.md` — controlled micro-skill IDs
- `blueprint/framework/error-taxonomy.md` — controlled learner-error IDs
- `blueprint/framework/exam-module-differences.md` — module routing, answer-normalization authority, score-conversion boundary
- `blueprint/framework/README.md` — authority classes

If `question_type`, topic, micro-skill, or required error ID is missing, return the relevant `unknown_*` value and stop.

## STEP 2 — GENERATE ORIGINAL STIMULUS + ITEMS

For Reading, generate an original passage/source-text set appropriate to the selected module and selected controlled task type.

For Listening, generate an original transcript/script plus item set appropriate to the selected controlled task type. `L_summary_completion` is a valid Listening ID and must be supported when selected.

Rules:
- Do not copy or closely paraphrase published IELTS/Cambridge passages, recordings, transcripts, or questions.
- Use `origin: generated` for newly authored LenBands content.
- A question type does not have an official IELTS band. If provisional item difficulty is needed for authoring, store it separately as `difficulty_status: provisional` and do not use it for scoring.
- Difficulty depends on the actual stimulus/item, distractors, inference load, language, and learner population; do not infer it from question-type identity alone.
- Listening/Reading scoring is answer-key based. Exact raw-score-to-band conversion is outside an individual item and must use an approved versioned conversion source.
- Answer normalization is item-key/config specific. Do not globally accept arbitrary synonyms, article deletion, plural changes, or format variants.

## QUESTION ITEM SCHEMA

```yaml
question_id: R_q_001
skill: reading
question_type: R_matching_headings
exam_module: academic
stimulus_ref: R_p_001
topic_ref: [t_environment]
difficulty:
  status: provisional
  label: high
  evidence_ref: null
prompt: "Choose the correct heading for each paragraph from the list below."
options: []
correct_answer: []
answer_normalization:
  rules: []
explanation:
  evidence_refs: []
  rationale: ""
error_tags: [R_ans_distractor_lexical, R_ans_paraphrase_missed]
microskill_tags: [R_skim_main_idea, R_paraphrase_recognition]
rights:
  origin: generated
  origin_ref: "original LenBands item following a public IELTS task family"
status: draft
version: 0.1.0
```

For completion items, include the exact instruction/word limit and an explicit accepted-answer registry. For T/F/NG or Y/N/NG, explanations must distinguish the required evidence semantics. For map/plan/diagram tasks, stimulus labels/coordinates must be versioned rather than inferred dynamically.

## HARD RULES

1. `question_type` MUST exist in `skill-questiontype-band.md`.
2. `topic_ref` MUST belong to the LenBands topic enum used by the content system.
3. Every `microskill_tags` value MUST exist in `microskill-enum.md`.
4. Every `error_tags` value MUST exist in `error-taxonomy.md`; categories or approximate substrings are not valid IDs.
5. The correct answer must be fully supported by the generated stimulus.
6. Explanations must cite the relevant stimulus evidence and explain why the answer is supported.
7. Distractors must be plausible but unambiguously wrong under the evidence.
8. Do not copy published test content or label generated content as Cambridge-derived.
9. Normalization follows the reviewed item key and `exam-module-differences.md`.
10. `difficulty` is provisional unless a governed calibration record exists; never convert it directly into an IELTS band.
11. A question item never owns the raw-score-to-band conversion table.
12. Output remains `draft` until content, rights, and quality review.

## STOP CONDITIONS

- Unknown controlled ID → return the relevant `unknown_*` value and STOP.
- Uncertain format fidelity, answer-key correctness, or rights/provenance → `needs_review`.
- Candidate content substantially resembles known published material → reject it and generate a different original stimulus.

## SIDECAR META.YAML SCHEMA

```yaml
type: knowledge-asset
asset_kind: question_item
asset_id: KA-NNNNNN
status: draft
version: 0.1.0
owner: colab
derived_from: [KA.Exercise]
framework_refs:
  - file: skill-questiontype-band
    version: 1.1.0
    nodes: [R_matching_headings]
  - file: microskill-enum
    version: 1.0.7
    nodes: [R_skim_main_idea, R_paraphrase_recognition]
  - file: error-taxonomy
    version: 1.0.7
    nodes: [R_ans_paraphrase_missed, R_ans_distractor_lexical]
  - file: exam-module-differences
    version: 1.0.7
    sections: ["Listening/Reading — raw score → band authority"]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: R_q_001.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-question-item, prompt_hash: <hash>, model: <model-id>, parameters: {skill: reading, question_type: R_matching_headings}}
created_at: "2026-08-17T00:00:00Z"
updated_at: "2026-08-17T00:00:00Z"
```

## OUTPUT

- `knowledge-assets/questions/<question_id>.md`
- `knowledge-assets/questions/<question_id>.meta.yaml`

Validate all framework references, answer evidence, provenance, duplicates/similarity risk, and payload checksum before completion. List any `unknown_*` or `needs_review` states.

---KẾT THÚC---
