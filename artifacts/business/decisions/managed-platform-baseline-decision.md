# Managed Platform Baseline Decision — Free-first P0

- **Decision state:** founder-selected pre-code baseline; activation remains blocked by procurement, DPA, benchmark and release evidence.
- **Date:** 2026-08-10
- **Owner:** Founder
- **Scope:** managed technology selection for the closed-pilot platform; this is not a runtime-readiness claim or a provisioning instruction.
- **Derived from:** `OPS.CostBudget`, `OPS.ModelRouting`, `OPS.Quota`, `OPS.Observability`, `OPS.ReleaseGate`, `EVAL.Writing`, `IDENTITY.Auth`

## 1. Decision

LenBands adopts a **free-first, standards-first managed platform**.  Free allocation is used for documents,
synthetic-data development and a bounded pilot; it is never treated as an availability guarantee, a DPA, a
quality result or a permanent price promise.  The application core remains provider-neutral: providers live
behind adapters, deployment/configuration and this decision record, not in capability IDs, domain entities,
events, OpenAPI or learner-facing copy.

| Boundary | Selected baseline | Activation condition | Replacement boundary |
|---|---|---|---|
| DNS, CDN, TLS edge, WAF policy, object storage | Cloudflare; R2 for private objects when objects are needed | domain/account, security review and storage access policy | DNS/edge config export; S3-compatible object copy/export |
| Next.js web, Go API, Python evaluation worker | Google Cloud Run as OCI containers | reviewed container, service IAM, secret references and deployment gate | OCI image + HTTP/job contracts; deploy to another container host |
| Runtime secrets | Google Secret Manager, referenced at deployment | least-privilege service identity and rotation plan | secret-reference mapping; never application source or image |
| Canonical relational data, migration, outbox | Neon PostgreSQL | DPA/data-region review, backup/restore plan and connection-pool test | standard Postgres dump/restore and migration history |
| Cache, rate-limit and async dispatch | Upstash Redis-compatible service | **before the first P0 async evaluation route**; Streams/consumer-group/DLQ acceptance must pass | Redis Streams adapter; Postgres outbox remains canonical truth |
| Transactional email | Resend primary; Brevo warm fallback | DPA/terms review, verified sender domain, delivery/idempotency test | `EmailProvider` adapter and delivery log |
| Product analytics, feature flags and error monitoring | PostHog, on trigger | consent/privacy filter and event-schema review | canonical event export; analytics does not own product facts |
| Error monitoring (supplementary) | Sentry, provision only when PostHog error tracking is insufficient for the pilot operating baseline | privacy-filtered telemetry and alert/runbook review | OpenTelemetry/structured-log exporter |
| Writing evaluation default route | DeepSeek V4 Flash | benchmark, DPA/data-use review, approved numeric cost policy and release gate | `EvaluationProvider` adapter; no provider terms in domain |
| Writing benchmark / approved exceptional workflow | DeepSeek V4 Pro | explicit benchmark/workflow authorization, separate cost attribution | same Evaluation Contract and benchmark comparison |
| Payment, speech, real-time media/notifications | PayOS, Google TTS, Pusher and Cloudinary are deferred candidates | respective phase, privacy/right/cost decision and acceptance evidence | `BillingProvider`, `SpeechProvider`, realtime/media adapters |

The selected baseline does **not** select an identity provider.  P0 identity remains blocked until the
founder selects an OIDC-compatible identity boundary and approves its DPA, export/delete behavior and
account-migration test.  Custom JWT/password infrastructure from the prior project is not inherited.

## 2. Cost and experience policy

The system may optimize provider use, but a learner must never be made responsible for a vendor quota.

1. A costly evaluation is admitted only after quota/cost reservation.  Once admitted, its submission is
   durable and its learner-visible state is truthful (`processing`, `delayed` or `unavailable`), never a
   hidden provider error.
2. Off-peak batching is permitted only for non-learner-visible work such as benchmark re-runs, backfills
   and analytics.  A submitted Writing evaluation is not delayed merely to seek a cheaper price.
3. Resend is primary for a clean transactional-email experience.  OTP abuse controls apply before provider
   send; a provider quota/rate-limit invokes idempotent retry or the Brevo fallback, never duplicate mail.
4. Redis is not a source of truth.  Redis quota/outage may reduce cache or dispatch capacity, but the
   Postgres outbox preserves accepted submissions for reconciliation.
5. Analytics, replay and error monitoring receive only privacy-filtered identifiers/metrics.  Essay, audio,
   transcript, request body, provider payload, prompt body, token and hidden reasoning are prohibited.
6. Cost controls may reduce optional detail, cache refresh or non-critical background work before they
   reduce data safety, rubric integrity, accessibility or a learner's accepted result.

## 3. Capacity policy

Every selected provider must have a dated capability record and an operating response before activation:

| Signal band | Required response | Learner effect |
|---|---|---|
| `observe` (at or above 60% of a verified hard quota) | alert owner; verify the current provider limit and forecast | none |
| `protect` (at or above 80%) | freeze optional/batch work; reserve capacity for accepted learner work; prepare same-provider upgrade | none for admitted core flows |
| `degrade` (at or above 90% or provider health failure) | activate documented fallback/delayed route; halt new optional work; page owner when required | transparent delayed/unavailable state; draft/submission retained |
| `recover` | reconcile outbox, delivery and cost attribution; review quota/model/provider decision | no duplicate evaluation, charge or email |

Percentages are operational early-warning bands, not price ceilings.  Numeric spend ceilings stay
`unarmed` until the benchmark and provider-price snapshot gates in `cost-budget.md` and
`benchmark/numeric-threshold-policy.yaml` are approved.

## 4. Verified desk snapshot — not a contract price

The following facts were checked against provider-owned documentation on 2026-08-10.  They are inputs to
procurement only and must be re-checked before provisioning and every 30 days while a free-tier boundary is
active.

| Provider | Current relevant public allowance / fact | Why it does not become a product guarantee |
|---|---|---|
| Cloudflare Workers/Pages/R2 | Workers Free: 100,000 requests/day shared with Pages Functions; Pages static requests are unlimited; R2 Free: 10 GB-month, 1M Class A and 10M Class B operations, Internet egress free | Worker limits are hard; static/edge and object-operation demand are measured independently |
| Cloud Run | request-based free allowance includes 2M requests/month and CPU/RAM allowance; containers scale with traffic | billing, region, cold-start and account quotas still apply |
| Neon | Free: 100 CU-hours/month/project, 0.5 GB/project, autosuspend after 5 minutes | provider limits/pricing may change; free does not replace backup/DPA evidence |
| Upstash | Free: 256 MB, 500K commands/month, 10 GB bandwidth | Streams semantics, retention and recovery must be acceptance-tested |
| Resend | Free: 3,000 transactional emails/month and 100/day; no overage on Free | daily cap can affect OTP; fallback and abuse controls are required |
| Brevo | Free: 300 emails/day; branding and plan terms require UX/legal review | fallback only until a reviewed provider policy says otherwise |
| DeepSeek V4 Flash | $0.14/M uncached input, $0.0028/M cache-hit input, $0.28/M output; thinking mode emits additional reasoning tokens billed at the same output rate, making per-evaluation cost sensitive to the thinking/non-thinking toggle; a single-source July-2026 report claims peak-pricing ~2× applies during Beijing business hours (09:00–12:00 and 14:00–18:00 Beijing time ≈ 08:00–11:00 and 13:00–17:00 Vietnam time) — this is an unverified external risk, not policy; official docs warn pricing may increase without notice | price snapshot is not numeric-cost approval or quality evidence; cost scenario in `build-buy-register.md§4.1` assumes 1,500 output tokens without thinking-mode overhead — actual cost may be 2–3× higher per evaluation when thinking mode is active (see §5.1) |

## 5. Non-negotiable boundaries

- No `deepseek-chat` or `deepseek-reasoner` route is introduced.  They are legacy aliases scheduled for
  discontinuation; use explicit V4 model IDs.
- No `LOG_REQUEST_BODY`, `LOG_RESPONSE_BODY`, raw learner content or provider payload configuration is
  allowed in any environment.
- No MongoDB, Bull/BullMQ, large fixed database pool, Pusher, Cloudinary, payment or TTS runtime is
  introduced for P0 merely because it existed in the prior project.
- Cloudflare-specific bindings, Neon-specific SQL, Redis-provider extensions and provider SDK types must
  not appear in domain contracts.
- A provider change, DPA change, price shock, quality regression or failed exit exercise follows the
  release-gate/provider-adapter policy; it is not a silent configuration edit.

### 5.1 Unverified external risks — DeepSeek

1. **Thinking-mode cost multiplier.** The desk-snapshot cost scenario in `build-buy-register.md §4.1`
   assumes 1,500 uncached output tokens for a non-thinking evaluation.  Enabling DeepSeek V4 Flash
   thinking mode emits reasoning tokens that are billed at the same $0.28/M output rate, potentially
   2–3× the output-token volume and per-evaluation cost.  The cost scenario must be re-run with
   thinking-mode token measurements before the numeric cost policy is armed.

2. **Peak-pricing signal.** A single-source July-2026 report claims DeepSeek token prices may double
   during Beijing business hours (09:00–12:00 and 14:00–18:00 Beijing time ≈ 08:00–11:00 and
   13:00–17:00 Vietnam time).  This has not been independently verified against a live billing
   statement.  It is recorded as an unverified external risk — not an operating assumption, not a
   pricing policy, and not a trigger for per-evaluation routing changes.  Re-verify at the
   procurement and benchmark dates.

3. **Deprecated alias retirement.** `deepseek-chat` and `deepseek-reasoner` were retired 2026-07-24.
   Only `deepseek-v4-flash` (with explicit thinking toggle) and `deepseek-v4-pro` may be referenced
   in any adapter, config, prompt contract or runbook.

4. **Cache-hit exclusion.** The budget scenario conservatively excludes cache-hit pricing
   ($0.0028/M input) because cache-hit eligibility depends on runtime prompt shape and prefix reuse
   not yet measured.  Should runtime evidence show a reliable cache-hit rate, the scenario may be
   revised; until then, uncached rates apply.

## 6. Activation and review gates

| Gate | Owner | Evidence required |
|---|---|---|
| Provider legal/data review | founder + privacy/legal | DPA, data use, retention/deletion, region and subprocessors |
| Evaluation route | quality + engineering | gold corpus, benchmark, route/model/prompt version, cost policy, failure/rollback test |
| Postgres | engineering + ops | migration, pooling, backup/restore drill plan and exit test |
| Redis Streams | engineering + ops | consumer-group, retry/DLQ/replay and outbox reconciliation acceptance |
| Email | engineering + ops | verified domain, DKIM/SPF/DMARC, idempotency/fallback and rate-limit test |
| Analytics/monitoring | product + privacy + ops | consent, schema/redaction, retention and alert test |
| Scale response | ops | observed-load exercise or provider-specific capacity test; same-provider upgrade runbook |

## References

- [Cloudflare Workers pricing](https://developers.cloudflare.com/workers/platform/pricing/) (accessed 2026-08-10)
- [Cloudflare Pages pricing](https://developers.cloudflare.com/pages/functions/pricing/) (accessed 2026-08-10)
- [Cloudflare R2 pricing](https://developers.cloudflare.com/r2/pricing/) (accessed 2026-08-10)
- [Cloud Run pricing](https://cloud.google.com/run/pricing) (accessed 2026-08-10)
- [Google Secret Manager pricing](https://cloud.google.com/secret-manager/pricing) (accessed 2026-08-10)
- [Neon pricing](https://neon.com/pricing) (accessed 2026-08-10)
- [Upstash Redis pricing](https://upstash.com/pricing/redis) (accessed 2026-08-10)
- [Resend pricing](https://resend.com/pricing) (accessed 2026-08-10)
- [Brevo transactional email](https://www.brevo.com/products/transactional-email/) (accessed 2026-08-10)
- [PostHog pricing](https://posthog.com/pricing) (accessed 2026-08-10)
- [DeepSeek models and pricing](https://api-docs.deepseek.com/quick_start/pricing/) (accessed 2026-08-10)
- `artifacts/business/decisions/build-buy-register.md`
- `artifacts/engineering/contracts/runtime/provider-adapter-contract.md`
- `artifacts/engineering/contracts/runtime/cloud-platform-topology-contract.md`
- `artifacts/operations/cost-budget.md`
