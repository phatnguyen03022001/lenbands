# ADR-0002 — Sole Evaluator and AI Governance

- **Status:** review
- **Date:** 2026-08-06
- **Owner:** Founder
- **Related Blueprint:** `01-product.md`, `03-features.md` (`EVAL.*`, `GOVERNANCE.*`), `06-engines.md`

## Context

LenBands needs scalable learner feedback/evaluation without presenting it as an official exam score or opaque score. A human-examiner workflow increases cost, latency, and complexity and is not suitable for a solo-founder MVP.

## Decision

- AI is the sole evaluator for learner-facing Writing/Speaking/Pronunciation evaluation.
- A governance layer is required: rubric version, evidence reference, confidence state, benchmark regression, drift/anti-gaming monitoring, and audit trail.
- A human does not override the learner score in the runtime flow.
- `low_confidence`, `insufficient_evidence`, `invalid`, and `anti_gaming_review` must not act as strong signals for readiness/recommendation.
- The learner sees the disclaimer, evidence, and recovery/action; raw model/provider internals remain hidden.

## Alternatives

| Alternative | Not selected because |
|---|---|
| Human-in-the-loop scoring | Not suitable for MVP cost/latency/scale; creates a workflow outside the product loop |
| Model score without governance | Insufficient trust, audit, or regression control |
| Provide only a rewrite, no score | Does not address diagnosis/readiness needs |

## Consequences

- An Evaluation Contract, benchmark spec, release gate, and cost budget are required before the public pilot.
- Do not market the output as an official IELTS score.
- Quality failure may block release; do not conceal it with UI copy.

## Review trigger

Review if the quality benchmark is not met, regulatory requirements change, or human review becomes a requirement supported by outcome/cost evidence.
