# Operations Artifacts

The operations lens owns how LenBands runs safely, maintains quality, controls cost, and supports recovery/rollback.

| Folder / artifact | Content |
|---|---|
| root | cost budget, release gate, benchmark, readiness matrix, workflow/runbook |
| `decisions/` | operational/governance ADR |
| `evidence/` | immutable license, permission, run, release, or incident proof |
| `catalogs/` | generated projection/index; not the SSOT |
| `spawn-prompts/` | workflow artifacts for agents that create Knowledge Assets; registry/validator required |
| `benchmark/` | gold-corpus intake, numeric policy, and benchmark runner contract |
| `acceptance/` | P0 runtime acceptance manifest and immutable run boundary |

Operations does not change product behavior or HTTP/data semantics directly. When they need to change, open a decision/contract in Business, Experience, or Engineering according to canonical ownership.
