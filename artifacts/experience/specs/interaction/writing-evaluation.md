# Interaction Contract — WRITING.Evaluation

> **Deprecated.** Canonical interaction specification for P0-04 is now
> `artifacts/experience/specs/interaction/writing-task-2.md` (10-step
> WR-I01..I10 with per-step failure/recovery, evidence, and runtime-spec
> traceability). This 6-step contract is retained for reference only and
> must not be used as a build input. See H7 resolution in convergence audit.

| Step | User intent | Command/API | Expected UX | Runtime completion | Failure UX |
|---|---|---|---|---|---|
| 1 | Open Task 2 | GET writing task | Prompt/editor | Task version loaded | Content unavailable/retry |
| 2 | Save draft | SaveDraft | Saved indicator | Draft version persisted | Retry; preserve local draft |
| 3 | Submit | POST writing submission | Processing state | Immutable submission accepted | Validation/quota error |
| 4 | Wait/evaluate | EvaluateSubmission | Progress or delayed state | Evaluation persisted | Retry/delayed/unavailable |
| 5 | Read feedback | GET evaluation | Criteria/findings | Feedback rendered | Explain incomplete evidence |
| 6 | Enter review | AcknowledgeFinding | Review CTA | Finding reference created | No card without evidence |

Completion evidence: submission, evaluation status/version, criterion results, finding references, and redaction/idempotency results.
