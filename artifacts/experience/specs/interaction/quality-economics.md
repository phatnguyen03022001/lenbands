# Interaction Contract — OPS.QualityEconomics

| Step | Operator intent | Command/API | Expected UX | Runtime completion | Failure UX |
|---|---|---|---|---|---|
| 1 | Inspect quality | OpenQualityDashboard | Current gate status | Facts loaded with versions | Stale/unavailable indicator |
| 2 | Run benchmark | CreateBenchmarkRun | Running/progress | Immutable run stored | Run failure marked |
| 3 | Evaluate gate | EvaluateGate | Pass/block reasons | Decision persisted | Block by default |
| 4 | Approve/block | ApproveGate/BlockRelease | Confirmation | Audit record written | Require reason/retry |
| 5 | Roll back | Rollback | Rollback progress | Rollback record persisted | Escalate and preserve evidence |

Completion evidence: immutable benchmark/cost records, gate decision, actor, reason, and rollback status.
