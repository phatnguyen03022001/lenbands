# Multi-skill Practice Runtime Specification

## 0. Scope and status

This is the runtime specification for domains outside Writing Task 2: Listening, Reading, Speaking, Pronunciation, and Mock Test. It connects capability/framework IDs to implementable behavior but is not considered build-ready.

Status: `review` / `spec_candidate`. Gold corpus, calibration benchmark, source code, and acceptance evidence for these slices are still missing.

## 1. Shared practice model

| Component | Responsibility |
|---|---|
| Practice API | authz, content eligibility, attempt creation, idempotency |
| Content service | returns the published stimulus/question/prompt at the correct version |
| Attempt service | snapshots the item and stores the answer/recording reference and lifecycle |
| Answer evaluator | deterministic key/normalization for Listening/Reading |
| Speaking evaluator | transcript/features/rubric projection, not a human examiner |
| Pronunciation evaluator | phoneme/stress/intonation/connected-speech evidence |
| Review service | maps a wrong answer/finding to an error, card, and retest |
| Mock orchestrator | section order, timer, resume, and composite result |

There is no scheduler or generic compiler. Async is used only when the audio/evaluation boundary needs a worker.

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
- The content version is snapshotted; republishing does not change a historical attempt.
- `abandoned` does not count as a wrong answer if the learner has not submitted.
- Retrying with the same idempotency key does not create a second attempt.

### Practice modes

| Mode | Required behavior |
|---|---|
| `untimed_practice` | immediate answer/result, explanation after submit |
| `timed_practice` | deadline, elapsed time, pacing evidence, timeout state |
| `adaptive_practice` | the selection reason must be traceable to a weakness/type/band signal |
| `review` | recall/apply response and FSRS transition |
| `retest` | new content with the same error/micro-skill, measuring transfer |

## 2. Listening

Input is a published audio stimulus with transcript/segment boundary, rights, and a question belonging to one of 10 IDs:

`L_form_completion`, `L_note_completion`, `L_table_completion`, `L_sentence_completion`, `L_flow_chart_completion`, `L_map_plan_labelling`, `L_diagram_labelling`, `L_multiple_choice`, `L_matching`, `L_short_answer`.

```yaml
listening_result:
  attempt_id: string
  item_results:
    - question_ref: string
      answer_status: correct | incorrect | invalid | unanswered
      normalized_answer: string | null
      accepted_answer_ref: string | null
      error_ref: string | null
  score: integer
  total: integer
  explanation_refs: []
  audio_duration_ms: integer
  response_duration_ms: integer
```

Rules:

- Completion normalization uses case/whitespace/number/date/unit rules; a synonym outside the key does not auto-pass.
- MCQ/matching preserves option identity/order; do not expose the answer before submission.
- Maps, diagrams, and flow charts have versioned stimulus coordinate/label boundaries; do not freely parse images.
- Audio load failure preserves the attempt; do not count it as unanswered if the media has not played fully.

## 3. Reading

Input is a published passage snapshot, paragraph/section IDs, and one of 16 IDs:

`R_multiple_choice`, `R_multiple_choice_multi`, `R_true_false_not_given`, `R_yes_no_not_given`, `R_matching_headings`, `R_matching_information_paragraph`, `R_matching_information_section`, `R_matching_features`, `R_matching_sentence_endings`, `R_sentence_completion`, `R_summary_completion`, `R_note_completion`, `R_table_completion`, `R_flow_chart_completion`, `R_diagram_labelling`, `R_short_answer`.

Academic and General Training use the same IDs but do not share a passage profile or default raw-score conversion.

```yaml
reading_result:
  attempt_id: string
  passage_ref: string
  passage_version: string
  module: academic | general_training
  score: integer
  total: integer
  raw_to_band_ref: string
  item_results: []
  reading_duration_ms: integer
```

- `R_true_false_not_given` and `R_yes_no_not_given` have different explanation rules: fact versus writer view.
- Matching paragraph/section must store the correct scope.
- Completion uses versioned answer normalization and word-limit rules.
- Passage read position can resume; an answer not submitted does not create a wrong-answer event.

## 4. Speaking

| Part | ID | Input | Output |
|---|---|---|---|
| Part 1 | `S_part1_interview` | prompt/topic sequence | recording, transcript/features, FC/LR/GRA/PR result |
| Part 2 | `S_part2_long_turn` | cue card + 1-minute prep | prep notes, 1–2 minute recording, result |
| Part 3 | `S_part3_discussion` | follow-up sequence | multi-turn recording, abstract-reasoning result |

Basic practice uses a fixed prompt sequence. `EVAL.Examiner` interactive follow-up is a separate capability and is not inferred from Part 3.

```yaml
speaking_attempt:
  attempt_id: string
  part: S_part1_interview | S_part2_long_turn | S_part3_discussion
  prompt_ref: string
  prompt_version: string
  audio_ref: string
  duration_ms: integer
  transcript_ref: string | null
  consent_scope: recording | transcription | evaluation
  status: created | recording | uploaded | processing | evaluated | low_confidence | unavailable
  result_ref: string | null
```

Raw audio/transcript is read only through a learner-scoped service; events/logs/queues use opaque refs.

Evaluation must separate FC, LR, GRA, and PR; each finding needs timestamp/segment evidence or `insufficient_evidence`. Do not return an official band. Permission/upload/provider failure preserves the recording and retries within bounds; do not duplicate an evaluation.

## 5. Pronunciation

Pronunciation is a support domain for Speaking, not an IELTS exam section or independent band score. The `P_*` values below are canonical `practice_unit` values; drill variants must resolve through the microskill enum.

Units: `P_phoneme`, `P_word_stress`, `P_sentence_stress`, `P_intonation`, `P_linking`. Drill variants: `P_minimal_pair`, `P_chunking_pauses`.

```yaml
pronunciation_attempt:
  attempt_id: string
  practice_unit: string
  target_ref: string
  reference_audio_ref: string
  learner_audio_ref: string
  feature_result:
    phoneme_accuracy: number | null
    stress_alignment: number | null
    intonation_pattern: string | null
    intelligibility_signal: number | null
  evidence_refs: []
  status: created | recorded | processing | evaluated | low_confidence | unavailable
```

Feature scores must not become an IELTS PR band. Feedback must have a target, evidence, and next drill. Retest uses a new token/word/sentence with the same pattern; it does not pass merely by repeating the sample audio.

## 6. Mock Test / Exam Simulation

```yaml
mock_session:
  session_id: string
  user_id: string
  module: academic | general_training
  mode: practice | exam | timed | review
  test_form_ref: string
  test_form_version: string
  section_order: [listening, reading, writing, speaking]
  current_section: listening | reading | writing | speaking | completed
  state: created | in_progress | paused | submitted | scoring | completed | abandoned
  attempt_refs: []
```

Rules:

- `exam` mode locks the answer/explanation until composite submission.
- `timed` mode has a deadline for each section; network loss/app crash → `paused`/`resume_required`; do not reset or duplicate the attempt.
- Academic/GT routing and conversion must follow `exam-module-differences.md`.
- A composite result must not invent an overall band when a section is missing; use `incomplete` or `low_confidence`.
- Writing/Speaking results retain separate rubric/evidence state; do not turn them into a raw-score shortcut.

## 7. Shared API candidate

This is a candidate interface, not approved OpenAPI:

| Operation | Purpose | Idempotency |
|---|---|---|
| `GET /v1/practice/items/{contentId}` | published question/stimulus/prompt | n/a |
| `POST /v1/practice/attempts` | create attempt snapshot | required |
| `PUT /v1/practice/attempts/{id}/response` | save answer/response version | version/key |
| `POST /v1/practice/attempts/{id}/submit` | close and evaluate attempt | required |
| `GET /v1/practice/attempts/{id}` | status/result | n/a |
| `POST /v1/speaking/recordings` | upload recording ref | required |
| `POST /v1/pronunciation/attempts` | submit drill production | required |
| `POST /v1/mock-sessions` | create module/form session | required |
| `POST /v1/mock-sessions/{id}/pause` | durable pause/resume boundary | required |
| `POST /v1/mock-sessions/{id}/submit` | finish composite | required |

## 8. Acceptance cases

| ID | Case | Expected evidence |
|---|---|---|
| `LR-01-answer-normalization` | answer outside the registry does not auto-pass | item fixture + normalization trace |
| `LR-02-module-conversion` | Academic/GT conversion does not mix modules | result + conversion ref |
| `LR-03-no-answer-leak` | before submission, do not expose key/explanation/raw stimulus | UI/API/redaction run |
| `LR-04-media-recovery` | audio/passage failure still permits resume | fault injection + state trace |
| `SP-01-recording-consent` | without consent, do not record/evaluate | privacy run |
| `SP-02-part-timing` | Part 2 preparation/speaking timing is correct | timer + recording trace |
| `SP-03-speaking-evidence` | finding has segment evidence or low-confidence | evaluation mapping |
| `SP-04-speaking-retry` | provider/transcription retry does not duplicate | idempotency trace |
| `PR-01-unit-routing` | each P unit routes to the correct drill/reference | fixture + unit ref |
| `PR-02-no-fake-band` | pronunciation does not create an independent IELTS band | API assertion |
| `PR-03-pronunciation-retest` | retest uses a new token/sentence with the same pattern | content refs |
| `MK-01-session-resume` | crash/network loss resumes the correct section | session trace |
| `MK-02-module-routing` | Academic/GT test form and conversion are correct | form + result refs |
| `MK-03-incomplete-result` | a missing section does not invent an overall band | incomplete evidence |
| `MK-04-exam-answer-lock` | exam mode locks explanation/key | acceptance run |

All IDs are currently `not_run`; no real evidence exists yet.

## 9. Build gate

Before code, each skill slice must have an experience slice, content/stimulus contract, data/attempt contract, API, event, failure/recovery, evaluation/answer rule, review/retest mapping, benchmark corpus, and acceptance manifest. If any layer is missing, keep it as `spec_candidate`.
