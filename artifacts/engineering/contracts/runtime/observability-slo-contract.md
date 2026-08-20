# Observability & SLO Contract — P0

## Signals and privacy

Every learner-visible operation uses a stable request/operation correlation identity across the application boundary, durable-operation mechanism when present, provider adapter when present, and final domain effect. Each observed stage records capability/operation, outcome class, attempt, latency and governed cost/route dimensions without raw learner content.

| Signal | Required dimensions | Prohibited |
|---|---|---|
| Metric | capability, operation, outcome, attempt, route tier when applicable | raw subject/content identifiers |
| Trace | trace/correlation ID, opaque operation/resource refs, stage, provider adapter identity internally when applicable | prompt, essay/audio/transcript, raw provider response, secret |
| Structured log | severity, failure/public class, retry/reconciliation state, opaque request/operation ref | learner content, token, provider payload, chain-of-thought |
| Audit record | contract/rubric/route/model/policy versions as applicable, governed state transition, actor/function scope | hidden reasoning or raw provider payload |

Transport-specific concepts such as queue lag, worker lease, DLQ size or cache hit rate are observed only if the selected implementation actually uses those mechanisms. They are not P0 architecture requirements.

## P0 provisional SLOs

These are candidate release targets, not claims of observed runtime performance. Activation requires the canonical runtime configuration/release process.

| Indicator | Candidate target | Breach action |
|---|---|---|
| Draft save durable acknowledgement | p95 < 1s when online | preserve local/last durable state; investigate sustained breach |
| Submission durable acceptance | p95 < 2s | retain draft; retry same idempotency identity |
| Evaluation begins useful processing | p95 < 60s | expose delayed state; investigate operation/provider backlog |
| Evaluation reaches terminal operation outcome | p95 < 5m excluding learner retry | delayed/unavailable; no silent loss |
| Duplicate logical evaluation/result/charge | 0 | release blocker + reconciliation |
| Raw learner content in general telemetry | 0 | security/privacy incident + disable affected route |
| Armed cost ceiling breach without exception | 0 | route/circuit review; block promotion |

Do not hard-code these values into domain semantics. A different approved runtime configuration may change SLO targets without changing capability/API meaning.

## Alert and incident minimum

Urgent/page-class signals include:

- raw-content/secret leak;
- duplicate logical domain effect or charge;
- sustained critical SLO breach;
- armed cost-ceiling breach;
- material evaluation-quality/drift signal under the quality policy;
- durable-operation backlog or provider outage that materially blocks the learner loop.

Lower-severity signals include elevated delayed rate, optional optimization degradation and reconciliation work that does not threaten data correctness.

Every incident record includes timeline, affected capability, candidate/release identity, learner impact, mitigation, rollback/disable/repair path and follow-up decision. It becomes evidence only after an actual occurrence or governed tabletop/drill.

BOPS owns the generic incident classification and support/escalation boundary; this contract owns runtime signal/redaction/SLO semantics only.

## Measurement rules

- aggregate metrics must not make learner-level raw assessment content reconstructable;
- route/model/provider dimensions are internal governance dimensions, not learner-facing product labels;
- result validity is measured separately from transport/operation failure;
- technical retries are attributable without double-counting one learner logical operation;
- optional cache/queue/worker metrics are absent when the mechanism is absent, rather than represented as fake zeros;
- dashboards distinguish provider execution, domain validation, authorization/quota denial, durable-operation delay and admitted result-validity classes.

## Acceptance conditions

- one learner journey can be correlated from HTTP/application entry through any required durable/provider stages to the committed domain effect without raw content in general telemetry;
- duplicate delivery/retry can be diagnosed using opaque operation/idempotency references;
- alert/tabletop reaches an owner and identifies a safe learner-facing state;
- disabling cache/queue/worker-specific metrics does not remove required product/domain observability when those mechanisms are not part of the selected runtime;
- no dashboard treats provider confidence as learner correctness probability or `result_validity` as transport failure.
