# Writing Task 2 — Event Contract Extension

These events specialize the canonical event envelope/rules in `blueprint/03-features.md`. They contain opaque references and derived classes only; no raw essay/prompt/provider payload.

| Event | Producer | Required references/properties | Consumers | Rule |
|---|---|---|---|---|
| `writing_task_opened` | task/application service | `task_ref`, `task_version`, session ref | product analytics | backend/domain fact; no raw task/essay text |
| `writing_draft_saved` | draft service | `draft_id`, `task_ref`, `draft_version`, save state | recovery/analytics | emit after durable server save; local-only save is not server-saved fact |
| `writing_submission_started` | submission boundary | draft/task refs | funnel/diagnosis | does not mean durable acceptance |
| `writing_submission_accepted` | submission service | `submission_id`, `operation_id`, `task_ref`, `task_version` | quota/evaluation/observability | emit only after durable commit |
| `evaluation_submitted` | evaluation orchestrator | `submission_id`, `operation_id`, `scorer_route_version` | cost/observability | describes accepted evaluation work, not an evaluation result |
| `evaluation_scored` | result-admission pipeline | `submission_id`, `evaluation_id`, `result_validity`, `score_label`, `score_scope` | history/review/outcome measurement | emit only after immutable normalized result is committed |
| `evaluation_delayed` | orchestrator | `submission_id`, `operation_id`, `reason_class` | recovery/notification | technical lifecycle only; no result-validity inference |
| `evaluation_failed` | orchestrator/result pipeline | `submission_id`, `operation_id`, `reason_class` | recovery/observability | technical terminal failure; not counted as scored |
| `writing_feedback_viewed` | application service | `evaluation_id`, feedback/finding refs viewed | helpfulness/outcome | view is activity, not learning improvement |

## Result validity boundary

`evaluation_scored.result_validity` uses:

```text
accepted | limited_evidence | insufficient_evidence | invalid | integrity_review
```

There is no `quality_status=low_confidence` event field. Raw scorer confidence/uncertainty remains restricted routing/governance data and does not become a learner-facing event truth.

An `evaluation_scored` event with `limited_evidence` or `insufficient_evidence` is still a fact that a result resource was created; consumers must apply their own evidence-admission rule rather than counting every scored event as progress/readiness.

## Consumer boundary

- History may display the result with its scope/validity.
- Review/remediation may consume only findings admitted for learning use.
- Readiness/mastery is **not** updated directly from the event; the owning evidence policy evaluates admitted evidence first.
- Cost/observability uses route/cost refs, not learner content.

`learning_error_saved`, fix/review and retest events are owned by `REVIEW.ErrorToReview` in the sibling error-to-review event contract. Writing provides normalized `FeedbackFinding` references only.

## Privacy and idempotency

- `privacy_class=assessment` where the event references assessment objects; payload remains redacted/opaque.
- no raw essay, evidence quote, prompt body, private note, provider response or model hidden reasoning;
- producer events follow domain idempotency so retry/replay does not duplicate logical outcome facts;
- backfills carry canonical backfill source/reason and must not trigger accidental notifications/recommendations.

## Forbidden

- SPA emits `evaluation_scored` before canonical result commit;
- `evaluation_submitted` invents an `evaluation_id` before result creation when only operation exists;
- event uses `low_confidence` as evaluation lifecycle/failure state;
- `evaluation_scored` alone marks learner error fixed/mastery/readiness improved;
- raw model confidence is emitted as correctness probability.