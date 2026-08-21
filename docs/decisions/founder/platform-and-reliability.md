# Platform and Reliability Decisions

STATUS: SUPPORTING
ROLE: FOUNDER DECISION HISTORY
AUTHORITY: NONE

Source authority at lock time: `A1_FOUNDER_SELECTED_UNRECORDED`.

This file normalizes the 64 founder decisions from V1, V2, V5, V7, and V8. Later repository sourcing decisions may supersede provider-specific directions while preserving the underlying founder principles.

## V1 — Cloud and infrastructure principles

| ID | Decision | Rationale |
|---|---|---|
| V1.1 | No hard data-residency requirement for early stage; Vietnam is the main initial market. | Avoid blocking pilot architecture before a verified legal/contractual residency requirement exists; still require privacy/legal review before activation. |
| V1.2 | First 6–12 month market primarily Vietnam. | Product, latency and support decisions should reflect the actual early market. |
| V1.3 | Managed vs self-hosted chosen per economics and quality. | Avoid ideological provider choices; use managed services where they reduce ops without failing portability/quality. |
| V1.4 | Hybrid vendor strategy: fewer vendors for core, flexibility for peripherals. | Reduce core operational blast radius without forcing inefficient consolidation. |
| V1.5 | Re-evaluate primary compute from scratch; do not inherit Cloud Run automatically. | Provider selection must follow current workload, cost, reliability and exit evidence. |
| V1.6 | PostgreSQL is the long-term canonical datastore. | Standards, relational integrity, migrations, backup/restore and provider exit are stronger than proprietary data models. |
| V1.7 | Closed-pilot core recovery target roughly <15 min; accepted learner submissions must not be lost. | Protect learner trust and durable work without active-active infrastructure. |
| V1.8 | Near-zero non-AI infra where practical; spend when reliability/quality/usage proves value. | Preserve runway while explicitly allowing stateful reliability spend. |
| V1.9 | Design initially for ~2,000–3,000 learners; later early-scale discussion extends planning to ~3,000–5,000, without a new exact canonical threshold. | Avoid both toy architecture and premature hyperscale design. |
| V1.10 | Mandatory portability boundaries: Database + AI + Identity. | These are the most strategically costly lock-in boundaries. |
| V1.11 | Privacy/legal/data safety are hard minimums; among eligible options prioritize reliability → cost → portability → speed. | Safety/quality must not become tradeable score components. |
| V1.12 | Production-shaped from the start, but do not overbuild. | Preserve operational discipline and migration paths while avoiding Kubernetes/microservice theater. |

## V2 — Runtime topology and reliability

| ID | Decision | Rationale |
|---|---|---|
| V2.1 | Accepted submissions use commit-before-ACK semantics. | A learner-visible success must correspond to durable application state. |
| V2.2 | AI outage → persist/queue/delay; fail over only to a pre-approved equivalent route. | Availability cannot silently lower scoring/evidence quality. |
| V2.3 | Environments: local + staging + production. | Separate testing and release risk without creating unnecessary environment sprawl. |
| V2.4 | PostgreSQL PITR required. | Recovery must cover operator/application failures beyond logical dumps. |
| V2.5 | General disaster RPO planning band ~15–60 min; accepted submission has stronger durability at commit boundary. | Separate disaster recovery objectives from no-loss accepted-work semantics. |
| V2.6 | Audio is ephemeral-by-default unless a future explicit retained-recording policy is approved. | Minimize sensitive-data retention and storage cost while preserving feedback/recovery paths. |
| V2.7 | Critical infrastructure as code; peripheral dashboard configuration may remain manual. | Audit and portability matter most on critical infrastructure; avoid ceremony for low-risk settings. |
| V2.8 | Cheaper/lower-reliability provider allowed only with an adequate recovery/fallback path and unchanged quality floor. | Cost may not create silent correctness degradation. |
| V2.9 | Portable compute; production may remain single-cloud. | Portability is required; active multi-cloud is not. |
| V2.10 | Moderate ops complexity may be accepted to save cost when reliability/maintainability remains justified. | Optimize total operating economics, not vendor count alone. |

## V5 — Data, storage, queue, and backup

| ID | Decision | Rationale |
|---|---|---|
| V5.1 | PostgreSQL owns canonical structured product/domain state. | One relational authority simplifies integrity, migrations and recovery. |
| V5.2 | Analytics may be logically separate but never owns canonical product facts. | Analytic convenience must not redefine learner state. |
| V5.3 | Redis outage must not break critical correctness; DB-backed critical flows continue. | Cache/dispatch is disposable relative to canonical state. |
| V5.4 | Transactional PostgreSQL outbox + dispatch layer. | Persist business state and publication intent atomically. |
| V5.5 | Worker death → automatic retry. | Async evaluation must recover from ordinary worker failure. |
| V5.6 | Retries are bounded, classified transient/permanent/ambiguous, idempotent and cost-aware. | Prevent retry storms, duplicate charges and false recovery. |
| V5.7 | One private object store with policy namespaces. | Keep storage operationally simple while separating retention/access rules. |
| V5.8 | PITR + daily independent logical backup. | Provider-native recovery plus provider-independent exit/recovery copy. |
| V5.9 | Independent backup must be outside the DB provider. | A provider incident must not destroy both primary and only backup. |
| V5.10 | Automated restore verification + periodic full disaster drill. | Backup existence is not recovery evidence. |
| V5.11 | Minimal analytics/structured events; no raw-content firehose. | Protect privacy and reduce unnecessary observability cost. |
| V5.12 | Derived progress/results long-lived; raw/intermediate learning data short-lived/adaptive. | Data retention follows learning value and sensitivity. |
| V5.13 | Persist state + outbox transaction before publication; broker is not authority. | Messaging failure must not erase accepted product facts. |
| V5.14 | Restore must reapply deletion semantics; deleted media/content must not become immortal through backups. | A restore cannot resurrect user-deleted data into normal product use. |

## V7 — Provider architecture selection

These 12 rows were founder-selected directions with independent lifecycle/activation gates. The original V7 table used boundary names rather than numeric row IDs.

| Boundary | Founder decision/direction | Lifecycle at lock time | Rationale |
|---|---|---|---|
| Identity | Auth0 | ACTIVATION_BLOCKED | Managed credential boundary; identity portability retained through internal learner ID and standards/exit requirements. |
| API / evaluation workers | Cloud Run in Singapore | PENDING_RECONCILIATION / benchmark before final provisioning | Container portability, scale-to-zero economics and single-region simplicity. |
| Frontend | Next.js on Cloudflare Workers/OpenNext; static-first/edge-first | PENDING_RECONCILIATION | Avoid first-page dependence on scale-to-zero backend; dynamic Next.js belongs on Workers/OpenNext rather than treating Pages as universal SSR host. |
| Region | Singapore for compute + Postgres | BENCHMARK_REQUIRED | Colocate API/DB hot path; exact latency numbers are not canonical until measured. |
| Postgres | Neon PostgreSQL | ACTIVATION_BLOCKED | Standard PostgreSQL, low early cost, PITR/branching convenience behind an exit boundary. |
| Independent backup | Neon PITR + encrypted logical backup outside Neon, currently R2 direction | ACTIVATION_BLOCKED | Provider-independent recovery and exit path. |
| Object storage | Cloudflare R2 | ACTIVATION_BLOCKED | Private S3-compatible storage and favorable early egress economics. |
| Redis | Do not provision initially; Postgres outbox first | PENDING_RECONCILIATION | YAGNI; Redis is not authority and should enter only after measured throughput need. |
| Admin auth | Same IdP may be used with separate application/policy boundary; new-device email OTP | ACTIVATION_BLOCKED | Separate privileged boundary without unnecessary second identity vendor. |
| Staging | Scale-to-zero; separate DB branch/project | PENDING_SPEC | Production-shaped validation at low standing cost. |
| IaC | OpenTofu/Terraform for critical infra | PENDING_SPEC | Portability/auditability with low proprietary coupling. |
| Provider rule | Measured total-cost scorecard after eligibility; no fixed `$10` rule | LOCKED_FOR_DESIGN | Avoid choosing on free-tier headlines or arbitrary price deltas. |

Historical lock-in language: **critical data/domain contracts are portable; provider-specific operational conveniences are allowed behind explicit exit boundaries.**

The provider selections above are historical founder directions and are **not** current provisioning authority. See `../repository/platform-sourcing.md` for later sourcing changes.

## V8 — Observability, recovery, and security operations

| ID | Decision | Rationale |
|---|---|---|
| V8.1 | Severity-based escalation (`C`). | Operational response should reflect user/data/security impact rather than alert every issue equally. |
| V8.2 | PostHog-first observability; Sentry supplementary only when needed (`B`). | Minimize vendor/telemetry duplication while retaining an escalation path. |
| V8.3 | Adaptive log retention (`D`). | Security/audit and ordinary application telemetry have different retention needs. |
| V8.4 | Privileged admin audit log (`A`). | Privileged changes require accountable history independent of product analytics. |
| V8.5 | Staging auto-deploy; production manual approval during early stage (`B`). | Preserve fast feedback while protecting production during immature release evidence. |
| V8.6 | Auto rollback for clear technical failure; controlled/manual handling for semantic/data issues (`C`). | Automatic downgrade scripts can worsen schema/data incidents. |
| V8.7 | Expand/contract migrations (`C`). | Maintain backward compatibility across releases and avoid destructive coupled deploys. |
| V8.8 | Weekly restore verification + quarterly full disaster drill (`B`). | Continuous recoverability evidence without daily full-drill burden. |
| V8.9 | Fallback only for critical boundaries (`B`). | Avoid hot-fallback theater on every provider. |
| V8.10 | Provider exit test (`A`). | Portability must be exercised, not merely documented. |
| V8.11 | Limited risky-feature flags (`A`). | Enable staged release/rollback for evaluator, provider route, scoring, audio and pricing/quota policy. |
| V8.12 | Emergency kill switches (`A`). | Risky runtime paths must be stoppable without ordinary code deploy latency. |
| V8.13 | Subsystem-aware degraded/maintenance mode (`C`). | Keep safe product surfaces available while blocking unsafe writes. |
| V8.14 | Incident runbook by incident/secret class (`C`). | Credential leak, provider outage and data incidents require different actions. |
| V8.15 | Immediate production deletion + immutable backup + tombstone replay (`A/C hybrid`). | Respect deletion in live product without corrupting immutable recovery copies. |
| V8.16 | Internal status dashboard during closed pilot (`B`). | Public status infrastructure is unnecessary before public scale. |

## Traceability and supersession

Original founder source: `artifacts/operations/decisions/lenbands-decision-register-v1.0.0-founder-locked-2026-08-12.md`.

Known later repository-level sourcing direction consolidates the managed platform and supersedes the V7 provider-sprawl topology for new design work. It does not erase the durable principles in V1/V2/V5/V8: canonical PostgreSQL state, commit-before-ACK, portability boundaries, recoverability, provider eligibility before cost, bounded retries, restore testing, and safe degraded operation.