# Interaction Contract — PLACEMENT.Diagnosis

| Step | User intent | Command/API | Expected UX | Runtime completion | Failure UX |
|---|---|---|---|---|---|
| 1 | Set target | SetGoal | Goal form/result | Goal version persisted | Validation error |
| 2 | Start baseline | StartPlacement | Instructions + progress | Attempt created | Config unavailable/retry |
| 3 | Answer | SubmitPlacementResponse | Next item/progress | Response persisted | Retry; no duplicate |
| 4 | Finish | ScorePlacement | Processing/result | Band/gap or insufficient evidence | Safe insufficient-evidence state |
| 5 | Accept path | AcceptInitialPath | Plan confirmation | Initial path linked to evidence | Regenerate/retry |

Completion evidence: goal, attempt, score status, gap profile, and initial path references.
