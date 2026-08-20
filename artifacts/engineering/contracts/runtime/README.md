# Runtime Derived Contracts — P0

This folder is an implementation-detail index, not a runtime authority.

Read canonical owners first:

1. `artifacts/engineering/runtime-contract.yaml` — durable execution, persistence, intelligence/provider/time/reproducibility invariants.
2. `artifacts/engineering/api/` — HTTP operations, schemas, types, access and API policy.
3. `artifacts/operations/bops/contract.yaml` — security/incident/support/recovery/experiment controls.
4. `artifacts/engineering/data-migration-contract.yaml` — schema/backfill/projection migration rules.
5. `artifacts/business/decisions/platform-sourcing.md` — managed build/buy/provider boundary.

Files in this folder may only specialize one unique implementation boundary. They cannot introduce a second lifecycle, API, topology, authorization model or infrastructure requirement.

| Derived contract | Unique purpose |
|---|---|
| `failure-taxonomy-contract.md` | internal technical failure classes → learner-safe public recovery codes; explicitly separate from result validity |
| `provider-adapter-contract.md` | bounded provider execution, candidate payload and independently recorded runtime provenance |
| `llm-routing-context-contract.md` | minimum-context inference routing, deterministic preflight, quality/cost boundary |
| `observability-slo-contract.md` | mechanism-neutral runtime signals, redaction and candidate SLO semantics |
| `runtime-baseline-config.yaml` | unarmed candidate runtime values; not architecture defaults |
| `api-governance-contract.md` | compatibility notes derived from canonical API policy; it cannot override `artifacts/engineering/api/` |

Compatibility notes for async workers, cache, outbox and cloud topology are being retired. Their surviving semantics already live in the canonical runtime/sourcing/BOPS contracts. Do not infer Redis, queues, worker fleets, caches, Go/Python services, VPCs or any provider product from historical paths or Git history.

## Creation rule

Add a new runtime-derived document only when all are true:

- a concrete implementation boundary exists;
- no canonical owner already owns the semantic field;
- the document reduces implementation invention rather than duplicating architecture;
- its lifecycle metadata and consumer are explicit;
- a validator/acceptance boundary can detect drift where material.

Otherwise deepen the existing canonical owner.
