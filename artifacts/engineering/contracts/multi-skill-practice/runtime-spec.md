# Multi-skill Practice Runtime Specification

## 0. Scope and status

This is the runtime specification for domains outside the existing Writing Task 2 slice: Listening, Reading, Speaking, Pronunciation, and composite Mock Test. It connects capability/framework IDs to implementable behavior but is not considered build-ready.

Status: `review` / `spec_candidate`. Gold corpora, calibration benchmarks, source code, and runtime acceptance evidence for these slices are still missing.

Framework authority: `blueprint/framework/`. Internal question-type/difficulty metadata must not override official-derived scoring/format contracts.

## 1. Shared practice model

| Component | Responsibility |
|---|---|
| Practice API | authorization, content eligibility, attempt creation, idempotency |
| Content service | returns the published stimulus/question/prompt at the correct version |
| Attempt service | snapshots the item and stores answer/recording references and lifecycle |
| Answer evaluator | deterministic key/normalization for Listening/Reading |
| Speaking evaluator | transcript/features/rubric evidence; not a human examiner |
| Pronunciation evaluator | diagnostic phoneme/stress/intonation/connected-speech evidence |
| Review service | maps supported findings to error, card, and retest contracts |
| Mock orchestrator | product simulation state, timer/recovery, section results, composite result |

There is no scheduler or generic compiler in this contract. Async is used only when the media/evaluation boundary requires a worker.

### Common attempt

```yaml
attempt_id: string
user_id: string
skill: listening | reading | speaking | pronunciation
exam_module: academic | general_training | shared
practice_mode: untimed_practice | timed_practice | adaptive_practice | evaluation | review | retest
content_ref: string
content_version: string
question_type: string | null
practice_unit: string | null
status: created | in_progress | submitted | evaluated | needs_review | abandoned
response_ref: string
result_ref: string | null
started_at: timestamp
submitted_at: timestamp | null
```

- `question_type` is required for Listening/Reading/Speaking; `practice_unit` is required for Pronunciation.
- Content version is snapshotted; republishing does not mutate historical attempts.
- `abandoned` is not a wrong answer if no response was submitted.
- Retrying with the same idempotency key does not create a duplicate attempt.

### Practice modes

| Mode | Required behavior |
|---|---|
| `untimed_practice` | answer/result and explanation after submission |
| `timed_practice` | deadline, elapsed time, pacing evidence, timeout state |
| `adaptive_practice` | selection reason traceable to governed learner evidence + question/micro-skill; difficulty must be provisional or calibrated explicitly |
| `review` | recall/apply response and FSRS transition |
| `retest` | new content targeting the same supported error/micro-skill to measure transfer |

No internal `band_signal` may be treated as a score or as calibrated difficulty without calibration evidence.

## 2. Listening

Input is a published audio stimulus with transcript/segment boundary, rights/provenance, and a question belonging to one of 11 controlled LenBands IDs:

`L_form_completion`, `L_note_completion`, `L_table_completion`, `L_flow_chart_completion`, `L_summary_completion`, `L_sentence_completion`, `L_map_plan_labelling`, `L_diagram_labelling`, `L_multiple_choice`, `L_matching`, `L_short_answer`.

```yaml
listening_result:
  attempt_id: string
  item_results:
    - question_ref: string
      answer_status: correct | incorrect | invalid | unanswered
      normalized_answer: string | null
      accepted_answer_ref: string | null
      error_ref: string | null
  raw_score: integer
  total: integer
  explanation_refs: []
  audio_duration_ms: integer
  response_duration_ms: integer
  score_conversion_ref: string | null
  band: number | null
  score_status: raw_only | converted | conversion_unavailable
```

Rules:
- Answer normalization is item-key/config specific. A synonym/format outside the reviewed accepted set does not auto-pass.
- MCQ/matching preserves option identity/order; the answer is not exposed before submission.
- Visual labelling assets have versioned stimulus/label boundaries; do not infer coordinates from arbitrary images at evaluation time.
- Media failure preserves the attempt and must not manufacture an unanswered response.
- `band` may be populated only from an approved versioned score conversion defined by `exam-module-differences.md`; otherwise retain the raw score and `conversion_unavailable`.

## 3. Reading

Input is a published passage snapshot, paragraph/section IDs where relevant, and one of 16 controlled LenBands IDs:

`R_multiple_choice`, `R_multiple_choice_multi`, `R_true_false_not_given`, `R_yes_no_not_given`, `R_matching_headings`, `R_matching_information_paragraph`, `R_matching_information_section`, `R_matching_features`, `R_matching_sentence_endings`, `R_sentence_completion`, `R_summary_completion`, `R_note_completion`, `R_table_completion`, `R_flow_chart_completion`, `R_diagram_labelling`, `R_short_answer`.

Academic and General Training can reuse controlled task IDs but require module-appropriate source profiles and approved score-conversion configuration.

```yaml
reading_result:
  attempt_id: string
  passage_ref: string
  passage_version: string
  module: academic | general_training
  raw_score: integer
  total: integer
  score_conversion_ref: string | null
  band: number | null
  score_status: raw_only | converted | conversion_unavailable
  item_results: []
  reading_duration_ms: integer
```

- T/F/NG and Y/N/NG use different evidence/explanation semantics: information versus writer view/claim.
- Matching paragraph/section stores the scope actually used by the asset.
- Completion uses versioned answer normalization and the explicit item word-limit rule.
- Reading position may be recovered by product UX; an unsubmitted answer does not create wrong-answer evidence.

## 4. Speaking

| Part | ID | Input | Output |
|---|---|---|---|
| Part 1 | `S_part1_interview` | examiner prompt/topic sequence | recording, transcript/features, FC/LR/GRA/PR evidence |
| Part 2 | `S_part2_long_turn` | task card + 1-minute preparation | prep notes, long-turn recording, evidence |
| Part 3 | `S_part3_discussion` | related discussion prompts | multi-turn recording, FC/LR/GRA/PR evidence |

`examiner_mode` must distinguish `strict_mock` from `guided_practice` as defined by `speaking-parts-framework.md`. Coaching/follow-up assistance from guided practice must not leak into strict mock turns.

```yaml
speaking_attempt:
  attempt_id: string
  part: S_part1_interview | S_part2_long_turn | S_part3_discussion
  examiner_mode: strict_mock | guided_practice
  prompt_ref: string
  prompt_version: string
  audio_ref: string
  duration_ms: integer
  transcript_ref: string | null
  consent_scope: recording | transcription | evaluation
  status: created | recording | uploaded | processing | evaluated | low_confidence | unavailable
  result_ref: string | null
```

Raw audio/transcript is read only through a learner-scoped service; events/logs/queues carry opaque refs.

Evaluation retains FC/LR/GRA/PR evidence and rubric version. A learner-visible Speaking band may be produced only by the governed evaluated/scored pathway with sufficient evidence and calibration; a part-level diagnostic or internal feature score is never an independent IELTS band.

## 5. Pronunciation

Pronunciation is a support/diagnostic domain for Speaking, not an IELTS exam section or independent band score.

Canonical practice units: `P_phoneme`, `P_word_stress`, `P_sentence_stress`, `P_intonation`, `P_linking`. Drill variants such as `P_minimal_pair` and `P_chunking_pauses` resolve through the micro-skill enum.

```yaml
pronunciation_attempt:
  attempt_id: string
  practice_unit: string
  target_ref: string
  reference_audio_ref: string
  learner_audio_ref: string
  feature_result:
    segmental_signal: number | null
    stress_signal: number | null
    intonation_signal: string | null
    intelligibility_signal: number | null
  evidence_refs: []
  status: created | recorded | processing | evaluated | low_confidence | unavailable
```

Internal feature signals must not be mechanically averaged into an IELTS Pronunciation band. Feedback targets intelligibility/communicative control and must not penalize accent identity.

## 6. Mock Test / Exam Simulation

A LenBands composite mock is a product orchestration over skill attempts. It must not imply that the real test always runs all four components in one uninterrupted app session; Speaking scheduling can differ from the Listening/Reading/Writing session.

```yaml
mock_session:
  session_id: string
  user_id: string
  module: academic | general_training
  mode: practice | strict_mock | review
  test_form_ref: string
  test_form_version: string
  component_plan: [listening, reading, writing, speaking]
  current_component: listening | reading | writing | speaking | completed
  state: created | in_progress | recovery_required | submitted | scoring | completed | abandoned
  attempt_refs: []
```

Rules:
- `strict_mock` locks answer/explanation until the relevant submission boundary and follows governed timing/format rules.
- App/network failure enters technical recovery; it must not grant an ungoverned learner-controlled exam pause or reset the attempt.
- Academic/GT routing and L/R conversion follow `exam-module-differences.md`.
- A composite result must not invent an overall band when a required section result is unavailable; use an incomplete/insufficient-evidence state.
- Writing section scoring preserves Task 1 + Task 2 with Task 2 weighted twice; Speaking preserves rubric/evidence state.

## 7. Shared API candidate

This is a candidate interface, not approved OpenAPI:

| Operation | Purpose | Idempotency |
|---|---|---|
| `GET /v1/practice/items/{contentId}` | published question/stimulus/prompt | n/a |
| `POST /v1/practice/attempts` | create attempt snapshot | required |
| `PUT /v1/practice/attempts/{id}/response` | save answer/response version | version/key |
| `POST /v1/practice/attempts/{id}/submit` | close/evaluate attempt | required |
| `GET /v1/practice/attempts/{id}` | status/result | n/a |
| `POST /v1/speaking/recordings` | upload recording ref | required |
| `POST /v1/pronunciation/attempts` | submit drill production | required |
| `POST /v1/mock-sessions` | create module/form session | required |
| `POST /v1/mock-sessions/{id}/recover` | technical recovery boundary | required |
| `POST /v1/mock-sessions/{id}/submit` | finish composite | required |

## 8. Acceptance cases

| ID | Case | Expected evidence |
|---|---|---|
| `LR-01-answer-normalization` | answer outside the reviewed accepted set does not auto-pass | item fixture + normalization trace |
| `LR-02-module-conversion` | Academic/GT conversion cannot mix modules or use an unapproved table | result + versioned conversion ref |
| `LR-03-no-answer-leak` | before submission, key/explanation is not exposed | UI/API/redaction run |
| `LR-04-media-recovery` | media/content failure permits governed recovery without false wrong-answer evidence | fault injection + state trace |
| `LR-05-listening-summary` | `L_summary_completion` resolves through content, answer, explanation, and review contracts | fixture + attempt trace |
| `SP-01-recording-consent` | without consent, do not record/evaluate | privacy run |
| `SP-02-part-timing` | Part 2 preparation/long-turn timing follows strict-mock contract | timer + recording trace |
| `SP-03-speaking-evidence` | finding has supported segment evidence or insufficient-evidence state | evaluation mapping |
| `SP-04-speaking-retry` | provider/transcription retry does not duplicate | idempotency trace |
| `SP-05-mode-boundary` | guided coaching cannot appear in strict mock | interaction trace |
| `PR-01-unit-routing` | each P unit routes to the correct drill/reference | fixture + unit ref |
| `PR-02-no-fake-band` | pronunciation features do not create an independent IELTS band | API assertion |
| `PR-03-pronunciation-retest` | retest uses new content with the same target pattern | content refs |
| `MK-01-session-recovery` | app/network failure recovers the correct component without resetting attempt/timer policy | session trace |
| `MK-02-module-routing` | Academic/GT form and approved conversion are correct | form + result refs |
| `MK-03-incomplete-result` | missing required section evidence does not invent an overall band | incomplete evidence |
| `MK-04-strict-answer-lock` | strict mock locks explanation/key until allowed | acceptance run |

All IDs remain `not_run`; no runtime evidence is claimed by this specification.

## 9. Build gate

Before code, each skill slice needs an experience slice, content/stimulus contract, data/attempt contract, API, event, failure/recovery, evaluation/answer rule, review/retest mapping, benchmark corpus where applicable, and acceptance manifest. Missing layers keep the slice at `spec_candidate`.
