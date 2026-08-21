# Architecture and Governance Decisions

STATUS: SUPPORTING
ROLE: REPOSITORY DECISION HISTORY
AUTHORITY: NONE

This file normalizes explicit repository ADRs that define architecture/governance direction. Original ADR status is preserved; a `review` ADR is not silently promoted to `approved` here.

## ADR-0001 — Repository and runtime planes

**Original status:** `approved`  
**Date:** 2026-08-06  
**Owner:** Founder

### Decision

LenBands separates three logical planes by responsibility and lifecycle:

| Plane | Canonical object | Purpose |
|---|---|---|
| Governance & Knowledge | Blueprint, Artifact, Knowledge Asset | Product rules, decisions, evidence, and canonical knowledge |
| Implementation | Source Code, Infrastructure-as-Code | Implement contracts and deploy the system |
| Runtime | Runtime Data, storage, queue, cache, analytics | Operate personal data and state while the system runs |

Core rules:

- each object has one canonical owner plane;
- projections/generated/deployment copies retain source reference, version and provenance;
- no lower plane mutates the source of a higher plane;
- stable IDs cross boundaries; relative file paths are not runtime contracts;
- learner essays, recordings, attempts, evaluation results and billing state are Runtime Data, not Knowledge Assets;
- canonical lessons/questions/rubric/taxonomy/templates/strategies are Knowledge Assets when versioned/canonical;
- evidence is append-only.

**Source:** `artifacts/engineering/decisions/ADR-0001-repository-and-runtime-planes.md`.

## ADR-0002 — Sole evaluator and AI governance

**Original status:** `review`  
**Date:** 2026-08-06  
**Owner:** Founder

### Decision

- AI is the sole evaluator for learner-facing Writing/Speaking/Pronunciation evaluation in this reviewed direction.
- Evaluation requires governance: rubric version, evidence reference, confidence state, benchmark regression, drift/anti-gaming monitoring and audit trail.
- A human does not override the learner score in the runtime flow.
- `low_confidence`, `insufficient_evidence`, `invalid`, and `anti_gaming_review` must not act as strong readiness/recommendation signals.
- Learner-facing output shows disclaimer, evidence and recovery/action while raw provider/model internals remain hidden.

### Status interpretation

This ADR is preserved as a **review-state decision**, not an approved production claim. Its own review trigger requires reconsideration when quality benchmarks fail, regulation changes, or human review becomes evidence-backed necessary.

**Source:** `artifacts/operations/decisions/ADR-0002-sole-evaluator-and-governance.md`.

## ADR-0003 — Platform boundary and managed infrastructure

**Original status:** `review`  
**Date:** 2026-08-06

### Historical direction

- Next.js frontend;
- Go synchronous orchestration/API;
- Python asynchronous evaluation/data/quality workload;
- Postgres relational authority;
- Redis Streams as the then-proposed P0 job/cache boundary;
- S3-compatible managed object storage;
- managed auth/payment/email/observability/analytics/runtime infrastructure;
- Kafka, self-hosted model serving, dedicated vector DB and multi-region outside P0;
- provider-neutral domain model and adapters.

### Supersession

This ADR is **historically important but partially superseded for new design work**:

- founder V7 later selected **Postgres outbox first / no initial Redis**;
- ADR-0004 removed Go/Python/Redis/worker/broker/cache as pre-authorized product architecture;
- `platform-sourcing.md` later replaced the provider-sprawl baseline with a consolidated buy-first candidate.

The durable principle that survives is managed commodity infrastructure behind provider-neutral semantic boundaries and exit paths.

**Source:** `artifacts/engineering/decisions/ADR-0003-platform-boundary-and-managed-infrastructure.md`.

## ADR-0004 — Composition-first application platform

**Original status:** `review`

### Decision

LenBands uses a managed, composition-first, provider-neutral application architecture. Product/domain semantics stay with Blueprint and canonical contracts. Commodity hosting, identity, relational storage, object storage, durable execution, observability, analytics, billing, email and model access are bought/managed by default through thin adapters.

Explicit non-preselection:

- no automatic Go production service;
- no automatic Python production worker/service;
- no Redis/Kafka requirement;
- no self-managed worker fleet/broker/cache/cloud VPC;
- no custom auth/analytics/workflow/model-serving fleet without evidence-backed need.

A custom runtime component requires a reviewed decision proving:

1. measured/contractual blocker;
2. why managed baseline cannot satisfy it;
3. operational/security cost;
4. data/privacy impact;
5. rollback/exit plan;
6. acceptance evidence that the component is necessary.

### Relationship to ADR-0003

ADR-0004 narrows and corrects ADR-0003's premature runtime/language assignments. It keeps provider-neutrality and managed-infrastructure principles while making runtime mechanisms evidence-driven.

**Source:** `artifacts/engineering/decisions/ADR-0004-composition-first-application-platform.md`.

## Decision chronology

```text
ADR-0001  responsibility planes                APPROVED
    │
    ├── ADR-0002  AI evaluator governance      REVIEW
    │
    └── ADR-0003  managed polyglot baseline    REVIEW
             │
             ├── founder V7: outbox-first / no Redis initially
             │
             └── ADR-0004: composition-first, no pre-authorized runtime stack
```

This chronology is supporting interpretation. Current canonical contracts/policies determine implementation authority.