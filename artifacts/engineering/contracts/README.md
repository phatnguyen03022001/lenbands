# Engineering Contracts

Engineering contracts are **scoped implementation agreements derived from canonical product/domain/runtime owners**. They are not a second architecture layer.

Before adding a contract, read `DOCS.yaml` and ask whether an existing canonical owner already owns the field. If yes, deepen that owner or add only a narrow derived specialization with an explicit consumer.

| Contract kind | Create only when | Canonical authority it consumes |
|---|---|---|
| HTTP/API specialization | never as a second OpenAPI; add operations/schemas to canonical API | `artifacts/engineering/api/` |
| Event schema | a concrete producer/consumer boundary exists | capability + owning domain lifecycle + privacy/runtime rules |
| Failure specialization | a slice needs recovery behavior beyond shared taxonomy | `runtime/failure-taxonomy-contract.md` + API failure projection |
| Data contract | a concrete entity/storage/evidence boundary exists | capability + retention + migration + runtime |
| Prompt/scorer specification | inference is materially required and quality can be validated | evaluation contract + benchmark + provider adapter |
| Durable-operation specialization | a concrete operation must outlive request lifetime | `artifacts/engineering/runtime-contract.yaml` |
| Observability specialization | generic signals cannot express a concrete learner-critical boundary | runtime + BOPS + observability derived contract |
| Runtime slice specification | several existing contracts must be connected into one implementable vertical flow | canonical API/runtime/domain contracts |

## Rules

- No Go/Python/Redis/queue/cache/service topology is assumed by this folder. Mechanisms are selected by sourcing/runtime evidence.
- A cache, queue, worker or dedicated service requires a measured/semantic need; the presence of a historical contract path is not justification.
- Do not create another cross-entity lifecycle authority. Operation lifecycle, result validity, retention and family-specific states remain with their registered owners.
- Do not create another access/auth scope vocabulary. `artifacts/engineering/api/access-control.md` owns web/internal authorization semantics.
- Do not create another OpenAPI or request/response schema registry.
- Model/provider output is candidate data until adapter/domain validation; prompts/providers never own product truth.
- A derived contract should be deleted when its unique semantic/implementation purpose is absorbed by a canonical owner and no executable consumer remains.
- Git history is the archive for retired proposal/migration/review packets.

Source implementation and executable tests belong in the application workspace once the target family is implementation-eligible and externally authorized. This folder exists to reduce implementation invention, not to maximize document count.
