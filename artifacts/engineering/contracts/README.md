# Engineering Contracts

An engineering contract is an implementation agreement derived from a Blueprint capability ID and a runtime contract. Do not create a contract until a specific build-ready boundary exists.

| Contract | Create when | Required references |
|---|---|---|
| OpenAPI | HTTP boundary/service is approved | capability ID, event/failure behavior, version |
| Event schema | event producer/consumer is approved | `blueprint/03-features.md` Event Contract |
| Failure schema | service failure behavior is approved | `blueprint/06-engines.md` Failure Contract |
| Data contract | entity lifecycle/storage boundary is approved | capability ID, privacy class, migration strategy |
| Prompt specification | AI workflow is approved | workflow ID, evaluation/quality gate, cost budget |
| Runtime job / worker | asynchronous side effect or Go → Python boundary is approved | job identity, idempotency, retry/DLQ, owner, cost/privacy scope |
| Cache | data/result is cached | source of truth, key scope, TTL, invalidation, failure behavior |
| API governance | multiple HTTP contracts share one lifecycle | auth, error envelope, versioning, rate limit, compatibility |
| Outbox / reconciliation | a domain write must trigger async work | atomic dispatch, deduplication, replay, repair |
| Observability / SLO | a learner outcome depends on runtime reliability | redaction, traces, SLO, alert, runbook |
| Provider adapter | a provider may be replaced or dual-run | neutral interface, timeout, circuit/fallback, audit version |
| Runtime slice specification | a capability needs multiple contracts connected into an implementable flow | actors, orchestration, state machine, recovery, entity relation, acceptance IDs |
| Multi-skill practice runtime | Listening/Reading/Speaking/Pronunciation/Mock share an attempt but differ in scoring/input | practice modes, stimulus/audio/session state, evaluation boundary, recovery, acceptance |

P0 runtime contracts are in `runtime/`. They are the shared foundation for vertical slices; each slice only adds its own extension and must not create conflicting semantics.

Runnable Go/Python/Next.js implementations and actual tests belong to Source Code when the implementation plane is created. This folder only holds shared contracts/specifications, not a competing implementation.
