# Durable Handoff & Reconciliation Compatibility Note

Canonical runtime authority: `artifacts/engineering/runtime-contract.yaml`.

This path no longer owns a transactional-outbox/Redis topology. It preserves the semantic problem only: a committed learner action that requires durable follow-up must not be stranded by a process or provider failure.

Required behavior:

1. Accept the domain mutation with a stable idempotency key.
2. Persist canonical domain state and a durable-operation reference atomically where the selected managed platform supports it; otherwise use the platform's reviewed durable handoff primitive with an auditable recovery path.
3. Execute through the provider-neutral durable-operation contract.
4. Reconcile accepted domain state against active/terminal operation state.
5. Repair by creating an audited recovery operation; never silently mutate an accepted evaluation.

Acceptance invariants:

- crash before/after any handoff boundary converges to one explainable state;
- duplicate handoff/delivery does not double-charge or duplicate evaluation/review effects;
- reconciliation can explain every stranded accepted submission using opaque references only;
- no custom relay, broker, outbox daemon, or Redis dependency is implied by this document.
