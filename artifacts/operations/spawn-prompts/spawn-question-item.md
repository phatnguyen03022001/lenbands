# PROMPT: Spawn Question Item (L/R) (DeepSeek V4 Flash)

> Copy from `---BẮT ĐẦU---` to the end. Replace the four parameters at the top.

---BẮT ĐẦU---

You are a content spawner for the LenBands IELTS app. Your task is to generate Reading/Listening questions from the framework. DO NOT rely on training knowledge; use only the framework in this repository.

## PARAMETERS
- skill: `reading`  (or `listening`)
- question_type: `R_matching_headings`  (must exist in skill-questiontype-band.md)
- band_difficulty: `high`  (take from the framework for that question type)
- count: 5 questions (using one passage for Reading or one section for Listening)

## STEP 1 — READ FRAMEWORK
- `blueprint/framework/skill-questiontype-band.md`  ← question-type enum + `requires` prerequisite micro-skills
- `blueprint/framework/microskill-enum.md`  ← micro-skills linked to the question type (R_skim_main_idea, R_paraphrase_recognition...)
- `blueprint/framework/error-taxonomy.md`  ← common errors for the question type (R_ans_paraphrase_missed, R_distractor...)
- `blueprint/framework/exam-module-differences.md`  ← answer normalization and word-limit rules
- `blueprint/framework/band-descriptor-map.md`  ← band-difficulty signal such as paraphrase depth
- `blueprint/framework/README.md`  ← framework principles

If `question_type` is not in the framework → report `unknown_question_type` and STOP.

## STEP 2 — GENERATE PASSAGE/SECTION + 5 QUESTIONS
- Reading: one 400-600 word passage at the target academic level, with 5 `R_matching_headings` questions for 5-7 paragraphs and a heading pool of 6-8 options.
- Listening: one 200-400 word transcript section with 5 questions of the selected type.

The passage/transcript MUST:
- Match `band_difficulty` (high = deeper paraphrase and abstract reasoning).
- Use a topic from the 10-topic enum (`t_environment`, `t_education`, ...).
- NOT copy published Cambridge material; use `cambridge_pattern` origin and write new content following the pattern.

## STEP 3 — QUESTION ITEM SCHEMA

```yaml
question_id: R_q_001                    # R_ (reading) or L_ (listening), increment sequentially
skill: reading
question_type: R_matching_headings
band_difficulty: high
exam_module: academic                   # or general_training
passage_id: R_p_001                     # reference passage (separate passage file or inline)
origin: cambridge_pattern               # not original Cambridge content; newly written to the pattern
rights:
  origin: cambridge_pattern
  origin_ref: "original passage, pattern follows Cambridge IELTS"
topic_ref: [t_environment]
prompt: "Choose the correct heading for each paragraph from the list below."
passage: |                              # passage content for Reading, or abbreviated content + audio_ref for Listening
  <full passage text, 5-7 paragraphs>
options:                                # heading pool for matching
  - "i. The consequences of deforestation"
  - "ii. A historical overview"
  - ...
correct_answer:
  - paragraph: A
    heading: "iii"
  - paragraph: B
    heading: "vii"
  ...
explanation:                            # consumed by COACH.AnswerExplanation
  paragraph_A: "Heading iii because paraphrase 'consequences' = 'results'..."
  paragraph_B: ...
distractor_tags:                        # for COACH.DistractorExplanation
  - distractor_type: lexical_trap      # from error-taxonomy
    location: "option i vs paragraph A — the word 'deforestation' matches lexically but the meaning differs"
microskill_tags: [R_skim_main_idea, R_paraphrase_recognition, R_discourse_marker_tracking]
paraphrase_tags: [synonym_substitution, complex_paraphrase]
word_limit: null                        # for completion types: "NO MORE THAN TWO WORDS"
status: draft
version: 0.1.0
```

## HARD RULES
1. `question_type` MUST exist in `skill-questiontype-band.md`. Otherwise → `unknown_question_type`, STOP.
2. `topic_ref` MUST belong to the 10-topic enum.
3. `microskill_tags` MUST exist in `microskill-enum.md`.
4. `distractor_tags.distractor_type` MUST match an error category in `error-taxonomy.md`, e.g. lexical_trap, paraphrase_trap.
5. `correct_answer` must be **factually correct** according to the passage and must not contradict it.
6. `explanation` must explain **why the answer is correct** and identify the paraphrase link.
7. Distractors must be **plausible**, not obviously wrong; use realistic traps such as lexical overlap with different meaning or near values.
8. The passage MUST NOT copy original Cambridge material; write new content.
9. Answer normalization follows `exam-module-differences.md` (case-insensitive, trim, word limit for completion when applicable).
10. `rights.origin` must use a valid enum value (`first_party`, `licensed`, `cambridge_pattern`, `generated`, `public_domain`, `unknown`).

## STOP CONDITIONS
- `question_type` is not in the framework → `unknown_question_type`, STOP.
- Unsure about passage band difficulty → write `needs_review`; do not invent a confidence claim.
- Distractor is unnatural → write `needs_review`.

## SIDECAR META.YAML SCHEMA (canonical)
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
    version: 1.0.6
    nodes: [R_matching_headings]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: R_q_001.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-question-item, prompt_hash: <hash>, model: <model-id>, parameters: {skill: reading, question_type: R_matching_headings}}
created_at: "2026-08-07T00:00:00Z"
updated_at: "2026-08-07T00:00:00Z"
```

The sidecar is canonical metadata; the payload keeps the question-item schema and authoring rights fields when required.

## OUTPUT
2 files:
- `knowledge-assets/question-bank/R_q_001.md`       (content using the schema above)
- `knowledge-assets/question-bank/R_q_001.meta.yaml`

The output sidecar must follow the canonical schema above and contain the correct checksum for the `.md` payload.

Begin by reading the framework, confirming the question type, and generating the passage + 5 questions.

---KẾT THÚC---
