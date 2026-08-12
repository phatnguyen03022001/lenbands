# Cloud / Platform Topology Contract — P0

## Purpose and classification

Design contract (pre-code document). Defines **provider-neutral** environment topology, trust zones,
IAM, network, DNS/WAF, secrets/KMS abstraction, Postgres/Redis/object-storage responsibility,
backup/restore, RPO/RTO targets, and DR decision points for the closed pilot. **No specific vendor is selected**;
procurement/DPA/setup is review/evidence-bound and outside this contract. Terraform/IaC is not included here
(IaC is post-code).

## 1. Environment topology (provider-neutral)

| Environment | Purpose | Data | Access |
|---|---|---|---|
| `dev` | integration testing, contract validation | synthetic/fixture only | engineer + agents |
| `staging` | pre-release validation (acceptance, benchmark, migration dry-run) | anonymized/fixture; real PII only if the founder approves it with retention | engineer + founder |
| `prod` | closed pilot | real learner data | founder/admin least-privilege; no default raw learner read |

- Each environment has its own Postgres schema/instance, Redis, and object-storage bucket. Stores are not shared across environments.
- Config promotion: `dev → staging → prod` through reviewed promotion; do not deploy laterally.
- `staging` and `prod` must have separate feature flags and kill switches (see the delivery contract).

## 2. Trust zones

```text
Internet
  │  WAF / TLS edge
  ▼
[Zone: edge]  Next.js FE + Go API public /v1/*
  │
  ▼
[Zone: app]   Go service boundary (auth, quota, idempotency, outbox)
  │
  ▼
[Zone: worker] Go workers → Python engine (EVAL/Governance), async, job-claimed
  │
  ▼
[Zone: data]  Postgres, Redis, object storage (private)
```

- Zones transfer data in one direction: edge → app → worker → data. The worker/engine must not call back into the app to execute a learner-visible side effect.
- Raw learner content (essay/audio) exists only in the `data` zone (object storage/learner-scoped service) and the `worker` zone when inference requires it; it does not enter logs/telemetry/analytics.

## 3. IAM roles (provider-neutral abstraction)

| Role | Can do | Cannot |
|---|---|---|
| `learner-service` | read/write learner-owned records, enqueue outbox | read other subjects, raw content in logs |
| `worker` | claim job, read learner-scoped content for inference, write result/idempotency | bypass quota/idempotency, publish learner-visible events on behalf of user |
| `migrator` | run reviewed migrations | alter data outside migration scope |
| `ops` (founder/admin) | read aggregate/audit, manage feature flags, run backup/restore, approve release | default read raw learner content (break-glass with policy) |
| `cicd` | build, run registered checks, promote artifacts | deploy directly to prod without release gate |

- IAM roles are an abstraction; mapping to provider-specific roles (AWS/GCP/Azure) is post-code and outside this contract.
- Least privilege: a service runs with the minimum required role; do not use one shared admin role for runtime.

## 4. Network ingress/egress + DNS/WAF

| Concern | P0 design |
|---|---|
| Ingress | Public traffic reaches only `edge` (FE + `/v1/*`). Do not expose Postgres/Redis/worker/data zones publicly. |
| TLS/WAF | TLS terminates at edge (provider-neutral: "TLS termination layer"); WAF blocks common web attacks (SQLi/XSS). Provider-specific details are selected later. |
| DNS | Canonical domain + `api.` subdomain; environment-encoded (dev/staging/prod) names do not collide. |
| Egress | Worker needs outbound access to provider inference (through the adapter); whitelist egress by provider endpoint; do not allow unrestricted egress. |
| VPC/network isolation | app/worker/data are in a private network; edge is public; use minimum security-group/network-policy controls. |

## 5. Secrets / KMS abstraction

- Secrets (provider API key, DB password, signing key) belong in **secrets manager / KMS** (provider-neutral), not in the repo, hard-coded environment variables, or artifacts/logs.
- Rotation: keys issued to workers/adapters have a rotation policy; rotation has no downtime (dual active + rollover).
- The adapter reads secrets through a secret-ref; it does not embed them in the image.
- A break-glass secret (if the founder needs one) has audit and expiry.

## 6. Data-store responsibility (provider-neutral)

| Store | LenBands owns | Managed/provider owns | P0 rule |
|---|---|---|---|
| Postgres | schema, migration, retention, encryption policy, backup schedule spec | HA, patching, infra | one primary relational store; standard dump/restore |
| Redis | job semantics, idempotency, retry, DLQ policy, cache key scope | cluster operation | Redis Streams; cache-aside; not the source of truth |
| Object storage | object key policy, retention, access control, lifecycle | durability, encryption at rest | draft/audio private by default; S3-compatible copy/export |

(Consistent with build-buy-register.md §4.)

## 7. Backup / restore design

| Store | Backup | Restore target | RPO | RTO (target) |
|---|---|---|---|---|
| Postgres | periodic snapshot + WAL/continuous | point-in-time to most recent safe | ≤ 5 min | ≤ 1 hour |
| Redis | only for job/queue metadata (canonical state is in Postgres) | rebuild from Postgres | n/a (cache/queue) | rehydrate from source |
| Object storage | replication/versioning | bucket-level restore | ≤ 15 min | ≤ 1 hour |

- The RPO/RTO values above are **design targets (pre-code)** and must be verified by a real restore drill (post-code evidence).
- Restore must not break idempotency: after restore, jobs/outbox must replay safely (outbox-reconciliation).
- The restore drill and its result are Evidence Artifacts after execution, not prose.

## 8. Disaster-recovery decision points

| Decision | Pre-code position | Evidence gate |
|---|---|---|
| Single-region vs multi-region | P0 single-region (closed pilot); multi-region deferred | volume/compliance demonstrate the need |
| RPO/RTO targets | designed in §7 | real restore drill |
| Failover | manual/founder-initiated in P0; no auto-failover | runbook + drill |
| Data residency | according to consent/privacy policy; provider region not selected | DPA/provider decision |

## 9. Non-goals

- Do not select a vendor, use Terraform/IaC, or deploy cloud resources (post-code).
- Do not claim that HA/backup/DR is operational; that is post-code evidence.
- Do not establish a raw learner content policy that conflicts with the privacy contract.

## Acceptance (design)

- [ ] Each environment has separate stores and clear promotion.
- [ ] Trust zones are one-way edge→app→worker→data.
- [ ] IAM roles are least-privilege; no shared admin role.
- [ ] Secrets are in KMS/secrets-manager with a rotation policy, not in the repo/logs.
- [ ] Backup/restore design + RPO/RTO target are declared; do not claim they have run.

## References

- `artifacts/business/decisions/build-buy-register.md` §4 (infra ownership)
- `artifacts/engineering/contracts/runtime/outbox-reconciliation-contract.md`
- `blueprint/02-architecture.md` § Cross-cutting infra
- `blueprint/07-conventions.md` § Data Privacy / Runtime contract
