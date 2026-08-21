# Product and Requirements Decisions

STATUS: SUPPORTING
ROLE: FOUNDER DECISION HISTORY
AUTHORITY: NONE

This file preserves the 45 founder decisions from V9 and 10A. It describes product direction and construct-to-requirement semantics; current canonical Blueprint/contracts remain authoritative.

## V9 — Product and runtime architecture

| ID | Decision | Rationale |
|---|---|---|
| V9.1 | Today-first home (`D`). | The system should answer “what should I do today?” instead of forcing learners to browse a library. |
| V9.2 | IELTS Skills + Supporting Skills (`C`). | Keep exam skills distinct from Vocabulary/Grammar/Pronunciation without leaking backend ontology. |
| V9.3 | Practice by training goal (`C`). | Learners choose what to improve, not navigate a database schema. |
| V9.4 | Listening = task practice + micro-skill drills + enrichment (`C`). | Combine exam familiarity, targeted remediation and broader listening development. |
| V9.5 | Listening audio hybrid TTS + human/curated high-value assets (`C`). | Use scalable audio generation without making all benchmark/high-value content synthetic. |
| V9.6 | Listening feedback = evidence segment + explanation + diagnosis + retry (`C`). | Wrong/right alone does not close the learning loop. |
| V9.7 | Reading progression micro → short → full → timed (`C`). | Build capability before demanding full exam performance. |
| V9.8 | Cover canonical task families in priority waves (`C`). | Model full construct while releasing production coverage honestly. |
| V9.9 | N:M evidence attribution (`C`). | One response can inform several capabilities; task label alone is too coarse. |
| V9.10 | Writing progresses sentence/paragraph/components → full essay (`C`). | Target isolated production gaps before integrated performance. |
| V9.11 | Progressive criterion feedback + priorities/evidence/drills (`C`). | Feedback must lead to action rather than a static AI report. |
| V9.12 | Targeted rewrite → paragraph/full rewrite loop (`C`). | Use feedback to create new production, not passive reading. |
| V9.13 | Speaking progresses Part 1/2/3 + supporting drills → full mock (`C`). | Do not make full mock the primary learning mechanism. |
| V9.14 | Record/replay/download; temporary server audio; persist result/evidence (`C`). | Preserve learner control and data minimization. |
| V9.15 | Pronunciation target indicators; numeric only after calibration (`C`). | Avoid pseudo-precision and accidental IELTS-band implication. |
| V9.16 | Vocabulary graph Lexeme → Sense → Collocation → Usage → Context → Recognition/Production (`C`). | Band/topic are views over language knowledge, not the ontology root. |
| V9.17 | Grammar = structured curriculum + error-driven + skill-context practice (`C`). | Combine systematic coverage with learner-specific remediation and transfer. |
| V9.18 | Progressive diagnostic / provisional profile (`C`). | A short first test cannot truthfully know the entire learner. |
| V9.19 | Task → section → skill → full mock hierarchy (`C`). | Provide assessment granularity between practice and full IELTS. |
| V9.20 | Practice performance separate from IELTS estimate (`C`). | Prevent small practice sets from masquerading as official band estimates. |
| V9.21 | Mastery represented as evidence/context-derived estimate (`D`, refined). | Competency is learned object; evidence supports an uncertain, versioned estimate. |
| V9.22 | Mastery is time/evidence-sensitive; no fixed decay formula (`B`). | Forgetting/staleness matters, but coefficients require data. |
| V9.23 | Daily Plan uses target gap + weakness + due review + available time + prerequisites (`D`). | Plan should allocate effort to the best current learning need under real constraints. |
| V9.24 | Strong recommendation with Swap/Skip/Shorten/Change-skill control (`C`). | Preserve learner agency without turning planner into decoration. |
| V9.25 | Progress is action-first; band/skill charts secondary (`D`). | Learner needs target → gap → priority → next action more than pseudo-analytics. |
| V9.26 | Gentle consistency; no punitive streak (`C`). | Support adherence without turning missed days into punishment. |
| V9.27 | Typed review by learning/evidence type (`C`). | Vocabulary, grammar, reading misconceptions, writing issues and speech issues need different review mechanisms. |
| V9.28 | Free includes a real learning loop (`C`). | Free must demonstrate product value, not merely sample content. |
| V9.29 | Premium sells depth/personalization/assessment/analytics, not AI tokens (`C`). | Protect product identity as a learning system instead of AI wrapper. |
| V9.30 | North Star = Adaptive IELTS Learning System (`C`). | All prior decisions converge on a closed evidence-driven learning loop. |

## 10A — Construct to performance requirements

| ID | Decision | Rationale |
|---|---|---|
| 10A.1 | Model Academic + General Training; initial release may be Academic-first. | Avoid hard-coding Academic into the domain while keeping launch scope realistic. |
| 10A.2 | TargetProfile is a constraint profile, not one overall band. | Real targets may require overall + minimum skill constraints. |
| 10A.3 | Model full band scale; support/coverage released honestly in waves. | Semantic representation should not pretend uncovered bands are production-supported. |
| 10A.4 | Listening/Reading requirements derive from stated abilities + task contexts. | Task-family names are formats, not automatically capabilities. |
| 10A.5 | Task family is not a competency by default. | Prevent ontology from mirroring exam UI rather than learnable capability. |
| 10A.6 | Writing criterion → observable performance requirements, scoped by Task 1/2. | Criteria are assessment dimensions; curriculum needs observable behaviors underneath. |
| 10A.7 | Speaking criterion × Part performance demands. | Part is elicitation context, criterion is assessment dimension, competency is derived later. |
| 10A.8 | Timing is a context condition only when construct requires it. | Do not manufacture time pressure for knowledge acquisition. |
| 10A.9 | Independent/unsupported performance required when target claim requires independence. | Guided success must not equal readiness. |
| 10A.10 | Same-item retry = recovery/learning; readiness/generalisation needs appropriate re-evidence. | Prevent memorized correction from becoming transfer evidence. |
| 10A.11 | Receptive readiness not inferred directly from practice % correct. | Correctness alone lacks context/coverage/independence/transfer semantics. |
| 10A.12 | Overall readiness derives from TargetProfile constraints + skill evidence, not average mastery numbers. | Respect skill minima and scoped evidence. |
| 10A.13 | Requirement granularity = smallest operationally useful unit. | Avoid both criterion-level coarseness and atomic-node explosion. |
| 10A.14 | Public band descriptors are construct evidence, not curriculum truth. | IELTS defines performance; LenBands designs learning progression. |
| 10A.15 | Every performance requirement has provenance + interpretation/validation status. | Separate direct source claims from LenBands derivation/hypothesis. |

## Durable product boundaries

These summaries aid navigation only:

```text
construct evidence → performance requirement → competency/behaviour/context
```

```text
practice result ≠ IELTS estimate
activity completion ≠ mastery
short diagnostic ≠ complete learner truth
```

Original source: `artifacts/operations/decisions/lenbands-decision-register-v1.0.0-founder-locked-2026-08-12.md`.