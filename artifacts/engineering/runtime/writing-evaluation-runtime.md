# Owner Runtime Spec — WRITING.Evaluation

## Identity

- `family_id`: `WRITING.Evaluation`
- `family_version`: `1.0.0`
- `lifecycle`: `ACTIVE`
- `build_status`: `candidate`
- `owner`: product + engineering
- `delta`: `WRITING.Task2`

## Purpose and non-goals

Allow a learner to open a Task 2 prompt, save a draft, submit an immutable essay, receive evidence-linked rubric feedback, and enter the error-to-review flow. Academic Task 1, GT Task 1, human examiner replacement claims, and automatic publication are out of this family’s current scope.

## Actors and commands

Learner: `OpenTask`, `SaveDraft`, `SubmitEssay`, `ViewEvaluation`, `AcknowledgeFinding`, `RetryDelayedEvaluation`. Runtime: `PersistSubmission`, `EvaluateSubmission`, `PersistEvaluation`, `CreateFindings`.

## Interaction path

Open prompt → edit/save draft → submit → validate/quota/idempotency → persist submission → evaluate synchronously or asynchronously → persist evaluation → create findings → show result or safe delayed/low-confidence state.

## Runtime boundary and state

Submission status (runtime-spec.md §5.2): `submitted → processing → scored | low_confidence | delayed | unavailable`; `not_created` applies when validation/quota is denied before submission creation. `drafting` is a pre-submission draft state (draft service), not a submission status.

Evaluation state is a separate axis (runtime-spec.md §5.3): `submitted → processing | scored | low_confidence | invalid | anti_gaming_review | failed`. `anti_gaming_review`/`invalid`/`failed` belong to evaluation state, not public submission status.

Submission and evaluation are separate aggregates. Evaluation writes are idempotent by submission and evaluator version.

## Entities and ownership

`WritingTask`, `WritingDraft`, `WritingSubmission`, `WritingEvaluation`, `CriterionResult`, `FeedbackFinding`. Writing owns submission/evaluation; Error-to-Review owns derived review cards after a valid finding.

## API/contract references

- `artifacts/engineering/contracts/writing-task-2/openapi.yaml`
- `artifacts/engineering/contracts/writing-task-2/data-contract.md`
- `artifacts/engineering/contracts/writing-task-2/evaluation-contract.md`

## Events

`writing_task_opened`, `writing_draft_saved`, `writing_submission_accepted`, `evaluation_submitted`, `evaluation_scored`, `evaluation_failed`, `evaluation_delayed`.

`learning_error_saved` belongs to `REVIEW.ErrorToReview`; Writing provides the finding reference but does not emit or co-own that event.

Events contain IDs, statuses, versions, and redacted metrics only; never essay text, finding text, or prompt raw content.

## Failure and recovery

Validation failure does not persist a submission. Quota failure preserves the draft. Provider timeout retries only the evaluation job. Repeated failure produces `delayed` or `unavailable`, never a fabricated score. Low confidence is visible and blocks false certainty.

## Acceptance

- duplicate submit creates one submission;
- provider timeout preserves submission and is retryable;
- evaluation cannot be persisted without rubric/evidence version;
- raw essay is absent from events/logs;
- findings link to criterion and source evaluation;
- anti-gaming/insufficient-evidence states do not return a normal band claim.

## Executor dossier — permission, data, UI, observability, adapter

- **Permission**: `learner:read` + `learner:write` (draft, submission, evaluation, feedback) scoped to `subject_id`; raw essay text only via learner-scoped draft service. No cross-user access.
- **Data read/write**: learner writes `WritingDraft` (raw text, learner-scoped), `WritingSubmission` (refs: `draft_id` + `draft_version`, no duplicate text); runtime writes `WritingEvaluation`, `CriterionResult`, `FeedbackFinding`. Privacy class `assessment` (manifest P0-04 canonical).
- **API**: `GET writing task`, `SaveDraft`, `POST writing submission` (idempotent), `GET evaluation`, `AcknowledgeFinding` per openapi.yaml; validation/quota denial returns `not_created` (no submission status).
- **Events**: producer `writing_task_opened`, `writing_draft_saved`, `writing_submission_accepted`, `evaluation_submitted/scored/failed/delayed`, `writing_feedback_viewed`; consumer `quota_warning_shown`, `quota_exceeded`. `learning_error_saved` owned by REVIEW.ErrorToReview.
- **UI/UX states**: per `writing-task-2.md` §5/§6 — Task (loading/empty/unavailable), Editor (idle/drafting/autosaving/validation_error/offline), Submit Confirm, Evaluating (processing/delayed/low_confidence/anti_gaming_review/unavailable), Feedback (scored/low_confidence/partial), Fix Drill, Review/Retest. WCAG AA, keyboard, autosave-no-loss.
- **Observability**: rubric/model/evidence version on every evaluation; raw essay excluded from telemetry (redaction acceptance WR-06); p95 SLOs per observability-slo-contract.md.
- **Rollback/kill-switch**: model/rubric route via provider-adapter feature-flag (no API/event/domain migration); rollback preserves submission and delays/unavailable state; kill-switch applies to evaluation route, never to retained draft.
- **Provider adapter boundary**: evaluation through provider-neutral adapter (provider-adapter-contract.md); prompt template fixed (`writing_evaluation_v1.md`), no free-form override; provider swap requires benchmark + dual-run before learner-visible change.
- **Non-goals**: academic Task 1, GT Task 1, human examiner replacement claim, auto-publication.
- **Deferred**: `EVAL.RewriteSuggestion` (P1), `PERSONAL.Insights` (P1), `STUDY.Resume`/`PKM.Offline` (P1), `GOVERNANCE.AntiGaming` (P1 — P0 placeholder `anti_gaming_status: unchecked`).

## Evidence and dependencies

Evidence: gold corpus, benchmark run, redaction acceptance, idempotency acceptance. Dependencies: `IDENTITY.Core`, published writing task, rubric/error taxonomy, quota/runtime contracts, `ADR-0001`.
