# Interaction Contract — STUDY.DailyAction

| Step | User intent | Command/API | Expected UX | Runtime completion | Failure UX |
|---|---|---|---|---|---|
| 1 | Open today | OpenToday | Plan loading | Plan version loaded | Retry/stale notice |
| 2 | Choose action | SelectNextAction | Reason + CTA | Action reserved | Show bounded alternatives |
| 3 | Begin | StartAction | Active session | Checkpoint created | Restore/retry |
| 4 | Pause/resume | PauseSession/ResumeSession | Paused/resumed state | Checkpoint updated | Use last durable checkpoint |
| 5 | Finish | CompleteSession | Completion summary | Session completed | Prevent duplicate completion |

Completion evidence: plan version, action reason, session state transition, and completion fact.
