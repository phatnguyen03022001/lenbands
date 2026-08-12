# Vertical Slice — Writing Task 2

## 0. Specification status

Canonical metadata is in `writing-task-2.meta.yaml`; do not keep duplicate lifecycle metadata in the body.

This is the specification for LenBands' first vertical slice. It is currently `draft`, not an official build input: benchmark, review, and acceptance runs do not yet exist. Behavior is anchored by capability IDs in §2; design artifacts are reference representations, not source identity.

Canonical runtime orchestration, normalized `FeedbackFinding`, API pending behavior, and the exact acceptance boundary are in `artifacts/engineering/contracts/writing-task-2/runtime-spec.md`; the sections below are learner-experience summaries and must not redefine them.

The canonical interaction path is in `artifacts/experience/specs/interaction/writing-task-2.md`; do not implement individual states/APIs until the interaction table is resolved.

## 1. Product goal

The learner writes an IELTS Writing Task 2 essay, receives evidence-backed feedback, chooses the most important error to fix, then reviews and retests to verify that the error has decreased.

```text
Task
  → Draft
  → Submit
  → Evaluation
  → Error Graph
  → Micro-fix
  → Mistake Notebook
  → FSRS Review
  → Retest
```

### Out of scope for this slice

- Speaking evaluation.
- Human examiner workflow.
- Full content authoring/collaborator workflow.
- Real payment; only the quota/access boundary is needed.
- Fine-tuning or per-learner FSRS optimization.

## 2. Traceability

P0-04 canonical capability IDs: `LEARN.Writing`, `EVAL.Writing`, `COACH.ErrorAnalysis`, `COACH.Feedback`, `PKM.Drafts`. The capabilities below are referenced but outside the P0-04 pack scope:

| Type | Reference | P0-04 scope |
|---|---|---|
| Capability | `LEARN.Writing`, `EVAL.Writing` | **in-pack** |
| Capability | `EVAL.RewriteSuggestion` | **out-of-scope (P1)** — referenced for future rewrite loop only |
| Feedback | `COACH.Feedback`, `COACH.ErrorAnalysis` | **in-pack** |
| Review | `REVIEW.MistakeNotebook`, `REVIEW.FSRS`, `REVIEW.SmartQueue` | **in-pack (P0-05)** |
| Personalization | `PERSONAL.NextBestAction`, `PERSONAL.Insights` | **out-of-scope (P1)** — Today/NBA uses deterministic rules in P0 |
| Governance | `GOVERNANCE.ConfidenceScore`, `GOVERNANCE.AuditTrail` | **in-pack (P0-06)** |
| Governance | `GOVERNANCE.AntiGaming` | **unresolved gap** — capability is P1; P0-04 evaluation flow requires `anti_gaming_status` and `anti_gaming_review` state (runtime-spec §5.3) but no P0 pack owns the anti-gaming capability. Until resolved, P0 anti-gaming detection is a placeholder adapter returning `anti_gaming_status: unchecked`. See convergence audit M10. |
| Runtime | `STUDY.Session` | **in-pack (P0-03)** |
| Runtime | `STUDY.Resume`, `PKM.Offline` | **out-of-scope (P1)** — P0 uses basic session/draft save without cross-device resume |

## 3. Users and permissions

| Role | Permission |
|---|---|
| Learner free | View task, save draft, submit within quota, view completed feedback |
| Learner premium | Same as free, with package-based quota |
| Collaborator | Outside the learner flow; cannot read a private draft without permission |
| Admin | View aggregate quality/audit only; cannot directly edit learner feedback in this slice |

Privacy rule: essays, drafts, evaluations, and personal errors are learner-private runtime data. Do not put essay text into analytics events or ordinary logs.

## 4. Entry and exit

### Entry conditions

One of the following conditions:

- The learner clicks `Writing Task 2` from Today.
- The learner selects `Writing` → `Task 2` from Skill Practice.
- `PERSONAL.NextBestAction` recommends this task.
- The learner selects a retest for a due Writing Error.

If no valid task exists, show an empty state and CTA `Choose another Writing task`. Do not create a random task when content has not been published.

### Exit conditions

- Draft is saved and the learner leaves the screen: draft state `drafting` (pre-submission; not a submission status).
- Successful submission: submission status moves `submitted` → `processing` (runtime-spec §5.2).
- With a valid evaluation: submission status moves to `scored`; Error Graph candidates are created automatically, but Review Cards are created only after the learner confirms the error (runtime-spec §D.7, §F.3 — do not auto-create a card).
- The learner completes the micro-fix: move to the review domain (`REVIEW.ErrorToReview`).
- Retest meets criteria: error state `improved` (error-to-review contract); otherwise return to the review queue.

## 5. State machine

Canonical submission lifecycle is in `runtime-spec.md` §5.2/§5.3. The states below are a UX-flow view; each state must map to the canonical runtime spec. UX-only states (such as `drafting`) are explicitly not persisted submission statuses.

```text
idle (UX only — pre-submission)
  ↓ open task
drafting (UX only — pre-submission; draft state ≠ submission status)
  ├─ autosave → drafting
  ├─ exit → drafting (resume later)
  └─ submit valid → submitted (runtime-spec canonical)

submitted (runtime-spec: submission accepted; outbox committed)
  ↓ job claimed
processing (runtime-spec canonical)
  ├─ accepted result → scored
  ├─ low_confidence result → low_confidence (runtime-spec canonical)
  ├─ invalid/insufficient evidence → unavailable
  ├─ delayed → delayed
  ├─ anti-gaming signal flagged → anti_gaming_review (evaluation state, not submission status)
  └─ provider/system failure → unavailable

anti_gaming_review (evaluation state — runtime-spec §5.2)
  ├─ route recheck clears signal → processing (re-evaluate)
  └─ route remains unavailable → unavailable

scored (runtime-spec canonical — submission status terminal)
  ├─ learner confirms error → review domain (REVIEW.ErrorToReview)
  └─ learner skips → scored (no error saved)

low_confidence (runtime-spec canonical)
  ├─ learner confirms evidence-backed error → review domain
  ├─ learner submits feedback → low_confidence
  └─ retry evaluation → processing
```

When submission is blocked by validation/quota/network, it does not create a new submission status; corresponding UX states (`quota_exceeded`, `pending_sync`) are UX-only and map to `not_created` (runtime-spec §5.2). The canonical review/retest state machine is in the `error-to-review` vertical slice and `REVIEW.ErrorToReview` runtime spec.

## 6. Screen inventory

| Screen | Purpose | Primary action | Required states |
|---|---|---|---|
| `WR-01 Task` | Understand task and start writing | Start writing | loading, empty, unavailable |
| `WR-02 Editor` | Write and save draft | Submit | idle, drafting, autosaving, validation_error, offline |
| `WR-03 Submit Confirm` | Confirm submission | Submit and evaluate | confirm, quota_exceeded (UX-only → not_created) |
| `WR-04 Evaluating` | Wait for a long task or route recheck | Leave while retaining state | processing, delayed, low_confidence, anti_gaming_review, unavailable |
| `WR-05 Feedback` | Understand errors and choose priority | Fix this error | scored, low_confidence, partial |
| `WR-06 Fix Drill` | Fix one specific error | Complete fix exercise | empty, in_progress, complete |
| `WR-07 Review/Retest` | Verify the error has decreased | Start retest | due, done, needs_review |

### WR-01 — Task

- Display: task prompt, task type, word target, expected time; internal source/license status is not shown to the learner.
- If the task has a prerequisite, explain it briefly before starting.
- Primary CTA: `Start writing`.
- Secondary CTA: `Later` → save task to the plan, do not create an empty draft.

### WR-02 — Editor

- Sections: collapsed task prompt, editor, word count, optional timer, autosave status, submit bar.
- Word count is informational; validate on submit:
  - Task 2 minimum 250 words.
  - Text is not empty.
- Autosave locally first, sync to the server later; network loss must not delete text.
- `Cmd/Ctrl+Enter` opens submit confirmation; it does not submit immediately.
- Leaving the screen must show `Saved` or `Saving`.

### WR-03 — Submit Confirm

- Copy: `Submit for evaluation? You cannot edit this version after submission.`
- Show word count and remaining quota.
- Buttons: `Back to edit`, `Submit`.
- If quota is exhausted: do not lose the draft; show a clear alternative.

### WR-04 — Evaluating

- Display: `Evaluating writing`, progress by stage, and an estimated time when available.
- Do not require the user to poll or refresh.
- The learner may leave; Home displays `Result processing`.
- If >3 seconds: status feedback is required.
- If delayed/unavailable: retain the submission and allow an idempotent retry.

### WR-05 — Feedback

Content order:

1. Quality state + confidence/disclaimer; no band claim unless the named slice passes the learning measurement admission gate.
2. 4 criteria: Task Response, Coherence & Cohesion, Lexical Resource, Grammar.
3. Evidence in the essay.
4. Short explanation: what the issue is and why.
5. One highest-priority error.
6. One immediate corrective action.

Do not show a long feedback list without priority order.

If confidence is low:

- Label `Needs review`.
- Show the supporting evidence.
- Allow the learner to mark `This feedback is incorrect`.
- Do not use that score as a strong readiness signal.

Primary CTA: `Fix priority error`. Secondary CTAs: `Save`, `View all errors`, `Skip this time`.

### WR-06 — Fix Drill

- One session focuses on one error pattern.
- Show incorrect example → hint → learner rewrites independently → check.
- Do not auto-rewrite the entire essay for the learner.
- Completion must create fix evidence, not merely mark it as read.

### WR-07 — Review/Retest

- Review card requires recall before revealing the explanation.
- Rating FSRS: Again / Hard / Good / Easy.
- Retest uses a new prompt/passage with the same error pattern.
- `improved` applies only when the learner meets the acceptance criteria; see section 12.

## 7. Runtime data contract

This is runtime data, not a Knowledge Asset.

### WritingSubmission

Canonical shape is in `data-contract.md`; raw `text` exists only in the learner-scoped draft service and is not duplicated in the submission entity.

```yaml
submission_id: string
user_id: string
task_ref: string
draft_id: string
draft_version: integer
word_count: integer
status: submitted | processing | scored | low_confidence | unavailable | delayed
submitted_at: timestamp
evaluation_ref: string?
```

### WritingEvaluation

```yaml
evaluation_id: string
submission_id: string
rubric_version: string
model_version: string
criteria:
  task_response: { band: number, confidence: number, evidence_refs: [] }
  coherence_cohesion: { band: number, confidence: number, evidence_refs: [] }
  lexical_resource: { band: number, confidence: number, evidence_refs: [] }
  grammar: { band: number, confidence: number, evidence_refs: [] }
overall_band: number
overall_confidence: number
evaluation_state: submitted | processing | scored | low_confidence | invalid | anti_gaming_review | failed
quality_status: accepted | low_confidence | insufficient_evidence | invalid
anti_gaming_status: clear | action_required
created_at: timestamp
```

### LearningError

```yaml
error_id: string
user_id: string
source_evaluation_id: string
error_pattern: string
criterion: task_response | coherence_cohesion | lexical_resource | grammar
severity: high | medium | low
evidence_ref: string
status: open | in_review | improved | dismissed
confidence: number
created_at: timestamp
```

### ReviewCard

```yaml
card_id: string
user_id: string
content_ref: error_id
due: timestamp
stability: number
difficulty: number
reps: integer
last_rating: again | hard | good | easy
algorithm_version: string
```

## 8. API boundary

Contract names are logical boundaries; the current OpenAPI draft is in `engineering/contracts/writing-task-2/openapi.yaml`. Shared HTTP/job/cache/outbox/provider semantics are in the Runtime Contract Pack; this slice must not redefine them.

| Operation | Input | Output | Idempotency |
|---|---|---|---|
| `GET /writing/tasks/{task_ref}` | task ref | prompt + constraints | n/a |
| `PUT /writing/drafts/{draft_id}` | text + version | saved version + saved_at | version check |
| `POST /writing/submissions` | draft ref + idempotency key | submission ref + status | required |
| `GET /writing/submissions/{id}` | submission ref | status/evaluation ref | n/a |
| `GET /writing/errors` | optional status filter | learner-owned error list | n/a |
| `POST /writing/errors` | confirmed error + evidence ref | saved error | required |
| `GET /writing/errors/{id}` | error ref | error status + review-card ref | n/a |
| `POST /writing/submissions/{id}/retry` | submission ref | same submission status | required |
| `POST /writing/errors/{id}/fixes` | fix evidence | updated error status | required |
| `POST /review/cards/{id}/ratings` | rating | next due + updated card | required |
| `POST /writing/submissions/{id}/feedback` | label + note | accepted feedback ref | required |

## 9. Events

Events must use the envelope in the Blueprint Event Contract and contain no essay text. The Writing family emits `evaluation_submitted`, `evaluation_scored`, `evaluation_failed`, `evaluation_delayed`; the Review family emits `learning_error_saved`, `review_completed`, `retest_completed`. The vertical slice observes the full loop but does not transfer ownership between families. The lifecycle/detail events below are registered extensions only; do not rename or replace outcome events.

```text
writing_task_opened
writing_draft_saved
writing_submission_started
writing_submission_accepted
evaluation_submitted
evaluation_scored
evaluation_delayed
evaluation_failed
writing_feedback_viewed
learning_error_saved
learning_error_fix_started
learning_error_fix_completed
review_card_created
review_card_rated
review_completed
retest_started
retest_completed
```

## 10. Failure contract

| Failure | User-facing state | Recovery |
|---|---|---|
| Draft save fail | `Saving locally` | Retry sync, retain text |
| Network submit fail | `Unable to submit` | Retry with the same idempotency key |
| Quota exceeded | `Evaluation quota used` | Retain draft, alternative/upgrade |
| Evaluation delayed | `Taking longer than expected` | Leave screen, notify when complete |
| Evaluation unavailable | `Evaluation is unavailable right now` | Retry, retain submission |
| Anti-gaming review | `Result is being checked further` | Do not show a temporary score; route recheck or unavailable state |
| Low confidence | `Needs review` | View evidence, learner feedback |
| Content unavailable | `Task is no longer available` | Choose another published task |

Do not show stack traces, provider names, or technical failure codes to the learner.

## 11. Quality and cost guardrails

### Quality

- Each criterion must have at least one evidence reference or status `insufficient_evidence`.
- Do not show an overall band if evaluation does not pass the quality gate.
- Run benchmark regression before changing the prompt/model/rubric.
- Store model version, rubric version, and evaluation trace for audit.
- System feedback must have scoped uncertainty copy; do not show a band claim if the named slice has not passed the learning measurement admission gate.

### Cost

- Do not call evaluation when the draft is not eligible for submission.
- Autosave uses debounce and sends only the necessary delta/version.
- Retry is bounded and idempotent.
- Generate detailed feedback only after the learner opens the result; the summary may use a less costly output.
- Micro-fix prioritizes short content/prompts and reuses Knowledge Assets.

## 12. Acceptance tests

### Critical path

- [ ] Learner opens a published task and sees the prompt + word target.
- [ ] Learner writes under 250 words and receives inline validation on submit.
- [ ] Draft autosaves; reload does not lose text.
- [ ] Submit creates exactly one submission even if the user clicks twice.
- [ ] Evaluation shows processing if it exceeds 3 seconds.
- [ ] Completed evaluation shows 4 criteria, overall, confidence, and evidence.
- [ ] Feedback creates at least one learning error with a source evaluation.
- [ ] Learner selects one error and completes the fix drill.
- [ ] Fix drill creates or updates a ReviewCard.
- [ ] FSRS rating creates a new `due` value.
- [ ] Retest uses new content/prompt with the same error pattern.
- [ ] Retest marks `improved` only when the defined criterion is met.

### Recovery

- [ ] Network loss during draft: text remains local.
- [ ] Network loss during submit: retry does not create a duplicate submission.
- [ ] Evaluation timeout: learner can leave and still receives the result after completion.
- [ ] Quota exhausted: draft is retained and the learner understands the alternative.
- [ ] Low confidence: band is not used as a strong readiness signal.
- [ ] Retired content: learner is routed to a replacement task.

### Success metric

The slice is considered quality-ready only when it measures:

- Rate of submissions receiving valid evaluation.
- Rate of evidence-backed feedback opened by the learner.
- Rate of errors moved into review.
- Fix-drill completion rate.
- Rate of retests showing error improvement.
- Average evaluation cost per submission.
