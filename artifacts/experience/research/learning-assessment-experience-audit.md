# Learning, Assessment & Experience Optimization Audit

## Purpose

This artifact is the evidence-informed synthesis for how LenBands should help a learner **learn, be assessed, receive feedback, and decide what to do next**. It is not an IELTS scoring authority, not evidence that LenBands is calibrated, and not a substitute for real learner research or benchmark runs.

The audit is organized as six independent specialist lenses:

1. learner journey and transfer,
2. learning science and retention,
3. scoring and psychometrics,
4. adaptive practice and learner modeling,
5. UX, motivation, and feedback,
6. assessment integrity and governance.

## Authority model

| Class | Meaning | How LenBands may use it |
|---|---|---|
| `external-normative` | Official IELTS format, scoring, and public descriptors | Ground scoring/format claims; never override with a LenBands heuristic |
| `peer-reviewed-evidence` | Research syntheses, meta-analyses, or established measurement work | Inform product/learning policy; still validate in LenBands |
| `lenbands-controlled` | Product/runtime policy | Version, test, observe, and change through governance |
| `experimental-hypothesis` | A plausible but unvalidated optimization | A/B or pilot only; never claim effectiveness before evidence |

## Executive conclusion

The current LenBands design is already strong in four areas: one clear next action, evidence-first feedback, graceful recovery, and retention without dark patterns. It is **not yet fully optimized**. The main missing contracts are:

- a learner model that represents **uncertainty**, not only a point estimate of weakness/mastery;
- a distinction between **item success, skill evidence, transfer, and durable mastery**;
- adaptive selection that balances weakness with **coverage, novelty/exposure, measurement information, review due state, goal relevance, and learner load**;
- mode-specific feedback rules for Learn / Practice / Retest / Exam;
- psychometric validation beyond a single aggregate error metric;
- placement termination and insufficiency rules that prevent a false-precision band estimate.

## 1. Learner journey and transfer

### Current strength

The existing outcome loop `Understand -> Practice -> Retest -> Confirm` is materially better than an activity-completion model.

### Required refinement

For durable IELTS learning, LenBands should reason about this fuller progression:

```text
Diagnose
  -> Understand
  -> Guided Practice
  -> Independent Practice
  -> Retest
  -> Transfer
  -> Maintain
```

`Transfer` means the learner demonstrates the same underlying skill on a **novel item, task, passage, prompt, speaker, or context**, rather than merely succeeding on a repeated item. `Maintain` means the evidence survives an appropriate delay or later authentic task.

### Policy

- A repeated familiar item can confirm recall of that item; it cannot by itself prove general skill mastery.
- A skill state should distinguish `observed_success`, `retest_success`, `transfer_evidence`, and `maintenance_evidence`.
- Readiness should weight independent/transfer evidence more strongly than scaffolded success.
- A scaffolded attempt may drive learning recommendations but must not be treated as equivalent to an exam-mode attempt.

## 2. Learning science and retention

### Retrieval and spacing

LenBands should continue using spaced retrieval for material that can be meaningfully retrieved: vocabulary, collocations, grammar forms, pronunciation targets, and traceable error concepts. Spacing and retrieval practice have broad empirical support, including in second-language learning.

### FSRS boundary

FSRS is a scheduling engine, not a universal mastery model.

- Use FSRS for **review timing** of retrievable knowledge/evidence units.
- Do not infer that a learner has mastered complex Reading, Writing, Listening, or Speaking constructs merely because related cards are mature.
- Complex skill confirmation requires authentic performance and transfer evidence.

### Feedback ladder

Default feedback should minimize cognitive overload while preserving useful information:

```text
Evidence
  -> Meaning / diagnosis
  -> One high-leverage action
  -> Retry / self-explanation
  -> Optional deeper explanation
```

Elaborated feedback is generally more useful than correctness-only feedback, but more feedback is not always better. LenBands should therefore use progressive disclosure and measure whether feedback produces a successful next attempt rather than optimize for feedback length.

### Metacognitive prompts

Use short, context-triggered prompts such as:

- "What evidence in the passage changed your answer?"
- "What will you do differently on the next item?"
- "Which criterion caused the largest loss here?"

Do not show reflection prompts after every interaction. Prompt usefulness must be tested by transfer/retest outcomes and abandonment rate.

## 3. Scoring and psychometrics

### Score identity

LenBands must distinguish these objects:

1. `official_ielts_score` — only an official IELTS result supplied by the learner or an authorized source;
2. `exam_simulation_estimate` — an estimate from a complete LenBands mock under exam-like conditions;
3. `diagnostic_estimate` — an estimate from partial evidence such as placement or a single Writing task;
4. `criterion_evidence` — evidence about a specific rubric criterion or micro-skill;
5. `learning_mastery` — a LenBands learner-model state, not an IELTS band.

They must never be collapsed into one numeric field or shown with identical language.

### Writing boundary

A Writing Task 2 task-level diagnostic estimate is **not** the IELTS Writing section band. IELTS assesses each Writing task independently, and Task 2 contributes more to the Writing score than Task 1. LenBands must preserve `score_scope` and task identity in storage and UI.

### Confidence and uncertainty

- Model confidence is not the probability that a band is correct unless it has been empirically calibrated.
- Runtime may store raw confidence for governance, but learner-facing uncertainty should use validated language such as `limited evidence`, `provisional estimate`, or `higher-confidence estimate` only after policy calibration.
- If evidence is insufficient, return no numeric estimate rather than a fabricated precise band.

### Evaluation benchmark suite

Before promoting a scorer/model/rubric version, the gold-standard benchmark should report at least:

- criterion-level exact agreement;
- criterion-level agreement within `±0.5` band;
- task-level exact agreement and `±0.5` agreement;
- mean/median absolute error as descriptive metrics;
- weighted agreement metric suitable for ordinal bands;
- repeated-run stability for identical inputs;
- error by task/prompt and proficiency region;
- subgroup slices only where sample size and data governance permit meaningful interpretation;
- confidence calibration: whether lower-confidence outputs are actually more error-prone;
- regression versus the currently promoted scorer.

No numeric release threshold in this artifact is active until the founder-approved corpus and evaluation protocol exist.

### Evidence-centered scoring

Automated scoring should preserve an explicit chain:

```text
Construct / rubric claim
  -> observable evidence required
  -> task elicits that evidence
  -> scorer maps evidence to criterion judgment
  -> criterion judgment produces diagnostic estimate
```

The scorer must not infer a criterion band from style proxies that are not evidence for the construct.

## 4. Adaptive practice and learner model

### Learner-state vector

A useful adaptive state is not merely `micro_skill -> mastery`.

At minimum the recommendation layer should be able to reason from:

```yaml
skill_state:
  estimate: number | null
  uncertainty: provisional | moderate | strong | unknown
  evidence_count: integer
  independent_evidence_count: integer
  last_evidence_at: timestamp | null
  transfer_state: none | emerging | demonstrated
  maintenance_state: untested | due | retained | lapsed
  error_recurrence: number
  exposure_count: integer
```

The exact numeric mastery model is an implementation decision and remains experimental until calibrated.

### Action selection objective

Adaptive selection should not repeatedly choose only the currently weakest label. Selection must balance:

- expected learning value;
- evidence uncertainty / diagnostic information;
- syllabus and construct coverage;
- due review;
- goal/exam relevance;
- transfer need;
- item/content exposure and novelty;
- available time and energy;
- recent workload/fatigue;
- cost and latency only after learning-quality guardrails.

This is a multi-objective policy. P0 may remain deterministic, but its rules must preserve these boundaries so a later optimizer does not inherit a weakness-only objective.

### Exploration versus exploitation

- `exploit`: practice a well-supported weakness.
- `explore`: sample under-measured constructs to reduce uncertainty.

A learner should not become trapped in one weakness because the system never samples other skills. Exploration must remain content-balanced and should not increase workload merely to collect data.

### Item exposure

For reusable assessment banks, track exposure so repeated familiarity does not inflate diagnostic confidence. High-exposure items may still be used for learning/review but should be down-weighted or excluded from fresh diagnostic evidence according to versioned policy.

## 5. UX, motivation, and feedback

### Mode-specific feedback contract

| Mode | During attempt | After response/submission | Readiness evidence |
|---|---|---|---|
| `learn` | hints/scaffolds allowed | immediate teaching feedback | weak evidence; never equivalent to exam performance |
| `practice` | learner answers before solution; limited hint policy | evidence -> one fix -> optional detail; retry encouraged | usable diagnostic evidence when unscaffolded |
| `retest` | no answer-revealing scaffold | concise result first, explanation after commitment | stronger evidence when item/context is sufficiently novel |
| `exam/mock` | no hints or formative feedback | feedback only after section/test completion | strongest simulation evidence when integrity conditions hold |

### Trust UI

- Always show **what the estimate represents** before showing precision.
- Prefer "estimated from this task" over a naked "Band 7.0" when scope is partial.
- Give a concise `Why this?` reason for recommendations and one lighter alternative when reasonable.
- Do not expose raw model confidence as a scientific-looking percentage until it has a validated interpretation.

### Progress UI

Progress should prioritize evidence such as:

- error recurrence decreased;
- novel retest succeeded;
- transfer evidence improved;
- estimate uncertainty decreased;
- exam-simulation performance became more stable.

Minutes, streak, question count, and card maturity are supporting activity metrics, not the primary learning outcome.

## 6. Assessment integrity and governance

### Placement

Placement needs a versioned blueprint containing required construct/content coverage. A placement attempt may finish because:

- required coverage and precision policy are satisfied;
- maximum allowed burden is reached;
- the learner stops;
- evidence is invalid/insufficient.

Only the first state may produce the normal configured placement estimate. Reaching a maximum item/time limit does not automatically justify a band estimate; it may terminate as `insufficient_data`.

### Content balancing and adaptive testing

Computer-adaptive assessment is not simply "pick a harder/easier next item". A valid design also needs content balancing, item-selection/information policy, and item-exposure control. Until LenBands has calibrated item parameters and evidence, P0 should prefer an auditable fixed or rule-based blueprint rather than claim CAT-level precision.

### Data leakage and familiarity

- Separate learning items from protected diagnostic/mock pools where practical.
- Track prior exposure to assessment items.
- Do not count an answer as independent transfer evidence if the learner has recently seen the answer/explanation.
- Version items, scoring policy, rubric, prompt, and model so historical estimates remain auditable.

## Required product/runtime changes

### P0 / current branch

1. Placement contract: add evidence coverage, precision/termination reason, and insufficient-data safeguards.
2. Daily-action contract: weakness routing must use independent evidence and must not treat repeated familiarity as repeated proof.
3. Evaluation contract: explicitly scope a score as task-level diagnostic estimate and expand benchmark requirements beyond aggregate MAE.
4. Experience research: define mode-specific feedback and progress evidence as above.

### Later adaptive engine

1. Introduce an uncertainty-aware learner state.
2. Add coverage and exposure control to item/action selection.
3. Separate review scheduling from complex-skill mastery.
4. Validate transfer and maintenance before declaring robust mastery/readiness.

## Measurement plan

| Question | Primary measure | Guardrail |
|---|---|---|
| Does feedback help? | next unscaffolded attempt / retest gain | abandonment, feedback length, latency |
| Is a weakness real? | recurrence across independent items + transfer | exposure/familiarity |
| Is recommendation useful? | completion plus retest/transfer lift | workload and opt-out |
| Is placement useful? | agreement/stability against a validated reference | test burden and content coverage |
| Is scoring trustworthy? | benchmark agreement + stability + calibration | subgroup degradation and invalid-result rate |
| Is review working? | delayed recall / transfer where applicable | review overload |

## Research inputs

### Official / normative IELTS

- IELTS scoring in detail: https://ielts.org/take-a-test/your-results/ielts-scoring-in-detail
- IELTS Writing resources: https://ielts.org/take-a-test/preparation-resources/writing-test-resources
- IELTS research on preparation practices: https://ielts.org/researchers/our-research/research-reports/investigating-test-preparation-practices-reducing-risks

### Learning science

- Carpenter, Pan & Butler, *The science of effective learning with spacing and retrieval practice*, Nature Reviews Psychology (2022): https://doi.org/10.1038/s44159-022-00089-1
- Kim & Webb, *The effects of spaced practice on second language learning: A meta-analysis*, Language Learning (2022): https://doi.org/10.1111/lang.12479
- Wisniewski, Zierer & Hattie, *The Power of Feedback Revisited*, Frontiers in Psychology (2020): https://doi.org/10.3389/fpsyg.2019.03087
- Van der Kleij, Feskens & Eggen, *Effects of Feedback in a Computer-Based Learning Environment*, Review of Educational Research (2015): https://doi.org/10.3102/0034654314564881
- Meta-analysis of metacognitive prompts in technology-enhanced learning: https://doi.org/10.1111/jcal.12650

### Adaptive assessment / automated scoring

- Shin, *Item selection methods for computerized adaptive testing*, Journal of Educational Evaluation for Health Professions (2018): https://doi.org/10.3352/jeehp.2018.15.7
- ETS / evidence-centered design for automated scoring and assessment validity: https://doi.org/10.1111/jedm.12332
- Recent empirical study of LLM automated essay scoring reliability/validity in ELL writing: https://doi.org/10.1016/j.caeai.2024.100234
- Automated essay scoring accuracy/fairness/generalizability trade-offs: https://doi.org/10.1609/aaai.v38i20.30254

## Evidence boundary

Research outside LenBands can justify a design hypothesis; it cannot prove the design works for LenBands learners. Promotion requires repository evidence: benchmark runs, pilot outcomes, usability sessions, or controlled experiments stored under the existing evidence/governance contracts.
