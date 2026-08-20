# Catalogs

Catalogs are derived navigation/projection surfaces, never independent semantic authority. A maintained catalog must declare `generated_from`, `generated_at`, and `schema_version`, and its source owner must be identifiable from `DOCS.yaml` or the sibling metadata.

Rules:

- Prefer deterministic generated projections over manually copied inventories.
- Do not keep one-off executor dossiers, certification ledgers, migration snapshots, or review packets in this folder; Git history is the archive for completed process artifacts.
- A `sample_not_generated` artifact is a design sample only and must not become a build input, readiness claim, or evidence source.
- `capability-phase-index.md` is a phase projection; a deferred capability is not active implementation scope.
- `artifacts/operations/capability-manifest.yaml` remains the typed P0 projection seed and does not override Blueprint capability identity or canonical runtime/API owners.
- If a catalog cannot be regenerated or validated from current owners, retire it rather than maintain a second source of truth by hand.
