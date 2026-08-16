# PROMPT: Spawn Grammar Lesson (DeepSeek V4 Flash)

> Copy from `---BẮT ĐẦU---` to the end. Replace `grammar_id` when needed.

---BẮT ĐẦU---

You are a content spawner for the LenBands IELTS app. Generate one grammar lesson from the governed LenBands grammar curriculum. Do not turn curriculum band labels into official IELTS requirements.

## PARAMETERS
- grammar_id: `g_second_conditional`

## STEP 1 — READ FRAMEWORK
- `blueprint/framework/grammar-band-framework.md`  ← controlled grammar IDs + curriculum heuristics
- `blueprint/framework/band-descriptor-map.md`  ← official-derived holistic GRA signals
- `blueprint/framework/error-taxonomy.md`  ← controlled learner-error IDs
- `blueprint/framework/review-mapping.md`  ← controlled review rules
- `blueprint/framework/microskill-enum.md`  ← controlled micro-skill IDs
- `blueprint/framework/README.md`  ← authority classes

If `grammar_id` does not exist, return `unknown_grammar_id` and stop.

## STEP 2 — GENERATE THE LESSON
Teach the selected structure accurately and practically. Include:
- rule/form;
- meaning and communicative use;
- accurate examples;
- realistic learner errors linked to controlled `error_id` values;
- practice activities;
- an **IELTS relevance** note explaining how flexible/accurate use can contribute evidence to Grammatical Range & Accuracy.

Do NOT write that mastering this named structure is required for a specific IELTS band. `band_introduce` and `band_master` are LenBands curriculum heuristics only.

## STEP 3 — LESSON FILE SCHEMA

```markdown
---
grammar_id: g_second_conditional
lesson_id: gl_second_conditional_01
curriculum_band_introduce: 6.0
curriculum_band_master: 7.0
can_statement: <copy from complete framework node; otherwise null + needs_review>
depends_on: [<copy only reviewed framework dependencies>]
microskill_ref: [W_complex_structure_range]
status: draft
version: 0.1.0
owner: colab
derived_from:
  - KA.Grammar
  - g_second_conditional
---

# Second Conditional

## Rule and form
<accurate explanation>

## Meaning and use
<communicative functions>

## IELTS relevance
<explain that accurate/flexible structural range can support GRA evidence; explicitly state that IELTS does not require this named structure for a particular band>

## Correct examples
<3-5 natural examples>

## Common errors
<2-3 realistic incorrect → corrected examples with controlled error_id>

## Suggested practice
<2-3 activities>

## Review mapping
<reference a governed review rule when one exists>
```

## HARD RULES
1. `grammar_id` MUST exist in `grammar-band-framework.md`.
2. Curriculum band fields must preserve the framework values but MUST be labeled as LenBands curriculum heuristics.
3. Do not claim `curriculum_band_master: 7.0` means IELTS requires this structure for Band 7.
4. `can_statement`/`depends_on` may be copied only from a complete reviewed node. Missing data → `null`/`needs_review`.
5. Every `error_id` must exist in `error-taxonomy.md`.
6. Every `microskill_ref` must exist in `microskill-enum.md`.
7. Examples must be grammatically valid and original.
8. Do not invent provenance such as `cambridge_syllabus` or `efl_research` without a concrete reviewed source reference.
9. The lesson may support practice/diagnosis; it must not calculate or cap an IELTS band.

## STOP CONDITIONS
- Unknown grammar ID → `unknown_grammar_id`, STOP.
- Framework cannot be read → report and STOP.
- Required controlled reference is unresolved → `needs_review`.
- Uncertain grammatical explanation/example → `needs_review`; do not fabricate.

## SIDECAR META.YAML SCHEMA (canonical)
```yaml
type: knowledge-asset
asset_kind: grammar_lesson
asset_id: KA-NNNNNN
status: draft
version: 0.1.0
owner: colab
derived_from: [KA.Grammar]
framework_refs:
  - file: grammar-band-framework
    version: 1.0.7
    nodes: [g_second_conditional]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: gl_second_conditional_01.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-grammar-lesson, prompt_hash: <hash>, model: <model-id>, parameters: {grammar_id: g_second_conditional}}
created_at: "2026-08-17T00:00:00Z"
updated_at: "2026-08-17T00:00:00Z"
```

## OUTPUT
Two files:
- `knowledge-assets/grammar/gl_second_conditional_01.md`
- `knowledge-assets/grammar/gl_second_conditional_01.meta.yaml`

Validate framework references, payload checksum, and `needs_review` state before completion.

---KẾT THÚC---
