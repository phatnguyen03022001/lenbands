# Repository Baseline — Authority Drift

Generated/recorded baseline findings requiring resolution before registry freeze.

| Finding | Severity | Evidence | Disposition |
|---|---|---|---|
| Family Registry currently points `owner_spec` to vertical slices rather than dedicated Owner Runtime Specs | P1 | `artifacts/operations/capability-family-registry.yaml` | fix before Phase 5 completion |
| Family Registry and Delta Registry scope authority must remain limited to implementation identity/variation | P1 | registry headers + architecture freeze | enforce with validator |
| Capability phase projection uses P0/P1/P2/deferred rather than normalized lifecycle | P1 | `capability-phase-index.md` | normalize in lifecycle registry |
| Existing runtime/API coverage is Writing-centric | P1 | runtime inventory and artifact coverage baseline | truthful; do not upgrade without contracts |
| Generated catalog projections are not capability implementation definitions | P1 | capability index/phase index headers | preserve projection label |
