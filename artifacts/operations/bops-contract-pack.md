# BOPS Contract Pack — Business/Operations/Platform/Security

- **Type:** bops-contract-pack
- **Status:** `review` — Deliverable C
- **Owner:** operations + engineering
- **Created:** 2026-08-10
- **Derived from:** `managed-platform-baseline-decision.md`, `build-buy-register.md`, all P0 capability IDs
- **Consumed by:** operations, engineering, founder, validators

## Purpose

Define the data classification, IAM, quota/cost, SLO, telemetry redaction, backup/restore, RPO/RTO,
provider exit, and scale-up policies for every managed provider in the LenBands platform baseline.
This is the operational execution layer that the `managed-platform-baseline-decision.md` selection
depends on.

This is a **pre-code design contract**, not post-code runtime evidence. Every numeric SLO, RPO/RTO,
and cost band is a **dated design target** (2026-08-10) until verified with runtime data.
No value in this document is a runtime measurement, provider SLA commitment, or availability guarantee.

**Contract inventory:**
- **6 active provider contracts:** Cloudflare (§1.1), Cloud Run (§1.2), Secret Manager (§1.3), Neon (§1.4), Upstash (§1.5), Resend/Brevo (§1.6)
- **2 on-trigger/supplementary contracts:** PostHog (§1.7 — default), Sentry (§1.8 — provisioned only when PostHog error tracking is insufficient)
- **1 evaluation-provider contract:** DeepSeek (§1.9 — V4 Flash default, V4 Pro benchmark-only)
- **4 deferred adapter contracts:** PayOS, Google TTS, Pusher, Cloudinary (§1.10 — no runtime, adapter interfaces only)
- **Total: 9 contracts with defined per-provider data/IAM/quota/SLO/exit policies + 4 deferred adapter stubs**

No claim of "10" or any other count is made without this explicit definition.

---

## 1. Per-provider BOPS contracts

### 1.1 Cloudflare — Edge, DNS, CDN, WAF, R2 Storage

```yaml
provider: Cloudflare
boundaries: [DNS, CDN, TLS termination, WAF policy, static asset serving, R2 object storage]
data_classes_allowed: [system, derived]
data_classes_prohibited: [assessment, audio, account]  # no learner PII/essay at edge
dpa_gate: >
  Data Processing Agreement required before learner data transits edge.
  Standard contractual clauses acceptable for pilot scale.
  Region: default (global); no explicit region pinning at free tier.
iam:
  - Cloudflare API tokens scoped per service (R2 read/write, Workers deploy, DNS edit)
  - Token rotation: 90-day max lifetime
  - No shared tokens between services
quota_cost_bands:
  - Workers: 100K req/day free; alert at 80% (80K); degrade at 90% (90K) → fail-open bypass Worker
  - R2: 10GB + 1M Class A + 10M Class B free
  - Static assets: unmetered free
slo:
  - CDN availability: target 99.9% (provider SLA)
  - Static asset latency: p95 < 100ms
telemetry_redaction:
  - Cloudflare analytics receive no learner-identifying headers
  - R2 access logs exclude object keys containing learner IDs (use opaque references)
backup_restore:
  - R2: versioning enabled for recovery; no additional backup
  - DNS/config: export via Cloudflare API; stored in Git as documented config
rpo_rto:
  - R2 RPO: object-level (versioned); RTO: immediate on provider recovery
  - DNS RPO: config-export interval (daily); RTO: < 1 hour (DNS propagation)
exit_exercise:
  - DNS: export zone file → import to alternative provider
  - R2: S3-compatible copy/export to alternative S3-compatible storage
  - CDN/WAF: standard HTTPS config, portable to any CDN
scale_up_path:
  - Workers: Free → Paid ($5/mo) → Workers Unbound (no code change)
  - R2: Free → usage-based billing (same API)
pre_vs_post_code: >
  Pre-code: config templates, IAM design, exit script design.
  Post-code: live traffic observation, SLO measurement, exit drill, RPO/RTO validation.
```

### 1.2 Google Cloud Run — OCI Container Host

```yaml
provider: Google Cloud Run
boundaries: [Next.js web container, Go API container, Python evaluation worker container]
data_classes_allowed: [account, learning, assessment, derived]
data_classes_prohibited: [audio]  # audio not yet in P0 scope
dpa_gate: >
  GCP Data Processing Amendment required. Region: asia-southeast1 (Singapore) preferred;
  us-central1 acceptable if SG unavailable at free tier. P0 containers must be deployable
  in the selected region.
iam:
  - Service account per service (web, api, worker) with least-privilege IAM
  - Cloud Run invoker: only Cloud Scheduler + BFF (for api)
  - Secret access: read-only to specific Secret Manager entries
  - Service account key rotation: 90-day max; prefer Workload Identity Federation
quota_cost_bands:
  - Free: 2M req/month + 180K vCPU-sec + 360K GiB-sec
  - Alert at 60% of free allocation; protect at 80%; degrade non-core at 90%
  - Paid: $0.000024/vCPU-sec + $0.0000025/GiB-sec + $0.40/M req
slo:
  - API availability: target 99.5% (pilot); p95 latency < 500ms (non-evaluation endpoints)
  - Cold start: target < 3s for API, < 10s for worker
  - Evaluation async: p95 < 5min end-to-end (submission → result available)
telemetry_redaction:
  - Cloud Run request logs: NO request body, NO response body
  - Structured logging: trace_id + operation + duration; raw essay never in log payload
  - Error reporting: user-safe error codes only; no provider payloads or stack traces
backup_restore:
  - No persistent compute state (stateless containers)
  - Container images: versioned in Artifact Registry; deploy rollback to prior image
rpo_rto:
  - RPO: N/A for stateless compute (data is in Neon/R2)
  - RTO: < 5 minutes (deploy prior container image)
exit_exercise:
  - OCI image export from Artifact Registry → push to alternative registry
  - HTTP/job contract is provider-neutral (no Cloud Run-specific API in domain code)
  - Deploy to any OCI container host (AWS App Runner, Azure Container Apps, self-hosted)
scale_up_path:
  - Increase max instances, concurrency, memory/CPU per container
  - Same container image; no migration
pre_vs_post_code: >
  Pre-code: container build pipeline, IAM design, deployment manifest.
  Post-code: cold-start measurement, p95 latency validation, load test at pilot scale.
```

### 1.3 Google Secret Manager

```yaml
provider: Google Secret Manager
boundaries: [runtime secrets referenced at deployment only]
data_classes_allowed: [system]  # secrets only
data_classes_prohibited: [account, learning, assessment, audio]
dpa_gate: Covered by GCP DPA (same as Cloud Run).
iam:
  - Service accounts read specific secrets by name (not wildcard)
  - No human access to production secrets after initial provisioning
  - Rotation: API keys rotated per provider recommendation; DB credentials 90-day
quota_cost_bands:
  - Free: 6 active secret versions/month (sufficient for pilot)
  - Access: $0.03/10K access operations (beyond free)
slo: N/A (secrets are deployment-time, not request-time)
telemetry_redaction: Secret contents never logged. Secret version accessed audit logged.
backup_restore: Secrets are versioned automatically; prior versions retained for rollback.
rpo_rto: RPO: secret creation interval; RTO: immediate (versioned)
exit_exercise: Secret-value export → import to alternative secret store (AWS Secrets Manager, Vault, env vars with documented migration)
scale_up_path: N/A (secrets volume is negligible at pilot scale)
pre_vs_post_code: >
  Pre-code: secret naming convention, IAM model, rotation schedule.
  Post-code: rotation drill, access audit review.
```

### 1.4 Neon PostgreSQL

```yaml
provider: Neon PostgreSQL
boundaries: [canonical relational data, schema migration, connection pooling, outbox]
data_classes_allowed: [account, learning, assessment, derived]
data_classes_prohibited: [audio]  # audio stored in R2, referenced by URL
dpa_gate: >
  Neon DPA required. Data region: ap-southeast-1 (Singapore) if available;
  us-east-1 acceptable at pilot scale. Region must be documented and reviewed
  against data residency decision (D-01).
iam:
  - Connection pooling via PgBouncer (Neon-managed)
  - Pool size: max 20 connections (serverless-aware, not fixed large pool)
  - Application credentials: read-write service role per environment
  - Migration credentials: separate role with DDL permission
  - Credential rotation: 90-day
quota_cost_bands:
  - Free: 0.5 GB storage, 100 CU-hours/month, autosuspend 5min
  - Alert at 60% storage; alert at 80% CU-hours
  - Paid: per-GB storage + per-CU-hour beyond free
slo:
  - Availability: target 99.95% (provider SLA)
  - Query latency: p95 < 50ms (simple queries), p95 < 500ms (complex queries)
  - Autosuspend wake: < 2s
telemetry_redaction:
  - Query logs: NO parameter values containing learner text
  - Slow query log: query template only (parameterized)
backup_restore:
  - Neon PITR: 6-hour window (free), configurable on paid
  - Backup verification: monthly restore drill to staging
  - Logical dump: weekly for exit portability
rpo_rto:
  - RPO: 6 hours (free PITR window); target 1 hour (paid plan)
  - RTO: < 1 hour (restore + replay)
exit_exercise:
  - Standard pg_dump → restore to alternative PostgreSQL (any managed or self-hosted)
  - No Neon-specific SQL, extensions, or features in schema
  - Connection string swap in deployment config; no code change
scale_up_path:
  - Free → Launch → Scale (same PostgreSQL, same API)
  - Increase CU, storage, PITR window on same instance
pre_vs_post_code: >
  Pre-code: schema design, pooling config, migration toolchain, dump/restore scripts.
  Post-code: restore drill, connection pool observation, autosuspend wake measurement.
```

### 1.5 Upstash Redis

```yaml
provider: Upstash Redis
boundaries: [cache, rate-limit, async job dispatch (Redis Streams)]
data_classes_allowed: [derived]  # cache, counters, job metadata only
data_classes_prohibited: [account, learning, assessment, audio]
dpa_gate: Upstash DPA required. Data region: ap-southeast-1 (Singapore) preferred.
iam:
  - Redis token: scoped per environment
  - No human access to production after provisioning
  - Token rotation: 90-day
quota_cost_bands:
  - Free: 256 MB, 500K commands/month, 10 GB bandwidth, max 10K cmd/sec
  - Alert at 60% commands; protect at 80% → reduce cache TTL, throttle non-critical dispatch
  - Paid: $0.20/100K commands beyond free + $0.25/GB-month
  - Cost ceiling: per cost-budget.md; hard cap at founder-approved threshold
slo:
  - Cache read latency: p95 < 5ms
  - Stream dispatch: message visible within 1s of enqueue
telemetry_redaction:
  - Redis keys contain opaque IDs only (no learner email, name, essay_ref)
  - Stream message body: job metadata (job_id, trace_id, attempt_number); never learner content
backup_restore:
  - NOT a source of truth — no backup
  - Data recovery: replay from Postgres outbox
rpo_rto:
  - RPO: not applicable (cache/dispatch — data is in Postgres outbox)
  - RTO: < 5 min (reconnect + outbox replay)
exit_exercise:
  - Redis Streams adapter → alternative Redis provider (Redis Cloud, ElastiCache, self-hosted)
  - Cache: key-value adapter → alternative key-value store
  - Postgres outbox is canonical; Redis is replaceable
scale_up_path:
  - Free → Pay-as-you-go on same endpoint (no code change)
  - Increase memory if needed (paid plans)
pre_vs_post_code: >
  Pre-code: Streams consumer group design, DLQ policy, adapter interface.
  Post-code: throughput measurement, cmd/sec observation, outbox reconciliation drill.
```

### 1.6 Resend (Primary) + Brevo (Fallback) — Transactional Email

```yaml
provider: Resend (primary), Brevo (warm fallback)
boundaries: [transactional email: magic-link, OTP, notification, export delivery]
data_classes_allowed: [account]  # email address, delivery status
data_classes_prohibited: [learning, assessment, audio, derived]
dpa_gate: >
  Resend DPA required. SOC 2 Type II, GDPR compliant. Region: us-east-1 (Resend default).
  Brevo DPA for fallback. Branding on Brevo free tier is acceptable for fallback only
  (primary Resend has no branding).
iam:
  - API key per environment
  - Verified sending domain (DKIM, SPF, DMARC)
  - OTP abuse guard: rate-limit per recipient before provider send (idempotent retry, no duplicate mail)
quota_cost_bands:
  - Resend free: 3,000 emails/month, 100/day
  - Brevo fallback free: 300 emails/day (branded)
  - Alert at 60% Resend daily cap (60/day); protect at 80% → activate Brevo fallback
  - Paid: Resend $20/mo for 50K emails
slo:
  - Magic-link delivery: p95 < 30s from request to inbox
  - OTP delivery: p95 < 15s
telemetry_redaction:
  - Delivery events logged (sent/delivered/bounced/opened)
  - Email content never logged (email body is provider-side template)
backup_restore: Delivery log in Postgres; provider delivery webhooks idempotent.
rpo_rto:
  - Email: best-effort delivery (no RPO/RTO for transient email outage)
exit_exercise:
  - EmailProvider adapter: swap Resend → Brevo (same interface)
  - Delivery log is provider-neutral
scale_up_path:
  - Resend: Free → Pro ($20/mo, 50K) → Scale (volume pricing)
  - Brevo fallback: Free → Starter ($9/mo, no branding)
pre_vs_post_code: >
  Pre-code: adapter interface, template design, domain verification.
  Post-code: delivery rate measurement, OTP end-to-end test, fallback drill.
```

### 1.7 PostHog (Default) — Analytics, Feature Flags, Error Tracking

```yaml
provider: PostHog (default observability surface)
boundaries: [product analytics, feature flags, error tracking]
data_classes_allowed: [derived]  # aggregated metrics, event names, feature flag state
data_classes_prohibited: [account, learning, assessment, audio]
  # account: no PII (email, name) in analytics
  # assessment: no essay text, no evaluation content, no error text
dpa_gate: >
  PostHog DPA required. Cloud region: US or EU. Self-hosted option available if
  data residency requires it (PostHog open-source).
iam:
  - Project API key (public for event ingestion; separate for management)
  - Feature flag management: admin-scoped
  - No learner PII in event properties
quota_cost_bands:
  - Free: 1M events/month, 5K session replays, 1M flag requests, 100K error tracking
  - Alert at 60% events; sample non-critical telemetry at 80%
  - Paid: $0.00005/event beyond free
slo:
  - Event ingestion: near-real-time (< 5 min to dashboard)
  - Flag evaluation: < 50ms client-side
telemetry_redaction:
  - Event schema reviewed for privacy before sending
  - NO: essay text, audio, transcript, request/response body, provider payload, prompt text, token content, error text, learner PII
  - YES: event name, capability_id, state transition, metric value, opaque refs
  - Session replay: disabled for assessment-related screens (captures essay text by definition)
backup_restore: Analytics events are non-critical (no backup); reprocess from event stream if needed.
rpo_rto: N/A (analytics — best-effort, not operational-critical)
exit_exercise:
  - Canonical event export to warehouse format (JSON/Parquet)
  - PostHog → alternative analytics (Mixpanel, Amplitude) via event export adapter
scale_up_path:
  - Free → Pay-as-you-go (same SDK, no code change)
  - Self-hosted PostHog for data residency (open-source option)
pre_vs_post_code: >
  Pre-code: event schema design, consent integration, privacy filter.
  Post-code: event volume measurement, privacy audit of actual payloads, session replay scope validation.
```

### 1.8 Sentry (On-Trigger Supplementary)

```yaml
provider: Sentry
boundaries: [error monitoring — supplementary, provisioned only when PostHog error
  tracking is insufficient for the pilot operating baseline]
data_classes_allowed: [derived]  # error codes, stack traces (anonymized)
data_classes_prohibited: [account, learning, assessment, audio]
dpa_gate: Sentry DPA required at provisioning. Region: US or EU.
iam:
  - DSN per environment
  - 1 user on free plan; admin access for ops only
quota_cost_bands:
  - Free: 5K errors/month; silently dropped beyond cap (pay-or-go-blind)
  - Alert BEFORE cap reached (if provisioned)
  - Paid: $26/mo Team plan
slo: Error ingestion: near-real-time (< 1 min)
telemetry_redaction:
  - NO: request body, response body, essay text, provider payload, learner PII
  - YES: error code, sanitized stack trace, trace_id, operation
  - Redaction enforced at SDK level before send
backup_restore: N/A
rpo_rto: N/A
exit_exercise: OpenTelemetry exporter → alternative error tracker (no vendor lock-in)
scale_up_path: Free → Team ($26/mo) if provisioned
provisioning_trigger: >
  Sentry is NOT provisioned by default. It is activated only when:
  (a) PostHog error tracking hits its free quota (100K/month) consistently for 2+ weeks, OR
  (b) PostHog error tracking lacks a required capability (e.g., source-mapped stack traces,
      release tracking, cron monitoring) that blocks operational visibility.
  Provisioning must be a documented operations decision with dated trigger evidence.
pre_vs_post_code: >
  Pre-code: Sentry SDK integration behind feature flag (off by default), redaction config.
  Post-code: trigger evaluation, provisioning decision, comparison with PostHog error tracking.
```

### 1.9 DeepSeek V4 — AI Evaluation Provider

```yaml
provider: DeepSeek V4 Flash (default evaluation), V4 Pro (benchmark-only)
boundaries: [writing evaluation inference]
data_classes_allowed: [assessment]  # essay text sent to provider for evaluation
data_classes_prohibited: [account]  # no learner PII (email, name) in prompt
dpa_gate: >
  DeepSeek API terms must explicitly state no-training-on-API-data. Data-use review
  required before learner essays are sent. Consent disclosure: learner must be informed
  that essay content is processed by a third-party AI provider (no provider name in UI,
  generic "evaluation service" disclosure). Founder must approve data-use terms before
  first learner evaluation. Data residency is governed by D-01; required submission
  consent is governed by `artifacts/engineering/contracts/runtime/auth-identity-contract.md`.
iam:
  - API key per environment; rotation 90-day
  - No direct learner access to provider API
  - Budget guard: hard cap per evaluation + daily cap
quota_cost_bands:
  - V4 Flash: $0.14/M uncached input, $0.0028/M cache-hit input, $0.28/M output
  - V4 Pro: $0.435/M input, $0.87/M output (benchmark workflow only; requires explicit founder auth)
  - Per-evaluation cost: $0.00098 (non-thinking, 4K in + 1.5K out); ~$0.00127 with 30% reserve
  - Thinking mode multiplier: 2–3× output tokens → 2–3× cost (see managed-platform-baseline §5.1)
  - Peak-pricing risk: unverified 2× during Beijing business hours (08:00–11:00, 13:00–17:00 VN time)
  - Daily cost cap: founder-defined (unarmed until benchmark run)
  - Alert at 60% daily cap; protect at 80% → stop non-critical evaluations; degrade at 90% → delayed/unavailable
slo:
  - p95 evaluation latency (end-to-end): < 5 minutes
  - Provider API latency: p95 < 10s (inference only, excluding retry/queue)
  - Async model: submission → job queued → worker claims → provider call → result persisted → learner polls
telemetry_redaction:
  - Prompt template: version-tracked, NOT logged per-request
  - Provider request: essay text sent to provider; NOT logged in LenBands telemetry
  - Provider response: evaluation result ingested; raw provider response NOT logged
  - Token consumption: counted per request for cost tracking; NOT per-response logged
backup_restore: >
  Postgres outbox is canonical truth for every submission. Provider outage → evaluation
  queued → retried when available. No provider-side backup dependency.
rpo_rto:
  - Provider outage: evaluation delayed (learner sees `delayed` state; submission preserved)
  - Provider switch: adapter swap + benchmark re-run before learner-visible routing change
exit_exercise:
  - ModelProvider adapter: same Evaluation Contract, swap model/endpoint/config
  - Dual-run benchmark: compare new provider vs baseline on same corpus before switch
  - Candidate providers: Anthropic, Google, open-weight (self-hosted) — each requires benchmark + DPA
scale_up_path:
  - Same model, increase quota: config change only
  - Switch route: model version/config via feature flag (V4 Flash → higher capacity tier)
  - Add second provider: adapter route by quality/cost policy
pre_vs_post_code: >
  Pre-code: ModelProvider adapter, prompt template, budget guard, timeout/concurrency config.
  Post-code: p95 latency validation, cost-per-evaluation measurement, cache-hit rate,
  thinking-mode token-count benchmark, peak-pricing verification, provider-switch drill.
  Categorically post-code: benchmark run, gold corpus, numeric threshold approval.
```

### 1.10 Deferred Providers

```yaml
providers_deferred:
  - provider: PayOS
    boundary: payment_collection
    activation: subscription phase (P1); founder pricing decision required
    pre_code: PaymentProvider adapter, webhook idempotency, ledger design
  - provider: Google TTS
    boundary: speech_synthesis
    activation: speaking/pronunciation phase (P1)
    pre_code: SpeechProvider adapter, audio storage contract
    note: 1M neural chars/month free; billing must be enabled with budget cap
  - provider: Pusher
    boundary: real_time_notifications
    activation: real-time notification phase (P2); polling sufficient for P0
    pre_code: RealtimeProvider adapter stub
  - provider: Cloudinary
    boundary: image_transformation
    activation: marketing/asset phase (deferred)
    pre_code: ImageProvider adapter stub
    note: Marketing images only; NOT for learner data storage
```

---

## 2. Cross-provider policies

### 2.1 Data classification per 4 axes

Every data class is governed across 4 orthogonal axes per provider. A cell marked `prohibited`
means the provider MUST NOT receive data of that class on that axis. A cell marked `allowed`
requires a signed DPA or equivalent terms before data flows.

**Axis definitions:**
- **Transit:** Data moving over the wire to/through the provider (TLS, edge proxy, API call).
- **Storage:** Data persisted by the provider (database rows, object bytes, queue messages).
- **Processing:** Data the provider's compute inspects, transforms, or evaluates (prompt content, query parameters, function input).
- **Telemetry/logging:** Data in provider-side logs, metrics, dashboards, or analytics.

#### account (email, name, consent state)

| Provider | Transit | Storage | Processing | Telemetry |
|---|---|---|---|---|
| Cloudflare edge | allowed (TLS passthrough) | prohibited | prohibited | prohibited |
| Cloud Run | allowed | prohibited (stateless) | allowed (session validation) | prohibited |
| Neon | allowed (TLS) | allowed | allowed | prohibited |
| Upstash | prohibited | prohibited | prohibited | prohibited |
| Resend/Brevo | allowed | allowed (email address) | allowed (template render) | allowed (delivery events only) |
| PostHog | prohibited | prohibited | prohibited | prohibited |
| Sentry | prohibited | prohibited | prohibited | prohibited |
| DeepSeek | prohibited | prohibited | prohibited | prohibited |
| Secret Manager | prohibited | prohibited | prohibited | prohibited |
| R2 | prohibited | prohibited | prohibited | prohibited |

#### assessment (essay text, evaluation result, finding text, criterion scores)

| Provider | Transit | Storage | Processing | Telemetry |
|---|---|---|---|---|
| Cloudflare edge | allowed (TLS passthrough to Cloud Run) | prohibited | prohibited | prohibited |
| Cloud Run | allowed | prohibited (stateless) | prohibited (delegates eval to worker) | prohibited |
| Neon | allowed (TLS) | allowed (evaluation facts, results) | allowed (query only) | prohibited |
| Upstash | prohibited | prohibited | prohibited | prohibited |
| Resend/Brevo | prohibited | prohibited | prohibited | prohibited |
| PostHog | prohibited | prohibited | prohibited | prohibited |
| Sentry | prohibited | prohibited | prohibited | prohibited |
| DeepSeek | allowed (essay text in prompt) | prohibited (no-training terms) | allowed (inference) | prohibited |
| Secret Manager | prohibited | prohibited | prohibited | prohibited |
| R2 | prohibited | prohibited | prohibited | prohibited |

#### audio (speaking recordings, pronunciation samples)

| Provider | Transit | Storage | Processing | Telemetry |
|---|---|---|---|---|
| Cloudflare edge | allowed (TLS passthrough; MUST NOT cache/log body) | prohibited | prohibited | prohibited |
| Cloud Run | allowed | prohibited (stateless) | prohibited | prohibited |
| Neon | prohibited (URL reference only) | prohibited | prohibited | prohibited |
| R2 | allowed (upload/download) | allowed (private bucket, signed-access policy, encryption at rest) | prohibited | prohibited |
| All others | prohibited | prohibited | prohibited | prohibited |

**Cloudflare/R2 audio clarification:** Audio data transits Cloudflare edge as TLS-encrypted bytes en route to R2 for storage. Cloudflare edge/CDN MUST NOT log, cache, or inspect audio request/response bodies. R2 stores audio in a private bucket with mandatory signed-access URLs (no public read). This is NOT a contradiction — edge transit is permitted as encrypted passthrough; edge storage/logging/caching is prohibited.

#### learning (goal, placement, session, review card, error pattern, retest outcome)

| Provider | Transit | Storage | Processing | Telemetry |
|---|---|---|---|---|
| Cloudflare edge | allowed (TLS passthrough) | prohibited | prohibited | prohibited |
| Cloud Run | allowed | prohibited (stateless) | allowed | prohibited |
| Neon | allowed (TLS) | allowed | allowed | prohibited |
| Upstash | prohibited | prohibited | prohibited | prohibited |
| PostHog | prohibited | prohibited | prohibited | prohibited |
| Sentry | prohibited | prohibited | prohibited | prohibited |
| All others | prohibited | prohibited | prohibited | prohibited |

#### derived (metrics, aggregates, event names, counts)

| Provider | Transit | Storage | Processing | Telemetry |
|---|---|---|---|---|
| Cloudflare edge | allowed | prohibited | prohibited | allowed (R2 access metrics, CDN analytics — no learner IDs) |
| Cloud Run | allowed | prohibited | allowed | allowed (structured logs — metric only, no content) |
| Neon | allowed | allowed | allowed | prohibited |
| PostHog | allowed | allowed | allowed | allowed (subject to privacy filter: event name + aggregate value only) |
| Sentry | allowed | prohibited | allowed | allowed (error code + sanitized trace only) |
| All others | — | — | — | — |

#### system (secrets, audit records, config, service accounts)

| Provider | Transit | Storage | Processing | Telemetry |
|---|---|---|---|---|
| Secret Manager | allowed | allowed | allowed | allowed (access audit log) |
| Neon | allowed | allowed | allowed | prohibited |
| Cloud Run | allowed | prohibited | allowed | allowed (deployment logs) |
| Cloudflare | allowed (config API) | allowed (DNS/config) | allowed | allowed (admin audit log) |
| All learner/analytics providers | prohibited | prohibited | prohibited | prohibited |

### 2.2 IAM rotation schedule

| Credential type | Max lifetime | Rotation method |
|---|---|---|
| Provider API keys | 90 days | Manual rotation with deployment update |
| Database credentials | 90 days | Connection string update with zero-downtime rolling |
| Service account keys | 90 days | Workload Identity Federation preferred |
| JWT signing keys | 30 days | Automated rotation with key versioning |

### 2.3 Quota/cost operating bands (unified)

All numeric ceilings remain `unarmed` until the founder approves the numeric threshold policy
(`benchmark/numeric-threshold-policy.yaml`) after a benchmark run. The operating bands below
are design targets:

| Band | Threshold | Required response | Learner effect |
|---|---|---|---|
| `observe` | ≥ 60% of verified hard quota | Alert owner; verify current provider limit; re-check provider pricing page | None |
| `protect` | ≥ 80% | Freeze optional/batch work; reserve capacity for accepted learner work; prepare same-provider upgrade | None for admitted core flows |
| `degrade` | ≥ 90% or provider health failure | Activate documented fallback/delayed route; halt new optional work; page owner | Transparent delayed/unavailable state; draft/submission retained; no fabricated scores |
| `recover` | Post-incident | Reconcile outbox, delivery log, and cost attribution; review quota/model/provider decision | No duplicate evaluation, charge, or email |

### 2.4 SLO summary

| Service | Availability target | Latency target (p95) |
|---|---|---|
| Go API (non-eval) | 99.5% | < 500ms |
| Writing evaluation (e2e) | 99% (async) | < 5 minutes |
| Neon PostgreSQL | 99.95% (provider SLA) | < 50ms simple, < 500ms complex |
| Upstash Redis | 99.9% (provider SLA) | < 5ms |
| Cloudflare CDN | 99.9% (provider SLA) | < 100ms |
| Resend email delivery | 99.9% (provider SLA) | < 30s (magic-link) |
| DeepSeek inference | 99% (provider target) | < 10s (inference only) |

### 2.5 RPO/RTO summary

| Component | RPO | RTO |
|---|---|---|
| Neon PostgreSQL | 6 hours (free PITR) → 1 hour (paid target) | < 1 hour |
| R2 object storage | Object-level (versioned) | Immediate (provider recovery) |
| Cloud Run compute | N/A (stateless) | < 5 minutes (image rollback) |
| Upstash Redis | N/A (not source of truth; replay from outbox) | < 5 minutes |
| Resend email | Best-effort (no RPO) | Provider recovery |
| DeepSeek | N/A (outbox preserves submissions) | Provider recovery + retry |

## 3. Pre-code vs post-code evidence distinction

Every provider contract above distinguishes:

**Pre-code (design contract, this document):**
- Data classification and IAM design
- Quota/cost band targets
- SLO/RPO/RTO targets
- Exit exercise design
- Scale-up path documentation

**Post-code (requires runtime, blocked by phase gate):**
- Live SLO measurement
- Actual cost per operation
- Provider outage response time
- Exit exercise execution
- RPO/RTO validation drill
- Cache-hit rate measurement
- Thinking-mode token-count benchmark
- Peak-pricing verification

No claim in this document is runtime evidence. All numeric values are design targets until
measured in a running system.

## 4. Founder decision dependencies

The following BOPS contracts are conditional on founder decisions:

| Contract | Dependent on | Decision |
|---|---|---|
| Data classification per region | D-01 | Data residency stance |
| DeepSeek data-use terms | D-01 | Residency + submission-consent contract |
| Identity provider IAM | D-02 | OIDC provider selection |
| Cost ceilings (all providers) | D-04 | Numeric threshold approval |
| Payment provider activation | D-05 | Pricing/plan decision |

## References

- `artifacts/business/decisions/managed-platform-baseline-decision.md`
- `artifacts/business/decisions/build-buy-register.md`
- `artifacts/operations/cost-budget.md`
- `artifacts/operations/benchmark/numeric-threshold-policy.yaml`
- `artifacts/engineering/contracts/runtime/observability-slo-contract.md`
- `artifacts/engineering/contracts/runtime/provider-adapter-contract.md`
- `artifacts/engineering/contracts/runtime/api-governance-contract.md`
- `artifacts/engineering/contracts/runtime/lifecycle-contract.md`
