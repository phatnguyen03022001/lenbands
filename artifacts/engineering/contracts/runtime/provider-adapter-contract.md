# Provider Adapter Contract — P0

## Boundary

Domain services call a provider-neutral adapter; no UI, domain entity, event name or Capability ID exposes provider terminology. Provider selection remains a Decision Artifact and cannot alter evaluation semantics without benchmark/release gate.

## Evaluation adapter interface

```yaml
evaluate_request:
  request_id: opaque-id
  submission_ref: opaque-id
  rubric_version: string
  task_version: string
  required_evidence: true
  deadline_at: timestamp
  cost_bucket: writing_eval_pilot

evaluate_response:
  outcome: accepted | low_confidence | insufficient_evidence | invalid | unavailable | delayed
  evaluation_ref: opaque-id
  rubric_version: string
  model_version: string
  evidence_refs: []
  confidence: number
  usage: {input_tokens: integer, output_tokens: integer}
  provider_trace_ref: opaque-id
```

`accepted | low_confidence | insufficient_evidence | invalid` are canonical quality outcomes. `unavailable | delayed` are transport/job states when no quality result exists; the adapter must not treat them as persisted quality statuses.

Raw provider request/response stays inside the privacy-scoped adapter/audit boundary. `provider_trace_ref` is opaque and never appears in learner analytics/UI.

## Threat model — provider boundary (M12)

| Asset | Threat | Control (P0) |
|---|---|---|
| Prompt template integrity | Prompt injection/override: learner or content text redefines the evaluation instruction | Prompt build is a fixed template in `writing_evaluation_v1.md`; embedded content is delimited data, not instructions; no free-form override appends to system prompt; prompt hash audited per call |
| Provider response tampering | Adapter normalizes model output without integrity; a malicious/tampered provider response reaches domain | Adapter validates Evaluation Contract schema + rubric/model version + cost bucket before persistence; disagreement goes to benchmark, not averaged; dual-run cross-checks |
| Provider credentials | Leaked provider API key/token | Keys live in a secrets manager / key store (provider/cloud not yet chosen), never in repo, env var per deployment, rotation policy; adapter reads via secret ref, not hard-coded |
| Data exfiltration via provider | Raw essay/audio or hidden reasoning transmitted beyond agreed data scope | Adapter sends only required submission/text for evaluation; raw content stays learner-scoped; provider_trace_ref opaque; no raw content in learner analytics/UI |
| Adapter isolation | Provider outage or malicious provider affects unrelated flows | Circuit breaker + deadline; adapter is per-provider module behind neutral interface; provider swap is config/feature-flag, not domain change |

Prompt-injection containment is a benchmark class (`evaluation-benchmark-spec.md` Adversarial cases) and must be tested before learner-visible promotion. This section is threat-model prose; it is not a security validation or evidence run.

## Timeout, circuit and fallback

| Concern | P0 rule |
|---|---|
| Deadline | Worker passes absolute `deadline_at`; adapter never extends it silently |
| Per-attempt timeout | Provider timeout must leave time for durable failure/result write before deadline |
| Circuit | Open after the threshold in Runtime Baseline Configuration; threshold changes require release review and an alert |
| Fallback | Prefer delayed queue/retry; alternate provider/model only if benchmarked for same contract and within cost quota |
| Low confidence | Return evidence + caveat; do not promote to readiness or silently average provider scores |
| Usage | Adapter records token/audio usage and cached/billed outcome for cost attribution |
| Retry | Only worker owns retry. Adapter never internally retries beyond its bounded attempt without emitting telemetry |

## Dual-run and change policy

- New provider/model/prompt/rubric runs shadow/dual-run against benchmark before learner-visible route change.
- Both outputs map to the same Evaluation Contract; disagreements are evidence for benchmark/review, not values to average.
- Adapter version, model version, prompt-template reference/hash and routing decision are audit fields.
- Rollback switches adapter route through feature flag/config without API/event/domain semantic change.

## Acceptance conditions

- Provider outage preserves submission and results in user-safe `delayed`/`unavailable` state.
- Provider swap does not require OpenAPI, runtime entity or event semantic migration.
- Cost, latency, error class and version are attributable for each accepted evaluation without retaining raw provider payload in general telemetry.
