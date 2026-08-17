# Cloud / Platform Topology — Compatibility Projection

Canonical authorities:

- runtime invariants: `artifacts/engineering/runtime-contract.yaml`
- build/buy and provider candidates: `artifacts/business/decisions/platform-sourcing.md`
- business/security operations: `artifacts/operations/bops/contract.yaml`
- data retention: `artifacts/operations/data-retention-registry.yaml`

This document is retained for migration only. It does not define a Go API, Python worker, Redis, VPC, KMS product, queue, or cache as mandatory topology.

## Provider-neutral trust zones

```text
browser
  -> managed web/application boundary
  -> managed identity + authorization enforcement
  -> canonical relational/object state
  -> managed durable operation when work outlives the request
  -> external provider adapters when required
```

The arrows describe trust/data-flow boundaries, not deployable services. A managed platform may collapse multiple boxes when isolation, authorization, observability, backup, and exit requirements remain satisfied.

## Environment invariants

`dev`, `staging`, and `prod` have isolated credentials and data. Production learner data is not copied to lower environments by default. Promotion is reviewed and versioned; runtime configuration is not an authority for product semantics.

## Security invariants

- public ingress reaches only the reviewed application boundary;
- database/storage service credentials and bypass-RLS/service-role credentials are server-only;
- secrets are managed outside repository/config APIs and rotated under provider capability;
- raw C1-C4 data is minimized according to the retention registry;
- provider egress is bounded to required adapters when the selected platform supports egress policy;
- backup/restore, RPO/RTO, region, DPA and residency claims remain evidence/procurement gates until tested.

## Sourcing rule

Choose the smallest managed composition that satisfies the canonical contracts. Do not reproduce infrastructure abstractions merely to match an older diagram. A dedicated service, queue, cache, broker, worker fleet, VPC, or self-managed component requires an evidence-backed blocker and a reviewed sourcing exception.
