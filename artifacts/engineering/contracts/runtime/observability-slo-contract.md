# Observability & SLO Contract — P0

## Signals and privacy

Every API request, outbox relay, stream job, and provider call shares a `trace_id`; each boundary creates a span with `capability_id`, operation, outcome class, attempt, latency, cache status, and cost bucket. Logs/events must not contain raw essay/audio, bearer tokens, provider payloads, complete prompts, or hidden reasoning.

| Signal | Required dimensions | Prohibited |
|---|---|---|
| Metric | capability, operation, outcome, attempt, model tier, cache status | raw subject/content identifiers |
| Trace | trace/correlation ID, opaque aggregate ref, provider adapter name internally | prompt, raw response, secret |
| Structured log | severity, failure code, retry/DLQ state, request/job ref | essay/audio/transcript body |
| Audit record | model/rubric/contract versions, state transition, actor type | chain-of-thought/provider raw payload |

## P0 provisional SLOs

These thresholds are `draft` release targets and must be benchmarked/load-tested before promotion:

| Indicator | Target | Breach action |
|---|---|---|
| Draft save durable acknowledgement | p95 < 1s when online | local-first state + incident if sustained |
| Submission acceptance | p95 < 2s | retain draft; client retry idempotently |
| Evaluation queue start | p95 < 60s | state `delayed`, alert on backlog |
| Evaluation terminal outcome | p95 < 5m excluding user retry | delayed/unavailable; no silent loss |
| Duplicate accepted evaluation | 0 | release blocker + reconciliation |
| Raw content in telemetry | 0 | security/privacy incident + halt affected route |
| Cost ceiling breach | 0 without exception | circuit/route review; block release |

## Alert and incident minimum

- Page/urgent alert: raw-content leak, duplicate charge/result, DLQ growth beyond configured P0 capacity, SLO breach sustained 15 minutes, cost hard ceiling.
- Ticket/next-business-day: cache hit collapse, elevated delayed rate, non-critical provider fallback, reconciliation repair.
- Every incident record contains timeline, affected capability, trace samples, learner impact, mitigation, rollback/repair, follow-up decision. It is an Evidence Artifact only after it occurs.

## Acceptance conditions

- One learner journey can be traced HTTP → outbox → worker → provider adapter → accepted result without raw content.
- Alert simulation reaches an owner; runbook identifies safe learner-facing state.
- Dashboard distinguishes provider failure, queue lag, cache behavior, domain validation and quota denial.
