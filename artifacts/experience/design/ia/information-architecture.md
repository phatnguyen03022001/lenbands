# Information Architecture

## Purpose

Defines LenBands' minimum learner-facing information architecture. This document decides **which areas learners can reach**; it does not decide HTML, CSS, or pixel layout.

## Principles

- One clear place to start: `Today`.
- Navigate by learning goal, not by engine name or internal capability name.
- The next action always takes priority over browsing all content.
- `Review` is an independent destination because it creates a retention loop.
- `Tests` is a separate destination because its states, timer, and results differ from a normal study session.
- Less-used functions go into `More` so the main sidebar stays light.

## Stage-Drawer Model (core IA architecture)

The IA is not 6 equal tabs; it is **1 stage + 5 weighted drawers**. This is a competitive advantage: the learner always sees **1 primary answer** (Today), while other areas recede into a "store" that surfaces only when Today recommends it or the learner actively needs it.

```text
┌─────────────────────────────────────────────────┐
│  STAGE — Today                                   │  ← always opens here
│  Contains 1 primary action + 1 insight + progress│
├─────────────────────────────────────────────────┤
│  EDGE RAIL (thin, with changing weights)         │  ← not equal
│  Learn · Practice · Review · Tests · More        │     surfaces/recedes by mode + context
└─────────────────────────────────────────────────┘
```

| Before (6 equal tabs) | After (Stage-Drawer) |
|---|---|
| Learner opens the app → 6 equal choices → easy to get lost | Learner opens the app → 1 Today stage → knows what to do |
| Band 4 and band 8 see the same UI | UI changes by mode (see State-Driven Modes) |
| Every tab competes for attention | Only Today competes; drawers recede into storage |

## State-Driven Modes (HARD progressive disclosure)

The learner shell changes by mode — this is not advice; it is a **rendering rule**. A band-4 learner physically does not see Advanced Analytics/Exam Readiness risk; it is not merely something they "should hide".

| Mode | Entry condition | Stage (Today) | Visible edge rail | Hidden edge rail |
|---|---|---|---|---|
| `onboarding` | no placement yet | Welcome + baseline CTA | (thin rail) | Tests, Practice (not needed yet) |
| `early` | IELTS band 3.0–5.0 | micro-session + 1 lesson/Writing action | Today, Learn, Practice, Review | **Tests hidden** (no pressure yet) |
| `core` | band 5.5–6.5 | full Today plan | Today, Learn, Practice, Review, Tests, More | — (all available) |

Mode bands use IELTS half-band labels, not a continuous real-number interval: band 5.0 remains `early`, band 5.5 enters `core`; there is no unsupported band value between them.
| `exam_prep` | <30 days to exam | exam readiness + prioritized weak skill | Today, Review, Tests surface; Learn recedes | — |
| `comeback` | absent for 7+ days | 1 light micro-session | Today; all drawers recede | — (minimal) |

Mode rules:
- The system determines mode from the state vector (band, exam date, streak, due queue); the learner does **not** choose it.
- The learner can always actively open a hidden drawer (link/spotlight search), but it is not shown by default.
- When the learner changes mode (e.g. sets an exam date), the shell updates weights immediately without waiting for reload.

## Loop Spine (the hidden backbone)

Visible IA = stage + drawer. Invisible IA = **the learning loop**. Today must always show the current loop position + next step. A drawer is where Today *pushes the learner*, not where the learner *has to search*.

```text
Diagnose → Learn → Practice → Fix → Review → Prove → (Diagnose again)
   ▲                                                        │
   └────────────────────────────────────────────────────────┘
```

- Each state in the loop has one primary action.
- Today always shows the **current position + next step** in the loop, not every step at once.
- A drawer surfaces only when it contains that learner's next loop step.

## Learner-facing structure

```text
Learner App
├── [Search] (global, in the header — not a tab)
├── Today
│   ├── Daily plan
│   ├── Continue session (study / writing draft / mock test)
│   └── Next best action + insight of the day
├── Learn
│   ├── Roadmap
│   ├── Band Map (full view of what is missing by band)
│   ├── Skills (Listening · Reading · Writing · Speaking · Pronunciation)
│   ├── Knowledge (Grammar · Vocabulary · Collocation · Strategy · Template · Band Descriptor)
│   └── Resources (Cheatsheet · Writing Sample · Speaking Sample)
├── Practice
│   ├── Skill practice
│   ├── Question types
│   └── Adaptive practice
├── Review
│   ├── Today's queue (FSRS)
│   ├── Smart queue (Today · Priority · Weak skill · Exam)
│   ├── Mistake notebook
│   └── Word bank
├── Tests
│   ├── Mock tests
│   ├── Test history (Assessment History)
│   ├── Exam readiness
│   └── Exam plan (Countdown · Checklist · Timeline)
└── More
    ├── Progress (Analytics · Timeline · Streak · Achievement · Wellbeing)
    ├── My Library (Notes · Drafts · Recordings · Saved items · Collections)
    ├── Account (Profile · Privacy · Import/Export · Language · Notifications)
    └── Help
```

`[Search]` is a global header entry, not a tab; use the `/` shortcut or icon. Results combine Knowledge, Question, Task, Band Descriptor, and Sample.

## Blueprint mapping

| Area | Experience role | Main capabilities |
|---|---|---|
| Search (header) | Find everything quickly | `SEARCH.Global`, `SEARCH.Knowledge`, `SEARCH.Question`, `SEARCH.BandDescriptor`, `SEARCH.WritingSample`, `SEARCH.SpeakingSample`, `SEARCH.Cheatsheet` |
| Today | Entry point and today's learning decision | `STUDY.DailyPlan`, `STUDY.Resume`, `STUDY.TodayQueue`, `PERSONAL.NextBestAction`, `PERSONAL.Insights`, `PROGRESS.Motivation` (streak shown at top) |
| Learn | Build foundations and follow the path | `LEARN.Path`, `LEARN.QuestionTypes`, `LEARN.Listening`, `LEARN.Reading`, `LEARN.Writing`, `LEARN.Speaking`, `LEARN.Pronunciation`, `BAND.Map`, `KA.*` |
| Practice | Deliberate practice by skill/question type | `PRACTICE.Set`, `PRACTICE.Drill`, `PRACTICE.Timed`, `PRACTICE.Adaptive` |
| Review | Review errors, due items, and memory | `REVIEW.SmartQueue`, `REVIEW.MistakeNotebook`, `REVIEW.FSRS`, `REVIEW.Queue`, `PKM.WordBank` |
| Tests | Mock exams, readiness, and exam planning | `PRACTICE.MockTest`, `PRACTICE.ExamSimulation`, `BAND.ExamReadiness`, `HISTORY.Attempts`, `HISTORY.*Timeline`, `HISTORY.Portfolio`, `HISTORY.Compare`, `GOAL.ExamPlan` |
| More → Progress | View progress, insight, and wellbeing | `PROGRESS.Dashboard`, `PROGRESS.LearningAnalytics`, `PROGRESS.SkillAnalytics`, `PROGRESS.BandProgress`, `PROGRESS.GoalTracking`, `PROGRESS.Motivation`, `PROGRESS.Achievement`, `PROGRESS.WeeklyRecap`, `PROGRESS.Wellbeing` |
| More → My Library | Learner-built personal store | `PKM.Notes`, `PKM.SavedItems`, `PKM.Collections`, `PKM.Drafts`, `PKM.Recordings`, `PKM.Import`, `PKM.Export`, `PKM.Sync`, `PKM.Offline` |
| More → Account | Profile, privacy, and preferences | `IDENTITY.Profile`, `IDENTITY.Recovery`, `IDENTITY.Privacy`, `IDENTITY.DeleteAccount`, `LOC.*`, `NOTIF.Preference`, `NOTIF.QuietHours`, `NOTIF.SmartDelivery`, `SUB.*` |

## Structure inside Learn

| Area | Learner question | Main content |
|---|---|---|
| Roadmap | What should I study next (the sequential path)? | Learning path, milestones, next lesson |
| **Band Map** | **What is still missing from here to band X (the full view)?** | **Per-skill completion, question types achieved/not achieved, micro-skills, grammar points, vocabulary count by topic — full band checklist** |
| Skills | Which skill is weak? | Listening, Reading, Writing, Speaking, **Pronunciation**, and each skill's question types |
| Knowledge | What do I need to understand/remember? | Grammar, Vocabulary, Collocation, Strategy, Template, Band Descriptor |
| Resources | Which samples do I want to see? | Cheatsheet, Writing Sample, Speaking Sample (open only when the catalog is large enough) |

`Learn` does not contain Review, Mistake Notebook, Smart Queue, or Word Bank. Those belong to the separate `Review` and `My Library` workspaces.

### Distinguishing Roadmap vs Band Map (important)

These two areas are not duplicates:

| | Roadmap | Band Map |
|---|---|---|
| Question | "What should I study **next**?" | "What is still **missing** to reach band X?" |
| Form | Sequential path (next lesson) | Full checklist (per-skill, cross-skill) |
| Zoom | zoom-in (one next step) | zoom-out (full band view) |
| Capability | `LEARN.Path` | `BAND.Map` |
| UI | Sequenced mile | Tree checklist with % completion + ✓/⚠/✗ markers |
| Symmetric surface | of Today (same zoom-in) | of Today (zoom-out) |

The learner needs both: Roadmap for "today", Band Map to "see the whole path".

### Structure inside Skills

Each skill is its own entry point (5 equal skills; do not absorb Pronunciation into Speaking):

| Skill | Entry purpose | Internal layers |
|---|---|---|
| Listening | Learn listening | Learning (player, transcript, dictation, shadowing) → Practice (question types) → Evaluation (`EVAL.Listening`, answer-key + coach) → Review |
| Reading | Learn reading | Learning (passage reader, highlight, annotation) → Practice (13 question types) → Evaluation (`EVAL.Reading`, answer-key + coach) → Review |
| Writing | Learn + write + receive evaluation | Learning (workspace) → Practice (draft) → Evaluation (`EVAL.Writing`, sole scorer) → Review (rewrite loop, portfolio) |
| Speaking | Learn + speak + receive evaluation + practice dialogue | Learning (cue card) → Practice (Examiner dialogue) → Evaluation (`EVAL.Speaking`, `EVAL.Examiner`) → Review (portfolio, compare) |
| Pronunciation | Fix phoneme-level pronunciation | Learning (phoneme, stress, intonation) → Practice (drill) → Evaluation (`EVAL.Pronunciation`) → Review (progress) |

Pronunciation is separate from Speaking because its feedback mechanism and metrics differ substantially (phoneme/stress/intonation vs fluency/lexical/grammar).

## Navigation visibility

| Destination | Guest | Learner | Premium |
|---|---|---|---|
| Placement | Preview (1 mini-test) | Available (if no baseline) | Available |
| Today | Preview | Available | Available |
| Learn | Preview | Available | Available |
| Practice | Limited demo | Available | Available |
| Review | Hidden | Available | Available |
| Tests | Locked (with unlock condition) | Conditional (placement required) | Available |
| Search | Demo | Available | Available |
| More (Library/Progress/Account) | Hidden | Available | Available |

Visibility controls access only; it must not make important destinations disappear without explanation. `Tests` is shown as Locked with a reason (placement required first) and an unlock condition.

## Entry Point Matrix

| User state / trigger | Landing destination | First goal |
|---|---|---|
| `new` | Placement | Create a baseline for personalization |
| `diagnosing` | Resume Placement | Continue at the correct checkpoint |
| `diagnosed` | Today | View the gap and receive a plan |
| `learning` | Today | Start the next best action |
| Review due | Review | Complete the priority queue |
| Writing/Speaking submitted | Feedback | Understand the error and choose one fix |
| Writing draft in progress | Editor (Resume draft) | Continue writing without losing content |
| Mock test in progress | Resume Test | Restore the timer and answers |
| Inactive for 7+ days | Today / Comeback state | Choose a manageable micro-session |
| Near exam date | Exam Readiness | View risk and prioritize review |
| Search (type `/` or use Search icon) | Search overlay | Find a question/knowledge/sample/band descriptor |
| Premium expired | Account → Subscription | Understand limits and renew |

## State-based visibility rules

Detailed rendering rules are in State-Driven Modes above. Additional rules:

- No placement: `Today` prioritizes `Start Placement Test` (mode `onboarding`).
- Placement exists but no study today: `Today` prioritizes `Today's Plan`.
- A session is in progress (study / writing draft / mock test): the header and `Today` prioritize `Continue` with the session type shown clearly.
- Review is due: change the Review drawer's **weight** (raise it); do not use a pressure-inducing red badge.
- Streak/motivation appears in the header and at the top of `Today`, not hidden in `More → Progress`.
- `Wellbeing` never pushes pressure; the learner opens it actively in `Progress`.
- Search is always accessible (header), including during a session, for quick knowledge/sample lookup.
- On mobile: keep only the 4 primary destinations `Today`, `Learn`, `Practice`, `Review`; route `Tests` and `More` through the expanded menu; Search remains in the header icon.

## Orphan check (every capability domain must have a home)

This table prevents the "capability has no destination" error. If a new domain is added to `03-features.md`, add a row here.

| Domain | IA home |
|---|---|
| IDENTITY | More → Account |
| LOC | More → Account |
| GOAL (Target/Plan) | Today, More → Account |
| GOAL.ExamPlan | Tests → Exam plan |
| PLACE | Placement (Guest) / Today (if no baseline) |
| LEARN | Learn |
| KA | Learn → Knowledge |
| PKM | Review → Word bank; More → My Library (Notes/Drafts/Recordings/Saved/Collections/Import/Export/Sync/Offline) |
| PRACTICE | Practice; Tests (MockTest/ExamSimulation) |
| EVAL (W/S/Pron) | In the skill flow in Learn/Skills; results in Tests → Test history |
| EVAL (Listening/Reading) | In the skill flow in Learn/Skills (answer-key + coach) |
| COACH | In the feedback flow (after Practice/Tests) and Learn/Skills |
| PERSONAL | Today (NextBestAction, Insights) |
| BAND | Learn → Band Map (full checklist); Tests → Exam readiness; Learn/Skills (progress) |
| REVIEW | Review |
| HISTORY | Tests → Test history |
| PROGRESS | More → Progress; Motivation/Streak in header + Today |
| SEARCH | Search (global header) |
| STUDY | Today |
| NOTIF | More → Account; SmartDelivery/QuietHours in Account |
| SUB | More → Account → Subscription |
| CONTENT | Not learner-facing (Colab/Admin tool) |
| ADMIN | Not learner-facing |
| OPS | Not learner-facing (backend) |
| GOVERNANCE | Not learner-facing (backend) |

Rule: non-learner-facing domains (CONTENT, ADMIN, OPS, GOVERNANCE) do not appear in the tab tree; they appear only through indirect tasks (content reports, audit views) or a separate tool.
