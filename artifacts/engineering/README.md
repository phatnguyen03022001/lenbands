# Engineering Artifacts

The engineering lens owns implementation boundaries that can be coded and tested; it does not own learner-facing product semantics or production evidence.

| Folder | Content |
|---|---|
| `decisions/` | technical ADR, platform boundary, repository/runtime architecture |
| `contracts/` | OpenAPI, data/event/failure/evaluation, runtime/cache/job/outbox/LLM/provider contracts |

Every engineering artifact traces to a Capability ID. Code is a separate implementation plane; benchmark/release/incident evidence belongs to Operations.
