# IELTS Skill × Practice Coverage Contract

## 0. Purpose and status

This artifact locks **everything the learner can practice** in LenBands: skill domain, module, question/task/practice unit, learning mode, evaluation, review, and retest.

It is a coverage contract/projection derived from the Blueprint and IELTS Framework; it is not a source for creating additional question types. The Framework remains the authority for IDs. An ID in the table without a vertical slice, contract, corpus, and acceptance evidence has status `domain_defined` and must not be called build-ready.

Current status: `review`.

### Coverage status

| Status | Meaning |
|---|---|
| `domain_defined` | Controlled vocabulary/framework node exists; no runtime spec yet |
| `spec_candidate` | Design/artifact candidate exists; contract or evidence is incomplete |
| `build_ready_candidate` | Enough contract to begin code after review; no runtime evidence yet |
| `deferred` | Identity and coverage contract exist, but the roadmap does not permit build |
| `unknown` | The Framework lacks the ID/semantics; the agent must stop and report `unknown_*` |

## 1. Learner practice mode ontology

Every skill slice must explicitly choose which modes are in scope. Do not use `practice` as an ambiguous umbrella term.

| Mode | Learner action | Required output/evidence |
|---|---|---|
| `learn` | view lesson/strategy/example with scaffolding | outcome + prerequisite + completion evidence |
| `untimed_practice` | complete a question/task without time pressure | answer/task result + explanation/error mapping |
| `timed_practice` | complete within a section/task limit | elapsed time + result + pacing evidence |
| `adaptive_practice` | practice by weakness/question type/band | reason for selection + result + routing evidence |
| `evaluation` | submit output for scoring/comparison | rubric/answer result + confidence/evidence |
| `review` | review an error/knowledge item by mapping | card transition + learner response |
| `retest` | complete a new item/task for the same error/micro-skill | transfer result, recurrence/improvement |
| `mock_test` | complete a composite test by module | section scores + raw-to-band conversion + result analysis |
| `exam_simulation` | simulate exam/review mode and resume | state recovery + final score + audit trail |

`review` and `retest` must not be inferred automatically from `evaluation`; they require valid `error-taxonomy` and `review-mapping`. `mock_test` must not be inferred by joining a few practice sets without a module/section/timing/scoring contract.

## 2. Skill × module × unit coverage

| Domain | Module | Controlled units | learn | untimed | timed | adaptive | evaluation | review/retest | mock | Current status |
|---|---|---|---|---|---|---|---|---|---|---|
| Listening | `shared` | 10: `L_form_completion`, `L_note_completion`, `L_table_completion`, `L_sentence_completion`, `L_flow_chart_completion`, `L_map_plan_labelling`, `L_diagram_labelling`, `L_multiple_choice`, `L_matching`, `L_short_answer` | lesson/strategy/audio | answer-key practice | section timing | weakness/question type | deterministic answer key + explanation | distractor/paraphrase/spelling/inference errors | 4 sections, 40 items | `spec_candidate` |
| Reading | `academic` | 16 controlled `R_*` types | passage strategy | answer-key practice | passage/section timing | question type/micro-skill | deterministic answer key + explanation | paraphrase/TFNG/location/completion errors | 3 passages, 40 items | `spec_candidate` |
| Reading | `general_training` | same 16 type IDs, GT passage profile | workplace/everyday strategy | answer-key practice | passage/section timing | question type/micro-skill | deterministic answer key + explanation | same error family with module-aware passage | 3 sections, 40 items | `spec_candidate` |
| Writing | `academic` | 5 `W_ac_task1_*` + 5 `W_task2_*` | task analysis/structure/language | outline/draft practice | task timing | criterion/question type weakness | rubric TR/CC/LR/GRA | criterion/error review + retest | Task 1 + Task 2 composite | `domain_defined` for Task 1; `build_ready_candidate` only for Task 2 contract, release `not_ready` |
| Writing | `general_training` | 3 `W_gt_task1_*` + 5 shared `W_task2_*` | letter register + Task 2 | outline/draft practice | task timing | criterion/question type weakness | rubric TR/CC/LR/GRA with module rules | tone/task/criterion error review + retest | GT Task 1 + Task 2 composite | `domain_defined` |
| Speaking | `shared` | `S_part1_interview`, `S_part2_long_turn`, `S_part3_discussion` | answer structure/fluency strategy | prompt response + self-record | part timing | part/micro-skill weakness | audio/transcript + FC/LR/GRA/PR rubric | fluency/lexical/grammar/pronunciation review + retest | 3-part composite | `spec_candidate` |
| Pronunciation | `shared` support domain | 5 canonical units: `P_phoneme`, `P_word_stress`, `P_sentence_stress`, `P_intonation`, `P_linking`; drill variants `P_minimal_pair`, `P_chunking_pauses` come from microskill enum | model audio + articulatory lesson | drill/listen-repeat | timed repetition/production | phoneme/stress/intonation weakness | audio features + PR feedback; not a separate IELTS exam score | pronunciation drill + new-word/sentence retest | consumed by Speaking mock; not standalone IELTS section | `spec_candidate` |
| Mock Test | `academic`/`general_training` | composite of Listening + Reading + Writing + Speaking; module routing required | exam strategy + section instructions | review mode only | exam mode required | post-test routing | section scoring + module conversion + writing/speaking evaluation | wrong-answer/error review after result | full composite | `deferred` |

## 3. Question/task inventory — no hidden forms

### Listening — 10

`L_form_completion`, `L_note_completion`, `L_table_completion`, `L_sentence_completion`, `L_flow_chart_completion`, `L_map_plan_labelling`, `L_diagram_labelling`, `L_multiple_choice`, `L_matching`, `L_short_answer`.

Each type needs audio stimulus, transcript/segment boundary, answer normalization, accepted alternatives, explanation, and rights/provenance. `L_map_plan_labelling`, `L_diagram_labelling`, and `L_flow_chart_completion` must not be collapsed into one generic labelling rule.

### Reading — 16

`R_multiple_choice`, `R_multiple_choice_multi`, `R_true_false_not_given`, `R_yes_no_not_given`, `R_matching_headings`, `R_matching_information_paragraph`, `R_matching_information_section`, `R_matching_features`, `R_matching_sentence_endings`, `R_sentence_completion`, `R_summary_completion`, `R_note_completion`, `R_table_completion`, `R_flow_chart_completion`, `R_diagram_labelling`, `R_short_answer`.

Academic and General Training share type IDs but do not share passage profiles, module routing, or default raw-score conversion.

### Writing — 13

- Academic Task 1: `W_ac_task1_chart`, `W_ac_task1_table`, `W_ac_task1_process`, `W_ac_task1_map`, `W_ac_task1_diagram`.
- General Training Task 1: `W_gt_task1_formal_letter`, `W_gt_task1_semi_formal_letter`, `W_gt_task1_informal_letter`.
- Task 2 shared: `W_task2_opinion`, `W_task2_discussion`, `W_task2_advantages_disadvantages`, `W_task2_problem_solution`, `W_task2_two_part`.

Task 1 must not be evaluated with a Task 2 prompt/rubric shortcut: Academic requires selection/overview/data language; GT requires tone/register/letter purpose.

### Speaking — 3 parts

`S_part1_interview`, `S_part2_long_turn`, `S_part3_discussion`. Each part has its own prompt rules, duration, interaction behavior, and failure/recovery; Part 3 is not Part 1 with harder questions.

### Pronunciation — 5 canonical practice units + drill variants

Canonical practice units: `P_phoneme`, `P_word_stress`, `P_sentence_stress`, `P_intonation`, `P_linking`. `P_minimal_pair` and `P_chunking_pauses` are drill variants/micro-skills, not question-type or practice-unit authority.

Pronunciation is a support domain linked to Speaking with a `practice_unit`; it does not claim to be an IELTS exam section or an independent band score.

## 4. Required artifact family by domain

A domain may leave `domain_defined` only when it has all of the following layers:

| Artifact family | Listening/Reading | Writing | Speaking | Pronunciation | Mock |
|---|---|---|---|---|---|
| Experience slice | input stimulus → answer/result → review | task/editor → evaluation → fix | prompt/record → feedback | model/record → drill | section flow/resume |
| Content/stimulus data | audio/passage/segment/question | task/prompt/rubric | cue card/question/audio rules | word/sentence/audio target | test form/section |
| Practice contract | answer normalization + timing | draft/outline/timing | recording/part timing | drill/repetition | section order/timer |
| Evaluation contract | answer key + explanation | rubric + evidence + confidence | rubric + transcript/features | PR feature/evidence limits | score aggregation/conversion |
| Data/event/failure | attempt, answer, recovery | submission/evaluation/finding | recording/evaluation/retry | audio attempt/feature result | test session/resume |
| Review/retest | question-type error → new item | finding/error → fix → new task | error → new prompt/record | target → new production | result → weak section/type |
| Corpus/benchmark | calibrated item sets | gold essays + labels | gold recordings + labels | labeled audio/features | composite benchmark |
| Acceptance | redaction, answer, timing | evidence/idempotency/recovery | permission/audio/recovery | privacy/audio/threshold | timing/resume/scoring |

Missing family means `spec_candidate` at most. It cannot be hidden behind `deferred` or a generic `PRACTICE.*` label.

## 5. Learner journeys that must exist

1. **Placement**: choose module/goal → baseline each skill → insufficient evidence safe state → initial path.
2. **Learn**: lesson/strategy → guided example → one observable outcome → practice.
3. **Question-type drill**: choose type → complete item → answer/explanation → error/micro-skill mapping.
4. **Timed practice**: choose section/task → timer → submit → pacing + accuracy feedback.
5. **Weakness/adaptive practice**: system states why it selected the item → practice → update weakness evidence.
6. **Writing workflow**: Task 1/Task 2 draft → submit → rubric feedback → fix → retest.
7. **Speaking workflow**: Part 1/2/3 prompt → record → transcript/features → rubric feedback → new prompt retest.
8. **Pronunciation workflow**: target unit → model/listen → record/repeat → feature feedback → new token/sentence retest.
9. **Listening/Reading review**: wrong answer → error type → new item with the same micro-skill, without repeating the exact question.
10. **Mock/exam simulation**: module selection → section timing → pause/recovery rules → composite result → per-skill/type review.
11. **Review queue**: due card → recall/apply → FSRS transition → retest eligibility.

## 6. Current truth and next required slices

| Slice | Runtime spec | API/data/event/failure | Benchmark/acceptance | Truthful state |
|---|---|---|---|---|
| Writing Task 2 | present | present, review | missing/not_run | `build_ready_candidate` |
| Writing Academic Task 1 | missing | missing | missing | `domain_defined` |
| Writing GT Task 1 | missing | missing | missing | `domain_defined` |
| Listening practice/evaluation | candidate in multi-skill runtime spec | missing | missing | `spec_candidate` |
| Reading practice/evaluation | candidate in multi-skill runtime spec | missing | missing | `spec_candidate` |
| Speaking Part 1/2/3 | candidate in multi-skill runtime spec | missing | recordings/labels missing | `spec_candidate` |
| Pronunciation drills/evaluation | candidate in multi-skill runtime spec | missing | audio/features missing | `spec_candidate` |
| Mock Test/Exam Simulation | missing | missing | composite benchmark missing | `deferred` |

Conclusion: the Framework has broad inventory; Artifact/Runtime coverage is not 100%. The existence of an enum must not be used to claim that the learner has the complete practice experience.
