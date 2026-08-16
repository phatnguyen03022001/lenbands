---
version: 1.0.6
scope: framework
---

# Skill × Question Type × Band Matrix

Status: `framework` — invariant vocabulary. Complete question/task-type inventory by skill plus common band ranges. Controlled vocabulary for `05-content.md` and `BAND.Map`.

## Node schema (each question type)

A complete question type is a node that owns `requires` and `done_when` inline. Inventory tables only lock IDs; when detailed node schema is missing, assets must remain `needs_review` and must not claim calibrated status.

```yaml
question_type_id: R_matching_headings
name: Matching Headings
skill: reading
band_difficulty: high
requires:                              # micro-skills required for this type (from microskill-enum.md)
  - R_skim_main_idea                   # hard by default unless strength is declared
  - id: R_paraphrase_recognition
    strength: hard_prerequisite
  - id: R_discourse_marker_tracking
    strength: recommended
done_when:
  accuracy_pct: 75                     # question-type completion threshold
  recent_mock_pass: true               # ≥1 recent mock test passes this type
```

Convention: `requires` references micro-skill IDs from `microskill-enum.md`. A question type does not directly depend on another question type; dependencies flow through shared micro-skills because question types are highly independent.

## Listening — 10 question types

| id | Question type | Description | Common band range |
|---|---|---|---|
| `L_form_completion` | Form Completion | Complete a form (name, number, address) | 3.0–6.0 (Section 1) |
| `L_note_completion` | Note Completion | Complete gaps in notes | 4.0–7.5 |
| `L_table_completion` | Table Completion | Complete a table | 4.5–7.0 |
| `L_sentence_completion` | Sentence Completion | Complete the end of a sentence | 4.5–7.0 |
| `L_flow_chart_completion` | Flow-chart Completion | Complete a flow chart (process steps) | 4.5–7.0 |
| `L_map_plan_labelling` | Map / Plan Labelling | Label a map/plan (spatial) | 4.5–7.0 |
| `L_diagram_labelling` | Diagram Labelling | Label a diagram (object/process) | 5.0–7.0 |
| `L_multiple_choice` | Multiple Choice (1 from 3, multi-select) | Select one or multiple answers | 4.5–8.5 |
| `L_matching` | Matching | Match items | 5.5–8.5 |
| `L_short_answer` | Short Answer | Give a short answer | 4.5–7.5 |

Listening has 10 controlled question types. Diagram, flow-chart, and map are separated because their mechanisms differ: maps require spatial following, diagrams require part labelling, and flow charts require process tracking. This is the SSOT; `05-content.md` is synchronized to this enum.

Sections increase in difficulty from S1 (easiest, social) to S4 (hardest, academic). Section contributes a band-difficulty signal.

## Reading — 16 question types (Academic + General Training shared vocabulary)

| id | Question type | Description | Band difficulty |
|---|---|---|---|
| `R_multiple_choice` | Multiple Choice (1 from 4) | Select an answer | medium |
| `R_multiple_choice_multi` | Multiple Choice (multi-select, choose 2+) | Select multiple answers from a list | high |
| `R_true_false_not_given` | True/False/Not Given | Determine whether a statement is true, false, or absent from the passage | medium |
| `R_yes_no_not_given` | Yes/No/Not Given | Determine whether the writer agrees, disagrees, or gives no clear position | medium-high (paraphrase-sensitive) |
| `R_matching_headings` | Matching Headings | Choose a heading for a paragraph | high (paraphrase + main idea) |
| `R_matching_information_paragraph` | Matching Information (which paragraph) | Locate information in a **paragraph** | high (scan + paraphrase, local) |
| `R_matching_information_section` | Matching Information (which section) | Locate information in a **section** (group of paragraphs) | high (global grouping; harder than paragraph-level) |
| `R_matching_features` | Matching Features | Match features to people/names/theories | high |
| `R_matching_sentence_endings` | Matching Sentence Endings | Match sentence halves | medium |
| `R_sentence_completion` | Sentence Completion | Complete the end of a sentence | medium |
| `R_summary_completion` | Summary Completion (with/without box) | Complete a summary | medium-high |
| `R_note_completion` | Note Completion | Complete notes | medium |
| `R_table_completion` | Table Completion | Complete a table | medium |
| `R_flow_chart_completion` | Flow-chart Completion | Complete a flow chart | medium |
| `R_diagram_labelling` | Diagram Labelling | Label a diagram | medium |
| `R_short_answer` | Short Answer | Give a short answer | medium |

**Academic vs General Training note:** the controlled vocabulary is shared; passages differ (Academic: scholarly; GT: everyday/workplace). See `exam-module-differences.md`.

## Writing — task types

### Academic

| id | Task type | Band range | Description |
|---|---|---|---|
| `W_ac_task1_chart` | Task 1 Academic — Chart/Graph | 5.0–9.0 | Describe a chart (line/bar/pie) |
| `W_ac_task1_table` | Task 1 Academic — Table | 5.0–9.0 | Describe a data table |
| `W_ac_task1_process` | Task 1 Academic — Process | 5.5–9.0 | Describe a process |
| `W_ac_task1_map` | Task 1 Academic — Map | 5.5–9.0 | Compare maps |
| `W_ac_task1_diagram` | Task 1 Academic — Diagram/Object | 5.5–9.0 | Describe an object diagram |
| `W_task2_opinion` | Task 2 — Opinion | 5.0–9.0 | "Do you agree/disagree" |
| `W_task2_discussion` | Task 2 — Discussion | 5.0–9.0 | "Discuss both views" |
| `W_task2_advantages_disadvantages` | Task 2 — Advantages/Disadvantages | 5.0–9.0 | Outweigh / pros and cons |
| `W_task2_problem_solution` | Task 2 — Problem/Solution | 5.0–9.0 | Causes + solutions |
| `W_task2_two_part` | Task 2 — Two-part question | 5.5–9.0 | Two sub-questions |

### General Training

| id | Task type | Band range | Description |
|---|---|---|---|
| `W_gt_task1_formal_letter` | Task 1 GT — Formal Letter | 5.0–9.0 | Formal complaint/request |
| `W_gt_task1_semi_formal_letter` | Task 1 GT — Semi-formal Letter | 5.0–9.0 | Known recipient in a formal context |
| `W_gt_task1_informal_letter` | Task 1 GT — Informal Letter | 5.0–9.0 | Friends/personal context |
| `W_task2_opinion`, `W_task2_discussion`, `W_task2_advantages_disadvantages`, `W_task2_problem_solution`, `W_task2_two_part` | Task 2 GT — same as Academic Task 2 | 5.0–9.0 | See Academic |

## Speaking — parts

| id | Part | Band range | Description | Duration |
|---|---|---|---|---|
| `S_part1_interview` | Part 1 — Interview | 4.0–9.0 | Personal Q&A + familiar topics (home/work/study, family) | 4-5 min |
| `S_part2_long_turn` | Part 2 — Long Turn (Cue Card) | 4.5–9.0 | 1–2 minute monologue from a cue card | 3-4 min (1 prep + 2 speaking) |
| `S_part3_discussion` | Part 3 — Discussion | 5.5–9.0 | Abstract Q&A related to Part 2 | 4-5 min |

Part 3 is the most demanding and requires abstract reasoning and deeper paraphrasing.

## Pronunciation — no separate "question type"

Pronunciation is a Speaking criterion (PR) but is separated into domain `EVAL.Pronunciation` because its feedback mechanism differs. Evaluation units:

| id | Unit | Description |
|---|---|---|
| `P_phoneme` | Phoneme | Individual sound, e.g. /θ/, /ð/ |
| `P_word_stress` | Word Stress | Word stress, e.g. phoTOgrapher |
| `P_sentence_stress` | Sentence Stress | Sentence stress (content vs function words) |
| `P_intonation` | Intonation | Rising/falling intonation |
| `P_linking` | Connected speech | Linking, elision, assimilation |

## Band difficulty (shared for L/R)

IELTS does not assign a band to an individual question type. Difficulty comes from **paraphrase depth**, **abstract reasoning**, and **synonym density**. Principle:

| Difficulty signal | Typical target band increase |
|---|---|
| Keyword match (same words) | 3.0–5.0 |
| Synonym paraphrase (1 step) | 5.0–6.0 |
| Complex paraphrase (2+ steps, sentence-level) | 6.5–7.5 |
| Abstract/inference (implied rather than explicit) | 7.5–9.0 |

This difficulty signal is `difficulty_signals` in `learning_design_profile` (`05-content.md`) and feeds `PRACTICE.Adaptive`.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.
- `version: 1.0.3` — corrected Listening/Reading inventory counts to match the enumerated nodes.
- `version: 1.0.6` — normalized the per-file release record; question-type enums are unchanged.

## Do not infer

If a question type is not listed above, the agent must report `unknown_question_type` rather than inventing a name. Adding a new rare type requires Colab review and a version update to this file.
