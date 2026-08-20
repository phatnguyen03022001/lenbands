# Provider Adapter Contract — P0

## Boundary

Domain/application logic calls provider-neutral adapters. Provider names, model names, queue names, cache names and deployment products never become Capability IDs, event identities, failure semantics or learner-facing score meaning. Provider selection remains a sourcing/procurement decision and cannot alter evaluation semantics without benchmark/release evidence.

The adapter executes a bounded provider call and returns an **untrusted candidate payload plus runtime execution provenance**. It does not decide `result_validity`, readiness, mastery, authorization or learner-facing score truth.

## Evaluation adapter interface

```yaml
evaluate_request:
  request_id: opaque-id
  submission_ref: opaque-id
  task_version: string
  rubric_version: string
  scorer_route_version: string
  prompt_template_id: string
  prompt_hash: string
  deadline_at: timestamp
  cost_bucket: writing_eval_pilot
  bounded_payload_ref: opaque-private-ref

evaluate_response:
  execution_outcome: succeeded | transient_failure | permanent_failure | deadline_exceeded
  candidate_payload: structured_candidate | null
  runtime_provenance:
    provider_id: string
    model_id: string
    provider_execution_ref: opaque-id
    started_at: timestamp
    completed_at: timestamp | null
    usage:
      input_units: integer
      output_units: integer
```

`candidate_payload` follows the scorer specialization, for example `writing-task-2/evaluation-contract.md`: criterion `band_candidate`, evidence refs, insufficiency/integrity signals and optional restricted raw-confidence data. The provider/model does not self-assert `provider_id`, `model_id`, route identity, prompt hash or result validity inside generated content; the adapter/runtime supplies those independently.

A failed/deadline-exceeded call produces no admitted learner result. Raw provider probability/confidence is never exposed as learner correctness confidence. Provider request/response bodies remain inside the privacy-scoped adapter boundary; general telemetry retains only opaque/versioned references and governed aggregates.

## Domain handoff

After a successful provider execution:

1. validate candidate structure against the scorer contract;
2. bind runtime provenance, task/rubric/prompt/route identity independently of generated fields;
3. validate cited evidence against deterministically supplied learner-owned evidence refs;
4. apply uncertainty/disagreement/integrity policy;
5. escalate only when a governed policy requires an independent approved route;
6. normalize into an immutable domain result;
7. assign `result_validity` in the owning domain, never in the provider adapter.

The adapter must never emit legacy `quality_status`, `low_confidence`, `confidence_state` or transport/result hybrid states as product truth.

## Prompt and response integrity

- Prompt instructions are fixed/versioned; learner/content text is delimited data and cannot append system instructions.
- Provider output is untrusted input even when schema-constrained.
- Evidence references are drawn from a deterministically supplied allowlist; free-form model-created evidence IDs are rejected.
- Provider/model fallback for learner-visible scoring is allowed only to a benchmark-approved compatible route under the owning scorer-route policy. Otherwise preserve the durable operation and expose delayed/unavailable state.
- A provider swap is configuration plus a reviewed adapter implementation, not a domain/API/event migration.

## Durable execution and retry

Retry ownership belongs to the canonical durable-operation contract, not to a worker process or provider SDK. The adapter performs only the bounded attempt requested by orchestration within its supplied deadline. Orchestration owns retry, deduplication and reconciliation using stable operation/idempotency identities. No queue, Redis, worker fleet or service boundary is implied.

Numeric timeout/circuit/retry values remain unarmed until backed by approved runtime/provider evidence. They are not architecture defaults.

## Security/privacy

Credentials come from a managed secret boundary and never enter the repository/client. Only the minimum assessment content required for the approved purpose may be sent to a provider. Provider payloads are treated as untrusted private processing data and are normalized before entering canonical state.

Model/provider credentials confer no LenBands authorization. The server resolves the exact learner-owned operation and permitted data before constructing the bounded provider request.

## Acceptance conditions

- Provider outage preserves submission and yields delayed/unavailable without silent scorer substitution.
- Provider swap preserves API, event, score and historical semantics.
- Cost, latency, execution failure and route/model identities are attributable without retaining raw provider payload in general telemetry.
- Duplicate orchestration attempts cannot produce duplicate domain effects.
- Generated content cannot self-author provenance or `result_validity`.
- Legacy `quality_status`/`low_confidence`/`confidence_state` do not appear in the adapter product contract.
