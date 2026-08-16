# 05 — Content & Knowledge System

This file describes the complete **Knowledge Layer**: Knowledge Assets (system knowledge), Taxonomy, Tagging schema, Question Bank, Colab Workflow, Versioning, and Publishing. It is the foundation for all AI features (`REVIEW.FSRS`, `PRACTICE.Adaptive`, `PERSONAL.Insights`, `COACH.ErrorAnalysis`) — shallow metadata means garbage in, garbage out.

> **IELTS Knowledge Framework**: the domain framework (official-derived descriptors/format facts plus LenBands-controlled question types, micro-skills, errors, grammar/vocabulary curriculum, speaking/writing practice models, and exam-module rules) lives in `blueprint/framework/`. Every `learning_design_profile`, `KA.*` asset, `BAND.Map` curriculum view, `EVAL.*`, and `REVIEW.*` must trace to the correct framework authority class. See `framework/README.md`.

## Knowledge Assets

System knowledge published by Colab and consumed by learners.

| Asset | Description |
|---|---|
| Lesson | Structured lesson by skill, learning stage, and question type |
| Grammar | Grammar point |
| Vocabulary | Vocabulary item with phonetic form, definition, example, collocation, and provisional routing metadata where applicable |
| Collocation | Collocation |
| Template | Writing / Speaking sentence pattern |
| Strategy | Question-type-specific test strategy |
| Example | Worked example such as an essay sample or sample speaking transcript |
| Exercise | Exercise linked to a lesson/knowledge item |

Every asset has a metadata schema defined by the taxonomy below.

## Taxonomy & Tagging (core IP)

This layer is **decisive** for the quality of the entire AI system. Every content item (question, passage, lesson, asset, sample) must carry the applicable governed metadata dimensions; fields that do not apply to a content type must not be fabricated merely to satisfy a generic schema.

### Tag dimensions

| Dimension | Example | Used by |
|---|---|---|
| `skill` | listening / reading / writing / speaking / pronunciation | Routing, filter |
| `band` / `band_range` | provisional LenBands routing metadata, e.g. `6.5-7.5`; never an automatic IELTS score/requirement | Curriculum routing, `PRACTICE.Adaptive` after calibration |
| `question_type` | Existing ID in the corresponding framework; missing registry → `unknown_question_type` | `LEARN.QuestionTypes`, `PERSONAL.Insights` |
| `micro_skill` | Existing ID in the corresponding framework; missing registry → `unknown_microskill` | `PERSONAL.Insights`, `COACH.ErrorAnalysis` |
| `distractor_type` | Registry v1 is not yet defined → `unknown_distractor_type` | `COACH.DistractorExplanation` |
| `paraphrase_pattern` | Registry v1 is not yet defined → `unknown_paraphrase_pattern` | `COACH.DistractorExplanation`, `PERSONAL.Insights` |
| `grammar_point` | Grammar ID in `grammar-band-framework.md`; missing → `unknown_grammar_point` | `COACH.ErrorAnalysis`, source for FSRS cards |
| `ielts_topic` | LenBands-controlled topic ID such as `t_environment`; not an official exhaustive IELTS topic list | `SEARCH.*`, recommendation |
| `difficulty` | `unknown_difficulty` until a calibration run exists; provisional labels must say so | `PRACTICE.Adaptive` |
| `cefr` | optional CEFR label with independent provenance; never derived mechanically from IELTS band metadata | cross-reference only when sourced |
| `estimated_time` | minutes, with method/calibration when used predictively | `STUDY.DailyPlan` |
| `practice_unit` | Pronunciation unit (`P_*`); required when `skill=pronunciation` | `LEARN.Pronunciation`, `EVAL.Pronunciation`, `REVIEW.FSRS` |

### Why tagging depth matters

- `REVIEW.FSRS` can optimize only when a card is mapped to the correct `grammar_point` / `micro_skill`; otherwise the system reviews the wrong unit.
- `PRACTICE.Adaptive` selects questions using calibrated/provisional `difficulty` + `question_type` + `micro_skill`; missing metadata turns selection into randomness, while uncalibrated metadata must not be presented as validated difficulty.
- `PERSONAL.Insights` (for example, "you miss Matching Headings because paraphrase recognition is weak") requires `question_type` + `micro_skill` + `paraphrase_pattern`; without them, the system cannot explain the weakness.
- `COACH.ErrorAnalysis` needs `grammar_point` to recommend the correct lesson.

**This is the hidden cost of Colab:** the metadata workload is large. Tooling must support it through auto-tag suggestions followed by Colab review. Dimensions without a framework registry must not become build inputs; retain `unknown_*` and open a separate decision/evidence path.

### Auto-tagging support

Manual tagging is expensive, so the system provides AI-assisted tag suggestions that Colab reviews:

| Capability | Description |
|---|---|
| `CONTENT.AutoTag` | AI suggests tags for new content (skill, question_type, micro_skill, topic) |
| `CONTENT.TagReview` | Colab reviews/edits suggested tags before publication |

## Question Bank

The question store for objective Listening/Reading items and Writing/Speaking prompts.

| Field | Description |
|---|---|
| `question_id` | unique |
| `skill`, `question_type` | controlled taxonomy |
| `band` / `band_range`, `difficulty`, `calibration_status` | internal routing/calibration metadata; not an IELTS scoring formula |
| `passage_id` / `audio_id` | stimulus reference (L/R) |
| `prompt` | question / task |
| `options` | if MCQ |
| `correct_answer` | answer key |
| `explanation` | used by `COACH.AnswerExplanation` |
| `distractor_tags` | used by `COACH.DistractorExplanation` |
| `micro_skill_tags`, `paraphrase_tags` | used by `PERSONAL.Insights` |
| `version`, `status` | versioning; see below |

## Colab Workflow

```text
Create content
   ↓
Auto-tag (AI suggestion)         ← CONTENT.AutoTag
   ↓
Tag review (Colab review)        ← CONTENT.TagReview
   ↓
Content review                   ← CONTENT.Moderation
   ↓
Publish                          ← CONTENT.Publish
   ↓
Monitor (feedback, performance)  ← CONTENT.Feedback
   ↓
Update / Retire                  ← CONTENT.BlueprintUpdate
```

### Moderation checklist

- Check content errors: factual errors, spelling, incorrect answer key
- Check tags: skill, routing band metadata, question_type, distractor, micro_skill
- Check difficulty/calibration state and evidence
- Check paraphrase/distractor validity
- Unpublish problematic content

### Content Feedback loop

Learner reports an issue → Colab handles it → fix → republish:

```text
Learner Report Content / Suggest Fix / Report Wrong Answer
   ↓                          ← CONTENT.Feedback
Colab reviews (Moderation Queue)
   ↓
Fix (if valid) / Reject (if invalid)
   ↓
Republish (increment version)
   ↓
Notify learner (optional)
```

## Versioning

Every content item has a `version` and `status`:

| Status | Meaning |
|---|---|
| `draft` | Colab is authoring |
| `in_review` | Under moderation |
| `published` | Live for learners |
| `deprecated` | Old; direct links still work, but the item is no longer recommended |
| `retired` | Removed from learner surfaces |

When published content changes, create a new version and preserve the old one so that:
- Assessment History remains valid; a learner who completed the old version still sees the correct historical result
- FSRS cards bound to a version do not become orphaned

## Publishing policy

- Only `published` content is shown to learners.
- `deprecated` remains available through a direct link (for example, an existing bookmark) but is excluded from primary recommendation/search results.
- `retired` is fully hidden.
- When the IELTS blueprint changes, `CONTENT.BlueprintUpdate` performs governed bulk updates and increments versions.

## Scope reminder

- Colab **never scores** Writing/Speaking/Pronunciation (`01-product.md` Role boundaries).
- Colab owns only the content layer, not the evaluation layer.
- Auto-tagging is AI-assisted, but Colab makes the final decision: human-in-the-loop exists for **content**, not evaluation.

## Taxonomy governance

Tags are not free-form text; they require controlled vocabulary, versioning, provenance, and explicit authority.

| Rule | Requirement |
|---|---|
| Controlled values | `skill`, `question_type`, `micro_skill`, `distractor_type`, `paraphrase_pattern`, `grammar_point`, `topic` have enums/versions |
| Required by asset | Questions require answer/explanation; L/R require stimulus/segment; W/S require prompt/rubric; learning assets require objective/estimated time |
| Provenance | Every item has source, license, author, reviewer, created_at, updated_at, and rationale for difficult answers/tags |
| Calibration | Difficulty, routing band metadata, and estimated_time have method, sample size, confidence, and calibration date before being called calibrated |
| Change impact | Changes to tags/answers identify impact on FSRS, recommendation, attempts, search, and published versions |
| Quality status | `draft → tagged → reviewed → calibrated → published`; missing required gates block publication |

### Content type schemas

Question Bank alone cannot represent the entire Knowledge Layer. Separate schemas are required for:

- **Passage/Audio**: section/part, transcript, segment timestamps, speaker, media codec, duration, accessibility transcript, and rights.
- **Lesson/Asset**: objective, prerequisite, explanation, examples, practice links, provisional curriculum routing metadata, estimated time, and mastery evidence.
- **Writing/Speaking prompt**: task type, public-format constraints, rubric version, allowed context, sample answers, and scoring notes. A prompt does not itself own or guarantee a band.
- **Question**: answer normalization, alternate accepted answers, option order, stimulus version, distractor rationale, and exposure limits.

### Controlled coverage matrix — skill, module, question type, and learning bucket

This is a **coverage contract**, not a content inventory and not a description of official Band Descriptors. It fixes the vocabulary that Blueprint, Artifacts, and agents may use when describing a learning design profile. Actual assets, prompts, detailed rubrics, and calibration evidence appear only later.

#### Exam module and learning-band bucket

| Field | Controlled values | Rule |
|---|---|---|
| `exam_module` | `academic`, `general_training`, `shared` | Writing/Reading must declare a module; Listening/Speaking normally use `shared`. |
| `learning_band_bucket` | `3.0-4.5`, `5.0-5.5`, `6.0-6.5`, `7.0-7.5`, `8.0-9.0` | A LenBands scaffold bucket for learning design, not a hard gate, official task difficulty, or scoring result. |
| `learning_stage` | `foundation`, `developing`, `target`, `advanced`, `precision` | Internal names that map respectively to the five learning buckets above. |
| `calibration_status` | `provisional`, `calibrated`, `retired` | Do not call an item calibrated without evidence for method, sample, confidence, and calibration date. |

#### Question-type vocabulary by skill

| Skill | Controlled `question_type` | Minimum micro-skill group to map |
|---|---|---|
| Listening | `L_form_completion`, `L_note_completion`, `L_table_completion`, `L_flow_chart_completion`, `L_summary_completion`, `L_sentence_completion`, `L_map_plan_labelling`, `L_diagram_labelling`, `L_multiple_choice`, `L_matching`, `L_short_answer` | `L_predict_content`, `L_number_date_capture`, `L_signal_word_detection`, `L_distractor_rejection`, `L_spelling_from_audio`, `L_note_concurrent`, `L_follow_direction`, `L_stage_tracking` |
| Reading | `R_multiple_choice`, `R_multiple_choice_multi`, `R_true_false_not_given`, `R_yes_no_not_given`, `R_matching_headings`, `R_matching_information_paragraph`, `R_matching_information_section`, `R_matching_features`, `R_matching_sentence_endings`, `R_sentence_completion`, `R_summary_completion`, `R_note_completion`, `R_table_completion`, `R_flow_chart_completion`, `R_diagram_labelling`, `R_short_answer` | `R_skim_main_idea`, `R_scan_specific_info`, `R_paraphrase_recognition`, `R_abstract_inference`, `R_reference_resolution`, `R_distractor_rejection` |
| Writing | `W_ac_task1_chart`, `W_ac_task1_table`, `W_ac_task1_process`, `W_ac_task1_map`, `W_ac_task1_diagram`, `W_gt_task1_formal_letter`, `W_gt_task1_semi_formal_letter`, `W_gt_task1_informal_letter`, `W_task2_opinion`, `W_task2_discussion`, `W_task2_advantages_disadvantages`, `W_task2_problem_solution`, `W_task2_two_part` | `W_task_analysis`, `W_position_clarity`, `W_idea_development`, `W_overview_t1`, `W_paragraph_topic_sentence`, `W_cohesive_device_range`, `W_lexical_precision`, `W_complex_structure_range`, `W_punctuation_control` |
| Speaking | `S_part1_interview`, `S_part2_long_turn`, `S_part3_discussion` | `S_extend_answer`, `S_cue_card_structure`, `S_abstract_reasoning`, `S_discourse_marker_use`, `S_paraphrase_spontaneous`, `S_self_correction_fluency`, `S_complex_grammar_speak`, `S_intonation_meaning`, `S_phoneme_target` |

#### Learning progression behavior

Every `learning_design_profile` must select **one** learning bucket and describe the corresponding internal teaching behavior. These stages are LenBands scaffolding; they are not official IELTS subscales and do not themselves prove a band.

| Learning bucket / stage | Learning design | Feedback and practice | Minimum evidence of curriculum progress |
|---|---|---|---|
| `3.0-4.5` / foundation | Break tasks into smaller units, guided vocabulary, one observable goal | Short feedback, one priority error, scaffolded practice | Complete unit task + supported recall/retest |
| `5.0-5.5` / developing | Connect micro-skill to question type and reduce hints step by step | Explain why the answer is wrong and provide one alternative strategy | Retest the same error pattern with fewer hints |
| `6.0-6.5` / target | Moderate timed practice and trade-offs between criteria | Evidence from the answer/writing, prioritizing errors that affect outcome | Stable performance across multiple equivalent prompts/items |
| `7.0-7.5` / advanced | More complex tasks with higher paraphrase/inference/precision demands | Compare options and surface nuance and consistency | Unscaffolded retest with lower error recurrence |
| `8.0-9.0` / precision | Optimize accuracy, flexibility, and risk control | Less frequent but deeper feedback; avoid template overfitting | Evidence across multiple contexts plus anti-gaming checks |

#### Completeness rule

An Artifact describing a lesson, practice, evaluation, or review must declare at minimum: `skill`, `exam_module`, `learning_band_bucket`, `learning_stage`, `target_micro_skills`, `evaluation_rule`, `review_mapping`, and `calibration_status`. `question_type` is required for Listening/Reading/Writing/Speaking; `practice_unit` is required for Pronunciation. If a skill-specific field is missing, the artifact remains a concept and cannot become a build-ready spec.

## Skill × Question Type × Learning Bucket Framework

The Blueprint does not need to list every asset or lesson, but every learning design must be expressible as `skill × question_type × learning_band_bucket`. This is the standard unit used later to create Vertical Slice Specs, rubrics, practice rules, and review rules.

```yaml
learning_design_profile:
  skill: writing | reading | listening | speaking | pronunciation
  exam_module: academic | general_training | shared
  question_type: <controlled value; required except pronunciation>
  practice_unit: []              # required for pronunciation; P_* from framework
  learning_band_bucket: <one controlled bucket, e.g. 5.0-5.5>
  learning_stage: foundation | developing | target | advanced | precision
  calibration_status: provisional | calibrated | retired
  learner_outcome: <observable outcome>
  prerequisite: []
  target_micro_skills: []
  difficulty_signals: []
  practice_mode: []
  evaluation_rule: <rubric/answer rule reference>
  feedback_priority: []
  review_mapping: <error/review rule reference>
  progressive_disclosure: <what is shown/hidden>
  acceptance_evidence: <how improvement is verified>
```

Invariant rules:

- `skill`, `question_type`, and `learning_band_bucket` use controlled vocabulary/versioning; do not use free text.
- Knowledge Asset payloads may retain `band_range` for provisional routing in `N.N-N.N` format (for example `6.5-7.5`). The authoring contract may use `target_band_range: [min, max]`; these fields must not be confused with an assessed IELTS band.
- A learning bucket may guide scaffolding, feedback depth, and progressive disclosure, but it does not lock learners out of useful content or produce a score.
- Every profile has an outcome and verification evidence, not merely a "lesson" or "practice" label.
- A Vertical Slice Spec may cover several profiles with identical behavior, but it must list exactly which profiles are in scope.
- Agents must not infer missing profiles into content, rubrics, or band requirements.

### Content quality gates

Before publication, Colab must satisfy:

1. correctness and answer key independently checked;
2. taxonomy completeness with no tags outside controlled vocabulary;
3. difficulty/routing-band metadata backed by calibration evidence or explicitly marked `provisional`;
4. explanation leads to one concrete learning action;
5. accessibility, licensing, media integrity, and version relationships are valid;
6. no duplicate exposure or leakage is introduced into exam simulation.

### Cost-aware content operations

- Auto-tag in batches, cache by content hash, and re-tag only changed portions.
- Use rules/lookups before models; use a smaller model for tag suggestions and escalate only ambiguous items.
- Precompute explanations/embeddings at publication; do not regenerate them for every learner when context is unchanged.
- Track cost per published item, explanation, and learner outcome; high-cost content with low outcome must be reviewed.

## Cross-references

- Related capability IDs: `CONTENT.*`, `KA.*` → `03-features.md`
- Tagging feeds: `PRACTICE.Adaptive`, `PERSONAL.Insights`, `COACH.*`, `REVIEW.FSRS` → `03-features.md`, `06-engines.md`
- Workflow emotional UX → `04-experience.md` (the Colab journey is an operator journey outside the eight learner journeys)
