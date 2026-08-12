# Interaction Contract — REVIEW.ErrorToReview

| Step | User intent | Command/API | Expected UX | Runtime completion | Failure UX |
|---|---|---|---|---|---|
| 1 | Open queue | OpenReviewQueue | Due cards | Queue snapshot loaded | Empty queue alternatives |
| 2 | Review error | ReviewCard | Recall/apply interaction | Review attempt persisted | Retry without rating duplicate |
| 3 | Rate | RateRecall | Next due state | FSRS transition persisted | Preserve prior state |
| 4 | Retest | StartRetest | New task/item | Retest started | Invalid retest explanation |
| 5 | Submit retest | SubmitRetest | Improvement/result | Error resolved or recurring | Keep error open |

Completion evidence: source finding, review transition, retest item identity, and outcome.
