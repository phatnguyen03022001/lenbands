# 04 — Experience Blueprint

This file describes the learner's **experience and journeys** — how the learner should feel. It **does not define features** (features are in `03-features.md`); it references capabilities only through IDs in the form `DOMAIN.Capability` so agents can trace them.

> **Scope guard:** this file describes the experience horizon for the full product. Closed-pilot P0 uses only `identity-consent`, `placement-and-plan`, `daily-action`, `writing-task-2`, `error-to-review`, and `governance-ops-dashboard` when permitted by the Build Readiness Matrix. Mock Test, Exam Readiness, Exam Day, After Exam, and other deferred capabilities are not P0 build inputs.

## UX principles

1. **Experience-centric, not feature-centric** — users think in journeys ("I need Band 7 with Writing ≥ 6.5 → what should I study today?"), not features ("I want to use Practice").
2. **Progressive Disclosure** — learners see only the depth that helps the current task; advanced rubric/analytics/governance detail is not dumped onto every learner.
3. **Always know the next step** — every primary learner surface ends by answering: "what is the next useful step and why?" (`PERSONAL.NextBestAction`).
4. **Evidence before celebration** — delight follows demonstrated progress, reduced uncertainty, successful retest/transfer, or meaningful completion; never manufacture progress from clicks/cards alone.
5. **Recovery before panic** — evaluation/network/session failures preserve work and expose an actionable recovery state.
6. **Minimum relevant context** — contextual coaching receives the smallest passage/question/task/evidence context required; it does not require unrestricted learner history.
7. **Energy-aware** — the system accounts for available time/energy and does not always push the same workload.
8. **Trust before persuasion** — score scope, evidence limits, data use, recommendation rationale, and uncertainty must be understandable; retention must never be purchased with dark patterns.
9. **One clear next step** — each surface has one primary action; secondary choices use progressive disclosure.
10. **No false precision** — if evidence is insufficient, the UI says so instead of showing a precise band/readiness percentage.

## Home (most frequently opened)

Home orchestrates `STUDY.*`; it is not a new feature.

```text
┌───────────────────────────────────┐
│  Greeting + optional streak       │  ← PROGRESS.Motivation
├───────────────────────────────────┤
│  Today's Goal / capacity          │  ← GOAL.Daily / STUDY.CheckIn
├───────────────────────────────────┤
│  ▶ Continue (resume session)      │  ← STUDY.Resume / STUDY.Continue
├───────────────────────────────────┤
│  Today's Plan                     │  ← STUDY.DailyPlan
│    • Review due                   │     REVIEW.SmartQueue
│    • Evidence / practice action   │     PRACTICE.*
│    • Lesson / remediation         │     LEARN.Path
├───────────────────────────────────┤
│  Evidence-backed insight          │  ← PERSONAL.Insights
│  ("Paraphrase evidence is weak") │
├───────────────────────────────────┤
│  Next Best Action + Why           │  ← PERSONAL.NextBestAction
└───────────────────────────────────┘
```

Empty state for a new learner: Home shows "Start Placement" (`PLACE.Test`) instead of pretending that a personalized plan already exists.

## 8 User Journeys

### 01. First Day (Onboarding)

The first experience must answer: "does this system understand my target, and does it know what it does not know about me yet?"

```text
Who are you? (basic profile)
   ↓
IELTS module? Academic / General Training
   ↓
Target overall + optional per-skill minima
   ↓
Target date / purpose              ← GOAL.Target
   ↓
Current level? self-report / prior official result / quick start
   ↓
Daily study capacity               ← GOAL.Daily / STUDY.CheckIn
   ↓
Placement Test                     ← PLACE.Test (when reliable evidence is missing)
   ↓
Evidence coverage + gap/uncertainty← PLACE.SkillDiagnosis / PLACE.GapDetection
   ↓
Create initial plan                ← PLACE.InitialPath + STUDY.DailyPlan
   ↓
First Home (Today's Plan appears)
```

Placement may legitimately end with `insufficient evidence`; reaching a time/item cap is not permission to fabricate a band estimate.

**Emotional goal:** "the system understands my real target, knows what evidence it has, and gives me a clear first action without overwhelming me."

### 02. Daily Study

The daily loop must answer: "where do I start today, why this, and what evidence would show that it helped?"

```text
Open app → Home (Today's Plan)     ← STUDY.DailyPlan
   ↓
Choose Continue / primary Today action
   ↓
Study Session                      ← STUDY.Session
   ↓
Learn / Practice / Review / collect evidence
   ↓
Outcome Summary                    ← STUDY.SessionSummary
   - action completed
   - evidence produced (if any)
   - error/remediation state
   - what is still uncertain
   ↓
Next Best Action                   ← PERSONAL.NextBestAction
```

Activity metrics such as minutes/questions support the summary but are not the primary definition of improvement.

**Emotional goal:** "I know what I achieved, what changed in the evidence, and what should happen next."

### 03. Mock Test

The mock-test experience should resemble the real exam and preserve score scope/integrity.

```text
Choose Mock Test                  ← PRACTICE.MockTest
   ↓
Exam Mode (timed, no hints)       ← PRACTICE.ExamSimulation
   ↓
[Interrupt according to valid resume policy]
   ↓
Resume without invalidating evidence context
   ↓
Submit
   ↓
Exam-simulation estimate + analysis ← PRACTICE.MockTest, EVAL.*
   ↓
Compare equivalent evidence/context ← HISTORY.Compare
   ↓
Exam Readiness updates only if evidence policy admits the result ← BAND.ExamReadiness
```

**Emotional goal:** appropriate exam-like tension without panic; after scoring, the learner knows what the estimate represents and what remains uncertain.

### 04. Wrong Answer

The experience converts an error into a traceable learning loop rather than a one-off explanation.

```text
Get a Reading/Listening question wrong
   ↓
Show answer evidence/explanation        ← COACH.AnswerExplanation
   ↓
Show distractor rationale when governed ← COACH.DistractorExplanation
   ↓
[Optional] contextual question          ← COACH.Tutor
   ↓
Save evidence-backed error              ← REVIEW.MistakeNotebook
   ↓
Map to remediation unit if one exists
   ├─ retrievable unit → FSRS card       ← REVIEW.FSRS
   └─ complex skill → practice/retest only
   ↓
Independent / novel retest               ← REVIEW.SmartQueue / PRACTICE.*
   ↓
Update learner evidence only after valid result
```

Do not auto-create an FSRS card when no meaningful retrievable unit exists.

**Emotional goal:** move from "I got this wrong" to "I know the cause, how to fix it, and how the system will verify that the improvement transfers."

### 05. Review (Spaced Repetition)

The review loop is light and fast, but it does not pretend card maturity equals IELTS skill mastery.

```text
Notification "X review units are due" ← NOTIF.SRS
   ↓
Open Today's Queue                    ← REVIEW.SmartQueue
   ↓
Retrieve before reveal                ← REVIEW.FSRS
   ↓
Rating: Again/Hard/Good/Easy
   ↓
FSRS updates scheduling state
   ↓
Forecast due load
```

A successful review may maintain a retrievable unit; complex-skill readiness still requires authentic independent/transfer evidence.

**Emotional goal:** "review efficiently without confusing memorization progress with exam readiness."

### 06. Before Exam

The final preparation stage must answer: "what evidence supports readiness, what is missing, and what has the highest value now?"

```text
Countdown displayed               ← GOAL.ExamPlan
   ↓
Exam Readiness check              ← BAND.ExamReadiness
   - scope / module / target minima
   - evidence coverage
   - per-skill state
   - uncertainty / blockers
   ↓
Evidence-backed priority insight  ← PERSONAL.Insights
   ↓
Priority practice/retest          ← REVIEW.SmartQueue / PRACTICE.*
   ↓
Last-minute plan                  ← GOAL.ExamPlan
```

Do not display a naked readiness percentage when required constructs/skills are under-measured.

**Emotional goal:** confidence from justified evidence, not manufactured certainty.

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

After the real exam, close the loop without silently treating one self-entered result as gold-standard training data.

```text
Enter official exam result        ← IDENTITY.Profile (optional + source scope)
   ↓
Compare actual vs prior scoped estimates ← HISTORY.Compare
   ↓
Optionally contribute to governed calibration/research only under consent/provenance policy
   ↓
Set a new target if needed        ← GOAL.Target
   ↓
Celebrate appropriately          ← PROGRESS.Motivation
   ↓
Adjust Learning Path             ← LEARN.Path + PERSONAL.NextBestAction
```

**Emotional goal:** close the loop, reflect on evidence, and have a clear next direction.

## Delight Moments

Delight follows meaningful progress and never upgrades readiness by animation alone.

| Moment | Trigger | Delight |
|---|---|---|
| Novel retest succeeds | valid independent retest improves an error pattern | "You fixed this pattern on a new task." |
| Transfer demonstrated | same construct succeeds in a new context | "This skill held up in a different context." |
| Uncertainty decreases | new independent evidence resolves an under-measured construct | "We now have stronger evidence for this skill." |
| Daily goal almost complete | <15 useful minutes remain | lightweight completion nudge |
| Review milestone | meaningful review count | lightweight milestone; explicitly a review milestone, not Band readiness |
| Scoped estimate improves | comparable valid attempts improve | show scope/context and evidence, not a naked band claim |
| Comeback | meaningful return after absence | short recap + one high-impact comeback action |

## Error Recovery

When something goes wrong, the learner must never be left at a dead end.

| Failure / validity state | Recovery | Capability |
|---|---|---|
| Evaluation timeout/provider failure | Preserve submission; show `processing`/`delayed`/`unavailable`; retry only through governed route | `EVAL.*` + failure contract |
| Writing/Speaking upload fails | Auto-retry where safe + preserve draft/local state | `PKM.Drafts` + `PKM.Offline` |
| Network loss during session | Auto-save checkpoint; resume according to evidence-validity policy | `STUDY.Resume` + `PKM.Sync` |
| Session timeout (Mock Test) | Preserve answers; restore only when exam-evidence policy permits valid resume | `STUDY.Resume` |
| Limited/insufficient evidence | Explain that more evidence is needed; suggest one appropriate retest/evidence action | `GOVERNANCE.ConfidenceScore` + `PERSONAL.NextBestAction` |
| Integrity-risk flag | Neutral notice; no cheating accusation; permit governed resubmission/retest path | `GOVERNANCE.AntiGaming` |

Technical failure codes, trace IDs, provider identity, and raw model confidence do not replace learner-facing guidance.

## Empty States

Every empty surface includes an honest onboarding action rather than a fabricated state.

| Surface | Empty state | Capability anchor |
|---|---|---|
| Home | "Start Placement to create your first plan" | `PLACE.Test` |
| Dashboard | "Complete a valid diagnostic/practice result to see evidence-based progress" | `PLACE.*` / `PRACTICE.*` |
| Mistake Notebook | "No saved evidence-backed errors yet" | `REVIEW.MistakeNotebook` |
| Word Bank | "Add words while learning or reading" | `PKM.WordBank` |
| Assessment History | "No attempts yet — scoped results will appear here" | `HISTORY.Attempts` |

## Progressive Disclosure by learner need

Band/learning bucket can influence presentation, but it is not the only dimension. Target profile, evidence coverage, learning mode, task and learner preference also matter.

| Typical learner state | Prioritize | Avoid by default |
|---|---|---|
| Foundation / limited evidence | one action, simple explanation, scaffolded practice, evidence collection | dense analytics, raw rubric/governance metrics |
| Developing / target range | criterion/micro-skill insight, independent retest, plan rationale | raw calibration internals |
| Advanced / precision | nuanced comparison, deeper rubric evidence, transfer/consistency analysis | unnecessary beginner scaffolding |

Principle: lower-level learners often need clearer scaffolding; higher-level learners often need precision. Neither group benefits from false certainty.

## Context Awareness

`COACH.Tutor` and model-assisted coaches receive **minimum relevant context**, not unrestricted history.

| User context | Minimum useful context | Example response |
|---|---|---|
| Reading Passage 2, Q18 | relevant passage segment, question/options, question type, answer/evidence state, relevant prior error summary if needed | explain the evidence and distractor pattern |
| Writing Task 2 active draft | task snapshot, draft, requested feedback scope | explain one criterion/action using text evidence |
| Speaking Part 2 attempt | cue card, transcript/approved audio-derived features, relevant pronunciation evidence | explain a supported fluency/pronunciation issue |

Implementation details and context-minimization rules live in `06-engines.md`.

## Healthy retention loop

Retention is a value loop, not a pressure loop:

```text
Open app
  ↓
Check time + energy                   ← STUDY.CheckIn
  ↓
Choose Micro / Standard / Deep        ← STUDY.MicroSession / STUDY.Session
  ↓
Complete one useful learning action
  ↓
Independent retest / evidence when appropriate
  ↓
See what evidence changed             ← PROGRESS.WeeklyRecap / PROGRESS.Motivation
  ↓
Choose an appropriate return schedule ← NOTIF.Preference / NOTIF.SmartDelivery
```

### Retention rules

- Never reset progress when the learner takes a break; use a short comeback plan.
- Never dump a huge backlog immediately after return; prioritize one high-impact action.
- Streak is optional information, never an unlock condition, and notifications must not threaten streak loss.
- Every notification has frequency cap, quiet hours, unsubscribe path, and a reason.
- Measure meaningful study days, independent retest/transfer gain, uncertainty reduction and error recurrence; do not optimize around minutes/clicks/notification count alone.

## Quality loop in the experience

Every meaningful feedback item follows:

1. **Evidence** — sentence/audio segment/answer/behavior that supports the claim.
2. **Meaning** — rubric criterion/skill/remediation concept affected.
3. **Action** — one high-leverage next intervention.
4. **Verification** — how an independent retest/attempt will verify improvement.

Processing state and result validity are separate:

- operation UI: `processing`, `delayed`, `unavailable`, `action_required` where applicable;
- result UI: accepted estimate/evidence, `limited evidence`, `insufficient evidence`, invalid/integrity-review recovery language according to policy.

Never show a score/insight as ordinary evidence when result validity does not permit it. Never expose raw uncalibrated model-confidence percentages as scientific certainty.

## Cost-aware experience

- Offer `Quick`, `Standard`, `Deep` feedback depth where useful; default to the least expensive depth that remains actionable.
- Reuse versioned/precomputed explanations and mappings when they answer the learner's need; generation is not inherently better.
- Show immediately available deterministic/approved reusable facts first; optional deeper model-assisted explanation may follow.
- On weak networks or low quota, prioritize preserving learner work, valid basic status/result, and governed retry.
- Premium may buy more depth/volume, but free/premium must share score semantics and minimum evaluation-quality floor.
- Do not expose provider identity as pedagogy; do expose usage limits, state and recovery honestly.

## Experience measurement

| Moment | Event to measure | Outcome |
|---|---|---|
| First day | `placement_completed`, `first_meaningful_session_completed` | activation, time-to-first-useful-diagnosis/action |
| Wrong answer | `explanation_viewed`, `practice_started`, `retest_completed` | independent error-recurrence reduction / transfer |
| Evaluation | `writing_feedback_viewed`, `practice_started`, `evaluation_submitted`, `retest_completed` | feedback helpfulness + independent improvement |
| Recommendation | `next_best_action_shown`, `next_best_action_taken`, later retest | action usefulness, not click-through alone |
| Comeback | `comeback_plan_started`, `comeback_plan_completed` | return quality, not merely login |
| Notification | delivered/opened/dismissed/opted_out | incremental value and fatigue |

## UX quality gates

Before releasing a new journey, verify that:

- the first meaningful action is easy to reach without unnecessary steps;
- time-to-first-useful-feedback/diagnosis is measured;
- the primary action and `Why this?` rationale are clear;
- keyboard/screen-reader use works;
- retry/offline/recovery paths are real;
- score scope and uncertainty cannot be mistaken for official certainty;
- copy is guilt-free;
- event tracking measures outcomes rather than clicks alone;
- model context is minimized;
- the cost budget stays within threshold without degrading the required quality floor.
