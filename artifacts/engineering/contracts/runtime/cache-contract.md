# Cache Compatibility Note

Canonical runtime authority: `artifacts/engineering/runtime-contract.yaml`.

Cache is **disabled by default**. This path is retained for inbound-reference compatibility and does not authorize Redis, Valkey, or any dedicated cache service.

A cache may be introduced only after measured latency/cost evidence and a reviewed invalidation model show that primary managed storage is insufficient. When enabled, these invariants apply:

- cache is derived acceleration, never the source of truth;
- cache outage/miss/eviction changes latency only, never authorization, entitlement, score, review due time, or draft durability;
- private keys are subject-scoped and contain no email/name/raw learner content;
- raw essays, recordings, transcripts, provider payloads, secrets, and hidden reasoning are forbidden;
- mutation commits canonical state before invalidation;
- permission/quota denial is never cached as reusable authorization state;
- every cache policy has an owner, evidence ref, TTL/invalidation rationale, and rollback-to-no-cache test.

Do not provision a cache because this compatibility file exists.
