# Runtime Contract Pack — P0

These contracts are shared standards for every P0 slice with an HTTP mutation, cache, async job, or provider call. They are not executable Source Code, Terraform, or Redis configuration.

| Contract | What it governs |
|---|---|
| `async-job-worker-contract.md` | Delivery at-least-once, idempotency, Redis Streams, retry/DLQ/replay |
| `cache-contract.md` | Scope, key, TTL, invalidation, cache failure, and privacy |
| `api-governance-contract.md` | HTTP version, auth, errors, idempotency, compatibility |
| `outbox-reconciliation-contract.md` | No job loss between database commit and enqueue |
| `observability-slo-contract.md` | Trace, redaction, SLO, alert, incident evidence |
| `provider-adapter-contract.md` | Provider-neutral inference, timeout, circuit/fallback, audit |
| `llm-routing-context-contract.md` | P0 LLM route, context boundary, token envelope, structured output, and cost/quality guard |
| `api-ownership-bff-contract.md` | Canonical API ownership/version/deprecation + BFF/server-client boundary (pre-code design) |
| `cloud-platform-topology-contract.md` | Provider-neutral env topology, trust zones, IAM, network, DNS/WAF, secrets/KMS, backup/restore, RPO/RTO, DR (pre-code design) |
| `sre-delivery-security-contract.md` | Incident/runbook taxonomy, alert ownership, redaction/audit, CI/CD gates, provenance, SCA, migration, config, flag/kill-switch/rollback (pre-code design) |
| `runtime-baseline-config.yaml` | Versioned P0 values for rate limit, retry, worker, circuit, cache, and retention |

The final three contracts are **pre-code design contracts** (Batch 5): they define canonical ownership/design and do not claim that runtime has run. Execution, benchmarking, acceptance, restore drills, and SCA scans are post-code evidence gates.

Current status: contracts with sufficient content are in `review`; `runtime-baseline-config.yaml` remains `draft` because its values are safe starting assumptions. No contract is inferred to have run correctly outside runtime; approval and acceptance evidence remain separate gates.
