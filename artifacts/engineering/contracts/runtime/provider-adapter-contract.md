# Provider Adapter Contract — P0

## Boundary

Domain/application logic calls provider-neutral adapters. Provider names, model names, queue names, cache names and deployment products never become Capability IDs, event identities, failure semantics or learner-facing score meaning. Provider selection remains a sourcing/procurement decision and cannot alter evaluation semantics without benchmark/release evidence.

## Evaluation adapter interface

```yaml
evaluate_request:
  request_id: opaque-id
  submission_ref: opaque-id
  rubric_version: string
  task_version: string
  scorer_route_version: string
  required_evidence: true
  deadline_at: timestamp
  cost_bucket: writing_eval_pilot

evaluate_response:
  quality_status: accepted | low_confidence | insufficient_evidence | invalid
  delivery_state: completed | delayed | unavailable
  evaluation_ref: opaque-id | null
  rubric_version: string
  scorer_route_version: string
  model_version: string
  evidence_refs: []
  confidence_state: unknown | provisional | stronger_evidence
  usage: {input_units: integer, output_units: integer}
  provider_trace_ref: opaque-id
```

A delayed/unavailable call has no accepted learner score. Raw provider probability/confidence is never exposed as learner correctness confidence. Provider request/response bodies remain inside the privacy-scoped adapter/audit boundary; general logs retain only opaque/versioned references and governed aggregates.

## Prompt and response integrity

- Prompt instructions are fixed/versioned; learner/content text is delimited data and cannot append system instructions.
- The adapter validates normalized output against the canonical evaluation schema, rubric version, scorer-route version and task/submission provenance before domain persistence.
- Provider/model fallback for learner-visible scoring is allowed only to a benchmark-approved combination in the same scorer-route version. Otherwise return delayed/unavailable.
- A provider swap is configuration plus a reviewed adapter implementation, not a domain/API/event migration.

## Durable execution and retry

Retry ownership belongs to the canonical durable-operation contract, not to a worker process or provider SDK. The adapter performs only a bounded attempt within its supplied deadline. The orchestration boundary decides retries, deduplication and reconciliation using stable operation/idempotency identities. No Redis/queue/worker mechanism is implied.

Numeric timeout/circuit/retry values remain unarmed until backed by approved runtime/provider evidence. They are not architecture defaults.

## Security/privacy

Credentials come from a managed secret boundary and never enter the repository/client. Only the minimum assessment content required for the approved purpose may be sent to a provider. Provider payloads are treated as untrusted input and normalized before entering canonical state.

## Acceptance conditions

- Provider outage preserves submission and yields delayed/unavailable without silent scorer substitution.
- Provider swap preserves API, event, score and historical semantics.
- Cost, latency, failure class and route/model versions are attributable without retaining raw provider payload in general telemetry.
- Duplicate orchestration attempts cannot produce duplicate domain effects.
