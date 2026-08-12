# Interaction Model

## Purpose

This is the behavior source for learner-experience wireframes. It describes states, intent, system decisions, responses, and state transitions; it does not describe CSS or component implementation.

P0 implementation must be read with `p0-experience-contract.md`. This file holds the general model; the P0 Experience Contract locks behavior for the closed pilot.

## State-Driven Modes (shell behavior)

The learner shell renders by **mode** — a hard rule, not advice. The system determines mode from the state vector (band, exam date, streak, due queue); the learner does not choose it. Rendering details are in `navigation-model.md`.

| Mode | Stage (Today) | Emotional goal |
|---|---|---|
| `onboarding` | Welcome + baseline CTA | "The system understands me and provides a path" |
| `early` (band 3–5) | micro-session + 1 lesson, Tests hidden | "One small step each day, without pressure" |
| `core` (band 5.5–6.5) | full Today plan | "I am progressing along the path" |
| `exam_prep` (<30 days to exam) | exam readiness + prioritized weak skill | "I know what is missing and what to prioritize" |
| `comeback` (absent 7+ days) | 1 light micro-session, all drawers recede | "Return gently, without guilt" |

Mode rules:
- Mode changes automatically when the state vector changes (e.g. set an exam date → `exam_prep`; absent for 7 days → `comeback`).
- The learner can actively open hidden drawers, but they are not shown by default.
- Mode does not delete learner data; it changes only drawer prominence + stage content.

## Loop Spine (loop backbone)

Learner behavior is not "browsing the app"; it is **progressing through a loop**. Today is the router, and each loop state has one primary action.

```text
Diagnose → Learn → Practice → Fix → Review → Prove → (Diagnose again)
   ▲                                                        │
   └────────────────────────────────────────────────────────┘
```

| Loop position | Primary intent | System decision | Do not |
|---|---|---|---|
| Diagnose | "What band am I at?" | Provisional band + first plan | Call it an official score |
| Learn | "What should I study?" | Next lesson in path | Offer 5 equal choices |
| Practice | "Practice this question" | One clear task, sufficient feedback | Dump many unprioritized questions |
| Fix | "Which error should I fix?" | One priority error + evidence | Treat 10 errors as equal |
| Review | "What should I review today?" | Short due queue + source evidence | Use a card without evidence |
| Prove | "Have I improved?" | Retest/mock tied to the old error | Claim a higher band without data |
| (loop again) | "What comes next?" | Insight + next best action | Repeat the previous session exactly |

Today always shows the **current position + next step**, not the entire loop.

### Band Map — the symmetric surface of Today

Today = zoom-in (1 next action). **Band Map = zoom-out** (the full view of what is missing to reach band X). The learner needs both: "what to do today" + "how far remains to the target band".

| Behavior | Today | Band Map |
|---|---|---|
| Zoom | zoom-in | zoom-out |
| Primary intent | "what is the next step?" | "what is missing for band X?" |
| Render | 1 primary action | tree checklist per-skill + cross-skill |
| Entry | always stage | Learn → Band Map, or peek link from Today |

Band Map must answer specific questions:
- Question types: 11/13 at band X (✓/⚠/✗ for each type)
- Micro-skills: 7/12 at band X
- Grammar points: 8/18 at band X (✓/⚠/✗ for each point)
- Vocabulary count by topic: 320/450 words at band X (per-topic)
- Collocations: 45/120 at band X

Band Map is not a numeric dashboard — every item must have an achieved/not-achieved status + a "practice this" action. Click item ⚠/✗ → open the corresponding drill/lesson, or add it to Smart Queue.

## Product states

| State | Entry condition | Default experience | Exit condition |
|---|---|---|---|
| `new` | No placement | Quick start, explain value | Complete onboarding |
| `diagnosing` | Placement in progress | Focus on one task, save progress | Submit or resume |
| `diagnosed` | Preliminary band/gap exists | View gap and proposed plan | Accept plan, edit goal |
| `learning` | Active plan exists | Today + next best action | Open session, pause, complete |
| `practicing` | Task in progress | One clear task, sufficient feedback | Submit, abandon, retry |
| `reviewing` | Due item exists | Short queue, prioritized by goal | Complete queue, snooze |
| `assessing` | Mock test in progress | Exam mode, timer, and recovery | Submit, timeout, resume |
| `ready-check` | Sufficient readiness data | Readiness, risk, and next work | Choose weak skill or test |
| `inactive` | No study within the reminder threshold | Gentle resume, no guilt | Start micro-session |
| `blocked` | System/rights/quality-gate error | Explanation and recovery path | Retry, contact, upgrade |

## P0 closed-pilot state machine

```text
new
  -> authenticated_unconsented
  -> consented
  -> goal_collecting
  -> placement_in_progress
  -> diagnosed
  -> learning
  -> writing_draft
  -> evaluation_pending
  -> feedback_ready
  -> fix_in_progress
  -> review_due
  -> retest_ready
  -> learning
```

| State | User intent | System decision | Primary response | Do not |
|---|---|---|---|---|
| `new` | Understand what the app offers | Minimal consent/profile required | Brief explanation + start | Show an empty dashboard |
| `authenticated_unconsented` | Know how data is used | Required/optional scope | Clear consent + management path | Default opt-in |
| `goal_collecting` | Set a reasonable goal | Validate exam date/time budget | Save goal + next placement | Show an error while typing |
| `placement_in_progress` | Complete baseline without losing progress | Resume or start section | Autosave + progress | Randomize questions on reload |
| `diagnosed` | Trust the baseline enough to start | Confidence/calibration level | Provisional gap + first plan | Call it an official score |
| `learning` | Know what to do today | Deterministic next best action | One CTA + why now | Offer 5+ equal choices |
| `writing_draft` | Write/submit safely | Draft is eligible for submit | Save state + submit guard | Lose draft to network/timeout |
| `evaluation_pending` | Know what the app is doing | Job delayed/retry/fail | Status + safe exit | Infinite spinner |
| `feedback_ready` | Understand one error to fix | Priority error + evidence | Fix CTA + optional detail | Dump a long rubric |
| `review_due` | Review quickly and see progress | Due queue + source evidence | Review card + next due | Use a card without evidence |
| `retest_ready` | Prove the error was fixed | Retest tied to old error | Compare before/after | Claim a higher band without data |

## Decision rules

### Opening the app

```text
new                         → Start consent-aware onboarding
authenticated_unconsented   → Consent disclosure
diagnosing                  → Resume placement
diagnosed                   → Review gap + accept plan
learning                    → Continue current session or Today's Plan
writing_draft               → Resume draft
evaluation_pending          → Evaluation status, with safe exit to Today
feedback_ready              → Feedback with one priority fix
reviewing / review_due      → Today's Review Queue
assessing                   → Resume exam with saved timer/state
inactive                    → Micro-session suited to time/energy
blocked                     → Recovery state; do not create a new task
```

### Choosing the next best action

Prioritize in this order:

1. An in-progress session that can be resumed.
2. A due review related to the nearest goal.
3. A weak skill with low confidence but sufficient practice data.
4. The next lesson in the learning path.
5. A mock test or readiness check when the exam date is near.

If confidence is insufficient, the system shows the reason and lets the learner choose among at most three options; it must not pretend to personalize with certainty.

### Trust display

| Surface | Required trust cue | Expanded detail |
|---|---|---|
| Placement result | confidence + calibration status | scoring config/version |
| Today recommendation | reason from current state | inputs used and skipped |
| Writing feedback | evidence span + confidence | rubric/model/prompt version |
| Review card | original error/evidence source | FSRS due explanation |
| Paywall/quota | limit before costly action | free alternative |

## Interaction contract

| Intent | Action | System response | Next state |
|---|---|---|---|
| Know what to study | Open Today | Show one primary CTA + plan | `learning` |
| Continue unfinished work | Press Continue | Restore the correct step/timer | Keep current state |
| Understand an error | Open feedback | Show evidence → explanation → fix | `reviewing` |
| Not ready for a long study session | Choose Micro | Reduce the outcome without dropping the goal | `learning` |
| Disagree with a result | View evidence/mark incorrect | Allow correction/feedback | `practicing` |
| Network loss | Continue local work | Autosave, report unsynced portion | Keep state + `offline` |
| Access exhausted | Open locked task | State limit and free alternative | `blocked` or return |

## Copy contract

| Situation | Copy must include | Copy must avoid |
|---|---|---|
| Low confidence | uncertain portion + next choice | band presented as certain conclusion |
| Timeout | work preserved + retry/status | "write it again from scratch" |
| Empty plan | why there is no plan + CTA | blank screen or empty chart |
| Wrong answer/error | specific error + how to fix | labeling the learner as "weak/bad" |
| Quota limit | limit + remaining access | lock created feedback/draft |

## Failure and recovery

- Evaluation timeout: preserve input and allow retry; do not count it as a new submission.
- Low confidence: show `Needs review`, state the uncertain portion, and do not present band as absolute truth.
- Audio/transcript error: preserve the recording and allow replay or manual transcript submission.
- Network loss: save local state; sync idempotently when online.
- Session timeout: restore the last checkpoint and show the save time.
- Empty queue: explain when the next item will appear and provide a replacement task.

## Retention loop

```text
Clear intent
  → a manageable task
  → actionable feedback
  → one error is saved
  → review at the right time
  → visible progress
  → return with the next best action
```

Retention does not rely on streak guilt, notification overload, or rewards unrelated to ability.

## Wireframe implications

Each screen in the full wireframe must record:

- The state being illustrated.
- Entry condition.
- Primary intent.
- Primary action.
- Success response.
- Failure/empty path.
- Next state.
