# LenBands

LenBands is organized by **semantic authority**, not by whichever file looks newest or most detailed.

## Start here

1. [`DOCS.yaml`](DOCS.yaml) — machine-readable authority, aliases, and agent navigation.
2. [`AGENTS.md`](AGENTS.md) — bounded agent rules.
3. Open only the canonical document that `DOCS.yaml` says owns the concern.

Do not scan the whole repository as a prerequisite to normal work.

## Repository planes

| Plane | Owns |
|---|---|
| `blueprint/` | durable product/domain invariants and IELTS framework |
| `artifacts/business/` | sourcing, market, commercial and legal decisions |
| `artifacts/experience/` | learner research and interaction specifications |
| `artifacts/engineering/` | API, data, event, failure and implementation contracts |
| `artifacts/operations/` | BOPS, quality, security, release, audit and evidence |
| `knowledge-assets/` | versioned learner-serving content |

Important current canonical contracts:

- Web API: `artifacts/engineering/api/openapi.yaml`
- Five-persona access model: `artifacts/engineering/api/access-control.md`
- Buy-first platform sourcing: `artifacts/business/decisions/platform-sourcing.md`
- BOPS: `artifacts/operations/bops/contract.yaml`
- Threat/interference model: `artifacts/operations/bops/threat-model.md`

Legacy paths are retained only when `DOCS.yaml` explicitly marks them as migration or historical inputs.

## Working rule

Create a new document only when it owns a new semantic concern. Otherwise extend the existing owner. Generated projections, indexes, research notes and provider catalogs never become competing sources of truth.
