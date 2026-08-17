# Platform Sourcing Decision — Buy-first Web Baseline

Status: **review / founder-directed candidate**. This supersedes the provider-sprawl baseline for new design work. It is not a production provisioning record and does not claim procurement, DPA, benchmark or runtime evidence.

## Decision

LenBands will **buy managed commodity planes first** and build only differentiated learning/evaluation semantics.

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

### Buy / managed

| Plane | Current candidate | What is bought | LenBands still owns |
|---|---|---|---|
| Web/runtime | Vercel + Next.js | deployment, CDN/edge platform, serverless functions, durable Workflow | route/domain logic, idempotency, state semantics |
| Data/identity/storage | Supabase | managed Postgres, Auth, Storage, RLS/RBAC, Realtime primitives | schema, RLS/RBAC policy, data lifecycle |
| Model access | Vercel AI Gateway | provider-neutral model endpoint, usage/budget/routing tooling | evaluator route version, prompts, rubric, benchmark, normalization |
| Transactional email | Resend or managed SMTP | email delivery/reputation | notification policy/content/frequency |
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

Python may be used offline for benchmark/statistics when it materially improves evaluation research. It is not a mandatory production service.

## Why this replaces the previous baseline

The earlier baseline was technically managed but composed many independent providers: Cloudflare, Cloud Run, Secret Manager, Neon, Upstash, email, analytics/error tracking, and model APIs. That still leaves a solo founder responsible for many credentials, networks, IAM models, queues, failure modes, upgrades and cross-provider incidents.

The new baseline consolidates the commodity platform into two primary operational planes:

1. **Vercel** — web/runtime/workflow/model gateway.
2. **Supabase** — Postgres/auth/storage/data authorization.

Email, billing and analytics stay specialized adapters because their domain obligations differ.

## Important provider boundaries

### Vercel Workflow

Use durable Workflow for multi-step asynchronous application flows such as evaluation. Domain state remains in canonical Postgres; workflow state is orchestration state, not the score SSOT.

Do not add Vercel Queues merely because it exists. Add a lower-level queue only when a measured fan-out/routing/throughput requirement cannot be cleanly expressed as Workflow.

### AI Gateway

General coaching/generation may use governed fallback. **Scoring routes may not automatically fall back to an unbenchmarked model/provider.** A scoring route version contains an explicit allow-list of model/provider combinations that passed the same evaluation gate. If none is available, evaluation is delayed/unavailable.

### Supabase

Use managed Postgres as canonical relational state and Supabase Auth as identity provider. Use RLS on exposed tables. Sensitive assessment, Colab and Admin writes default to the application API even when RLS exists.

Never expose a service-role/bypass-RLS credential in browser code.

### Billing

Paddle is a sourcing candidate because a merchant-of-record model can buy payment, tax and subscription operations. It must still pass account availability, payout, legal/privacy, pricing and exit review before activation.

Webhook delivery is at-least-once and may be out of order. Entitlement updates are idempotent by provider event ID, reason about provider event time, and have reconciliation against the provider API.

## Exit strategy

| Plane | Exit artifact |
|---|---|
| Vercel runtime | standard Next.js/HTTP boundaries; domain state outside workflow runtime; portability review before provider-specific feature expansion |
| Supabase data | standard Postgres logical dump/schema migrations; Storage export; identity subject mapping |
| AI Gateway | `EvaluationProvider`/model-route adapter and benchmark suite |
| Resend | `EmailProvider` adapter and delivery log |
| Paddle | provider-neutral subscription/entitlement ledger + event reconciliation |
| PostHog | canonical event dictionary and exportable derived telemetry |

## Procurement gate

No candidate becomes production-authoritative until:

- current terms/DPA/data region and retention are reviewed;
- cost/spend controls are armed;
- data classes are allowed in BOPS;
- export/exit path is exercised at least at design/test level;
- provider-specific security checklist passes;
- learner-visible evaluation providers pass the benchmark route gate.

## Research basis

Current official documentation checked 2026-08-17:

- Vercel Functions: https://vercel.com/docs/functions
- Vercel Workflow GA: https://vercel.com/blog/a-new-programming-model-for-durable-execution
- Vercel AI Gateway: https://vercel.com/docs/ai-gateway
- Supabase platform: https://supabase.com/docs/guides/platform
- Supabase Auth: https://supabase.com/docs/guides/auth
- Supabase RLS: https://supabase.com/docs/guides/database/postgres/row-level-security
- Paddle webhooks/subscriptions: https://developer.paddle.com/webhooks/ and https://developer.paddle.com/build/subscriptions/provision-access-webhooks/
