# API Ownership & Application Boundary

Status: **superseded compatibility contract**.

The previous design split LenBands HTTP ownership between two OpenAPI files. That structure caused authority and migration drift. The canonical contract is now:

- `artifacts/engineering/api/openapi.yaml` — all LenBands web HTTP operations;
- `artifacts/engineering/api/access-control.md` — personas, roles, entitlements and separation of duties;
- `artifacts/engineering/api/README.md` — API governance and application boundary.

The old files remain temporarily as **migration-only representations** because validators and historical artifacts still reference them:

- `artifacts/engineering/contracts/openapi.yaml`
- `artifacts/engineering/contracts/writing-task-2/openapi.yaml`

No new operation, schema, permission or deprecation rule may be added only to a legacy file.

## Target application boundary

```text
Browser
  -> same-origin Next.js web/application API
     -> managed Auth identity
     -> managed Postgres/Storage
     -> durable managed Workflow for async evaluation
     -> governed model gateway/provider adapter
```

There is no custom session exchange API and no separate Go/Python network hop by default. Provider identities remain behind adapters and BOPS.

## Migration gate

Legacy OpenAPI files can be deleted only when:

1. validators consume the canonical spec;
2. every historical operation has a canonical successor or explicit retirement;
3. inbound references are migrated or intentionally historical;
4. code generation/contract tests use only the canonical spec;
5. same-head verify/trust gates pass.

Until then they are compatibility inputs, **not parallel authorities**.
