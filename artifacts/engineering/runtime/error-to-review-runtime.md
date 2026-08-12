# Owner Runtime Spec — REVIEW.ErrorToReview

## Identity

- `family_id`: `REVIEW.ErrorToReview`
- `family_version`: `1.0.0`
- `lifecycle`: `ACTIVE`
- `build_status`: `candidate`
- `owner`: product

## Purpose and non-goals

Convert a valid evaluation finding into a review card, schedule it, collect a review response, and create a retest outcome. It does not create cards from unsupported prose or invent an error taxonomy.

## Actors and commands

Learner: `OpenReviewQueue`, `ReviewCard`, `RateRecall`, `StartRetest`, `SubmitRetest`. Runtime: `CreateReviewCard`, `ScheduleCard`, `ResolveError`.

## Interaction path

Valid finding → create card → queue due card → learner recalls/applies → rate response → FSRS transition → retest with a new task/item → compare outcome → resolve or reschedule.

## Runtime boundary and state

Card: `created → learning → review → relearning → graduated`. Error: `open → in_review → improved → dismissed` (states per OpenAPI LearningError.status). `resolved` and `recurring` are terminal states (see lifecycle contract). Retest is a separate `RetestAttempt` entity, not a LearningError state transition; the error stays `in_review` during retest.

## Entities and ownership

`LearningError`, `ReviewCard`, `ReviewAttempt`, `RetestAttempt`. Review owns scheduling/card state; Writing owns source evaluation/finding.

## API/contract references

- `artifacts/engineering/contracts/error-to-review/data-contract.md`
- `artifacts/engineering/contracts/error-to-review/event-contract.md`
- `artifacts/engineering/contracts/error-to-review/failure-contract.md`

## Events

`review_card_created`, `review_queue_opened`, `review_card_rated`, `review_completed`, `review_card_graduated`, `retest_started`, `retest_completed`, `learning_error_resolved`.

Events contain IDs and state transitions only.

## Failure and recovery

`NO_EVIDENCE_NO_CARD` rejects unsupported card creation. `REVIEW_QUEUE_EMPTY` offers a permitted alternative. `RETEST_INVALID` preserves the error and does not mark it resolved.

## Acceptance

- no evaluation evidence means no card;
- card transition is deterministic and idempotent;
- duplicate rating does not double schedule;
- retest uses a new task/item;
- resolution requires improvement evidence;
- recurring error reopens without deleting history.

## Evidence and dependencies

Evidence: review scheduling acceptance and retest outcome acceptance. Dependencies: `WRITING.Evaluation`, error taxonomy, review mapping, deterministic FSRS contract.

## Executor dossier — permission, data, UI, observability, adapter

- **Permission**: `learner:read` (review queue, cards, errors) + `learner:write` (rate card, start retest, submit retest). Cross-user isolation by `subject_id`; all review/retest data is learner-scoped.
- **Data read/write**: learner reads `LearningError`, `ReviewCard`, `ReviewAttempt`, `RetestAttempt`; runtime writes card/schedule/retest outcomes. `RetestAttempt` uses a new task/item (never replays original submission). Writing owns source evaluation/finding; Review owns derived cards and scheduling state — no data duplication across families.
- **API**: `GET /v1/writing-errors`, `POST /v1/writing-errors/{id}/fix`, `POST /v1/writing-errors/{id}/retest`, `GET /v1/review-cards`, `POST /v1/review-cards/{id}/rate` (per data-contract.md). Idempotent mutation; duplicate rating does not double-schedule.
- **Events**: producer `review_card_created`, `review_queue_opened`, `review_card_rated`, `review_completed`, `review_card_graduated`, `retest_started`, `retest_completed`, `learning_error_resolved`; consumer `evaluation_scored` (from WRITING.Evaluation). `learning_error_saved` is a Review-owned event — Writing provides the finding reference but does not co-own it. Event payloads contain IDs and state transitions; no essay text, finding text, or learner content.
- **UI/UX states**: per `error-to-review.md` — Error List (empty/no_evidence/error_list), Review Queue (empty/loading/queue), Card Detail (question/recall), Rating (again/hard/good/easy), Retest (new prompt/loading/result). `NO_EVIDENCE_NO_CARD` shows empty state; `REVIEW_QUEUE_EMPTY` offers permitted alternative; `RETEST_INVALID` preserves error without fake resolution. WCAG AA, keyboard, reduced-motion for card transitions.
- **Observability**: FSRS version + error taxonomy version on every card/transition; card graduation/resolution metrics; raw learner content excluded from telemetry per observability-slo-contract.md.
- **Rollback/kill-switch**: FSRS schedule is deterministic and versioned; kill-switch blocks new card creation but preserves existing cards and scheduling state (no data loss); card transition idempotent.
- **Provider adapter boundary**: P0 FSRS is deterministic (no provider call). If a later spaced-repetition provider is introduced, it must go through provider-adapter-contract.md and benchmark. Provider vocabulary never enters card/error domain.
- **Non-goals**: not a general spaced-repetition platform, not a content-authoring review system, no manual/human review workflow.
- **Deferred**: `REVIEW.QuestionReview`/`REVIEW.WrongAnswer`/`REVIEW.WrongQuestion`/`REVIEW.Queue`/`REVIEW.History`/`REVIEW.Bookmark` (all P1/deferred); P0 scope is `REVIEW.MistakeNotebook` + `REVIEW.FSRS` + `REVIEW.SmartQueue` + `PRACTICE.Drill` (retest only).
- **Cross-family ownership note**: `PRACTICE.Drill` (P0 ACTIVE) lives in this family's runtime boundary for retest/drill execution. The separate `PRACTICE.Drill` family (PLANNED) hosts `PRACTICE.Set`/`PRACTICE.Timed`/`PRACTICE.Adaptive` for general drill types — this is an intentional architecture decision, not an orphan.
