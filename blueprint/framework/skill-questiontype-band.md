---
version: 1.1.0
scope: framework
---

# Skill × Question Type × Band Matrix

Status: `framework` — LenBands-controlled task/question-type vocabulary mapped to public IELTS task families. Feeds content tagging, practice routing, and curriculum coverage.

Authority:
- Public IELTS task families and Speaking timing are `official-derived`.
- LenBands may split an official family into finer internal IDs (for example paragraph-vs-section matching information or separate visual/completion layouts) when that helps diagnosis/authoring.
- `band_difficulty`, `Common band range`, and individual task-band ranges are `experimental-heuristic` metadata unless calibrated. IELTS does not assign a band to a question type.
- A question/task ID does not itself imply learner ability or item difficulty.

Official references:
- Listening format: `https://ielts.org/take-a-test/test-types/ielts-academic-test/ielts-academic-format-listening`
- Academic Reading format: `https://ielts.org/take-a-test/test-types/ielts-academic-test/ielts-academic-format-reading`
- General Training Reading format: `https://ielts.org/take-a-test/test-types/ielts-general-training-test/ielts-general-training-format-reading`

## Node schema

```yaml
question_type_id: R_matching_headings
name: Matching Headings
skill: reading
band_difficulty: high             # provisional LenBands routing heuristic
calibration_status: provisional
requires:
  - R_skim_main_idea
  - id: R_paraphrase_recognition
    strength: recommended
done_when:
  accuracy_pct: 75                # internal mastery rule, not an IELTS band rule
  recent_mock_pass: true
```

`requires` references controlled micro-skill IDs. Missing calibration/provenance means the node may still be used as a stable authoring ID but must not claim calibrated difficulty.

## Listening — 11 question types

Public IELTS groups tasks into multiple choice, matching, plan/map/diagram labelling, form/note/table/flow-chart/summary completion, sentence completion, and short-answer questions. LenBands separates several layouts into finer controlled IDs:

| id | LenBands question type | Public family | provisional difficulty note |
|---|---|---|---|
| `L_form_completion` | Form Completion | form/note/table/flow-chart/summary completion | often fact-focused |
| `L_note_completion` | Note Completion | form/note/table/flow-chart/summary completion | context-dependent |
| `L_table_completion` | Table Completion | form/note/table/flow-chart/summary completion | context-dependent |
| `L_flow_chart_completion` | Flow-chart Completion | form/note/table/flow-chart/summary completion | process tracking may be relevant |
| `L_summary_completion` | Summary Completion | form/note/table/flow-chart/summary completion | main-idea/detail integration may be relevant |
| `L_sentence_completion` | Sentence Completion | sentence completion | context-dependent |
| `L_map_plan_labelling` | Map / Plan Labelling | plan/map/diagram labelling | spatial tracking may be relevant |
| `L_diagram_labelling` | Diagram Labelling | plan/map/diagram labelling | visual/part tracking may be relevant |
| `L_multiple_choice` | Multiple Choice | multiple choice | varies by recording/item |
| `L_matching` | Matching | matching | varies by recording/item |
| `L_short_answer` | Short Answer | short-answer questions | context-dependent |

Question counts are variable. Do not attach a fixed IELTS band to any type.

## Reading — 16 LenBands question types

Public IELTS Reading uses multiple choice, identifying information, identifying writer views/claims, matching information/headings/features/sentence endings, sentence completion, summary/note/table/flow-chart completion, diagram label completion, and short-answer questions. LenBands retains finer internal splits where useful:

| id | Question type | Public task family | provisional difficulty note |
|---|---|---|---|
| `R_multiple_choice` | Multiple Choice (single answer) | multiple choice | varies |
| `R_multiple_choice_multi` | Multiple Choice (multi-select) | multiple choice | varies |
| `R_true_false_not_given` | True/False/Not Given | identifying information | evidence classification |
| `R_yes_no_not_given` | Yes/No/Not Given | writer views/claims | stance classification |
| `R_matching_headings` | Matching Headings | matching headings | main idea + paraphrase |
| `R_matching_information_paragraph` | Matching Information — paragraph | matching information | local search/paraphrase |
| `R_matching_information_section` | Matching Information — section | matching information | broader search scope |
| `R_matching_features` | Matching Features | matching features | relationships/attribution |
| `R_matching_sentence_endings` | Matching Sentence Endings | matching sentence endings | meaning/syntax fit |
| `R_sentence_completion` | Sentence Completion | sentence completion | detail retrieval |
| `R_summary_completion` | Summary Completion | summary/note/table/flow-chart completion | synthesis/detail |
| `R_note_completion` | Note Completion | summary/note/table/flow-chart completion | detail/organisation |
| `R_table_completion` | Table Completion | summary/note/table/flow-chart completion | categorical detail |
| `R_flow_chart_completion` | Flow-chart Completion | summary/note/table/flow-chart completion | sequence/process |
| `R_diagram_labelling` | Diagram Label Completion | diagram label completion | text↔visual mapping |
| `R_short_answer` | Short Answer | short-answer questions | detail retrieval |

Academic and General Training share broad task families; source-text style/content differs by module. See `exam-module-differences.md`.

## Writing — LenBands task taxonomy

### Academic

| id | Task type | routing band_range | Description |
|---|---|---|---|
| `W_ac_task1_chart` | Task 1 Academic — Chart/Graph | 5.0–9.0 | visual data (chart/graph) |
| `W_ac_task1_table` | Task 1 Academic — Table | 5.0–9.0 | tabular visual data |
| `W_ac_task1_process` | Task 1 Academic — Process | 5.5–9.0 | process/procedure |
| `W_ac_task1_map` | Task 1 Academic — Map | 5.5–9.0 | map/plan/change |
| `W_ac_task1_diagram` | Task 1 Academic — Diagram/Object | 5.5–9.0 | object/event/sequence visual |
| `W_task2_opinion` | Task 2 — Opinion | 5.0–9.0 | position/extent question |
| `W_task2_discussion` | Task 2 — Discussion | 5.0–9.0 | views/discussion |
| `W_task2_advantages_disadvantages` | Task 2 — Advantages/Disadvantages | 5.0–9.0 | benefits/drawbacks/weighing |
| `W_task2_problem_solution` | Task 2 — Problem/Solution | 5.0–9.0 | cause/problem/response |
| `W_task2_two_part` | Task 2 — Two-part | 5.5–9.0 | two explicit questions |

### General Training

| id | Task type | routing band_range | Description |
|---|---|---|---|
| `W_gt_task1_formal_letter` | Task 1 GT — Formal Letter | 5.0–9.0 | formal situation/register |
| `W_gt_task1_semi_formal_letter` | Task 1 GT — Semi-formal Letter | 5.0–9.0 | known recipient, non-intimate context |
| `W_gt_task1_informal_letter` | Task 1 GT — Informal Letter | 5.0–9.0 | personal/familiar context |
| `W_task2_opinion`, `W_task2_discussion`, `W_task2_advantages_disadvantages`, `W_task2_problem_solution`, `W_task2_two_part` | Task 2 authoring categories | 5.0–9.0 | shared internal Task 2 taxonomy |

These `band_range` values are authoring/routing metadata only until calibrated; they are not claims that a task type belongs to one IELTS band.

## Speaking — parts

| id | Part | routing band_range | Description | official-derived duration |
|---|---|---|---|---|
| `S_part1_interview` | Part 1 — Introduction/interview | 4.0–9.0 | familiar/general questions | 4–5 min |
| `S_part2_long_turn` | Part 2 — Long Turn | 4.5–9.0 | task card + preparation + long turn | 3–4 min total |
| `S_part3_discussion` | Part 3 — Discussion | 5.5–9.0 | more general/abstract discussion related to Part 2 | 4–5 min |

Part-level `routing band_range` is LenBands metadata. IELTS awards one Speaking band from performance across the test, not separate bands by part.

## Pronunciation — diagnostic units, not question types

| id | Unit | Description |
|---|---|---|
| `P_phoneme` | Phoneme | selected segmental feature |
| `P_word_stress` | Word Stress | lexical stress/prominence |
| `P_sentence_stress` | Sentence Stress | utterance prominence |
| `P_intonation` | Intonation | pitch/prominence contour |
| `P_linking` | Connected speech | linking/reduction diagnostics |

## Difficulty metadata boundary

Difficulty depends on the actual stimulus/item, language, distractors, inference load, task demands, and learner population. Labels such as `low | medium | high` or a numeric/band range may be used only as provisional authoring metadata until calibrated.

Historical rules such as "keyword match = Band 3–5" or "abstract inference = Band 7.5–9" are not official IELTS rules and must not be used as score conversions.

## Usage

- Content uses only controlled IDs from this file.
- `PRACTICE.Adaptive` may use provisional difficulty metadata conservatively; calibrated routing requires evidence.
- `BAND.Map` may show task-family exposure/performance but must not map question-type identity directly to a band.
- Official score calculation remains in the governed assessment/scoring contracts.

## Versioning

- Current release: `1.1.0`; the frontmatter is authoritative for the file version.
- `version: 1.0.3` — corrected earlier Listening/Reading inventory counts.
- `version: 1.0.6` — normalized the per-file release record; controlled IDs were unchanged.
- `version: 1.1.0` — added missing `L_summary_completion`, mapped LenBands IDs to public IELTS task families, and reclassified task-band/difficulty labels as provisional internal metadata.
- New controlled question/task ID: minor bump.
- Description/heuristic correction without ID change: patch.
- Removal: deprecate rather than silently delete.

## Do not infer

- Unknown type → `unknown_question_type`.
- Do not claim a task type has an official IELTS band.
- Do not infer item difficulty from question-type identity alone.
- Do not create a new internal split/ID without review and downstream coverage update.
