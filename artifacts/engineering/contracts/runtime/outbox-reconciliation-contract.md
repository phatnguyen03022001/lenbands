# Transactional Outbox & Reconciliation Contract — P0

## Problem solved

There must not be a state of “submission received but evaluation never occurs” merely because the database commit succeeded before Redis publish. P0 uses a transactional outbox to connect durable domain state to the async job.

## Write protocol

```text
HTTP mutation
  → validate + idempotency lookup
  → one Postgres transaction:
       domain write / state transition
       idempotency record
       outbox record
  → commit
  → outbox relay publishes Redis Stream
  → worker durable effect
  → ack
```

| Record | Required fields |
|---|---|
| IdempotencyRecord | subject scope, operation, key hash, request hash, outcome ref/status, expires_at |
| OutboxRecord | outbox_id, aggregate type/id, job name/version, payload ref, trace ID, privacy class, available_at, publish attempts, status |
| ReconciliationRecord | subject/aggregate ref, detected state, repair action, actor, trace ID, timestamp |

## Relay and repair rules

- Relay publish is idempotent by `outbox_id`; publish acknowledgment is persisted before marking outbox delivered.
- Outbox publish error retries with bounded backoff. It does not modify accepted learner submission.
- Reconciliation periodically finds: accepted submission without terminal/active job, expired pending stream item, terminal job without expected domain state, and state transition without canonical event.
- Repair creates audited outbox/job records; never silently mutates an accepted evaluation.
- Retention of idempotency/outbox records must outlive max client retry/job deadline. Exact retention is operational configuration, recorded before pilot.

## Acceptance conditions

- Crash at each boundary (before/after DB commit, Redis publish, worker effect, ack) converges to one recoverable state.
- Duplicate relay publish/delivery does not double-charge or duplicate evaluations/review cards.
- Reconciliation can explain and repair every stranded submission without raw essay in logs.
