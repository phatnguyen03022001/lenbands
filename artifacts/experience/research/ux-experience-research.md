# UX Experience Research Synthesis

## Purpose

This artifact gathers UX insights for immediate use in the P0 closed pilot. It is not a user-interview finding and does not approve a launch claim. It is a research synthesis that turns principles into a behavior contract for LenBands.

## Scope

P0 evaluates experience only for the loop:

```text
Identity / consent
  -> Placement / goal
  -> Today action
  -> Writing Task 2
  -> evidence feedback
  -> one fix
  -> FSRS review
  -> retest proof
```

Listening, Reading, Speaking, and Pronunciation remain product-horizon areas. Do not use this artifact to expand P0 scope.

## Research sources

| Source | Role in LenBands | Application |
|---|---|---|
| IELTS official Writing preparation resources | Rubric/task grounding | Writing feedback must follow the four criteria: Task Response/Achievement, Coherence and Cohesion, Lexical Resource, and Grammatical Range and Accuracy. |
| British Council IELTS assessment resources | Assessment trust | Band/feedback must clearly state that this is a learner-facing evaluation, not an official score. |
| Google PAIR - Errors and Graceful Failure | AI failure UX | An AI timeout or low-confidence result must let the learner continue; do not turn a system failure into a learner failure. |
| Nielsen Norman Group - Progressive disclosure | Complexity control | Home/Feedback shows the primary action first; advanced rubric/evidence opens on demand. |
| Nielsen Norman Group - Error message guidance | Recovery copy | An error must state the problem, impact, and next action; preserve the input. |
| Open Spaced Repetition / FSRS documentation | Review mental model | A review card needs a clear rating and the resulting next review schedule; do not explain the algorithm too deeply in the main flow. |

References are research input only. Evidence about LenBands exists only when a real interview, benchmark, or pilot run is recorded in `artifacts/operations/evidence/`.

Reference URLs:

- IELTS Writing preparation resources: https://ielts.org/take-a-test/preparation-resources/writing-test-resources
- British Council IELTS assessment resources: https://takeielts.britishcouncil.org/teach-ielts/test-information/assessment
- Google PAIR Errors and Graceful Failure: https://pair.withgoogle.com/chapter/errors-failing/
- Nielsen Norman Group hostile error patterns: https://www.nngroup.com/articles/hostile-error-messages/
- Open Spaced Repetition FSRS repository: https://github.com/open-spaced-repetition/free-spaced-repetition-scheduler

## P0 learner jobs

| Job | Moment | User question | UX requirement |
|---|---|---|---|
| Start safely | first app open | What data does the app collect about me? | Short consent, clear scope, and a management path. |
| Know baseline | after goal/placement | Where am I, and is it trustworthy? | Band/gap always includes confidence and a provisional/calibrated label. |
| Start today | every return | What should I do today? | One primary CTA, a short reason, and a fallback when data is insufficient. |
| Trust feedback | after submitting Writing | Why does the app say I am wrong? | Evidence highlight -> explanation -> one fix; do not dump the rubric. |
| Improve one thing | after feedback | What should I fix first? | One priority error, one drill/retest, and a measurable result. |
| Come back calmly | after an absence | Am I being punished or shamed about my streak? | A light micro-session, no shame, and no coercive notification. |

## Experience principles for code handoff

1. Every screen must have one primary action. If there is more than one primary action, the artifact must state the decision rule.
2. Every learner-facing AI output must have a trust layer: confidence, evidence, version, and recovery.
3. Every empty state must say why it is empty and provide a path forward. An empty state must not be a dead screen.
4. Every failure must preserve the learner's input before offering a retry.
5. Every recommendation must state its reason using the available data; do not pretend to personalize when data is missing.
6. Every paywall/limit must provide a reasonable free alternative in P0 and must not lock already-created input.
7. Every review item must have original evidence; do not create a flashcard from an untraceable error.
8. Every retention surface must prioritize learning outcomes over time in the app.

## P0 anti-patterns

| Anti-pattern | Why it is dangerous | Replacement rule |
|---|---|---|
| Dashboard with many cards | The learner does not know where to start | Today = one next action + optional plan detail. |
| AI score presented as truth | Trust breaks when the model is wrong or changes | Score/evaluation has confidence, rubric version, and a dispute path. |
| Feedback that is too long | The learner cannot act on it | Feedback hierarchy: verdict -> evidence -> one fix -> optional detail. |
| Review queue without a reason | FSRS becomes busywork | Every review states the error/source and goal. |
| Blank empty state | The user thinks the app is broken | Empty state has an explanation + one CTA. |
| Unexpected paywall | Reduces trust and increases churn | Show the limit before a high-cost action; do not lose created input. |

## Decision impact

P0 design artifacts must be updated to show:

- Entry points by product state.
- State-specific behavior for default/loading/empty/error/locked.
- Trust behavior for Writing evaluation.
- Continuity behavior for draft, placement, review, and retry.
- Outcome-based acceptance criteria, not only screen rendering.

## Open gaps

- No real user-interview findings yet.
- No usability test run yet.
- No benchmark of Writing-feedback helpfulness yet.
- No pricing/paywall comprehension test yet.

Therefore this artifact is `draft`; it may guide design, but must not be used to claim market validation.
