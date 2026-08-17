# ADR-0004 — Composition-first Application Platform

## Status

Review

## Context

LenBands is an IELTS product, not a platform/runtime product. Rebuilding foundation runtime capabilities would increase attack surface, maintenance cost, and time to learner outcome without creating domain advantage. The official stack remains Go (request/orchestration), Python (async evaluation/data), and Next.js (web surface), but each layer must compose suitable frameworks or managed services instead of building a proprietary framework.

## Decision

1. Write only IELTS-specific domain code: knowledge model, learning loop, evaluation evidence, learner UX, policy, and thin adapters at provider boundaries.
2. Build/buy decisions are mandatory for auth, authorization primitives, managed database, object storage, queue/workflow execution, scheduler, retries/DLQ, observability, deployment, payment, email, migration/query tooling, API client/server generation, validation, feature flags, and FSRS implementation.
3. Do not build a custom generic runtime, job framework, workflow engine, scheduler, ORM/query builder, auth system, OpenAPI generator/client, telemetry pipeline, model gateway, or FSRS mathematics. A domain-specific adapter must not become a platform abstraction.
4. Redis Streams in P0 is a transport boundary, not authorization to build a queue runtime. If worker/retry/DLQ/scheduling requirements exceed the selected managed library/service, open a Build/Buy decision instead of expanding a custom worker framework.
5. Every new dependency/provider requires an owner, pinned version/contract, data boundary, cost boundary, security/privacy review, observability integration, and exit/migration path. Provider selection follows `artifacts/business/decisions/build-buy-register.md`.
6. All business-value logic must live in a domain contract. Frameworks, runtimes, and providers appear only behind adapter boundaries and must be replaceable without changing capability identity, IELTS semantics, event meaning, rubric, evidence, or learner state.

## Commodity boundary — do not build internally

In addition to the runtime/workflow concerns above, LenBands does not build its own cache framework, event bus, dependency-injection container, validation library, CLI framework, config loader, logger, retry framework, plugin loader, template engine, Markdown parser, AST parser, diff engine, scheduler, message broker, search engine, or vector database. Use mature implementations and pin dependencies; custom code is allowed only as a thin adapter carrying a domain contract.

An exception must identify a domain invariant that cannot be represented by existing solutions, a benchmark/runtime blocker, total ownership cost, security impact, and an exit plan. “We want more control” or “we can build it” is not evidence.

## Consequences

- Do not select a specific provider or framework before procurement/evidence exists; this ADR does not turn a candidate into an approved platform vendor.
- When source code is scaffolded, dependency manifests for Go, Python, and Next.js become the canonical inventory for selected versions. Tooling validates inventory and boundaries; it does not create runtime abstractions.
- Any proposal to build a prohibited concern internally requires an approved, evidence-backed exception ADR stating the runtime blocker, ownership cost, and exit plan.

## Acceptance

- Do not merge runtime source code without the corresponding dependency manifest.
- Do not merge a generic package from the prohibited list without an approved exception ADR.
- Runtime implementation must demonstrate framework/managed-component use through lockfile, configuration, integration tests, and observability evidence; prose alone is insufficient.
- Provider-replacement tests must not require migration of IELTS domain semantics; only adapter/configuration/provider-specific state may change.
