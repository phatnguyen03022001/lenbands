# Technology Boundary — Buy-first

This file is retained as a compatibility pointer. Technology selection is now owned by:

- `artifacts/business/decisions/platform-sourcing.md` — build/buy and provider baseline;
- `artifacts/operations/bops/contract.yaml` — runtime/security/provider controls;
- `artifacts/engineering/api/openapi.yaml` — application HTTP contract.

## Default implementation shape

```text
Next.js / TypeScript
  + managed web functions/workflows
  + managed Postgres/Auth/Storage
  + managed model gateway
```

Do not create a separate Go or Python production service merely because older architecture documents listed one. A new runtime/language/service needs a measured blocker and an ADR showing why the managed composition cannot satisfy the contract.

Python remains permitted for offline evaluation research, benchmark/statistics, or a future specialized workload when evidence justifies it.

## Dependency policy

Prefer:

1. platform/runtime primitive already purchased;
2. maintained library;
3. thin provider adapter;
4. small custom implementation;
5. new service/framework only as last resort.

A dependency is accepted only when it removes more operational/semantic complexity than it adds. Library catalogs are recommendations, not architecture authority.
