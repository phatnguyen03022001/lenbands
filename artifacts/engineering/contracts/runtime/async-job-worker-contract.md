# Async Job & Worker Contract — P0

## Scope

Applies to `EVAL.Writing`, quality/benchmark batches, and every Go → Python heavy workload. P0 uses **Redis Streams consumer groups**; Kafka is outside this contract.

## Delivery model

- Queue delivery is **at-least-once**.
- Domain effect must be exactly-once *by idempotency key*, not by the number of times a worker receives a message.
- Producer does not put raw essay/audio into the stream. Payload contains only opaque refs and privacy class; the worker reads raw content through a learner-scoped service when needed.

## Job envelope

```yaml
job_id: uuid
job_name: writing_evaluation
job_version: 1
idempotency_key: opaque-string
causation_id: submission_id
trace_id: opaque-trace-id
producer: submission_service
subject_ref: opaque-user-id
privacy_class: assessment
payload_ref: submission_id
created_at: timestamp
not_before: timestamp
deadline_at: timestamp
attempt: 1
max_attempts: 2
cost_bucket: writing_eval_pilot
```

`job_name + job_version` is the contract identity. Changing payload semantics requires increasing the version or creating a new job; old workers must not guess new fields.

## State and acknowledgement

```text
outbox_pending → stream_pending → claimed → processing
                                         ├→ succeeded
                                         ├→ retry_scheduled
                                         ├→ dead_lettered
                                         └→ cancelled
```

- Producer writes the outbox in the same transaction as the domain write; the relay then publishes to the stream.
- Consumer claims a message through a consumer group. Ack **after** the durable domain effect/idempotency record is committed.
- A message idle longer than `worker_lease_timeout` in Runtime Baseline Configuration may be reclaimed by another worker. Reclaim must check the idempotency record before the side effect.
- `succeeded`, `dead_lettered`, `cancelled` are terminal. Do not manually republish a terminal job; replay creates a new job with `replay_of` and a new key.

## Retry, DLQ, and concurrency

| Rule | P0 policy |
|---|---|
| Retryable | timeout, transient provider/network, worker crash before durable effect |
| Non-retryable | validation, entitlement/quota denied, task retired, privacy policy denied |
| Backoff | 30s with jitter; must not exceed `deadline_at` (2 × 75s + 30s remains within the 300s baseline) |
| Max attempts | 2; each worker attempt makes at most 1 provider call |
| DLQ | record reason class, last trace, attempt count, subject ref; no raw learner content |
| Replay | operator action has an audit record; runs through idempotency/preflight as a new job |
| Concurrency | by `job_name` + cost bucket in Runtime Baseline Configuration; quota check before provider call |
| Cancellation | only before provider call or at a safe checkpoint; do not roll back an accepted evaluation |

## Threat model — async evaluation boundary (M12)

| Asset | Threat | Control (P0) |
|---|---|---|
| Go → Python trust boundary | Worker receives or executes untrusted payload; a tampered stream message drives a side effect | Worker validates job envelope (`job_name + job_version`, `privacy_class`, `deadline_at`), idempotency key before side effect; ack only after durable effect; raw content read via learner-scoped service, not from stream |
| Untrusted learner content in worker | Essay/audio text injected into prompt path or telemetry | Worker sends only required submission ref to adapter; raw text never written to job stream, DLQ or logs; redaction acceptance (WR-06) |
| Payload integrity | A message replayed or reordered duplicates an evaluation/charge | Idempotency key + causation_id + replay creates new job with `replay_of`; terminal jobs not republished manually |
| Worker crash mid-effect | Duplicate visible result after reclaim | Reclaim checks idempotency record before side effect; commit-before-ack ordering |
| Provider boundary | Worker forwards provider failure/tampering into domain | Adapter handles provider concerns (see provider-adapter-contract.md); worker only owns retry/state, never fabricates score |

This section is threat-model prose keyed to the async boundary; it is not a security validation or evidence run.

## Acceptance conditions

- Duplicate delivery creates at most one accepted evaluation, one review card set, and one quota charge.
- A worker dying after provider return but before ack does not create a duplicate visible result/charge.
- A job reaching its deadline goes to DLQ or a clear terminal failure; the learner submission remains retained.
- Worker lag, DLQ size, reclaim count, attempts, and cost are traced/alerted under the Observability contract.
