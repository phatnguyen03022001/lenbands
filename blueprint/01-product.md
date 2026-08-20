# 01 — Product

This file owns **WHY / WHO / WHAT**. Implementation belongs to Architecture/Engines/contracts.

## Vision

LenBands is an **evidence-first IELTS Learning OS** designed to help a learner:

- define the real IELTS target and constraints;
- know what current evidence supports rather than confuse activity with ability;
- distinguish English-foundation gaps, IELTS-technique gaps, integrated-performance gaps and missing evidence;
- receive one smallest useful next action instead of navigating a feature catalog;
- verify improvement through independent retest, transfer and maintenance evidence;
- know when the evidence supports readiness and when current constraints make the target plan risky or insufficient.

LenBands is not merely an LMS, quiz app, content library, AI tutor, AI scoring wrapper or streak system.

The durable product loop is:

```text
Target
  -> Evidence
  -> Feasibility + supported gap/cause
  -> ONE smallest useful intervention
  -> Independent practice
  -> Novel retest
  -> Transfer / maintenance
  -> Readiness update
  -> Next highest-value target gap
```

## Target users

- IELTS learners from early foundation through advanced target preparation;
- learners who need a clear answer to "what should I do today and why?";
- learners whose blocker may be English foundation, IELTS technique, integrated performance, or simply missing evidence;
- learners with a target overall band, per-skill minimums, exam date and limited study capacity;
- learners who need honest readiness guidance rather than fabricated certainty.

## Core value

LenBands should answer five learner questions better than a pile of courses, videos, AI prompts and practice apps:

1. What is my target?
2. Where does the evidence say I am now?
3. What is actually holding me back?
4. What one thing should I do next?
5. What evidence will prove that it worked?

Internal complexity is allowed only when it improves these answers. The learner must not be required to understand the internal capability graph, evidence graph, taxonomy, scorer routes, provider stack or governance model.

## Product positioning

**Evidence-first IELTS Learning OS — one target-aware path from diagnosis to verified improvement.**

The intended moat is:

```text
TargetProfile
  + governed learner evidence
  + diagnosis cause
  + curriculum coverage
  + intervention/retest mapping
  + readiness policy
```

A competitor using the same model provider must not automatically reproduce LenBands learner state, remediation policy or readiness semantics.

## Product principles

1. **Evidence-first.** Readiness and learner state come from governed evidence; completion, model confidence, card maturity or familiar-item success are not mastery by themselves.
2. **Deterministic-first.** Rules, typed data, controlled vocabulary, answer keys, SQL, schedulers and explicit policies are preferred whenever they meet the quality contract.
3. **One clear next step.** Primary learner surfaces expose one action, one reason and one verification rule, plus at most one lighter alternative.
4. **Cause before intervention.** Supported English-foundation, IELTS-technique and integrated-performance blockers route differently. Missing evidence remains missing evidence.
5. **Minimum sufficient challenge.** Harder/higher-band material is not automatically better. Route above the current/target level only when prerequisite, exam authenticity or transfer policy requires it.
6. **Curriculum sufficiency before recommendation.** Do not recommend a gap when no governed intervention + independent verification/retest path exists; report a content gap instead.
7. **Automated evaluation + governance.** Learner-facing evaluation is automated without runtime human dependency, but scorer quality requires benchmark/release evidence.
8. **AI is not a role or authority.** Models/speech services produce bounded observations/candidate judgments; domain contracts decide what becomes truth.
9. **No false precision.** Insufficient evidence returns insufficient evidence; unvalidated probabilities/hours-to-band estimates are prohibited.
10. **Progress over pressure.** Retention follows real progress, not streak anxiety, notification pressure or dark patterns.
11. **Outcome loop.** Meaningful weakness/error should move through Understand → Practice → Independent Retest → Transfer when the construct permits it.
12. **Quality/cost guardrail.** Optimize cost per verified improvement while preserving quality, accessibility, privacy and learner trust.
13. **SSOT.** Each semantic concern has one canonical owner; projections/AI outputs do not become competing truth.

## Learner outcome contract

LenBands may promise the **quality of the learning process**. It must not promise a specific future official IELTS band merely because the learner follows the plan.

### Process guarantee

For an activated learner path, LenBands must guarantee by product contract that:

- every primary action is tied to a target, admitted evidence, due review/retest or explicit evidence gap;
- a missing observation is never silently called a weakness;
- a supported weakness is classified into an intervention-changing cause where evidence permits;
- advanced/beyond-target content is not selected without explicit pedagogical/assessment justification;
- a recommended intervention has a governed verification path, or the system reports `content_gap`;
- completing learning activity alone cannot increase readiness/mastery;
- repeated/revealed content alone cannot count as independent transfer;
- learner work is preserved through governed recovery when the system/provider fails;
- target feasibility/readiness copy communicates uncertainty and blockers honestly;
- provider/model output never directly grants score truth, entitlement or readiness.

### Outcome honesty boundary

LenBands must **not** claim:

- "Follow this plan and you will get Band X.";
- a probability of official-band attainment without validated probabilistic calibration;
- a universal number of study hours/weeks required to gain a band;
- that `target_met` readiness equals an official IELTS result;
- that one task/partial diagnostic equals a full skill/overall score.

A future attainment-effectiveness claim requires governed cohort/outcome evidence, a defined population, target conditions, confidence/limitations and approval through the evidence/release policy.

## Target feasibility

Target feasibility is a planning state, not an exam prediction.

```text
insufficient_evidence
on_track
at_risk
current_constraints_insufficient
target_met
```

It may reason from target, admitted evidence, exam date, declared study capacity, recent adherence and available curriculum/retest coverage.

It may not invent an attainment probability.

When current constraints are insufficient, the product should surface one actionable decision at a time: more study capacity, later exam date, changed target/minimum, or another evidence-backed constraint change. It should not present an impossible-looking ordinary daily plan.

## Role model

Web personas:

- Guest;
- Learner;
- Premium Learner = learner + entitlement;
- Colab;
- Admin.

Automated evaluation/recommendation/speech systems are not personas.

Role boundaries:

- Learner owns their learning data and actions under product policy.
- Colab manages content author/review/publish permissions and never scores learner work.
- Admin operates accounts/configuration/billing/release/governance and never manually overwrites learner evaluation results.
- Internal service principals are function-scoped.
- Model/provider credentials confer no LenBands business authority.

## Scope

### In scope

- TargetProfile: module, overall target, optional per-skill minima, target date, purpose/study constraints.
- Placement/diagnosis with evidence coverage and insufficient-evidence behavior.
- Foundation-vs-technique-vs-integrated-performance diagnosis where evidence supports it.
- Target feasibility and plan-risk state.
- One-action study orchestration.
- Learning/practice/evaluation/review across activated IELTS skills by phase.
- Writing/Speaking/Pronunciation automated evaluation under governed score scope.
- Deterministic objective Listening/Reading scoring where answer keys suffice.
- Error → remediation → review when appropriate → novel retest → transfer.
- Curriculum/content rights, coverage and exposure control.
- Evidence-based Band/Exam Readiness when the activated phase has sufficient evidence.
- Healthy retention, comeback and time/energy adaptation.
- Privacy/export/delete, accessibility, recovery and governance.

### Out of scope

- live classes and real-time 1:1 video tutoring;
- runtime human examiner dependency for learner-facing scoring;
- manual score overwrite;
- guaranteed official-band attainment from plan adherence;
- unvalidated probability/time-to-band claims;
- complex community/forum or marketplace unrelated to the learning outcome;
- heavy leaderboard/avatar/badge gamification;
- model/provider/prompt/agent as curriculum/readiness authority.

## Score/evidence boundary

Always distinguish:

- official IELTS result;
- LenBands exam-simulation estimate;
- partial/task diagnostic estimate;
- criterion/micro-skill evidence;
- learner-model/readiness state.

A task-level result never becomes an official skill score by presentation alone.

Learner-facing evaluation must preserve score scope, result validity, rubric/task/scorer-route provenance and admissible evidence. Provider/model execution identity belongs to governed audit/runtime provenance when applicable, not generated-output authority.

## Minimal learner path

The primary product should feel like this, regardless of how many internal capabilities exist:

```text
Set target
  -> collect minimum evidence
  -> see target status
  -> see one supported blocker/cause
  -> do one useful action
  -> verify on independent evidence
  -> update readiness
  -> repeat only while another target gap remains
```

The learner should not need to decide between "Lesson / Smart Queue / Insights / Recommendation / Band Map / Practice / Review" before the system produces the next action.

## Product success contract

### North Star

**Weekly Verified Progress** — active learners who produce governed evidence of meaningful improvement such as lower independent error recurrence, successful novel retest, transfer/maintenance evidence, reduced uncertainty or improved comparable scoped performance.

### Metric tree

| Layer | Metric | Guardrail |
|---|---|---|
| Activation | first target-aware useful action | onboarding burden |
| Diagnosis | useful cause/evidence-gap classification | false weakness/cause rate |
| First value | time to useful diagnosis/action/feedback | correctness before superficial speed |
| Retention | D7/W4 meaningful study, comeback quality | no notification/streak coercion |
| Learning | independent retest/transfer/maintenance gain | no activity-only proxy |
| Target planning | feasibility blockers resolved appropriately | no guaranteed-band/false probability |
| Trust/quality | benchmark agreement, invalid/limited-evidence rate, helpfulness | explicit uncertainty/recovery |
| Economics | cost/active learner, cost/evaluation, cost/verified improvement | optional depth degrades before integrity |

### Future attainment evidence

Track official-result outcomes only with provenance/consent and valid comparison design. If enough evidence later supports an effectiveness statement, the claim must identify:

- cohort/population;
- starting evidence range;
- target definition;
- study/adherence definition;
- observation window;
- attrition/missing-data treatment;
- uncertainty/limitations;
- whether the outcome is association or causal evidence.

Until then, the product promises a governed process and evidence-based readiness, not guaranteed official results.

## Retention promise

Every return should answer:

- where am I relative to my target?;
- what should I do now?;
- why this?;
- how will we verify it?;
- what changed after I did it?

Provide short sessions when needed, standard depth otherwise, and comeback without backlog dumping/guilt.

## Quality promise

- feedback states evidence → meaning/cause → one action → verification;
- every score/result preserves scope/validity/provenance;
- invalid/insufficient/integrity-review evidence does not silently promote readiness;
- recommendation does not outrun curriculum/retest coverage;
- challenge level does not outrun learner prerequisites/target without explicit justification;
- raw model confidence is not presented as scientific learner certainty.

## Cost principles

- deterministic computation first;
- precompute reusable curriculum/explanation/mappings;
- bounded model context;
- stronger/specialist inference only when benchmark evidence justifies it;
- no expensive generation merely to create extra plan alternatives;
- measure cost against verified learner outcome.

## Runtime contract boundary

- Architecture owns system/runtime boundaries.
- Capability Catalog owns capability identity.
- Experience owns learner journey/compression.
- Content owns curriculum sufficiency/rights/exposure.
- Engines own deterministic recommendation/evaluation mechanisms.
- API/runtime contracts own executable semantics.
- Risk/evidence/release artifacts own verification/claim eligibility.

No role, UI click, provider response, prompt or exception text may substitute for these contracts.
