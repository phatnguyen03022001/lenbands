# Platform Sourcing Decisions

STATUS: SUPPORTING
ROLE: REPOSITORY DECISION HISTORY
AUTHORITY: NONE

This file normalizes the current business sourcing direction and its superseded predecessors. Provider activation still requires current procurement, privacy/security, cost, benchmark and exit gates.

## Current sourcing direction — buy-first web baseline

**Source status:** `review / founder-directed candidate`.

### Decision

LenBands buys managed commodity planes first and builds only differentiated learning/evaluation semantics.

### Build

LenBands owns:

- IELTS taxonomy, task/skill/error/evidence semantics;
- learner evidence model, transfer/retention state and recommendation policy;
- content schema, content versioning and publishing rules;
- rubric/evaluation contract, prompt/rubric versioning, benchmark and score-scope policy;
- thin product orchestration and API authorization policy;
- database schema/RLS policies;
- learner/Colab/Admin product experience;
- provider-neutral events, failures, audit and entitlement semantics.

### Buy / managed candidates

| Plane | Candidate | Bought capability | LenBands still owns |
|---|---|---|---|
| Web/runtime | Vercel + Next.js | deployment, CDN/edge, serverless functions, durable Workflow | route/domain logic, idempotency, state semantics |
| Data/identity/storage | Supabase | managed Postgres, Auth, Storage, RLS/RBAC, Realtime primitives | schema, RLS/RBAC policy, data lifecycle |
| Model access | Vercel AI Gateway | provider-neutral endpoint, usage/budget/routing tooling | evaluator route version, prompts, rubric, benchmark, normalization |
| Transactional email | Resend or managed SMTP | delivery/reputation | notification policy/content/frequency |
| Billing/tax | Paddle candidate when monetization activates | checkout, subscription lifecycle, tax/compliance as merchant-of-record | product entitlements, local ledger, webhook reconciliation |
| Product analytics/flags | PostHog candidate | event ingestion/exploration/feature flags | event schema, privacy filtering, experiment quality guardrails |

### Explicitly not built in P0

- custom password/MFA/session infrastructure;
- standalone Go API service;
- standalone Python request/worker service;
- self-managed Postgres/Redis/object storage;
- Redis Streams/Kafka;
- custom distributed workflow engine;
- custom feature-flag or analytics platform;
- custom payment/tax stack;
- self-hosted model inference fleet;
- vector database or search cluster;
- separate secret-management service solely for application keys;
- Terraform-heavy multi-cloud platform before runtime evidence requires it.

Python may be used offline for benchmark/statistics when it materially improves evaluation research; that does not make it a mandatory production service.

### Important boundary decisions

- durable Workflow may orchestrate multi-step async flows, but canonical domain state stays in Postgres;
- do not add a lower-level queue merely because the provider offers one;
- general model use may have governed fallback, but scoring routes may only use benchmark-approved model/provider combinations;
- sensitive assessment/Colab/Admin writes default to application API even when RLS exists;
- never expose service-role/bypass-RLS credentials to browser code;
- entitlement reconciliation is idempotent and handles at-least-once/out-of-order billing events;
- every managed plane needs an exit artifact/adapter.

## Superseded predecessor — build/buy register

**Status:** `SUPERSEDED` for new design work.

Historical principle retained: LenBands owns differentiated learning/evaluation semantics and buys commodity infrastructure. The old register must not select a new provider or production topology.

**Source:** `artifacts/business/decisions/build-buy-register.md`.

## Superseded predecessor — managed platform baseline

**Status:** `SUPERSEDED` for new design work.

Historical baseline: Cloudflare + Cloud Run + Secret Manager + Neon + Upstash. It was superseded because the composition created too many independent operational/provider boundaries for a founder-scale product.

**Source:** `artifacts/business/decisions/managed-platform-baseline-decision.md`.

## Relationship to founder V7

Founder V7 captured an earlier provider topology (Auth0, Cloud Run, Cloudflare, Neon, R2, OpenTofu/Terraform, outbox-first/no Redis). The later sourcing direction consolidates commodity operations around Vercel + Supabase candidates.

The durable principles survive:

```text
managed commodity capability by default
+ provider-neutral domain contracts
+ Postgres canonical state
+ no Redis/queue without measured need
+ explicit exit path
+ activation gates before production
```

## Procurement gate

No candidate becomes production-authoritative until current terms/DPA/data region/retention, spend controls, allowed data classes, export/exit, security checklist and learner-visible evaluation benchmarks pass their required gates.

Primary source: `artifacts/business/decisions/platform-sourcing.md`.