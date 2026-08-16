---
version: 1.0.6
scope: framework
---

# Micro-skill Enumeration

Status: `framework` — versioned controlled vocabulary. Lists the micro-skills required for each question type/task. Feeds `target_micro_skills` in `learning_design_profile`, the `BAND.Map` micro-skill row, and `COACH.ErrorAnalysis`.

Conventions:
- `id` uses `{skill}_{microskill}` snake_case and is versioned. Bump the version when adding/changing; never delete an ID — mark it `deprecated`.
- `applies_to`: question type/task for which this skill is required.
- `band_signal`: band range where the micro-skill starts to become discriminative.
- This file is an **enum**; assets/lessons must not invent new micro-skills.

## Node schema (each micro-skill)

A complete micro-skill is a **self-contained node** that owns relationships, completion conditions, and its learner-facing statement inline. Current tables are controlled inventories; rows without complete node schema must not be used to claim calibrated outcomes. Global graph/index views are projections, not SSOT.

```yaml
id: R_matching_headings
name: Matching Headings (skill)
applies_to: [R_matching_headings]      # question_type id from skill-questiontype-band.md
band_signal: 6.0
can_statement: "Learner can identify the main idea of a paragraph and match it to the correct heading by recognizing paraphrase and discourse markers."
depends_on:
  - id: R_skim_main_idea
    strength: hard_prerequisite
    source: colab_curated
  - id: R_paraphrase_recognition
    strength: hard_prerequisite
    source: colab_curated
  - id: R_discourse_marker_tracking
    strength: recommended
    source: colab_curated
done_when:
  accuracy_pct: 80                     # micro-skill threshold is lower than grammar because objective questions are harder
  consecutive_sessions: 3
  no_review_regression_days: 30
  evidence_source: [practice, mock_test]
unlocks:
  - R_matching_information             # similar main-idea + paraphrase mechanism, more advanced
```

Conventions:
- `can_statement`: required, written as "Learner can ..." for learner-facing meaning rather than as a technical label.
- `depends_on`: prerequisite micro-skill. `strength` and `source` follow the grammar framework.
- `done_when`: AND conditions required for ✓ in the `BAND.Map` micro-skill row.
- `done_when.accuracy_pct` is typically 80 for micro-skills because objective questions are more difficult; grammar drills use 90.

## Listening — micro-skills

| id | Micro-skill | applies_to | band_signal |
|---|---|---|---|
| `L_predict_content` | Predict content from the question before listening | all | 5.0 |
| `L_signal_word_detection` | Detect signal words (now, however, finally) | all | 5.5 |
| `L_paraphrase_recognition` | Recognize paraphrase between question stem and audio | matching, multiple_choice | 6.0 |
| `L_distractor_rejection` | Reject distractors (near-miss answers, misleading numbers) | multiple_choice, matching | 6.0 |
| `L_number_date_capture` | Capture numbers/dates/addresses accurately | form/note/table_completion | 4.0 |
| `L_spelling_from_audio` | Spell heard words accurately | form/note_completion | 4.5 |
| `L_note_concurrent` | Take notes while continuing to listen | note/table_completion | 6.5 |
| `L_follow_direction` | Follow spatial directions (left/right/behind) | map_labelling | 5.5 |
| `L_stage_tracking` | Track stages of a process/diagram | flow_chart_labelling | 6.0 |
| `L_multi_speaker_distinguish` | Distinguish speakers and viewpoints | matching (multiple speakers) | 6.5 |
| `L_abstract_inference` | Infer meaning that is not stated directly | multiple_choice, matching | 7.5 |

## Reading — micro-skills

| id | Micro-skill | applies_to | band_signal |
|---|---|---|---|
| `R_skim_main_idea` | Skim for the main idea of a paragraph | matching_headings | 5.0 |
| `R_scan_specific_info` | Scan for specific information | matching_information, completion | 4.5 |
| `R_paraphrase_recognition` | Recognize stem↔passage paraphrase | all completion/matching | 6.0 |
| `R_synonym_substitution` | Detect synonym substitution | true_false_not_given, yes_no | 6.0 |
| `R_distractor_rejection` | Reject lexical-trap distractors | multiple_choice | 6.5 |
| `R_writer_attitude_inference` | Infer writer attitude (positive/negative) | yes_no_not_given | 7.0 |
| `R_not_given_vs_false` | Distinguish "false" (contradicted) from "not given" (absent) | true_false_not_given, yes_no | 6.0 (important boundary) |
| `R_global_vs_local` | Distinguish whole-text information from paragraph-specific information | matching_information, matching_headings | 6.5 |
| `R_reference_resolution` | Resolve references (this/these/such) | all | 5.5 |
| `R_discourse_marker_tracking` | Track discourse markers (however/thus/in addition) | matching_headings, sentence_endings | 6.0 |
| `R_abstract_inference` | Infer meaning that is not stated directly | multiple_choice, yes_no | 7.5 |
| `R_summary_gap_strategy` | Use grammar/logic strategy for summary gaps | summary_completion | 6.0 |

## Writing — micro-skills (Task 1 + Task 2)

| id | Micro-skill | applies_to | band_signal |
|---|---|---|---|
| `W_task_analysis` | Analyze the task and identify every required part | all | 5.0 (TR) |
| `W_position_clarity` | Maintain a clear position throughout | task2 | 6.0 (TR) |
| `W_idea_development` | Develop a main idea with support (example/reasoning) | task2 | 6.5 (TR) |
| `W_paragraph_topic_sentence` | Write a clear topic sentence for each paragraph | all | 6.0 (CC) |
| `W_cohesive_device_range` | Use a range of cohesive devices without mechanical overuse | all | 7.0 (CC) |
| `W_reference_substitution` | Use reference + substitution (this/this approach/the latter) | all | 6.5 (CC) |
| `W_lexical_precision` | Choose precise vocabulary rather than merely adequate wording | all | 7.0 (LR) |
| `W_collocation_awareness` | Use collocations accurately | all | 7.0 (LR) |
| `W_paraphrase_task` | Paraphrase the task without changing meaning | all | 6.5 (LR) |
| `W_complex_structure_range` | Use a range of complex structures (relative clauses/conditionals/inversion) | all | 7.0 (GRA) |
| `W_punctuation_control` | Control punctuation (comma, semicolon) | all | 6.5 (GRA) |
| `W_data_selection_t1` | Select important data (trends/comparisons rather than listing everything) | task1 | 6.0 (TR Task1) |
| `W_overview_t1` | Produce a clear overview of main trends/features | task1 | 6.0 (TR Task1) |
| `W_tone_register_letter` | Use appropriate tone/register for the letter type | gt_letter | 6.0 (TR/LR GT) |

## Speaking — micro-skills

| id | Micro-skill | applies_to | band_signal |
|---|---|---|---|
| `S_extend_answer` | Extend answers beyond yes/no | part1 | 5.5 (FC) |
| `S_cue_card_structure` | Structure a 1–2 minute monologue with opening/body/closing | part2 | 6.0 (FC) |
| `S_long_turn_sustain` | Sustain speech without pauses >5s or disruptive fillers | part2 | 6.5 (FC) |
| `S_abstract_reasoning` | Give abstract reasoning and defend a viewpoint | part3 | 7.0 (FC) |
| `S_discourse_marker_use` | Use discourse markers (well/actually/on the other hand) | all | 6.0 (FC) |
| `S_paraphrase_spontaneous` | Paraphrase immediately when a word cannot be recalled | all | 7.0 (LR) |
| `S_idiomatic_use` | Use idiom/collocation naturally | part2, part3 | 7.0 (LR) |
| `S_complex_grammar_speak` | Use complex grammar in speech (relative clauses/subordination) | part3 | 7.0 (GRA) |
| `S_self_correction_fluency` | Self-correct without losing fluency | all | 6.5 (FC) |
| `S_intonation_meaning` | Use intonation to convey question/emphasis/attitude | all | 7.0 (PR) |
| `S_sentence_stress_content` | Stress content words clearly | all | 6.5 (PR) |
| `S_phoneme_target` | Produce target phonemes (/θ/ /ð/ /æ/) | all | 6.0 (PR) |

## Pronunciation — micro-skills (subset of Speaking, separated for dedicated feedback)

| id | Micro-skill | band_signal |
|---|---|---|
| `P_phoneme_targeted` | Target phoneme (per phoneme) | 6.0 |
| `P_minimal_pair` | Distinguish minimal pairs (ship/sheep, bit/beat) | 6.5 |
| `P_word_stress_rule` | Apply word-stress rules (noun/verb, suffix) | 6.0 |
| `P_sentence_stress_pattern` | Apply sentence stress (content vs function words) | 6.5 |
| `P_intonation_pattern` | Control intonation patterns (statement vs question) | 7.0 |
| `P_connected_speech_linking` | Use linking (consonant-vowel) and elision | 7.5 |
| `P_chunking_pauses` | Chunk speech and pause at appropriate boundaries | 6.5 |

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — clarified inventory-only rows versus spawn-ready nodes.
- `version: 1.0.6` — normalized the per-file release record; micro-skill enum values are unchanged.
- Adding a micro-skill: bump minor (1.1.0) + record `added_in`.
- Editing description without changing meaning: bump patch.
- Removal: NEVER delete; mark `deprecated_in` and retain compatibility because older assets may still reference it.

## Usage

- `learning_design_profile.target_micro_skills[]` contains only IDs from this enum.
- `COACH.ErrorAnalysis` maps an error to affected micro-skills; see `error-taxonomy.md`.
- The `BAND.Map` micro-skill row shows `% achieved for band X` using these micro-skill IDs.
- `REVIEW.MistakeNotebook` review cards carry `micro_skill_ref` so FSRS reviews the correct unit.

## Do not infer

Lessons/assets must not invent micro-skill IDs. If one is missing, report `unknown_microskill` to Colab, update the enum, and bump the version.
