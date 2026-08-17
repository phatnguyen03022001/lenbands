---
version: 1.0.7
scope: framework
---

# Micro-skill Enumeration

Status: `framework` — LenBands-controlled micro-skill vocabulary for learning design, diagnosis, feedback, and review. Stable IDs may be referenced by assets and learner evidence.

Authority:
- Micro-skill IDs and descriptions are `lenbands-controlled` decomposition of observable IELTS-relevant behavior.
- `band_signal` is an `experimental-heuristic` used for routing/research. It is **not** an official IELTS threshold and must not directly award/cap a band.
- `done_when` thresholds are internal curriculum mastery rules. They establish mastery of a LenBands learning unit, not IELTS band attainment.

Conventions:
- `id` uses `{skill}_{microskill}` snake_case and is versioned. Never silently delete a referenced ID; deprecate it.
- `applies_to` identifies relevant task/question contexts.
- `band_signal` remains for backward compatibility and must be interpreted as provisional routing metadata unless calibration evidence explicitly promotes it.
- Assets/lessons must not invent new micro-skill IDs.

## Node schema

```yaml
id: R_matching_headings
name: Matching Headings (skill)
applies_to: [R_matching_headings]
band_signal: 6.0                 # provisional LenBands routing heuristic
calibration_status: provisional  # provisional | calibrated | retired
can_statement: "Learner can identify the main idea of a paragraph and match it to an appropriate heading using textual evidence."
depends_on:
  - id: R_skim_main_idea
    strength: hard_prerequisite
    source: colab_curated
  - id: R_paraphrase_recognition
    strength: recommended
    source: colab_curated
done_when:
  accuracy_pct: 80               # internal mastery rule, not an IELTS band rule
  consecutive_sessions: 3
  no_review_regression_days: 30
  evidence_source: [practice, mock_test]
```

A table row is an inventory entry, not automatically a spawn-ready/calibrated node. Missing dependency provenance/outcome criteria → `needs_review`.

## Listening — micro-skills

| id | Micro-skill | applies_to | band_signal |
|---|---|---|---|
| `L_predict_content` | Use question/context to predict likely information type before listening | all | 5.0 |
| `L_signal_word_detection` | Detect discourse/signalling language | all | 5.5 |
| `L_paraphrase_recognition` | Recognize paraphrase between question and audio | matching, multiple_choice | 6.0 |
| `L_distractor_rejection` | Reject plausible but unsupported/revised alternatives | multiple_choice, matching | 6.0 |
| `L_number_date_capture` | Capture numbers/dates/addresses accurately | form/note/table_completion | 4.0 |
| `L_spelling_from_audio` | Produce accurate spelling for a heard answer | form/note_completion | 4.5 |
| `L_note_concurrent` | Record useful information while continuing to listen | note/table_completion | 6.5 |
| `L_follow_direction` | Follow spatial descriptions/directions | map_labelling | 5.5 |
| `L_stage_tracking` | Track stages of a described process | flow_chart_labelling | 6.0 |
| `L_multi_speaker_distinguish` | Distinguish speakers and attributed viewpoints | matching (multiple speakers) | 6.5 |
| `L_abstract_inference` | Infer meaning/attitude that is not directly stated | multiple_choice, matching | 7.5 |

## Reading — micro-skills

| id | Micro-skill | applies_to | band_signal |
|---|---|---|---|
| `R_skim_main_idea` | Identify the main idea efficiently | matching_headings | 5.0 |
| `R_scan_specific_info` | Locate specific information efficiently | matching_information, completion | 4.5 |
| `R_paraphrase_recognition` | Recognize question↔passage paraphrase | completion/matching | 6.0 |
| `R_synonym_substitution` | Recognize lexical substitution without assuming exact equivalence | true_false_not_given, yes_no | 6.0 |
| `R_distractor_rejection` | Reject textually plausible but unsupported options | multiple_choice | 6.5 |
| `R_writer_attitude_inference` | Infer writer view/stance from evidence | yes_no_not_given | 7.0 |
| `R_not_given_vs_false` | Distinguish contradiction from absence of information | true_false_not_given, yes_no | 6.0 |
| `R_global_vs_local` | Distinguish whole-text from local information | matching_information, matching_headings | 6.5 |
| `R_reference_resolution` | Resolve reference/cohesion links | all | 5.5 |
| `R_discourse_marker_tracking` | Track discourse relationships | matching_headings, sentence_endings | 6.0 |
| `R_abstract_inference` | Infer an implication supported by the text | multiple_choice, yes_no | 7.5 |
| `R_summary_gap_strategy` | Use syntax/meaning constraints in completion tasks | summary_completion | 6.0 |

## Writing — micro-skills

| id | Micro-skill | applies_to | band_signal |
|---|---|---|---|
| `W_task_analysis` | Identify every requirement in the actual task | all | 5.0 (TR) |
| `W_position_clarity` | Present/maintain a clear position when the task requires one | task2 | 6.0 (TR) |
| `W_idea_development` | Develop relevant main ideas with explanation/support | task2 | 6.5 (TR) |
| `W_paragraph_topic_sentence` | Create paragraphs with clear central purpose where appropriate | all | 6.0 (CC) |
| `W_cohesive_device_range` | Use cohesion flexibly without mechanical overuse | all | 7.0 (CC) |
| `W_reference_substitution` | Use reference/substitution clearly | all | 6.5 (CC) |
| `W_lexical_precision` | Select vocabulary precisely for intended meaning | all | 7.0 (LR) |
| `W_collocation_awareness` | Use collocational patterns appropriately | all | 7.0 (LR) |
| `W_paraphrase_task` | Re-express task language without distorting meaning | all | 6.5 (LR) |
| `W_complex_structure_range` | Use structural variety appropriately and accurately | all | 7.0 (GRA) |
| `W_punctuation_control` | Control punctuation and sentence boundaries | all | 6.5 (GRA) |
| `W_data_selection_t1` | Select key visual information rather than indiscriminately listing it | task1 | 6.0 (TA) |
| `W_overview_t1` | Summarize the most important visual features | task1 | 6.0 (TA) |
| `W_tone_register_letter` | Use register appropriate to the General Training letter situation | gt_letter | 6.0 (TA/LR) |

## Speaking — micro-skills

| id | Micro-skill | applies_to | band_signal |
|---|---|---|---|
| `S_extend_answer` | Develop a relevant answer sufficiently for the interaction | part1 | 5.5 (FC) |
| `S_cue_card_structure` | Organize a coherent Part 2 long turn from the task card | part2 | 6.0 (FC) |
| `S_long_turn_sustain` | Sustain a Part 2 long turn with manageable hesitation | part2 | 6.5 (FC) |
| `S_abstract_reasoning` | Explain/compare/speculate about more abstract Part 3 issues | part3 | 7.0 (FC) |
| `S_discourse_marker_use` | Use discourse resources appropriately rather than mechanically | all | 6.0 (FC) |
| `S_paraphrase_spontaneous` | Reformulate meaning when direct wording is unavailable | all | 7.0 (LR) |
| `S_idiomatic_use` | Use idiomatic/collocational language naturally when appropriate | part2, part3 | 7.0 (LR) |
| `S_complex_grammar_speak` | Use a range of grammatical structures flexibly in speech | all | 7.0 (GRA) |
| `S_self_correction_fluency` | Repair speech without disproportionately disrupting coherence | all | 6.5 (FC) |
| `S_intonation_meaning` | Use intonation/prominence to support intended meaning | all | 7.0 (PR) |
| `S_sentence_stress_content` | Use prominence/stress to support intelligibility and meaning | all | 6.5 (PR) |
| `S_phoneme_target` | Produce selected segmental contrasts sufficiently clearly for intelligibility | all | 6.0 (PR) |

## Pronunciation — diagnostic micro-skills

| id | Micro-skill | band_signal |
|---|---|---|
| `P_phoneme_targeted` | Diagnose/practice a selected segmental feature | 6.0 |
| `P_minimal_pair` | Perceive/produce a relevant sound contrast | 6.5 |
| `P_word_stress_rule` | Produce intelligible lexical stress | 6.0 |
| `P_sentence_stress_pattern` | Use prominence across an utterance | 6.5 |
| `P_intonation_pattern` | Use intonation to support discourse meaning | 7.0 |
| `P_connected_speech_linking` | Diagnose/practice connected-speech features where useful | 7.5 |
| `P_chunking_pauses` | Group speech into meaningful chunks | 6.5 |

These pronunciation units are feedback dimensions. Absence of a particular accent feature is not itself a band error.

## Usage

- `learning_design_profile.target_micro_skills[]` contains only controlled IDs from this enum.
- `COACH.ErrorAnalysis` may map evidence → micro-skill for remediation.
- `BAND.Map` may show **micro-skill curriculum mastery** but must not translate a micro-skill completion percentage or `band_signal` directly into an IELTS band.
- `REVIEW.MistakeNotebook` may attach `micro_skill_ref` so review targets the relevant learning unit.
- Calibration status/evidence must be checked before an adaptive engine treats `band_signal` as a validated difficulty estimate.

## Versioning

- Current release: `1.0.7`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — clarified inventory-only rows versus spawn-ready nodes.
- `version: 1.0.6` — normalized the per-file release record; micro-skill enum values were unchanged.
- `version: 1.0.7` — clarified that band signals/mastery thresholds are LenBands diagnostic heuristics, removed synthetic pause/structure/idiom requirements, and separated curriculum mastery from IELTS scoring.
- Adding a micro-skill: minor bump + `added_in`.
- Description/heuristic correction: patch.
- Removal: mark `deprecated_in` and retain compatibility.

## Do not infer

- Do not invent a micro-skill ID.
- Do not claim a micro-skill `band_signal` is an official IELTS threshold.
- Do not infer an IELTS band from mastery of one or more micro-skills without the governed assessment/calibration path.
- Missing controlled ID/provenance → `unknown_microskill` or `needs_review`.
