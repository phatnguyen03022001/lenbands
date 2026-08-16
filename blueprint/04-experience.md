# 04 — Experience Blueprint

This file describes the learner's **experience and journeys** — how the learner should feel. It **does not define features** (features are in `03-features.md`); it references capabilities only through IDs in the form `DOMAIN.Capability` so agents can trace them.

> **Scope guard:** this file describes the experience horizon for the full product. Closed-pilot P0 uses only `identity-consent`, `placement-and-plan`, `daily-action`, `writing-task-2`, `error-to-review`, and `governance-ops-dashboard` when permitted by the Build Readiness Matrix. Mock Test, Exam Readiness, Exam Day, After Exam, and other deferred capabilities are not P0 build inputs.

## UX principles

1. **Experience-centric, not feature-centric** — users think in journeys ("I want Band 7 → what should I study today?"), not features ("I want to use Practice").
2. **Progressive Disclosure** — lower-band learners see less and higher-band learners see more; do not expose Advanced Analytics/Rubric/Calibration all at once. UI depth expands with readiness.
3. **Always know the next step** — every surface ends by answering one question: "what is the next step?" (`PERSONAL.NextBestAction`).
4. **Delight at moments of progress, not through gamification** — celebrate when Band Readiness improves, not through XP/leaderboards.
5. **Recovery before panic** — when evaluation fails, the network drops, or a session times out, the system recovers gracefully and the user does not lose data.
6. **Context-aware** — AI always knows the user's current context (passage/question/skill) so it can respond in context (`COACH.Tutor`).
7. **Energy-aware** — the system asks about available time and energy today and proposes an appropriate session instead of always pushing the same workload.
8. **Trust before persuasion** — scoring status, limitations, data use, and recommendation rationale must be understandable; retention must never be purchased with dark patterns.
9. **One clear next step** — each surface has one primary action; secondary choices sit behind progressive disclosure to reduce cognitive load.

## Home (most frequently opened)

Home orchestrates `STUDY.*`; it is not a new feature.

```text
┌───────────────────────────────────┐
│  Greeting + Streak                │  ← PROGRESS.Motivation
├───────────────────────────────────┤
│  Today's Goal (progress bar)      │  ← GOAL.Daily
├───────────────────────────────────┤
│  ▶ Continue (resume session)      │  ← STUDY.Resume / STUDY.Continue
├───────────────────────────────────┤
│  Today's Plan                     │  ← STUDY.DailyPlan
│    • Today's Review (N due)       │     REVIEW.SmartQueue
│    • Today's Practice             │     PRACTICE.*
│    • Today's Lesson               │     LEARN.Path
├───────────────────────────────────┤
│  Insight of the day               │  ← PERSONAL.Insights
│  ("Matching Headings is weak")   │
├───────────────────────────────────┤
│  Next Best Action                 │  ← PERSONAL.NextBestAction
└───────────────────────────────────┘
```

Empty state for a new learner: Home shows "Start Placement Test" (`PLACE.Test`) instead of Today's Plan.

## 8 User Journeys

### 01. First Day (Onboarding)

The first experience must answer: "does this system understand me?"

```text
Who are you? (basic profile)
   ↓
Current band? (self-report or quick test)
   ↓
Target band?             ┐
   ↓                     │
How long until the exam? │ → GOAL.Target, GOAL.ExamPlan (horizon; not active in P0)
   ↓                     │
Daily study time?        │ → GOAL.Daily (horizon; P0 uses daily budget in the placement contract)
   ↓                     │
Placement Test           │ → PLACE.Test (if there is no reliable band yet)
   ↓                     │
Gap Detection            │ → PLACE.GapDetection
   ↓                     │
Create personal plan     │ → PLACE.InitialPath + STUDY.DailyPlan
   ↓
First Home (Today's Plan appears)
```

**Emotional goal:** "the system understands me, gives me a clear path, and does not overwhelm me."

### 02. Daily Study

The daily loop must answer: "where do I start today, and how do I know I improved after studying?"

```text
Open app → Home (Today's Plan)     ← STUDY.DailyPlan
   ↓
Choose "Continue" or an item in Today
   ↓
Study Session (timer, goal)        ← STUDY.Session
   ↓
Learn / Practice / Review (according to plan)
   ↓
Session Summary                    ← STUDY.SessionSummary
   ("42 minutes, 18 Reading questions, 6 new words, 3 Grammar errors")
   ↓
Streak / Goal updated              ← PROGRESS.Motivation, PROGRESS.GoalTracking
   ↓
Next Best Action for tomorrow      ← PERSONAL.NextBestAction
```

**Emotional goal:** "I completed something, achieved a small win, and know what to do tomorrow."

### 03. Mock Test

The mock-test experience should resemble the real exam while remaining safe: mistakes are allowed and can be understood afterward.

```text
Choose Mock Test                  ← PRACTICE.MockTest
   ↓
Exam Mode (timed, no hints)       ← PRACTICE.ExamSimulation
   ↓
[Interrupt: incoming call]        ← STUDY.Resume (restore timer and state)
   ↓
Resume at the exact position
   ↓
Submit
   ↓
Band Score + Result Analysis      ← PRACTICE.MockTest, EVAL.*
   ↓
Compare with previous attempt     ← HISTORY.Compare
   ↓
Exam Readiness updated            ← BAND.ExamReadiness
```

**Emotional goal:** appropriate exam-like tension without panic; after scoring, the learner understands where they are and what remains missing.

### 04. Wrong Answer

This is one of the easiest moments for a learner to become discouraged; the experience must convert failure into learning.

```text
Get a Reading/Listening question wrong
   ↓
Answer explanation                 ← COACH.AnswerExplanation
   ↓
Distractor explanation             ← COACH.DistractorExplanation
   ↓
[Optional] ask a contextual question ← COACH.Tutor (context-aware)
   ↓
Save to Mistake Notebook           ← REVIEW.MistakeNotebook
   ↓
Auto-add to FSRS queue              ← REVIEW.FSRS
   ↓
Reappear in Smart Queue             ← REVIEW.SmartQueue
   ↓
Retest when due                     ← REVIEW.SmartQueue (Exam/Priority Queue)
```

**Emotional goal:** move from "I'm bad at this" to "I understand why I was wrong, and I will remember next time."

### 05. Review (Spaced Repetition)

The review loop should be light, fast, and visibly progressive.

```text
Notification "X items are due today" ← NOTIF.SRS
   ↓
Open Today's Queue                 ← REVIEW.SmartQueue
   ↓
Review card (FSRS)                 ← REVIEW.FSRS
   Rating: Again/Hard/Good/Easy
   ↓
FSRS updates stability/difficulty/due
   ↓
7-day forecast                     ← REVIEW.FSRS
   ↓
Retention rate                     ← REVIEW.FSRS
```

**Emotional goal:** "review quickly, remember for longer, and avoid overload."

### 06. Before Exam

The final preparation stage must answer: "am I ready, what is missing, and what should I prioritize?"

```text
Countdown displayed               ← GOAL.ExamPlan
   ↓
Exam Readiness check              ← BAND.ExamReadiness
   (Overall + per-skill + Confidence + Risk)
   ↓
Insight: "Task Response is the remaining gap" ← PERSONAL.Insights
   ↓
Prioritize weak-skill review      ← REVIEW.SmartQueue (Weak Skill/Exam Queue)
   ↓
Last-minute Review Plan           ← GOAL.ExamPlan
   ↓
Mock Test Readiness Check         ← PRACTICE.MockTest
```

**Emotional goal:** confidence from knowing current readiness and focus from knowing what deserves priority.

### 07. Exam Day

On exam day, the app recedes into the background and provides only light support.

```text
Exam-day timeline                 ← GOAL.ExamPlan
   ↓
Pre-exam Checklist                ← GOAL.ExamPlan
   ↓
Time Management Strategy          ← GOAL.ExamPlan
   ↓
Test Day Anxiety Tips             ← GOAL.ExamPlan
   ↓
[No heavy push notifications]
```

**Emotional goal:** stay calm and avoid distraction from the app.

### 08. After Exam

After the real exam, update targets, adjust the path, and celebrate appropriately.

```text
Enter real exam result            ← IDENTITY.Profile (optional)
   ↓
Compare actual vs predicted       ← HISTORY.Compare (vs EVAL.BandPrediction)
   ↓
Recalibrate (feed Governance)     ← GOVERNANCE.GoldStandardBenchmark
   ↓
Set a new target (if needed)      ← GOAL.Target
   ↓
Celebrate if achieved             ← PROGRESS.Motivation
   ↓
Adjust Learning Path              ← LEARN.Path + PERSONAL.NextBestAction
```

**Emotional goal:** close the loop, reflect on progress, and have a clear next direction.

## Delight Moments

These are not gamification mechanics (no XP/leaderboard). They are celebrations at moments of genuine progress:

| Moment | Trigger | Delight |
|---|---|---|
| Band Readiness increases | `BAND.Readiness` rises by 0.5+ | "You reached Band Readiness 6.5 — Task Response is the remaining gap" (`PERSONAL.Insights`) |
| Daily goal almost complete | <15 minutes remain | "Only 12 minutes remain to complete today's goal" |
| Streak milestone | 7/30/100 days | Lightweight celebration + recap |
| 100 Reviews | `REVIEW.FSRS` reaches 100 | Lightweight achievement badge (`PROGRESS.Achievement`) |
| Band improvement | `HISTORY.BandTimeline` increases | "Reading improved from 6.0 → 6.5 in 3 weeks" |
| Comeback | Return after absence | "Welcome back — you retained 85% of your vocabulary" (`PROGRESS.Motivation` comeback nudge) |

## Error Recovery

When something goes wrong, the user must never be left at a dead end; every failure needs a clear recovery path.

| Failure | Recovery | Capability |
|---|---|---|
| Evaluation error / timeout | Show "scoring again" and deliver the result later; never lose the submission | `EVAL.*` + `GOVERNANCE.ConfidenceScore` flag |
| Writing/Speaking upload fails | Auto-retry + save locally; "will submit when connection returns" | `PKM.Drafts` + `PKM.Offline` |
| Network loss during session | Auto-save state; resume at the exact position when connected | `STUDY.Resume` + `PKM.Sync` |
| Session timeout (Mock Test) | Restore timer; preserve answered questions | `STUDY.Resume` |
| Low-confidence score | Flag in backend (invisible); pipeline may request another scoring pass through calibration flow | `GOVERNANCE.ConfidenceScore` |
| Anti-gaming flag | If a submission is suspected to be a sample/AI-generated answer, provide a restrained notice and guidance | `GOVERNANCE.AntiGaming` |

These recovery paths must map to the Failure Contract in `06-engines.md`: user-facing states use only `processing`, `delayed`, `unavailable`, or `action_required`; technical failure codes must never replace actionable guidance.

## Empty States

Every empty surface for a new learner must include inline onboarding rather than remaining blank.

| Surface | Empty state | Capability anchor |
|---|---|---|
| Home | "Start the Placement Test to create your plan" | `PLACE.Test` |
| Dashboard | "Complete your first test to see progress" | `PRACTICE.MockTest` |
| Mistake Notebook | "No errors yet — incorrect answers will appear here" | `REVIEW.MistakeNotebook` |
| Word Bank | "Add words while studying Vocabulary or from Reading passages" | `PKM.WordBank` |
| Assessment History | "No attempts yet — results will appear here" | `HISTORY.Attempts` |

## Progressive Disclosure by Band

The UI does not expose all information at once; depth expands according to learner readiness.

| Band | Show | Hide |
|---|---|---|
| 3.0–4.5 | Core Learning, Practice, Mistake Notebook, simple Dashboard | Advanced Analytics, detailed Band Rubric, Calibration metrics, Exam Readiness risk |
| 5.0–6.5 | + Band Framework, Insights, Exam Readiness, Smart Queue | Governance dashboard, Raw calibration data |
| 7.0+ | + Advanced Analytics, full Rubric, deeper Compare attempts | Almost nothing |

Principle: lower-band learners primarily need to know "what should I learn next?"; higher-band learners need to know "why have I not reached the next band yet?"

## Context Awareness

`COACH.Tutor` and other Coaches always know the user's current context so they can respond correctly:

| User context | AI context available | Example response |
|---|---|---|
| Reading Passage 2, Q18, Matching Heading | passage, question, type, prior errors on this type | "For this Matching Heading question, you chose B because the keyword matched, but D is correct because of the paraphrase..." |
| Writing Task 2, active draft | draft content, task | "Paragraph 2 needs a clearer topic sentence" |
| Speaking Part 2, recording just completed | transcript, cue card | "You used 'I suppose' appropriately, but /θ/ pronunciation needs work" |

Implementation is defined in `06-engines.md` through context injection into the prompt.

## Healthy retention loop

Retention is designed as a value loop, not a loop that pressures users to reopen the app:

```text
Open app
  ↓
Check available time + energy             ← STUDY.CheckIn
  ↓
Choose Micro / Standard / Deep Session    ← STUDY.MicroSession / STUDY.Session
  ↓
Complete one outcome loop                 ← Understand → Practice → Retest → Confirm
  ↓
See evidence of progress                  ← PROGRESS.WeeklyRecap / PROGRESS.Motivation
  ↓
Choose an appropriate return schedule     ← NOTIF.Preference / NOTIF.SmartDelivery
```

### Retention rules

- Never reset progress when the learner takes a break; move them to a short `comeback plan` (`PROGRESS.Reactivation`).
- Never show a huge backlog immediately after return; prioritize one high-impact action.
- Streak is optional information, never an unlock condition, and notifications must not threaten streak loss.
- Every notification has a frequency cap, quiet hours, a clear unsubscribe path, and a reason for being sent.
- Measure `meaningful study days`, retest gain, and error recurrence; do not optimize retention around minutes, clicks, or notification count.

## Quality loop in the experience

Every feedback item must contain four parts:

1. **Evidence** — which sentence, audio segment, answer, or behavior supports the feedback.
2. **Meaning** — which rubric criterion or skill is affected.
3. **Action** — one specific lesson, drill, or rewrite.
4. **Verification** — a retest or attempt comparison that lets the learner see improvement.

If evaluation is not complete, the UI must show `processing`, `delayed`, `low_confidence`, or `unavailable`; it must not pretend a result exists and must not generate insights from invalid data.

## Cost-aware experience

- Allow the learner to choose feedback depth: `Quick`, `Standard`, `Deep`; default to the minimum depth that is still actionable.
- Surface cached transcript, explanation, and insight immediately when available; deeper analysis may run in the background.
- On weak networks or low quota, prioritize saving the draft, basic scoring/status, and queued retry; never lose learner data.
- Do not expose model/provider identity in the UI, but clearly expose usage limits, expected waiting time, and result state.

## Experience measurement

| Moment | Event to measure | Outcome |
|---|---|---|
| First day | `placement_completed`, `first_meaningful_session_completed` | activation and time-to-first-value |
| Wrong answer | `explanation_viewed`, `practice_started`, `retest_completed` | lower error recurrence |
| Evaluation | `writing_feedback_viewed`, `practice_started`, `evaluation_submitted`, `retest_completed` | feedback helpfulness and score improvement |
| Comeback | `comeback_plan_started`, `comeback_plan_completed` | return quality, not merely login |
| Notification | delivered/opened/dismissed/opted_out | incremental value and notification fatigue |

## UX quality gates

Before releasing a new journey, verify that the first meaningful action takes ≤ 3 steps, the primary action is clear, keyboard/screen-reader use works, offline/retry paths are real, copy is guilt-free, event tracking is complete, and the cost budget stays within threshold.
