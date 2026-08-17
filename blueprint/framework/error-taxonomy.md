---
version: 1.0.7
scope: framework
---

# Error Taxonomy (per skill)

Status: `framework` — LenBands-controlled learner-error vocabulary. Feeds `COACH.ErrorAnalysis`, `REVIEW.MistakeNotebook`, diagnostic analytics, and review mapping.

Authority:
- `error_id`, category, and controlled criterion links are LenBands internal diagnostic constructs.
- `criterion_impact` means the observation is relevant to that assessment criterion; it does **not** mean one occurrence mechanically lowers the criterion band.
- `band_signal` is retained as an experimental diagnostic/routing heuristic for backward compatibility. It is not an official IELTS threshold and must not cap/award a band.
- Scoring remains holistic for Writing/Speaking and answer-key based for Listening/Reading.

Conventions:
- `error_id`: `{skill}_{category}_{specific}`, versioned and never silently deleted once referenced.
- `criterion_impact`: controlled enum `TR`, `CC`, `LR`, `GRA`, `FC`, `PR`, `answer-key`, `strategy`, `TR_TASK1`, `TR_LR`.
- `band_signal`: one-decimal heuristic value or `all_bands`.
- Remediation lives in `review-mapping.md`.

## Node schema

```yaml
error_id: W_gra_relative_clause
category: grammar
description: Relative-clause error that affects clarity or grammatical control
criterion_impact: GRA
band_signal: 6.5                 # provisional LenBands diagnostic heuristic
calibration_status: provisional
microskill_ref: [W_complex_structure_range]
resolve_when:
  no_recurrence_in_recent_n_submissions: 3
  retest_accuracy_pct: 90
  review_card_state: review
```

`resolve_when` is an internal remediation state, not proof of an IELTS band.

## Listening — error taxonomy

| error_id | Category | Description | criterion_impact | band_signal | microskill_ref |
|---|---|---|---|---|---|
| `L_ans_wrong_content` | content | Misunderstands content and selects/provides an unsupported answer | answer-key | 4.0 | `L_signal_word_detection` |
| `L_ans_distractor_lexical` | distractor | Chooses a lexical near-match that is not the correct answer | answer-key | 6.0 | `L_distractor_rejection` |
| `L_ans_distractor_number` | distractor | Chooses a revised/near numerical value instead of the required value | answer-key | 5.5 | `L_distractor_rejection` |
| `L_ans_paraphrase_missed` | comprehension | Misses a relevant paraphrase between question and audio | answer-key | 6.0 | `L_paraphrase_recognition` |
| `L_spelling_error` | spelling | Spelling makes an otherwise identified answer incorrect under the item key | answer-key | 4.5 | `L_spelling_from_audio` |
| `L_word_boundary` | listening | Segments the speech stream incorrectly | answer-key | 5.0 | `unknown_microskill` |
| `L_ans_number_format` | normalization | Answer representation is outside the reviewed accepted-normalization set | answer-key | 5.0 | `L_number_date_capture` |
| `L_ans_unit_missing` | normalization | Omits a unit that the item/key requires | answer-key | 5.0 | `L_number_date_capture` |
| `L_note_incomplete` | note-taking | Misses relevant information while attempting concurrent note-taking | answer-key | 6.5 | `L_note_concurrent` |
| `L_direction_lost` | spatial | Loses the spatial relation required by a map/plan task | answer-key | 5.5 | `L_follow_direction` |
| `L_abstract_inference_missed` | inference | Misses an inference supported by the recording | answer-key | 7.5 | `L_abstract_inference` |
| `L_overtime_spent` | strategy | Attention remains on one item and contributes to missing later information | strategy | 5.5 | — |

## Reading — error taxonomy

| error_id | Category | Description | criterion_impact | band_signal | microskill_ref |
|---|---|---|---|---|---|
| `R_ans_wrong_passage_loc` | location | Searches/interprets the wrong text region | answer-key | 6.5 | `R_global_vs_local` |
| `R_ans_distractor_lexical` | distractor | Selects a lexical near-match unsupported by the required meaning | answer-key | 6.0 | `R_distractor_rejection` |
| `R_ans_paraphrase_missed` | comprehension | Misses a relevant paraphrase | answer-key | 6.0 | `R_paraphrase_recognition` |
| `R_tfng_false_vs_notgiven` | classification | Confuses contradiction with absence of information | answer-key | 6.0 | `R_not_given_vs_false` |
| `R_tfng_writer_vs_fact` | classification | Confuses writer view/claim with factual-information classification | answer-key | 6.5 | `R_writer_attitude_inference` |
| `R_heading_wrong_main_idea` | comprehension | Chooses a detail/partial-match heading rather than the main idea | answer-key | 6.5 | `R_skim_main_idea` |
| `R_completion_word_form` | grammar | Supplies a word/form that does not satisfy the item/key | answer-key | 5.5 | `R_summary_gap_strategy` |
| `R_completion_over_limit` | instruction | Exceeds the word/number limit stated in the item | answer-key | 5.0 | — |
| `R_completion_not_in_passage` | fact | Supplies information unsupported by the required source text | answer-key | 5.5 | — |
| `R_reference_misread` | reference | Resolves a textual reference incorrectly | answer-key | 5.5 | `R_reference_resolution` |
| `R_overtime_spent` | strategy | Time allocation contributes to unfinished/lower-quality later responses | strategy | 5.5 | — |

## Writing — error taxonomy

| error_id | Category | Description | criterion_impact | band_signal | microskill_ref |
|---|---|---|---|---|---|
| `W_tr_task_missed_part` | task response | A required part of the actual prompt is not addressed | TR | 5.0 | `W_task_analysis` |
| `W_tr_position_unclear` | task response | Position is unclear/inconsistent where the task requires a position | TR | 6.0 | `W_position_clarity` |
| `W_tr_idea_undeveloped` | task response | Relevant main idea lacks sufficient development/support | TR | 6.5 | `W_idea_development` |
| `W_tr_off_topic` | task response | Material is irrelevant to the task | TR | 4.0 | `W_task_analysis` |
| `W_tr_under_wordcount` | task response | Response is below the official minimum word count | TR | all_bands | — |
| `W_cc_no_paragraphing` | coherence | Organisation/paragraphing is ineffective for the response | CC | 5.0 | `W_paragraph_topic_sentence` |
| `W_cc_mechanical_cohesive` | coherence | Cohesive resources are repetitive/mechanical enough to affect quality | CC | 6.0 | `W_cohesive_device_range` |
| `W_cc_topic_sentence_unclear` | coherence | Paragraph purpose/central idea is unclear | CC | 6.0 | `W_paragraph_topic_sentence` |
| `W_cc_progression_unclear` | coherence | Logical progression is difficult to follow | CC | 5.5 | — |
| `W_lr_repetitive` | lexical | Lexical repetition limits precision/flexibility | LR | 5.0 | `W_lexical_precision` |
| `W_lr_wrong_collocation` | lexical | Collocational choice is inaccurate/inappropriate | LR | 6.5 | `W_collocation_awareness` |
| `W_lr_word_form_error` | lexical | Word-form choice is inaccurate | LR | 5.5 | — |
| `W_lr_spelling` | lexical | Spelling error affects lexical accuracy | LR | 5.0 | — |
| `W_lr_paraphrase_task_mis` | lexical | Rewording changes/distorts the task meaning | LR | 6.5 | `W_paraphrase_task` |
| `W_gra_only_simple` | grammar | Structural range is consistently very limited in the sampled response | GRA | 5.0 | `W_complex_structure_range` |
| `W_gra_complex_with_error` | grammar | More complex structures are attempted with errors affecting control | GRA | 6.0 | `W_complex_structure_range` |
| `W_gra_tense` | grammar | Tense/aspect choice is inaccurate in context | GRA | 4.5 | — |
| `W_gra_subject_verb` | grammar | Subject–verb agreement error | GRA | 5.0 | — |
| `W_gra_article` | grammar | Article/determiner use is inaccurate | GRA | 5.5 | — |
| `W_gra_punctuation` | grammar | Punctuation/sentence-boundary error affects control | GRA | 6.5 | `W_punctuation_control` |
| `W_gra_relative_clause` | grammar | Relative-clause construction is inaccurate | GRA | 6.5 | `W_complex_structure_range` |
| `W_t1_no_overview` | task1 | Task 1 response lacks a clear overview of key features | TR_TASK1 | 5.0 | `W_overview_t1` |
| `W_t1_detail_dump` | task1 | Response reports details without effective key-feature selection | TR_TASK1 | 6.0 | `W_data_selection_t1` |
| `W_t1_opinion_injected` | task1 | Personal commentary displaces/reduces relevant description | TR_TASK1 | 5.0 | — |
| `W_letter_wrong_tone` | gt_letter | Register is inappropriate for the letter situation/purpose | TR_LR | 6.0 | `W_tone_register_letter` |

None of these rows encodes an automatic numeric band cap. `criterion_impact` identifies where evidence is relevant.

## Speaking — error taxonomy

| error_id | Category | Description | criterion_impact | band_signal | microskill_ref |
|---|---|---|---|---|---|
| `S_fc_short_answer` | fluency | Response development is insufficient for the question/context | FC | 5.0 | `S_extend_answer` |
| `S_fc_long_pause` | fluency | Hesitation/pause materially disrupts continuity; no fixed seconds threshold is assumed | FC | 5.5 | `S_long_turn_sustain` |
| `S_fc_repetition` | fluency | Repetition materially limits fluent/coherent development | FC | 5.5 | — |
| `S_fc_off_topic` | fluency | Response becomes materially irrelevant to the question | FC | 5.5 | — |
| `S_fc_part2_under_time` | fluency | Part 2 long turn ends materially early and limits available evidence | FC | 6.0 | `S_cue_card_structure` |
| `S_fc_part3_no_develop` | fluency | Part 3 response does not sufficiently explain/develop the view | FC | 6.5 | `S_abstract_reasoning` |
| `S_fc_no_discourse_marker` | fluency | Legacy label for limited discourse organisation; absence of a specific connector is not itself an error | FC | 6.0 | `S_discourse_marker_use` |
| `S_lr_repetitive` | lexical | Lexical repetition limits flexibility/precision | LR | 5.5 | `S_paraphrase_spontaneous` |
| `S_lr_limited_paraphrase` | lexical | Reformulation is insufficient when needed to communicate meaning | LR | 6.5 | `S_paraphrase_spontaneous` |
| `S_lr_wrong_collocation` | lexical | Collocational choice is inaccurate/inappropriate | LR | 6.5 | `S_idiomatic_use` |
| `S_lr_no_idiom` | lexical | **Deprecated legacy label**: absence of an idiom must not be treated as an IELTS error | LR | 7.0 | `S_idiomatic_use` |
| `S_gra_only_simple` | grammar | Sample shows consistently limited structural range | GRA | 5.5 | `S_complex_grammar_speak` |
| `S_gra_tense` | grammar | Tense/aspect choice is inaccurate | GRA | 5.0 | — |
| `S_gra_subject_verb` | grammar | Agreement error | GRA | 5.5 | — |
| `S_pr_phoneme` | pronunciation | Segmental production contributes to reduced intelligibility | PR | 6.0 | `S_phoneme_target` / `P_phoneme_targeted` |
| `S_pr_word_stress` | pronunciation | Lexical stress contributes to reduced intelligibility | PR | 6.0 | `P_word_stress_rule` |
| `S_pr_sentence_stress` | pronunciation | Prominence/stress pattern makes intended meaning harder to follow | PR | 6.5 | `S_sentence_stress_content` |
| `S_pr_intonation_flat` | pronunciation | Intonation/prominence control limits meaning/discourse signalling | PR | 7.0 | `S_intonation_meaning` |
| `S_pr_fast_unintelligible` | pronunciation | Rate/control makes speech difficult to understand | PR | 5.5 | — |

### Deprecated compatibility IDs

- `S_lr_no_idiom`: deprecated in `1.0.7`. Existing historical evidence may retain the ID, but new `COACH.ErrorAnalysis` output and new review cards must not generate it. If lexical flexibility is weak, record the actual observed evidence (`S_lr_repetitive`, `S_lr_limited_paraphrase`, inaccurate collocation, etc.).

## Strategy errors

| error_id | Description |
|---|---|
| `X_time_management` | Time allocation contributes to incomplete/lower-quality performance |
| `X_instruction_misread` | Misreads a task instruction |
| `X_answer_transfer_wrong` | Transfers/enters an answer incorrectly |
| `X_skip_and_not_return` | Skips an item and does not return before time expires |

Strategy IDs describe behavior; they are not Writing/Speaking criterion scores.

## Usage

- `COACH.ErrorAnalysis` records observed evidence and maps it to a controlled error ID only when the evidence supports that classification.
- `REVIEW.MistakeNotebook` and Error Graph preserve IDs for remediation/history.
- `BAND.Map` may surface error patterns, but no error count or `band_signal` formula can replace official scoring evidence.
- Unknown observation → `unknown_error` rather than forcing a nearest taxonomy label.

## Versioning

- Current release: `1.0.7`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — audited error IDs and micro-skill references.
- `version: 1.0.5` — converted criterion/band-signal cells to controlled values.
- `version: 1.0.6` — normalized the per-file release record; taxonomy nodes were unchanged.
- `version: 1.0.7` — clarified diagnostic authority, removed synthetic pause/fixed-band implications, and deprecated `S_lr_no_idiom` for new evidence.
- Addition: minor bump; semantic/description correction: patch; removal: deprecate rather than delete.

## Do not infer

- Do not infer a criterion band from one error or an error count.
- Do not use `band_signal` as an official threshold.
- Do not generate deprecated error IDs for new evidence.
- Unclassified evidence → `unknown_error` + review path.
