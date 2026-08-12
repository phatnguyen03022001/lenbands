# ADR-0001 — Repository and Runtime Planes

- **Status:** approved
- **Date:** 2026-08-06
- **Owner:** Founder
- **Related Blueprint:** `blueprint/README.md` § Repository Constitution; `blueprint/02-architecture.md`

## Context

LenBands is a Knowledge OS with canonical content, learner personal data, evaluation, and agent-supported workflows. If the canonical sources for these information types are mixed, the repository becomes difficult to audit, data rights become unclear, and agents can easily create duplicate sources of truth.

## Decision

The system uses three logical planes. This classification is by responsibility and lifecycle; it does not require each plane to reside in a separate physical repository or service.

| Plane | Canonical object | Purpose |
|---|---|---|
| Governance & Knowledge | Blueprint, Artifact, Knowledge Asset | Product rules, decisions, evidence, and canonical knowledge |
| Implementation | Source Code, Infrastructure-as-Code | Implement contracts and deploy the system |
| Runtime | Runtime Data, storage, queue, cache, analytics | Operate personal data and state while the system runs |

### Canonical ownership

- Each object has exactly **one canonical owner plane**.
- A projection, generated copy, deployment copy, or cache may exist on another plane but must have a source reference, version, and provenance.
- No layer mutates the source of a higher layer.
- Stable IDs are used for cross-reference; do not use relative file paths as runtime contracts.

### Repository structure

```text
blueprint/         high-level invariants and product/runtime contracts
artifacts/         decisions, research, evidence, operations, contracts, catalogs
knowledge-assets/  canonical learning knowledge objects + manifests
```

Source code and infrastructure will be added with the first implementation. Runtime Data is not in the Git repository.

## Consequences

- Learner essays, recordings, attempts, evaluation results, and billing state are Runtime Data, not Knowledge Assets.
- Lessons, canonical questions, rubric data, taxonomy vocabulary, templates, and strategies are Knowledge Assets when canonical/versioned.
- OpenAPI, event schemas, failure schemas, ADRs, license evidence, benchmark specifications, and release gates are Artifacts by role; executable implementation remains Source Code.
- Artifacts do not retain mutable, learner-serving copies of Knowledge Assets.
- Evidence is append-only: a new permission/license creates a new evidence version; do not overwrite old evidence.

## Re-review conditions

Review this ADR when there is a multi-repo setup, external content ingestion, a new regulated market, or an object cannot be assigned a clear canonical owner plane.
