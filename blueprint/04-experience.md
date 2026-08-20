# 04 — Experience Blueprint

This file owns the learner experience and journey. It does **not** define capability semantics or algorithms; those remain in `03-features.md` and `06-engines.md`.

> **Scope guard:** this file describes the full product horizon. Closed-pilot P0 uses only the approved vertical slices in the Build Readiness Matrix. Deferred Mock Test, full Exam Readiness, Speaking/Pronunciation, After Exam, and other future capabilities do not become P0 build inputs merely because they appear here.

## 1. Experience contract

The learner should never need to understand LenBands' internal capability graph, evidence graph, scorer routes, taxonomy, FSRS internals, provider routing, risk controls or governance machinery to know what to do next.

The primary experience answers five questions:

1. **What is my IELTS target?**
2. **Where does the evidence say I am now?**
3. **What is actually blocking the target: English foundation, IELTS technique, integrated performance, or missing evidence?**
4. **What one thing should I do now, and why?**
5. **What evidence will show that the improvement is real and transferable?**

Everything else is progressive disclosure.

## 2. UX principles

1. **Experience-centric, not feature-centric** — users think in target journeys, not capability names.
2. **One primary path** — each primary surface exposes one next action and at most one lighter alternative.
3. **Progressive disclosure** — rubric detail, analytics, history and governance depth appear only when useful.
4. **Evidence before certainty** — missing evidence is shown as missing evidence, not weakness or a fabricated band.
5. **Cause before intervention** — foundation, IELTS technique and integrated-performance problems should not receive the same generic practice path.
6. **Minimum sufficient challenge** — do not push harder/higher-band content unless prerequisite, exam authenticity or transfer policy requires it.
7. **Evidence before celebration** — progress follows independent retest, transfer, maintained evidence or meaningful uncertainty reduction.
8. **Recovery before panic** — failures preserve work and present one actionable recovery state.
9. **Energy-aware** — available time/energy changes burden, not scoring truth.
10. **Trust before persuasion** — score scope, feasibility limits, data use and recommendation rationale must be understandable.
11. **No dark patterns** — streaks, reminders and premium design never manufacture urgency or readiness.
12. **No guaranteed-band copy** — LenBands may explain target feasibility and evidence-based readiness; it must not promise an official IELTS band from plan compliance alone.

## 3. Minimal Target-to-Band path

This is the default learner route across the product:

```text
Target Profile
   ↓
Minimum useful evidence
   ↓
Target feasibility
   ├─ insufficient evidence -> collect the smallest missing evidence
   ├─ on track -> continue highest-value target action
   ├─ at risk -> address highest-leverage actionable blocker
   ├─ current constraints insufficient -> change one constraint/expectation
   └─ target met -> maintain/transfer/readiness evidence
   ↓
Supported cause
   ├─ English foundation
   ├─ IELTS technique
   ├─ Integrated performance
   ├─ Mixed
   └─ Evidence needed
   ↓
ONE smallest useful intervention
   ↓
Independent verification / retest
   ├─ not yet -> diagnose cause / adjust
   └─ passes -> transfer / maintenance where required
   ↓
Readiness update
   ↓
Next highest-value target gap
```

This path is a product invariant. Feature additions may deepen a step but must not create a parallel primary journey without evidence that the extra choice materially improves learner outcome.

## 4. Home

Home is an orchestration surface, not a feature dashboard.

Default layout:

```text
┌────────────────────────────────────────┐
│ Target status                          │
│ e.g. Band target + feasibility state   │
├────────────────────────────────────────┤
│ ▶ Today's one primary action           │
│ Why this?                              │
│ How we will verify it                  │
├────────────────────────────────────────┤
│ Optional lighter action                │
│ only when time/energy requires it      │
├────────────────────────────────────────┤
│ Small status/review indicator          │
│ only if it changes today's decision    │
└────────────────────────────────────────┘
```

Do **not** stack separate primary cards for Daily Plan, Smart Queue, Insights, Recommendation, Learning Path and Progress if they all compete for the same next-action decision.

Advanced history/analytics/content browsing remains accessible but secondary.

New learner empty state: `Start placement / provide evidence` rather than fake personalization.

## 5. First Day

The first experience answers: **Does the system understand my target, constraints and uncertainty, and can it give me one credible first step?**

```text
Basic profile
   ↓
Academic / General Training
   ↓
Target overall + optional skill minima
   ↓
Exam date / purpose
   ↓
Study capacity
   ↓
Prior official result/self-report when available
   ↓
Minimum placement evidence when needed
   ↓
Evidence coverage
   ↓
Foundation vs technique vs integrated-performance diagnosis
   ↓
Target feasibility state
   ↓
ONE first action + why + verification
```

Rules:

- placement may end with insufficient evidence;
- target feasibility may also be insufficient evidence;
- `on_track` is not a guarantee;
- `current_constraints_insufficient` must present actionable choices without shaming the learner;
- onboarding should not ask for metadata that does not change the first plan.

## 6. Daily Study

The daily loop:

```text
Open app
   ↓
Today action + Why + Verification
   ↓
Micro / Standard burden according to time/energy
   ↓
Learn / Practice / Review / Retest / Evidence collection
   ↓
Outcome summary
   - what was completed
   - what evidence changed
   - what remains uncertain
   - whether verification passed
   ↓
Next action only when needed
```

Activity metrics such as minutes/questions are secondary. They do not define progress.

## 7. Error-to-improvement journey

```text
Evidence-backed error
   ↓
Cause: foundation / technique / integrated performance
   ↓
Explain evidence + meaning
   ↓
ONE high-leverage fix
   ↓
Guided practice when needed
   ↓
Independent practice
   ↓
Novel retest
   ↓
Transfer / maintenance when the construct requires it
   ↓
Update learner evidence
```

FSRS is inserted only for a genuinely retrievable remediation unit. Review-card maturity never substitutes for complex IELTS performance.

## 8. Progressive disclosure by learner need

| Learner state | Primary presentation | Hide by default |
|---|---|---|
| Limited evidence | one evidence-collection action + simple reason | weakness labels, dense analytics, fake band precision |
| Foundation blocker | bounded language remediation + simple verification | advanced task tricks, high-band enrichment |
| IELTS-technique blocker | task method + targeted independent practice | unrelated general-English lesson inventory |
| Integrated-performance blocker | timed/independent application + transfer | repeated explanations already understood |
| Mixed | smallest blocking component first + explain ordering | multiple simultaneous plans |
| Target range/advanced | precision, transfer and stability evidence | unnecessary beginner scaffold |

A learner should never be pushed into advanced material simply because their target is high. Prerequisites and current evidence determine the next challenge.

## 9. Target feasibility UX

Learner-facing feasibility states:

| State | Meaning | UX |
|---|---|---|
| `insufficient_evidence` | not enough current evidence to judge the plan | collect the smallest missing evidence |
| `on_track` | current policy sees no known pace/coverage blocker | continue; explicitly avoid guarantee wording |
| `at_risk` | one or more actionable blockers exist | show the highest-leverage blocker + action |
| `current_constraints_insufficient` | current time/capacity/content constraints cannot form a credible path | offer one decision at a time: more time, later date, changed target/minimum, or another realistic constraint |
| `target_met` | readiness policy is satisfied by admitted evidence | maintain/transfer/exam-prep; do not force higher-band study |

Forbidden copy patterns:

- `Follow the plan and you will get Band 7.`
- `97% chance of Band 7` without validated probabilistic calibration.
- `You only need N hours to gain 1 band` without validated outcome evidence.

Allowed promise:

> LenBands will keep the plan tied to your target and admitted evidence, explain why each step matters, and only count improvement when the owning evidence policy supports it.

## 10. Mock / Before Exam / Exam Day

When these capabilities activate, keep the same compressed model.

### Mock Test

```text
Exam-like attempt
   ↓
Scoped simulation estimate
   ↓
What the result represents
   ↓
Highest-value blocker
   ↓
ONE next action
```

### Before Exam

```text
Target + evidence-backed readiness
   ↓
Missing/at-risk skill or construct
   ↓
Highest-value remaining action
   ↓
Light exam logistics/checklist
```

Do not show a naked readiness percentage when required evidence is missing.

### Exam Day

The app recedes into the background: timeline/checklist/time strategy only. No heavy learning queue or guilt notification.

## 11. After Exam

A learner-entered official result is stored with source scope and compared with prior LenBands estimates only when comparison is semantically valid. It does not automatically become calibration truth.

The next path is either:

- target achieved -> close/maintain/new target;
- target missed -> compare evidence, identify the most supportable gap, create a new one-action plan.

## 12. Failure and recovery

Every failure ends in a useful state.

| Condition | Recovery |
|---|---|
| Evaluation timeout/provider failure | preserve submission; show processing/delayed/unavailable and governed retry |
| Network loss | preserve accepted server state + safe local unacknowledged work where allowed |
| Limited/insufficient evidence | explain missing evidence + one collection/retest action |
| Integrity risk | neutral notice + governed resubmission/retest; never cheating accusation from a weak signal |
| Missing curriculum coverage | `content_gap`; do not substitute unrelated/harder material |
| Target constraints insufficient | show one constraint decision, not an impossible normal plan |
| No eligible action | truthful fallback/no-plan state |

Technical codes, provider identity and raw model confidence never replace learner-facing guidance.

## 13. Healthy retention

Retention is a value loop:

```text
Return
  -> one useful action
  -> evidence change
  -> clear next state
  -> optional reminder for genuinely useful follow-up
```

Rules:

- breaks do not reset progress;
- comeback starts with one high-value action, not backlog dumping;
- streak is optional information, never an unlock condition;
- notifications respect quiet hours/frequency caps/opt-out;
- measure meaningful study days + independent improvement, not notification opens alone.

## 14. Feedback contract

Every meaningful feedback item follows:

1. **Evidence** — what supports the claim.
2. **Meaning** — what foundation/technique/criterion/skill issue it represents.
3. **Action** — one high-leverage intervention.
4. **Verification** — how an independent attempt will verify improvement.

Optional deeper explanation comes after these four elements, never before the learner knows what to do.

## 15. Cost-aware experience

- deterministic/reusable facts first;
- generated wording only when it adds value;
- default feedback depth is the least expensive version that remains actionable;
- premium may increase volume/depth, never alter score/evidence semantics;
- weak network/quota preserves work and basic truth before optional depth;
- fewer learner-facing choices are preferred when they preserve outcome quality.

## 16. Experience measurement

| Moment | Primary outcome | Guardrail |
|---|---|---|
| First day | time to first credible target-aware action | onboarding burden |
| Diagnosis | supported cause classification / useful evidence collection | false weakness/cause rate |
| Recommendation | later retest/transfer lift | choice overload / opt-out |
| Feedback | next independent attempt improves | abandonment / feedback length |
| Feasibility | learner takes an appropriate plan/constraint action | no false guarantee/false precision |
| Comeback | meaningful session resumed | guilt/notification fatigue |
| Before exam | evidence coverage and stable performance improve | avoid last-minute over-band cramming |

## 17. UX quality gates

Before releasing a learner journey, verify that:

- the first meaningful action is easy to reach;
- the learner does not need to browse the feature catalog to know what to do next;
- one primary action, one reason and one verification rule are visible;
- at most one lighter alternative competes with the primary action;
- missing evidence is not labeled weakness;
- foundation vs technique vs integrated-performance cause changes the intervention where evidence supports it;
- no over-target/advanced material appears without explicit justification;
- missing curriculum coverage returns a truthful content-gap state;
- target feasibility never becomes a guaranteed-band claim;
- keyboard/screen-reader/reflow/recovery behavior works on the critical path;
- score scope/result validity cannot be mistaken for official certainty;
- tracking measures outcomes rather than clicks alone;
- model context is minimized;
- cost stays within the quality floor.
