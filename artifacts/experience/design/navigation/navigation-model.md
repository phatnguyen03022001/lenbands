# Navigation Model

## Purpose

Turns the Information Architecture (Stage-Drawer + State-Driven Modes + Loop Spine) into navigation logic for the learner shell. This is a logic contract; it contains no CSS, dimensions, colors, or markup.

## Stage-Drawer architecture

It is not 6 equal tabs. It is **1 stage + a weighted edge rail**.

| Role | Destination | Rule |
|---|---|---|
| **Stage** | `Today` | Always the landing destination. Contains 1 primary action + 1 insight + progress. |
| **Edge rail (drawer)** | `Learn`, `Practice`, `Review`, `Tests`, `More` | Not equal. Weight changes by mode + context. Surfaces only when Today recommends it or the learner actively needs it. |

The edge rail does not use a red badge. Changing **weight** changes order / prominence / contrast; the learner always chooses.

### Stage contract

`Today` must have:
- 1 **primary action** only (no 2 equally weighted CTAs).
- 1 **insight of the day** (from `PERSONAL.Insights` or the reason from the current state).
- A small **progress proof** (streak / last meaningful improvement).
- A **recovery slot** for no-plan/stale/offline/quota.

`Today` does not show an empty dashboard, an empty chart, or a long unprioritized task list.

### Drawer weight contract

Weight reflects the next step in the Loop Spine + context:

| Trigger | Drawer that surfaces | Drawer that recedes |
|---|---|---|
| Missed Matching Headings 3 times | Review (with a light marker) | — |
| 2 weeks until the exam | Tests (Exam readiness) | — |
| 12 cards due | Review | Learn |
| Low band, foundation needed | Learn | Tests |
| Absent 7+ days (comeback) | — (Today only) | all drawers recede |

## State-driven shell modes

The shell renders by mode (a rule, not advice). The system determines mode from the state vector; the learner does not choose it.

| Mode | Stage content | Visible edge rail | Hidden edge rail |
|---|---|---|---|
| `onboarding` | Welcome + baseline CTA | (thin rail, Today + Learn) | Tests, Practice |
| `early` (IELTS band 3.0–5.0) | micro-session + 1 Writing/lesson action | Today, Learn, Practice, Review | **Tests hidden** |
| `core` (band 5.5–6.5) | full Today plan | Today, Learn, Practice, Review, Tests, More | — |

Mode selection uses IELTS half-band labels. Band 5.0 belongs to `early`; band 5.5 belongs to `core`, so the table does not define a continuous 5.0–5.5 dead zone.
| `exam_prep` (<30 days to exam) | exam readiness + weak skill | Today, Review, Tests surface; Learn recedes | — |
| `comeback` (absent 7+ days) | 1 light micro-session | Today | all drawers recede |

The learner can actively open a hidden drawer through spotlight search or "all areas" — but it is not shown by default, reducing cognitive load.

## Loop Spine routing

Today is the **router** for the learning loop. Navigation reflects the current position:

```text
Diagnose → Learn → Practice → Fix → Review → Prove → (Diagnose again)
```

| Loop position | Today primary action | Drawer suggested by Today |
|---|---|---|
| Diagnose | Start/continue placement | — |
| Learn | Open the next lesson | Learn |
| Practice | Do the next question | Practice |
| Fix | Fix the priority error | Review (Mistake Notebook) |
| Review | Review due cards | Review |
| Prove | Take a retest/mock | Tests |
| (loop again) | View insight + next | Learn |

Today does not show every loop step at once — only the **current position + next step**.

## Route concepts

| Key | Label | Route concept | Desktop | Mobile |
|---|---|---|---:|---:|
| `today` | Today | `/today` | Stage (primary) | Stage + bottom nav |
| `learn` | Learn | `/learn` | Edge rail | Bottom nav |
| `practice` | Practice | `/practice` | Edge rail | Bottom nav |
| `review` | Review | `/review` | Edge rail | Bottom nav |
| `tests` | Tests | `/tests` | Edge rail | Through More |
| `more` | More | menu | Edge rail | Menu sheet |

Mobile bottom nav: 4 fixed items `Today`, `Learn`, `Practice`, `Review`; `Tests` + `More` go through the expanded menu.

## Edge rail hierarchy (desktop)

The desktop edge rail has 2 levels: workspace (level 1) + commonly used destinations (level 2, collapsible).

```text
TODAY (stage)
─────────────────
Learn
├── Roadmap
├── Band Map (full view of what is missing by band)
├── Skills (Listening · Reading · Writing · Speaking · Pronunciation)
└── Knowledge (Vocabulary · Grammar · Strategies)

Practice
├── Skill Practice
├── Question Types
└── Adaptive Practice

Review
├── Today's Queue (FSRS)
├── Smart Queue (Today · Priority · Weak · Exam)
├── Mistake Notebook
└── Word Bank

Tests
├── Mock Tests
├── Test History (Assessment History)
├── Exam Readiness
└── Exam Plan (Countdown · Checklist · Timeline)

More
├── Progress (Analytics · Timeline · Streak · Achievement · Wellbeing)
├── My Library (Notes · Drafts · Recordings · Saved · Collections)
└── Account (Profile · Privacy · Import/Export · Language · Notifications · Subscription)
```

Rule: the rail expands only the group related to the current mode/loop step; it does not flatten the entire tree at once.

## Header

The header always has:
- Logo/wordmark → returns to `Today`.
- Context title for the current area.
- **Continue chip** when a session/draft/mock is in progress (1 button, no crowding).
- Search icon (global).
- Subtle notification (does not crowd the primary action).
- Avatar → Account menu.

P0 Search: the header icon opens an overlay; it does not need to be attached to one destination.

## Role-specific shells

Do not use the same shell for every role:

| Shell | Primary workspaces |
|---|---|
| Learner | Today (stage) + 5 edge rail |
| Premium | Learner shell + quota/subscription context |
| Collaborator | Content, Drafts, Validation, Feedback |
| Admin | Overview, Content, Quality, Rights, Cost, Observability |

Role changes navigation only after authentication; Content/Admin does not enter the learner shell.

## Visibility rules

| Destination | Guest | Learner | Premium |
|---|---|---|---|
| Placement | Preview (1 mini-test) | Available (if no baseline) | Available |
| Today | Preview | Stage | Stage |
| Learn | Preview | Edge rail | Edge rail |
| Practice | Limited demo | Edge rail | Edge rail |
| Review | Hidden | Edge rail | Edge rail |
| Tests | Locked (with condition) | Conditional | Edge rail |
| Search | Demo | Header | Header |
| More | Hidden | Edge rail | Edge rail |

A locked destination must explain the unlock condition + alternative. Do not disorient the learner.

## Entry Point Matrix

The entry point is decided **before rendering the default destination**. The Stage (Today) remains available for the learner to change direction actively.

| State / trigger | Destination | Primary action |
|---|---|---|
| `new` | Placement | Start placement |
| `diagnosing` | Resume Placement | Continue checkpoint |
| `diagnosed` | Today | View the gap and receive a plan |
| `learning` | Today | Start the next best action |
| Review due | Review | Start the priority queue |
| Submission complete | Feedback | View evidence and choose one fix |
| Writing draft in progress | Editor (Resume draft) | Continue writing |
| Mock test interrupted | Resume Test | Restore timer/state |
| Inactive 7+ days | Today / Comeback | Choose a micro-session |
| Near exam date | Exam Readiness | View risk and prioritize review |
| Search trigger | Search overlay | Find question/knowledge/sample |
| Premium expired | Account → Subscription | Understand limits + renew |

## Contextual navigation

- From `Today`, the primary CTA opens the correct next task, not an intermediate list.
- After a session, the primary CTA goes to `Review` or the next task selected by `PERSONAL.NextBestAction`.
- From feedback, the learner can go to `Mistake Notebook` or `Review queue`.
- Network loss: preserve route + session state; lock only actions that require the server.
- Route with no data: preserve the shell and show an empty state in the content region.

## Active state

Active state is based on the route concept, not the file/component name. A child route still highlights its parent destination. Mode determines the parent's prominence (weight), not route alone.

## Traceability

Navigation model is derived from `information-architecture.md` + capabilities:

- `STUDY.DailyPlan`, `STUDY.Resume`, `STUDY.TodayQueue`
- `LEARN.Path`, `LEARN.QuestionTypes`
- `PRACTICE.Set`, `PRACTICE.Drill`, `PRACTICE.Adaptive`, `PRACTICE.MockTest`, `PRACTICE.ExamSimulation`
- `REVIEW.SmartQueue`, `REVIEW.MistakeNotebook`, `REVIEW.FSRS`, `PKM.WordBank`
- `BAND.ExamReadiness`, `BAND.Map`, `HISTORY.*`, `GOAL.ExamPlan`
- `PERSONAL.NextBestAction`, `PERSONAL.Insights`
- `SEARCH.Global`, `SEARCH.Knowledge`
