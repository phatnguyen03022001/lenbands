---
version: 1.0.6
scope: framework
---

# Error Taxonomy (per skill)

Status: `framework` — versioned controlled vocabulary. Classifies learner errors by skill. Feeds `COACH.ErrorAnalysis`, `REVIEW.MistakeNotebook` tags, and `BAND.Map` ⚠/✗ items.

Conventions:
- `error_id` uses `{skill}_{category}_{specific}` snake_case and is versioned.
- Every error has `criterion_impact` (affected criterion), `band_signal` (band range where the error commonly appears), and `microskill_ref` (related micro-skill when one exists).
- `criterion_impact` is a controlled enum: `TR`, `CC`, `LR`, `GRA`, `FC`, `PR`, `answer-key`, `strategy`, `TR_TASK1`, `TR_LR`.
- `band_signal` is a one-decimal IELTS value (`5.0`) or `all_bands`; prose/free-form text is not allowed in this field.
- This is an **error taxonomy**, not an error-remediation model; remediation lives in `review-mapping.md`.

## Node schema (each error)

Each error is a node that owns its resolved condition inline. There is no central "error mastery file".

```yaml
error_id: W_gra_relative_clause
category: grammar
description: Incorrect relative clause (who/which/that)
criterion_impact: GRA
band_signal: 6.5
microskill_ref: [W_complex_structure_range]
resolve_when:
  no_recurrence_in_recent_n_submissions: 3    # no recurrence in the 3 most recent Writing submissions
  retest_accuracy_pct: 90                      # retest of the same error pattern reaches 90%
  review_card_state: review                    # error-linked FSRS card has graduated from Learning/Relearning
```

Conventions:
- `resolve_when` is an AND condition for moving an error from `open` → `improved` in `REVIEW.MistakeNotebook`.
- `no_recurrence_in_recent_n_submissions`: number of recent submissions/attempts without recurrence, default 3.
- `review_card_state: review` means the FSRS card has passed Learning and is in stable Review state.

## Listening — error taxonomy

| error_id | Category | Description | criterion_impact | band_signal | microskill_ref |
|---|---|---|---|---|---|
| `L_ans_wrong_content` | content | Misunderstands the content and selects the wrong factual answer | answer-key | 4.0 | `L_signal_word_detection` |
| `L_ans_distractor_lexical` | distractor | Falls for a lexical distractor trap (same word, different meaning) | answer-key | 6.0 | `L_distractor_rejection` |
| `L_ans_distractor_number` | distractor | Falls for a numerical trap (near value, changed unit) | answer-key | 5.5 | `L_distractor_rejection` |
| `L_ans_paraphrase_missed` | comprehension | Misses a paraphrase between stem and audio | answer-key | 6.0 | `L_paraphrase_recognition` |
| `L_spelling_error` | spelling | Misspells a heard word | answer-key | 4.5 | `L_spelling_from_audio` |
| `L_word_boundary` | listening | Fails to distinguish word boundaries (e.g. an apple vs a napple) | answer-key | 5.0 | `unknown_microskill` (framework has no dedicated segmentation node yet) |
| `L_ans_number_format` | normalization | Uses the wrong number/date/phone/currency format despite hearing the value correctly | answer-key | 5.0 | `L_number_date_capture` |
| `L_ans_unit_missing` | normalization | Omits a required unit such as kg or pounds | answer-key | 5.0 | `L_number_date_capture` |
| `L_note_incomplete` | note-taking | Misses information because note-taking cannot keep pace | answer-key | 6.5 | `L_note_concurrent` |
| `L_direction_lost` | spatial | Loses spatial orientation in a map task | answer-key | 5.5 | `L_follow_direction` |
| `L_abstract_inference_missed` | inference | Misses implied meaning | answer-key | 7.5 | `L_abstract_inference` |
| `L_overtime_spent` | strategy | Spends too long on one item and misses later information | strategy | 5.5 | — |

## Reading — error taxonomy

| error_id | Category | Description | criterion_impact | band_signal | microskill_ref |
|---|---|---|---|---|---|
| `R_ans_wrong_passage_loc` | location | Looks in the wrong paragraph/section (local vs global) | answer-key | 6.5 | `R_global_vs_local` |
| `R_ans_distractor_lexical` | distractor | Falls for a lexical trap based on matching words | answer-key | 6.0 | `R_distractor_rejection` |
| `R_ans_paraphrase_missed` | comprehension | Misses a paraphrase | answer-key | 6.0 | `R_paraphrase_recognition` |
| `R_tfng_false_vs_notgiven` | classification | Confuses false (contradicted) with not given (absent) | answer-key | 6.0 | `R_not_given_vs_false` |
| `R_tfng_writer_vs_fact` | classification | Confuses writer opinion (yes/no) with factual truth (true/false) | answer-key | 6.5 | `R_writer_attitude_inference` |
| `R_heading_wrong_main_idea` | comprehension | Chooses a detail-trap heading rather than the main idea | answer-key | 6.5 | `R_skim_main_idea` |
| `R_completion_word_form` | grammar | Uses the wrong word form (noun vs verb) | answer-key | 5.5 | `R_summary_gap_strategy` |
| `R_completion_over_limit` | instruction | Exceeds the permitted word count | answer-key | 5.0 | — |
| `R_completion_not_in_passage` | fact | Writes an idea that is not in the passage | answer-key | 5.5 | — |
| `R_reference_misread` | reference | Misreads a reference such as this/these | answer-key | 5.5 | `R_reference_resolution` |
| `R_overtime_spent` | strategy | Spends too long on one question | strategy | 5.5 | — |

## Writing — error taxonomy

| error_id | Category | Description | criterion_impact | band_signal | microskill_ref |
|---|---|---|---|---|---|
| `W_tr_task_missed_part` | task response | Omits part of the task, e.g. answers only one side of "discuss both views" | TR | 5.0 | `W_task_analysis` |
| `W_tr_position_unclear` | task response | Position is unclear or changes | TR | 6.0 | `W_position_clarity` |
| `W_tr_idea_undeveloped` | task response | Main idea is stated but unsupported/undeveloped | TR | 6.5 | `W_idea_development` |
| `W_tr_off_topic` | task response | Goes off-topic | TR | 4.0 | `W_task_analysis` |
| `W_tr_under_wordcount` | task response | Below 250 words (Task 2) / 150 words (Task 1) | TR | all_bands | — |
| `W_cc_no_paragraphing` | coherence | Missing paragraphing or illogical paragraph structure | CC | 5.0 | `W_paragraph_topic_sentence` |
| `W_cc_mechanical_cohesive` | coherence | Cohesive devices are mechanical/repetitive | CC | 6.0 | `W_cohesive_device_range` |
| `W_cc_topic_sentence_unclear` | coherence | Topic sentence is unclear | CC | 6.0 | `W_paragraph_topic_sentence` |
| `W_cc_progression_unclear` | coherence | Overall logical progression is unclear | CC | 5.5 | — |
| `W_lr_repetitive` | lexical | Repeats basic vocabulary such as good/important/bad | LR | 5.0 | `W_lexical_precision` |
| `W_lr_wrong_collocation` | lexical | Uses an incorrect collocation, e.g. do a mistake vs make a mistake | LR | 6.5 | `W_collocation_awareness` |
| `W_lr_word_form_error` | lexical | Uses the wrong word form, e.g. success vs successful | LR | 5.5 | — |
| `W_lr_spelling` | lexical | Spelling error | LR | 5.0 | — |
| `W_lr_paraphrase_task_mis` | lexical | Paraphrases the task with changed meaning | LR | 6.5 | `W_paraphrase_task` |
| `W_gra_only_simple` | grammar | Uses only simple sentences and no complex structures | GRA | 5.0 | `W_complex_structure_range` |
| `W_gra_complex_with_error` | grammar | Attempts complex structures with many errors | GRA | 6.0 | `W_complex_structure_range` |
| `W_gra_tense` | grammar | Uses the wrong tense | GRA | 4.5 | — |
| `W_gra_subject_verb` | grammar | Subject-verb agreement error | GRA | 5.0 | — |
| `W_gra_article` | grammar | Incorrect/missing article (a/an/the) | GRA | 5.5 | — |
| `W_gra_punctuation` | grammar | Punctuation error such as comma splice or run-on | GRA | 6.5 | `W_punctuation_control` |
| `W_gra_relative_clause` | grammar | Incorrect relative clause (who/which/that) | GRA | 6.5 | `W_complex_structure_range` |
| `W_t1_no_overview` | task1 | Missing overview, a required Task 1 element | TR_TASK1 | 5.0 | `W_overview_t1` |
| `W_t1_detail_dump` | task1 | Lists all figures instead of selecting trends/features | TR_TASK1 | 6.0 | `W_data_selection_t1` |
| `W_t1_opinion_injected` | task1 | Adds personal opinion to a neutral Task 1 response | TR_TASK1 | 5.0 | — |
| `W_letter_wrong_tone` | gt_letter | Uses the wrong tone/register for the letter type | TR_LR | 6.0 | `W_tone_register_letter` |

## Speaking — error taxonomy

| error_id | Category | Description | criterion_impact | band_signal | microskill_ref |
|---|---|---|---|---|---|
| `S_fc_short_answer` | fluency | Gives a short yes/no answer without extension | FC | 5.0 | `S_extend_answer` |
| `S_fc_long_pause` | fluency | Long pause (>5s) breaks flow | FC | 5.5 | `S_long_turn_sustain` |
| `S_fc_repetition` | fluency | Repeats words/sentences excessively | FC | 5.5 | — |
| `S_fc_off_topic` | fluency | Goes off-topic | FC | 5.5 | — |
| `S_fc_part2_under_time` | fluency | Part 2 ends before 1 minute | FC | 6.0 | `S_cue_card_structure` |
| `S_fc_part3_no_develop` | fluency | Part 3 answer is short and does not defend/develop a view | FC | 6.5 | `S_abstract_reasoning` |
| `S_fc_no_discourse_marker` | fluency | Uses no discourse markers/connectors | FC | 6.0 | `S_discourse_marker_use` |
| `S_lr_repetitive` | lexical | Repeats vocabulary | LR | 5.5 | `S_paraphrase_spontaneous` |
| `S_lr_limited_paraphrase` | lexical | Cannot paraphrase when a word is forgotten | LR | 6.5 | `S_paraphrase_spontaneous` |
| `S_lr_wrong_collocation` | lexical | Uses an incorrect collocation | LR | 6.5 | `S_idiomatic_use` |
| `S_lr_no_idiom` | lexical | Does not use idiomatic language expected at higher bands | LR | 7.0 | `S_idiomatic_use` |
| `S_gra_only_simple` | grammar | Uses only simple structures | GRA | 5.5 | `S_complex_grammar_speak` |
| `S_gra_tense` | grammar | Tense error | GRA | 5.0 | — |
| `S_gra_subject_verb` | grammar | Agreement error | GRA | 5.5 | — |
| `S_pr_phoneme` | pronunciation | Incorrect target phoneme (/θ/ /ð/ /æ/) | PR | 6.0 | `S_phoneme_target` / `P_phoneme_targeted` |
| `S_pr_word_stress` | pronunciation | Incorrect word stress | PR | 6.0 | `P_word_stress_rule` |
| `S_pr_sentence_stress` | pronunciation | Flat sentence stress without clear content-word prominence | PR | 6.5 | `S_sentence_stress_content` |
| `S_pr_intonation_flat` | pronunciation | Flat intonation that does not convey meaning/attitude | PR | 7.0 | `S_intonation_meaning` |
| `S_pr_fast_unintelligible` | pronunciation | Speaks too fast and becomes unclear | PR | 5.5 | — |

## Strategy errors (cross-skill, not criterion-owned)

| error_id | Description |
|---|---|
| `X_time_management` | Spends too long on one question/section and cannot finish |
| `X_instruction_misread` | Misreads instructions such as word limit or number of options |
| `X_answer_transfer_wrong` | Transfers an answer incorrectly on Listening/Reading answer sheet |
| `X_skip_and_not_return` | Skips a question and never returns to it |

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — audited error IDs and microskill references; no untracked taxonomy ID is silently introduced.
- `version: 1.0.5` — converted `criterion_impact` and `band_signal` cells to controlled values; no new error node added.
- `version: 1.0.6` — normalized the per-file release record; taxonomy nodes are unchanged.
- Addition: bump minor; description-only correction: patch; removal: `deprecated_in` rather than deletion.

## Do not infer

Mistake Notebook tags, Error Graph nodes, and `COACH.ErrorAnalysis` output must use `error_id` values from this taxonomy. An unclassified error becomes `unknown_error` and is flagged for Colab to add.
