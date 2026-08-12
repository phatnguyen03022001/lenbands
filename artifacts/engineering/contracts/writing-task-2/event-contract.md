# Writing Task 2 — Event Contract Extension

These events use the envelope/semantic rules in `blueprint/03-features.md`; this file specifies the producer, consumer, and required references for the Writing slice.

| Event | Producer | Required references | Consumers | Quality rule |
|---|---|---|---|---|
| `writing_task_opened` | task service (backend) | task_ref, session_id | learning analytics | no raw text; SPA does not emit analytics directly |
| `writing_draft_saved` | backend sync | draft_id, task_ref | recovery | idempotent version |
| `writing_submission_accepted` | submission service | submission_id, task_ref | quota, evaluation | valid draft only |
| `evaluation_submitted` | evaluation orchestrator | submission_id, evaluation_id, evaluation_kind | quota, cost, observability | canonical Blueprint event |
| `evaluation_scored` | evaluation pipeline | submission_id, evaluation_id, quality_status | history, review, readiness | canonical; `quality_status` follows 07-conventions |
| `evaluation_delayed` | evaluation orchestrator | submission_id, reason_class | recovery/notification | canonical; no provider failure text |
| `evaluation_failed` | evaluation worker | submission_id, reason_class | recovery/observability | canonical; not counted as scored |

`learning_error_saved`, fix/review, and retest events belong to `REVIEW.ErrorToReview`; the canonical producer/payload is in `artifacts/engineering/contracts/error-to-review/event-contract.md`. Writing provides only the `FeedbackFinding`/evaluation reference as input and does not co-own the event.

Event properties use the Blueprint envelope; `privacy_class` is `assessment` (single member per controlled enum — manifest P0-04 canonical, convergence audit M4). No raw essay, prompt body or provider payload may be emitted.
