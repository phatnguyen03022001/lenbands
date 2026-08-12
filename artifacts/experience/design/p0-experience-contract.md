# P0 Experience Contract

## Purpose

This is the behavior contract for the P0 closed pilot. If a wireframe answers "what does the screen look like?", this file answers "which state is the learner in, what does the system decide, which copy/action must appear, and which state follows?".

## Mode guard (P0 constraint)

The P0 shell must follow Stage-Drawer + State-Driven Modes (`information-architecture.md`, `navigation-model.md`). P0 implements only 3 modes:

| Mode P0 | Stage (Today) | Edge rail |
|---|---|---|
| `onboarding` | Welcome + baseline CTA | Today + Learn only; Tests/Practice hidden |
| `early` (after placement, band 3–5) | micro-session + 1 Writing/lesson action | Today, Learn, Practice, Review; **Tests hidden** |
| `core` (band 5.5+) | full Today plan | All 5 rails |

`exam_prep` and `comeback` are post-P0, but the contract must remain safe when they are added later.

P0 rules:
- Today is always the stage and contains exactly 1 primary action.
- Do not render Tests for a learner without placement or with band < 5.5.
- The edge rail has no red badge; change only weight (prominence, order).

## Loop spine rule (P0 constraint)

Every P0 screen must declare its position in the loop `Diagnose → Learn → Practice → Fix → Review → Prove`. Today is the router — Today's primary action is that learner's next loop step, not a fixed task.

| Loop pos | Today primary action (P0) |
|---|---|
| Diagnose | Start/continue placement |
| Learn | Open the next lesson |
| Practice | Do Writing Task 2 (P0 slice) |
| Fix | Fix the priority error from feedback |
| Review | Review due FSRS cards |
| Prove | Retest proof for the Writing error (P0); full band-readiness proof is post-P0 |

Today does not show every loop step at once.

Reference sources:

- `artifacts/experience/research/ux-experience-research.md`
- `artifacts/experience/design/interaction-model.md`
- `artifacts/experience/specs/vertical-slices/*.md`

## P0 north-star experience

In a successful learning loop, the learner should feel:

```text
I know where I am
  -> I know what to do today
  -> I finish writing without losing my work
  -> I understand one important error
  -> I fix it and see evidence of progress
```

Do not optimize P0 for the number of lessons, charts, notifications, or screens.

## Global behavior requirements

| Requirement | Rule |
|---|---|
| Primary action | Each state has one primary CTA. Secondary actions must have a clear reason. |
| State visibility | Loading/empty/error/locked each needs its own copy; do not render one shared skeleton. |
| Recovery | Preserve user input before every retry/timeout. |
| Trust | Evaluation results must include confidence, evidence, and model/rubric/prompt version in the internal trace. |
| Cost | An action that calls an LLM must show/respect quota; do not call a model to decorate the UI. |
| Rights | If a task/source is invalid, the UI must block with an empty/recovery state; do not generate a random task. |
| Privacy | Consent copy appears before processing learner-facing content with high sensitivity. |

## Entry point matrix

| Product state | Landing | Primary CTA | Secondary path | Guardrail |
|---|---|---|---|---|
| `new` | Welcome / consent-aware onboarding | Start baseline | Preview how evaluation works | Do not show an empty dashboard. |
| `authenticated_unconsented` | Consent disclosure | Accept required scope | Manage consent | Do not default to opt-in for optional processing. |
| `diagnosing` | Placement resume | Continue placement | Retry if the attempt is corrupt | Do not lose answered questions. |
| `diagnosed` | Gap + first plan | Accept Today plan | Edit goal | Band remains provisional if not calibrated. |
| `learning` | Today | Start next action | Switch to micro-session | No more than 3 choices. |
| `writing_draft` | Writing workspace | Continue writing | Save and exit | Show autosave status clearly. |
| `evaluation_pending` | Evaluation waiting | View status | Return to Today | Do not lock the app in a spinner. |
| `feedback_ready` | Feedback | Fix priority error | View rubric/evidence | Do not present 10 equal errors. |
| `review_due` | Review queue | Review due error | Snooze with a reason | Every card has original evidence. |
| `inactive` | Comeback | Do a micro-session | View plan again | No guilt/streak shame. |
| `blocked` | Recovery | Retry / alternative | Help / report | Copy states impact and exit path. |

## Screen-level anatomy

### Today

| Zone | Required content | Interaction |
|---|---|---|
| Context strip | goal, time budget, current confidence | edit goal/check-in |
| Main action | one next best action + why now | start |
| Plan detail | review/practice/lesson as secondary | expand/collapse |
| Recovery slot | no plan/stale/offline/quota message | retry or fallback |
| Progress proof | last meaningful improvement | open detail |

### Placement

| Zone | Required content | Interaction |
|---|---|---|
| Setup | target band/date/time | validate on blur/submit |
| Baseline intro | what will be estimated and confidence rule | start |
| Attempt | question, progress, save status | answer/pause/resume |
| Result | provisional band, gap, first action | accept plan |
| Retry path | insufficient data reason | retry bounded section |

### Writing workspace

| Zone | Required content | Interaction |
|---|---|---|
| Task | prompt, task type, module, rights status | switch task only if draft safe |
| Compose | word count, timer, autosave | write/save/submit |
| Submit guard | quota/cost-visible state, consent required | submit or cancel |
| Pending | job status, expected next check | leave screen safely |
| Recovery | duplicate submit/timeout/offline | retry idempotently |

### Feedback

| Zone | Required content | Interaction |
|---|---|---|
| Verdict | band estimate, confidence, user-safe caveat | see criteria |
| Evidence | quoted learner span or section reference | jump to text |
| Priority fix | one error with expected impact | start fix |
| Explanation | why it matters and how to fix | expand detail |
| Retest | short proof task | complete/retry |

### Review

| Zone | Required content | Interaction |
|---|---|---|
| Queue header | due count, estimated time, source | start/snooze |
| Review card | error, original evidence, recall prompt | reveal |
| Rating | Again/Hard/Good/Easy | schedule |
| Result | next due, progress proof | next/done |
| Empty | when next review appears + alternative | open Today |

## State matrix

| Surface | Loading | Empty | Error | Locked/limited |
|---|---|---|---|---|
| Today | skeleton + "Calculating the best next action" | placement CTA or micro-session | fallback action | explain quota and free alternative |
| Placement | restore progress | no config available | retry section | n/a P0 |
| Writing | restore draft/task | no published task | draft preserved + retry | submit limit shown before action |
| Feedback | evaluation pending | no submitted essay | delayed/unavailable + retry | existing feedback still readable |
| Review | loading due queue | no due item + next due time | queue stale + Today fallback | n/a P0 |

## Retention rules

| Moment | Allowed nudge | Forbidden |
|---|---|---|
| First day | "Complete the baseline to receive your first task" | claim guaranteed band improvement |
| After feedback | "Fix this error to check again" | 10 simultaneous improvement tips |
| Review due | "3 errors due, takes 5 minutes" | guilt copy about losing streak |
| Inactive comeback | "Start again with a 7-minute task" | shame or penalty language |
| Quota reached | "You can still review/fix existing work" | hiding existing work behind paywall |

## Acceptance checklist

- [ ] New learner can reach first meaningful action without seeing an empty dashboard.
- [ ] Returning learner sees one clear action in <= 5 seconds after app open.
- [ ] Writing draft survives refresh, offline period and duplicate submit attempt.
- [ ] Evaluation timeout never loses essay and never charges/records duplicate accepted submission.
- [ ] Feedback includes evidence, confidence and one priority fix before detailed rubric.
- [ ] Review card cannot exist without source error/evidence reference.
- [ ] Every empty/error/locked state has one recovery action.
- [ ] Paywall or quota state never hides already-created learner work.
- [ ] UX copy never claims official IELTS score or guaranteed result.

## Readiness

This artifact remains `draft` until the related P0 vertical slices and runtime contracts are reviewed. It is used as input for code writing, but the Build Readiness Matrix remains `not ready` until a real acceptance run exists.
