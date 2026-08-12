# ADR-0003 — Platform Boundary and Managed Infrastructure

- **Status:** review
- **Date:** 2026-08-06
- **Owner:** Founder
- **Related Blueprint:** `02-architecture.md`, Build/Buy Register

## Context

LenBands uses Go, Python, and Next.js; a solo founder should not operate the database, queue, storage, payment, auth, or model fleet as a core competency.

## Decision

- Next.js is the learner/admin frontend; Go is synchronous orchestration/API; Python is the asynchronous evaluation/data/quality workload.
- Postgres is the primary relational store; Redis Streams is the P0 job/cache boundary; S3-compatible managed object storage is used for binary objects.
- Auth, payment, email, observability, analytics, and runtime infrastructure use managed/buy boundaries under the Build/Buy Register.
- Kafka, self-hosted model serving, dedicated vector DB, and multi-region infrastructure are outside P0.
- The business/domain model must be provider-neutral; provider responses must not pass directly to UI/domain events.

## Alternatives

| Alternative | Not chosen because |
|---|---|
| One language for every layer | Reduces fit for evaluation/data workloads or request paths |
| Self-host all infrastructure | SRE/security burden does not fit a solo-founder MVP |
| Vendor-first domain design | Creates lock-in and breaks the exit strategy |

## Consequences

- An adapter and export/migration path are required at every managed boundary.
- Specific providers are benchmarked/procured in Artifacts and do not enter the Blueprint.
- Go/Python contracts and idempotent job semantics are build conditions for AI workloads.
- Composition-first rules, the list of runtime components not to build, and migration/provider
  exit requirements are detailed in `ADR-0004`.

## Review trigger

Review when volume/SLO/cost/compliance exceeds the managed baseline or when a boundary becomes a measurable moat.
