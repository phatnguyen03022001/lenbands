# Vertical Slice — Writing Task 2

## 0. Specification status

Canonical lifecycle metadata remains in `writing-task-2.meta.yaml`.

This slice is the first closed-pilot learner outcome proof. It is not build-ready until the canonical API/schema, rights-approved content, benchmark route and executable acceptance evidence align with the current Blueprint/runtime contracts.

The canonical runtime processing contract is `artifacts/engineering/contracts/writing-task-2/runtime-spec.md`. This document owns the learner-experience summary and must not redefine runtime/API state semantics.

## 1. Product outcome

The learner writes one IELTS Writing Task 2 essay, receives evidence-backed task-scoped diagnostic feedback, fixes the highest-leverage error, then demonstrates improvement on sufficiently novel content.

```text
Task
  -> Draft
  -> Submit
  -> Staged evaluation
  -> Evidence-backed priority finding
  -> Smallest useful fix
  -> Review when retrievable
  -> Independent/novel retest
  -> Verified improvement or explicit remaining gap
```

Success is not "AI returned a score" and not "learner completed a card". The slice succeeds when a later admissible attempt provides evidence that the targeted error decreased.

## 2. Scope

In-scope capability packs:

- P0-04: `LEARN.Writing`, `EVAL.Writing`, `COACH.ErrorAnalysis`, `COACH.Feedback`, `PKM.Drafts`;
- P0-05 integration: `REVIEW.MistakeNotebook`, `REVIEW.FSRS`, `REVIEW.SmartQueue`, `PRACTICE.Drill`;
- P0-06 controls: `OPS.*` required by Writing evaluation plus `GOVERNANCE.ConfidenceScore`/audit semantics.

Explicitly out of scope:

- full essay rewrite generation;
- Speaking/Pronunciation;
- human examiner runtime workflow;
- full cross-skill content management;
- advanced personalization/Insights;
- generic AI-generated-text adjudication;
- per-learner FSRS optimization;
- full mock/exam-readiness claims.

## 3. Learner / access boundary

| Persona | Slice behavior |
|---|---|
| Learner | own task/draft/submission/evaluation/error/retest within entitlement/quota |
| Premium Learner | same learner role; different entitlement/quota/depth only |
| Colab | no private learner evaluation access in normal content role |
| Admin | aggregate governance/operations; no manual score overwrite |
| Internal evaluation worker | function-scoped access to one required operation payload |

Premium never uses a different scoring truth/quality floor. Higher plans may buy quota, latency priority or deeper optional explanation, not a lower/higher semantic definition of the same score.

## 4. Entry conditions

P0 entry requires:

- authenticated learner + effective required consent;
- TargetProfile exists or a safe P0 fallback target state exists;
- a right-approved published Writing Task 2 exists for the relevant module/policy;
- the task/rubric/evaluation route is build/release eligible;
- evaluation quota/budget can be checked before paid inference.

If no eligible task exists, show a truthful empty/unavailable state. Do not synthesize an arbitrary assessment task at runtime to avoid the empty state.

## 5. Learner flow

### WR-01 — Task

Show:

- task prompt/type;
- module where relevant;
- word target/time guidance;
- clear primary CTA `Start writing`.

Do not expose internal provider/model identity.

### WR-02 — Editor

Must provide:

- autosave/local recovery;
- word count;
- optional timer;
- visible `Saved`/`Saving locally` state;
- submit confirmation rather than accidental immediate keyboard submit.

Network loss must never erase the current learner draft.

### WR-03 — Submit confirmation

Show immutable-version warning, current word count and applicable remaining evaluation allowance.

Before paid inference, deterministic checks validate task/version/input/quota/idempotency.

Invalid input keeps the draft editable and produces zero scorer calls.

### WR-04 — Evaluating

The learner sees only truthful operation states:

- processing;
- delayed;
- unavailable.

The learner may leave the screen. The accepted submission remains durable and may be resumed/read later.

Do not expose `low_confidence` as a queue/lifecycle state.

### WR-05 — Feedback

Content order:

1. what this result represents (`diagnostic estimate from this Writing Task 2`);
2. result limitation copy when evidence is limited/insufficient;
3. criterion summary;
4. cited evidence from the learner essay;
5. one highest-priority finding;
6. one concrete corrective action;
7. how improvement will be verified.

Do not show raw model confidence percentages as learner truth.

Primary CTA: `Fix priority error`.

Secondary actions may include `View more detail`, `This feedback seems wrong`, or `Skip for now`.

### WR-06 — Fix

The intervention is the smallest useful action for the confirmed error.

Example behavior:

```text
source evidence
  -> short diagnosis
  -> worked/contrast example if needed
  -> learner produces corrected response independently
  -> save fix evidence
```

Do not auto-rewrite the whole essay by default. A full rewrite is not evidence that the learner learned the target construct.

### WR-07 — Review / Retest

If the remediation unit is meaningfully retrievable, it may enter FSRS review.

Examples suitable for FSRS:

- grammar form/rule;
- collocation/phrase;
- punctuation/error concept;
- bounded sentence pattern.

Examples not proven by card maturity alone:

- Task Response;
- Coherence & Cohesion;
- overall Writing performance.

Retest uses sufficiently novel eligible content according to exposure policy. A familiar/revealed prompt can support practice but does not automatically prove transfer.

## 6. State presentation

Experience consumes the runtime axes rather than creating new semantic states.

### Operation state

```text
accepted -> processing -> succeeded | delayed | unavailable | failed | cancelled
```

Learner UI normally projects these into actionable copy such as `Evaluating`, `Taking longer`, `Unavailable`.

### Result validity

```text
accepted
limited_evidence
insufficient_evidence
invalid
integrity_review
```

Result validity determines whether/how a diagnostic estimate or finding is shown and whether downstream learner-state policy may admit it.

Do not put `low_confidence`, `anti_gaming_review`, `invalid` into the same persisted submission lifecycle enum.

## 7. Score and trust UX

Every numeric result must show scope before precision.

Preferred framing:

- `Estimated from this Writing Task 2`;
- `Limited evidence — use another task to strengthen the estimate`;
- `Not enough evidence for a reliable numeric estimate`.

Avoid:

- naked `Band 7.0` with no scope;
- `73% confidence` when the number has no calibrated learner interpretation;
- language implying official IELTS examiner equivalence without evidence.

## 8. Integrity UX

Integrity handling is neutral and recoverable.

If an unresolved integrity risk exists:

- do not accuse the learner based on a detector score;
- explain that this attempt cannot currently be used as normal evidence;
- allow an appropriate resubmission/new attempt path;
- keep original learner work durable according to retention policy.

Known-sample similarity/provenance/exposure facts are preferred over probabilistic AI-text-detector claims.

## 9. TargetProfile behavior

The task itself does not store the learner target.

TargetProfile may influence:

- module eligibility;
- planning/priority;
- feedback depth/prioritization after scoring;
- later gap/readiness interpretation.

It must not bias the scorer into awarding the target band. Rubric judgment uses task evidence, not "the learner wants Band 7" as scoring evidence.

## 10. Event/outcome measurement

Core learner-outcome sequence:

```text
writing_submission_accepted
evaluation_submitted
evaluation_scored | evaluation_delayed | evaluation_failed
writing_feedback_viewed
learning_error_saved
learning_error_fix_completed
review_completed                 # only when review exists
retest_completed
verified_improvement_recorded    # add/activate only through canonical event governance
```

Existing canonical event names remain authoritative. If `verified_improvement_recorded` is not yet registered, do not emit it until the event owner adds it; derive pilot evidence from admitted retest/evidence records in the meantime.

Do not treat feedback view, fix completion or review completion as verified improvement by themselves.

## 11. Quality guardrails

- every actionable finding cites actual learner evidence;
- unsupported/hallucinated evidence is not silently promoted;
- scorer route change requires benchmark/release gate;
- task/rubric/prompt/scorer provenance is retained;
- no result validity state bypasses evidence admission;
- no learner-facing score is generated when evidence policy requires `insufficient_evidence`;
- repeated/familiar retest is not counted as independent transfer;
- accessibility and keyboard recovery remain part of release acceptance.

## 12. Cost guardrails

- zero scorer calls for deterministically invalid input;
- one approved primary scorer route for ordinary cases;
- stronger/second scorer only under hard-case policy;
- concise feedback is default;
- deep personalized feedback is optional/quota-bound;
- remediation content is reused/precomputed where possible;
- FSRS uses deterministic library logic;
- route/retry/escalation cost is attributable per evaluation;
- pilot evaluates `cost_per_verified_improvement`, not only tokens/evaluation.

## 13. Failure/recovery matrix

| Problem | Learner behavior |
|---|---|
| Draft network failure | keep local draft; retry sync |
| Duplicate submit/retry | resolve same logical submission via idempotency |
| Quota unavailable | keep draft; explain alternative |
| Provider timeout | preserve submission; show delayed; bounded retry |
| No approved scorer route | unavailable, not silent model substitution |
| Invalid scorer evidence | do not pretend result exists; governed retry/degraded validity |
| Limited evidence | show scoped result limitation and next verification action |
| Integrity risk | neutral action-required/resubmission path |
| Retest content unavailable | keep error state; offer another valid action rather than fake completion |

## 14. Acceptance criteria

P0 slice is acceptable only when executable tests/evidence prove:

- published/right-approved task only;
- draft survives refresh/network interruption;
- invalid/under-threshold input creates no paid scorer call;
- duplicate submit creates one semantic submission/charge;
- evaluation uses staged pipeline and approved routes;
- malformed/hallucinated evidence cannot become accepted learner feedback;
- learner A cannot access learner B data;
- raw essay is absent from general telemetry;
- learner sees task-scoped estimate semantics;
- raw confidence is not exposed as a correctness probability;
- one evidence-backed finding maps to one smallest useful fix;
- FSRS card is created only for suitable retrievable unit;
- retest meets configured novelty/exposure requirement;
- improvement is based on admitted retest evidence rather than completion;
- provider/model output cannot directly update readiness/mastery;
- primary/escalation/deep-feedback cost is measurable.

## 15. Exit

The slice exits with one of these learner-meaningful states:

- verified improvement for the targeted error;
- error remains active with a clear next action;
- evidence remains insufficient and the learner knows what evidence is needed;
- evaluation temporarily unavailable but learner work is preserved.

There is no valid exit state called "AI finished".