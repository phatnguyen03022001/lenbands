# IELTS AI-first Knowledge OS — Blueprint

This is the product Single Source of Truth (SSOT), organized as a **9-file hub-and-spoke architecture**, where each file owns exactly one concern and dependencies are almost entirely one-way.

The Blueprint is the **invariant-definition layer**. It answers why the product exists, which capabilities it has, which behaviors must not be broken, and which quality/cost/legal guardrails must be preserved. The Blueprint is not a backlog, wireframe, OpenAPI specification, or implementation plan.

## Purpose

Model an IELTS learning application as an **AI-first Knowledge OS**: not an LMS that stores lessons, not a quiz app, but a system that helps the learner understand the full IELTS blueprint, know where they are, identify what is missing, and determine what to learn next.

## Repository Constitution

1. **Blueprint defines invariants.** Blueprint is the SSOT for durable product principles and contracts.
2. **Artifact records decisions, evidence and indexes.** Artifacts do not become a mutable learner-serving content source.
3. **Knowledge Asset is the canonical, versioned knowledge object.** Every asset has an `asset_id`, manifest, provenance, and explicit lifecycle.
4. **Only pipelines/agents create or transform Knowledge Assets. Evidence is immutable.** A pipeline/agent must record each transformation; evidence is never overwritten and is instead represented by a new version/snapshot.

Repository structure is defined in `../README.md`. Dependencies use stable IDs and flow downward only; no layer reads or mutates the source of a higher layer.

## Blueprint contract

All new material must belong to exactly one concern in the eight spokes below; this README is the hub and governance layer, forming a nine-file set:

| File | Must define | Must not define |
|---|---|---|
| `01-product.md` | Vision, user, value, scope, success, product guardrails | Screen/API/data schema |
| `02-architecture.md` | Domain, boundary, planes, runtime state, technology boundary | Capability detail/backlog |
| `03-features.md` | Capability catalog, stable IDs, event contract | UI layout, implementation code |
| `04-experience.md` | Experience principles, journeys, UX behavior invariants | CSS/component code |
| `05-content.md` | Knowledge model, taxonomy, content quality/publish rules | Learner runtime content files |
| `06-engines.md` | Engine contracts, failure, evaluation/governance/cost invariants | Provider-specific code |
| `07-conventions.md` | Naming, privacy, accessibility, localization, cross-cutting rules | One-off feature decisions |
| `08-roadmap.md` | Phase, priority, release/deprecation policy | Detailed build specification |

### Blueprint capability readiness

A capability is considered a `build candidate` only when it has:

```yaml
capability_id: DOMAIN.Capability
user_outcome:
owner:
phase:
dependencies: []
primary_events: []
quality_gate:
cost_budget:
fallback:
privacy_class: account | learning | assessment | audio | billing | system | derived
```

These fields are the minimum contract; detailed screen/API/data/failure definitions belong in an Artifact build-ready spec.

### Blueprint change rule

- Blueprint changes when an invariant, scope, capability, or guardrail changes.
- Concrete implementation decisions belong in Artifacts; do not turn the Blueprint into an implementation-detail store.
- Roadmap can change without changing capability identity.
- Each capability has exactly one canonical description in `03-features.md`; other spokes reference it by ID.

## Cross-cutting principles

1. **Blueprint structured, not a lesson list** — IELTS is modeled as a structured domain; band progression is a soft recommendation and does not hard-lock access.
2. **Sole evaluator + governance** — the entire evaluation layer is handled 100% by AI, with no human in the loop; AI Governance is an invisible backend control target, not a quality guarantee until real corpus/threshold/run evidence exists.
3. **No-AI-label UI** — documentation may use the term "AI" on capabilities so developers understand their origin; the user interface does not display the word "AI" or an AI icon and instead uses plain functional names.
4. **Progress over pressure** — retention comes from visible progress, appropriately sized study sessions, and a respectful return path; the product does not use guilt, streak loss, or notification spam for retention.
5. **Trustworthy outcomes** — every piece of feedback must be explainable, lead to a concrete action, and include a way to verify improvement; the system surfaces appropriate status, limitations, and confidence.
6. **Cost-aware by design** — every AI capability has a model tier, budget, quota, cache strategy, and fallback; minimum quality is protected before cost optimization.
7. **Fixed tech stack** — Backend: **Go**, Engine/AI/Data: **Python**, Frontend: **Next.js**. See `02-architecture.md` § Technology Stack for details and boundaries. Every generated artifact must use this stack.

## Document Map

| File | Concern | Artifact type AI will generate |
|---|---|---|
| `README.md` (this file) | HUB: index, glossary, principles | — (entry point) |
| `01-product.md` | WHY / WHO / WHAT: vision, role, scope, boundaries | Product brief |
| `02-architecture.md` | Domain Map, Capability Layer, System Boundary, Skill Modeling, Runtime State Model | System architecture |
| `03-features.md` | Capability Catalog, Event Contract (Learner / Content / Admin) anchored by capability ID | Entity, API, data model, analytics schema |
| `04-experience.md` | 8 User Journeys, Home, UX Principles, Delight, Empty State | UI screen, component, workflow |
| `05-content.md` | Knowledge System: Assets, Taxonomy, Tagging, Question Bank, Colab Workflow | Content schema, tagging model |
| `framework/` (child spoke of 05) | IELTS Knowledge Framework: band descriptor, question type, micro-skill, error taxonomy, grammar/vocab band, speaking parts, writing task, exam module differences | IELTS domain generation (hallucination guard) |
| `06-engines.md` | Learning Engine: FSRS, Evaluation, Recommendation, Failure Contract, Governance, Quality & Cost | Algorithms, runtime errors, routing, calibration pipeline |
| `07-conventions.md` | UI Naming, Icon, Accessibility, Localization, Data Privacy | Design system, convention |
| `08-roadmap.md` | P0/P1/P2, MVP, Version, Release, Deprecation | Sprint backlog, phasing |

## Reading Order

```
README (this file)
   │
   ▼
01 Product  ──WHY/WHO/WHAT──
   │
   ▼
02 Architecture  ──domain/capability layer──
   │
   ▼
03 Features  ──capability catalog + capability id──
   │
   ┌────┴────┐
   ▼         ▼
04 UX     05 Content   ← use capability IDs as anchors; do not duplicate descriptions
   │         │
   └────┬────┘
        ▼
06 Engines  ──provide algorithms for Features (FSRS, Evaluation, Recommendation, Governance)
   │
   ▼
07 Conventions  ──apply rules across all files above
   │
   ▼
08 Roadmap  ──reads all prior layers for phasing
```

Dependencies are almost entirely one-way. A spoke must not depend backward on a preceding spoke (trivial back-references are acceptable).

## Capability ID schema

Every capability has a unique ID in the form `{DOMAIN}.{Capability}`, used as the cross-spoke reference anchor, especially in `04-experience.md` and `06-engines.md`:

- `EVAL.Writing` — Writing Evaluation
- `EVAL.Speaking` — Speaking Evaluation
- `EVAL.Pronunciation` — Pronunciation Evaluation
- `EVAL.Examiner` — Examiner (interactive dialogue)
- `EVAL.BandPrediction`
- `EVAL.RewriteSuggestion`
- `EVAL.AntiGaming`
- `COACH.AnswerExplanation`
- `COACH.VocabularyExplanation`
- `COACH.DistractorExplanation`
- `COACH.ListeningCoach`
- `COACH.ReadingCoach`
- `COACH.ErrorAnalysis`
- `COACH.Recommendation`
- `COACH.Tutor` — IELTS Q&A, context-aware
- `LEARN.Listening`, `LEARN.Reading`, `LEARN.Writing`, `LEARN.Speaking`, `LEARN.Pronunciation`
- `PRACTICE.Drill`, `PRACTICE.Adaptive`, `PRACTICE.MockTest`, `PRACTICE.ExamSimulation`
- `REVIEW.SmartQueue`, `REVIEW.MistakeNotebook`, `REVIEW.FSRS`
- `PERSONAL.Insights`, `PERSONAL.NextBestAction`, `PERSONAL.GapAnalysis`
- `BAND.Map`, `BAND.Readiness`, `BAND.ExamReadiness`, `BAND.Checklist`, `BAND.Requirement`
- `STUDY.Session`, `STUDY.DailyPlan`, `STUDY.TodayQueue`
- `PKM.Notes`, `PKM.WordBank`, `PKM.Collections`, `PKM.Import`, `PKM.Export`, `PKM.Offline`
- `GOVERNANCE.ConfidenceScore`, `GOVERNANCE.GoldStandardBenchmark`, `GOVERNANCE.DriftDetection`, `GOVERNANCE.AntiGaming`
- `OPS.ContentQuality`, `OPS.EvaluationQuality`, `OPS.ReleaseGate`, `OPS.OutcomeMeasurement`, `OPS.ModelRouting`, `OPS.CostBudget`, `OPS.Quota`, `OPS.Observability`
- `CONTENT.Publish`, `CONTENT.Moderation`, `CONTENT.Feedback`

The complete list is in `03-features.md`.

## Quality bar (Definition of 10/10)

The Blueprint is considered complete only when all four layers below are satisfied:

| Layer | Required outcome | Primary metrics |
|---|---|---|
| Value | Learner receives a diagnosis and one useful action in the first session | time-to-first-value, activation rate |
| Retention | Learner returns because progress is visible and sessions fit available energy/time | D7/W4 retention, meaningful study days, comeback rate |
| Learning quality | Feedback is correct, understandable, actionable, and verifiable | outcome lift, error recurrence, calibration error, content report rate |
| Economics | Cost per useful outcome stays within budget | cost/active learner, cost/evaluation, cache hit rate, fallback rate |

New capabilities must specify owner, phase, dependency, quality gate, cost budget, and measurement event. Without these, a capability is only an idea, not a build contract.

## Glossary

- **Knowledge OS** — a knowledge operating system: models a domain (IELTS) structurally so users know where they are, what they are missing, and what to learn next.
- **Sole evaluator** — AI is the only scoring source, with no human in the loop; backend governance is a control mechanism that must be demonstrated with real corpus, thresholds, and runs.
- **AI Governance** — invisible backend controls (confidence scoring, gold-standard benchmark, drift/bias monitoring, anti-gaming), not human review.
- **Capability id** — the unique identifier for a system capability, in the form `{DOMAIN}.{Capability}`, used as a cross-reference anchor.
- **Colab** — the content-operator role that adds, moderates, and publishes content; it never scores learner work.
- **FSRS** — Free Spaced Repetition Scheduler, the system's primary spaced-repetition algorithm (see `06-engines.md`).
- **Band Readiness** — readiness at a given band, used as a soft recommendation rather than a hard lock.
- **Exam Readiness** — readiness for the real exam (overall + per-skill + confidence + risk).
- **Smart Review Queue** — views over the FSRS queue (Today's, Priority, Weak Skill, Exam Queue).
- **Personal Knowledge (PKM)** — the learner's personal knowledge store (notes, word bank, collections, drafts, recordings), distinct from system Knowledge Assets published by Colab.
- **Runtime State Model** — the learner's multidimensional state vector: lifecycle, learning, session, evaluation, and goal; it is the SSOT for Home, recommendation, notification, and recovery.
- **Event Contract** — a versioned invariant schema for product/learning facts; it is the SSOT for analytics, recommendation, dashboard, and experimentation.
- **Failure Contract** — the standard taxonomy and response contract for runtime failures: retry, fallback, data safety, quota, UI state, and telemetry.

## Cross-references

- Roles and boundaries → `01-product.md` § Role Model
- Domain and capability layer → `02-architecture.md`
- Capability details → `03-features.md`
- Emotion and journeys → `04-experience.md`
- Content workflow and taxonomy → `05-content.md`
- Engine algorithms → `06-engines.md`
- Naming / a11y / localization conventions → `07-conventions.md`
- Phasing and roadmap → `08-roadmap.md`
- Quality, retention, and cost guardrails → `01-product.md`, `04-experience.md`, `06-engines.md`, `08-roadmap.md`
- Runtime contracts → `02-architecture.md` § Runtime State Model, `03-features.md` § Event Contract, `06-engines.md` § Failure Contract
