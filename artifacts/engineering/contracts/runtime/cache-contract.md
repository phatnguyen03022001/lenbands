# Cache Contract — P0

## Invariants

- Postgres/runtime service is the canonical source; cache is derived acceleration only.
- Cache outage/miss/eviction does not change entitlement, evaluation result, review due time, or draft durability.
- Do not put raw essays, recordings, provider payloads, secrets, or hidden reasoning into shared cache.
- Private response keys always include subject scope; do not use email/name/raw user ID in a key.

## Key format and classes

```text
lb:{environment}:{contract_version}:{class}:{subject_scope}:{resource_version}:{normalized_input_hash}
```

`subject_scope` is `public` or an opaque subject ID. `normalized_input_hash` must be created after redaction/canonicalization, and the original input must not be logged.

| Class | Example | TTL P0 | Invalidation | Rule |
|---|---|---:|---|---|
| public_read | published writing-task metadata | 1h | publish/unpublish/task version | stale for at most 5 minutes when source is healthy |
| private_read | learner submission status | 30s | write/evaluation state transition | owner scope required |
| deterministic_compute | daily-plan candidate / FSRS forecast | 5m | state/algorithm version change | recompute from source on miss |
| model_result | immutable accepted evaluation summary | 24h | rubric/model/evaluation version change | cache accepted result only; do not cache raw provider response |
| negative_read | unavailable published task | 30s | publish event | do not cache permission/quota denial |

## Read/write behavior

1. Read cache-aside; validate scope/version before return.
2. Mutation commits canonical state first, then invalidates/publishes cache invalidation through the outbox.
3. Single-flight by full key to avoid stampede. If no lock exists, the request reads the source instead of waiting indefinitely.
4. Do not cache 5xx exceptions. Negative-cache only public 404 under the TTL above.
5. Cache entry contains `schema_version`, `source_version`, `written_at`, `expires_at`; ignore entries missing a field.

## Acceptance conditions

- User A cannot read User B's cached response even when resource/version matches.
- Publish/unpublish or accepted evaluation does not serve data staler than policy allows.
- Redis flush increases latency/recompute only; it does not lose draft/result/schedule or change entitlement.
- Cache hit/miss/eviction/stampede fallback is measurable; do not log raw content.
