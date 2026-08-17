# Async Execution Compatibility Note

Canonical runtime authority: `artifacts/engineering/runtime-contract.yaml`.

This path is retained only for inbound references during migration. Redis Streams, consumer groups, Go→Python workers, DLQs, and a custom worker fleet are **not** LenBands architecture requirements.

Preserved invariants:

- work that must outlive an HTTP request uses the canonical `durable_operation` state machine;
- transport may be at-least-once, while domain effects are exactly-once by stable idempotency;
- retry ownership exists at one layer only and is bounded by an absolute deadline;
- raw essay/audio/transcript/prompt/provider payload never enters handoff metadata, logs, or a DLQ;
- completion is recorded only after the durable domain effect is committed;
- replay creates a new audited operation and does not mutate a terminal result;
- the implementation mechanism is selected by the sourcing decision and may be a managed durable workflow, managed queue, or equivalent adapter.

Do not implement Redis Streams or a worker service from this compatibility file. New implementation work reads the canonical runtime contract first.
