# PROMPT: Spawn Grammar Lesson (DeepSeek V4 Flash)

> Copy from `---BẮT ĐẦU---` to the end. Replace `grammar_id` when needed.

---BẮT ĐẦU---

You are a content spawner for the LenBands IELTS app. Your task is to generate one grammar lesson from the framework. DO NOT rely on training knowledge; use only the framework in this repository.

## PARAMETERS
- grammar_id: `g_second_conditional`  (change this only when spawning another grammar point that exists in grammar-band-framework.md)
- band_master: 7.0  (take from the framework; do not invent)

## STEP 1 — READ FRAMEWORK
- `blueprint/framework/grammar-band-framework.md`  ← 47 grammar points + node schema (band_introduce, band_master, depends_on, done_when, can_statement)
- `blueprint/framework/error-taxonomy.md`  ← grammar-linked errors such as W_gra_complex_with_error
- `blueprint/framework/review-mapping.md`  ← review rules for grammar errors
- `blueprint/framework/microskill-enum.md`  ← grammar-linked micro-skills such as W_complex_structure_range
- `blueprint/framework/README.md`  ← controlled-vocabulary principles

If `grammar_id` is not in the framework → report `unknown_grammar_id` and STOP.

## STEP 2 — GENERATE LESSON
The lesson must teach the grammar point at `band_master` depth. Include: rule, form, usage, band signal (how it supports higher-band performance), correct examples, incorrect examples showing common errors, and suggested exercises.

## STEP 3 — LESSON FILE SCHEMA

```markdown
---
grammar_id: g_second_conditional
lesson_id: gl_second_conditional_01
band_master: 7.0
band_introduce: 6.0
can_statement: <copy verbatim from the framework node>
depends_on: [<copy from the framework node>]
microskill_ref: [W_complex_structure_range]
status: draft
version: 0.1.0
owner: colab
derived_from:
  - KA.Grammar
  - g_second_conditional
---

# Second Conditional

## Rule
<definition, form, usage>

## Form
<if + past simple, would + bare infinitive; example sentences showing the form>

## Usage
<when to use it: hypothetical present/future, advice, imagination>

## Band signal (6.0 → 7.0)
<why second conditional can support higher-band grammar performance: complex structure, hypothetical reasoning>

## Correct examples
<3-5 accurate, natural sentences, linked to IELTS topics where appropriate>

## Common errors (linked to error-taxonomy)
<2-3 common errors in incorrect → corrected form, with error_id from error-taxonomy.md>

## Suggested practice
<2-3 exercises: sentence transformation, gap fill, applied writing task>

## Review mapping
<reference the review rule from review-mapping.md for the error linked to this grammar point>
```

## HARD RULES
1. `grammar_id` MUST exist in `grammar-band-framework.md`. Otherwise → `unknown_grammar_id`, STOP.
2. `band_master`, `band_introduce`, `can_statement`, and `depends_on` must be copied **verbatim** from the framework node; do not rewrite them.
3. Every `error_id` in "Common errors" MUST exist in `error-taxonomy.md`.
4. `microskill_ref` MUST exist in `microskill-enum.md`.
5. Correct examples must be genuine grammatical English and use the second conditional correctly.
6. Incorrect examples must represent realistic learner errors, e.g. "If I will have money, I would travel" → incorrect `will` in the if-clause.
7. DO NOT invent error IDs or micro-skill IDs outside the enum.
8. If the framework contains only a summary table and lacks `can_statement` or edge provenance, write `null`/`needs_review`; do not fabricate a field as if it came from the framework.

## STOP CONDITIONS
- `grammar_id` is absent from the framework → `unknown_grammar_id`, STOP.
- Framework file cannot be read → report it and STOP.
- Uncertain about an example/form → write `needs_review`; DO NOT invent.

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
    version: 1.0.6
    nodes: [g_second_conditional]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: gl_second_conditional_01.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-grammar-lesson, prompt_hash: <hash>, model: <model-id>, parameters: {grammar_id: g_second_conditional}}
created_at: "2026-08-07T00:00:00Z"
updated_at: "2026-08-07T00:00:00Z"
```

The sidecar is canonical metadata; do not duplicate `grammar_id`, `band_master`, or lesson content into the sidecar except where lineage/framework audit fields require it.

## OUTPUT
2 files:
- `knowledge-assets/grammar/gl_second_conditional_01.md`       (lesson content)
- `knowledge-assets/grammar/gl_second_conditional_01.meta.yaml`

The output sidecar must follow the canonical schema above and contain the correct checksum for the `.md` payload.

Begin by reading the framework, confirming that `grammar_id` exists, and then generating the lesson.

---KẾT THÚC---
