# ADR-0004 — Composition-first application platform

Status: `review`

## Decision

LenBands uses a **managed, composition-first, provider-neutral application architecture**. Product/domain semantics are owned by Blueprint and canonical contracts. Hosting, identity, relational storage, object storage, durable execution, observability, analytics, billing, email, and model access are purchased/managed capabilities by default and are connected through thin adapters.

This ADR does not select Go, Python, Redis, a worker fleet, a broker, a cache, a cloud VPC, or a self-managed runtime as part of the product architecture.

Canonical boundaries:

- system/domain architecture: `blueprint/02-architecture.md`
- runtime invariants: `artifacts/engineering/runtime-contract.yaml`
- sourcing/provider candidates: `artifacts/business/decisions/platform-sourcing.md`
- API: `artifacts/engineering/api/openapi.yaml` + deterministic schema resolution
- BOPS/security/operations: `artifacts/operations/bops/contract.yaml`

## Why

The closed pilot is founder-operated. Extra services, languages, queues, caches and control planes multiply integration, deployment, observability, security and recovery states before product evidence exists. Managed composition minimizes irreversible operational surface while preserving provider exit through adapters and standard data formats.

## Invariants

1. Business logic is domain-owned.
2. Provider semantics do not leak into capability, event, failure or learner-facing API meaning.
3. Commodity runtime concerns are not custom-built without an evidence-backed blocker.
4. Every provider boundary has an exit path and a contract test strategy.
5. Runtime mechanisms are chosen only after the semantic contract requires them.
6. Cache/search/vector/queue/worker infrastructure is disabled by default until measured need exists.
7. Learner-visible scoring uses only benchmark-approved scorer routes; unavailable approved capacity produces `delayed`/`unavailable`, not silent model substitution.
8. Build readiness and release readiness require evidence; architecture prose cannot promote either state.

## Candidate managed composition

Provider names live only in `platform-sourcing.md` as procurement candidates. They may be replaced without changing this ADR when the canonical semantic boundaries remain intact.

## When custom infrastructure is allowed

A custom service or dedicated infrastructure component requires a reviewed decision containing:

- the measured or contractual blocker;
- why the managed baseline cannot satisfy it;
- operational/security cost;
- data and privacy impact;
- rollback/exit plan;
- acceptance evidence that proves the new component is needed.

Absent that record, the default is **do not build it**.

## Consequences

Implementation should normally converge on one web/application codebase plus managed platform capabilities and provider adapters. Offline Python or other specialist tooling may be used for benchmark/statistical research when justified; that does not create a production service boundary. A separate backend language, worker runtime, Redis/Kafka layer, custom workflow engine, custom auth, custom analytics, or model-serving fleet is not pre-authorized.
