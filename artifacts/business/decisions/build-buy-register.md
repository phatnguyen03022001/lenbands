# Build / Buy Register

- **Status:** draft — proposed MVP baseline
- **Date:** 2026-08-06
- **Owner:** Founder
- **Related Blueprint:** `02-architecture.md`, `06-engines.md`, `07-conventions.md`

## 1. Purpose

Consistently decide which parts LenBands builds, uses as managed services, buys as external capabilities, or combines across both approaches. This register decides **ownership and boundaries**. The founder's conditional vendor baseline is in `managed-platform-baseline-decision.md`; that choice does not override procurement, DPA, benchmark, or release gates.

## 1.1 Scope

### In scope

- P0 external/managed boundaries: identity, payment, database, queue, storage, email, analytics, observability, evaluation inference, and speech-to-text.
- Ownership boundaries for Error Graph, rubric, quality gate, recommendation, consent/retention, and event/failure semantics.
- Cost scenario, procurement gate, exit exercise, and review trigger for P0.

### Out of scope

- Vendor contract/DPA approval, production account setup, or legal sign-off.
- Content/Knowledge Asset procurement and evidence intake.
- Enterprise compliance, multi-region, self-hosted model fleet, Kafka/vector DB scale-out.
- A claim that a candidate has met quality/latency benchmarks before a benchmark run exists.

## 2. Principles

1. Build only the parts that create differentiated learning outcomes, Error Graph, calibration, or learning data.
2. Use managed/buy for commodities with complex security or operations.
3. Use hybrid when a model/vendor provides foundational capability but LenBands must own the rubric, quality gate, and experience.
4. A vendor must not appear in the domain model, capability ID, event name, or learner-facing copy.
5. Every buy/managed boundary must have an export path, cost ceiling, privacy review, and user-safe fallback.
6. Do not self-host model/infra in the MVP merely to optimize unit price; change only when outcome, cost, or compliance proves it necessary.

### Priority when principles conflict

```text
1. Privacy, legal compliance, and data safety
2. Learner outcome / evaluation quality
3. Recoverability and exit path
4. Cost ceiling
5. Delivery speed / operational simplicity
```

Example: if buy is cheaper but does not satisfy deletion/export or benchmark quality, the decision must not be promoted. If build creates differentiation but lacks a recoverable boundary for a solo founder, use hybrid/managed first.

## 3. Decision rubric

| Criterion | Prefer build when | Prefer buy/managed when |
|---|---|---|
| Differentiation | Create Error Graph, recommendation, calibration, retention loop | Commodity does not create a learning moat |
| Quality control | A dedicated rubric/evidence/benchmark is needed | Standard SLA meets the outcome |
| Privacy/legal | A dedicated policy/retention model is needed | Provider satisfies DPA, export/delete, and data scope |
| Operating burden | Team can maintain it with a solo founder + agent | Security/SRE/scale burden is high |
| Reversibility | Domain boundary is stable | Fast trial is needed or the vendor is easy to replace |
| Cost | Frequency/volume is large enough and benchmarked | Volume is low, variable, or value is unproven |

## 4. Baseline decisions

| Boundary | Decision | LenBands owns | External/managed responsible | P0 rule | Exit strategy |
|---|---|---|---|---|---|
| Identity & authentication | Buy / managed | User profile, permission policy, account lifecycle | Credential, MFA, session primitives | Use standards-based auth; do not store passwords | OIDC-compatible export/migration, independent user mapping |
| Payments & subscription | Buy | Entitlement, quota policy, product copy | Payment collection, tax/payment compliance | Do not store card data; idempotent webhook | Provider-neutral billing ledger + export |
| Postgres database | Managed | Schema, migration, data retention, encryption policy | HA, backup, patching | One primary relational store | Standard Postgres dump/restore |
| Cache / job queue | Managed Redis | Job semantics, idempotency, retry, DLQ policy | Cluster operation | Redis Streams first; Kafka deferred | Queue adapter + durable job record |
| Object storage | Managed S3-compatible | Object key policy, retention, access control | Durability, encryption at rest | Draft/audio private by default | S3-compatible copy/export |
| Transactional email | Buy | Notification policy, copy, consent/frequency cap | Delivery/reputation | No marketing dependency for core recovery | Provider adapter + delivery log |
| Product analytics | Buy / managed | Canonical event schema, privacy filter, outcome metrics | Event ingestion/exploration | No raw essay/audio in analytics | Export canonical events to warehouse format |
| Error monitoring / observability | Buy / managed | Error taxonomy, SLO, alert policy, redaction | Ingestion, dashboards, alert transport | Redact PII/raw learner content | Vendor-neutral structured logs/metrics |
| Feature flags / experiments | Managed or simple internal config | Flag semantics, cohort rule, rollback policy | Flag evaluation/hosting if bought | No experiment may bypass quality/privacy gate | Config export and kill switch |
| Search | Build on Postgres P0 | Search intent, permissions, ranking rules | Database index capability | No vector DB in P0 | Add search adapter only when catalog size proves need |
| FSRS scheduler | Integrate + build orchestration | Card policy, queue priority, learner UX, outcome measurement | Maintained FSRS implementation/library | Do not reimplement FSRS maths in P0 | Versioned algorithm adapter + migration path |
| Writing evaluation | Hybrid | Rubric, prompt contract, evidence extraction, confidence, Error Graph, benchmark and fallback UX | Foundation model inference | No provider score directly shown to learner | Provider adapter + benchmark suite + dual-run migration |
| Speech-to-text | Buy / managed initially | Transcript QA policy, speaking rubric, learner UX | Speech recognition | No self-hosting in P0 | Store canonical transcript + provider-agnostic interface |
| Model governance / evaluation benchmark | Build | Benchmark corpus references, regression runner, confidence policy, release gate | Optional compute/model APIs | Release blocked on quality regression | Reproducible benchmark and model trace |
| Recommendation / next best action | Build | Priority policy, Error Graph, explainability, user state logic | Optional inference/model call | Rule-based baseline first | Deterministic fallback remains available |
| Content authoring | Build minimal workflow later | Taxonomy, rights gate, publish state | n/a | Out of current scope; no asset work now | Keep content model independent of authoring UI |

## 4.1 Cost scenario — planning assumptions

These figures are a scenario for order-of-magnitude checks, not a quote/vendor commitment. Re-verify every pricing snapshot at the procurement date.

### Assumptions

| Variable | Closed pilot | Public pilot | Early growth |
|---|---:|---:|---:|
| Monthly active learners | 25 | 100 | 500 |
| Accepted Writing evaluations / learner / month | 5 | 8 | 10 |
| Evaluation input tokens | 4,000 | 4,000 | 4,000 |
| Evaluation output tokens | 1,500 | 1,500 | 1,500 |
| Retry/reserve factor | 1.30 | 1.30 | 1.30 |

### Evaluation inference scenario

Founder-selected desk candidate: DeepSeek V4 Flash.  Snapshot verified on 2026-08-10 is USD $0.14 / million uncached input tokens and USD $0.28 / million output tokens.  Cache-hit pricing is excluded from the scenario because it is not an entitlement until runtime behavior is measured. Under the assumptions above, one evaluation is approximately $0.00098 before reserve and approximately **$0.00127** with a 30% retry/reserve factor.

| Scenario | Evaluations/month | Inference estimate | Managed platform baseline | Excludes |
|---|---:|---:|---:|---|
| Closed pilot | 125 | ~$0.16 | free-tier candidate; not an availability commitment | speech, payment, email, support, DPA/backup obligations |
| Public pilot | 800 | ~$1.02 | free-tier candidate; upgrade/alert policy required | speech, payment, email, support, DPA/backup obligations |
| Early growth | 5,000 | ~$6.37 | re-benchmark required | speech, payment, email, support, DPA/backup obligations |

This is only a pricing sensitivity scenario. DeepSeek explicitly reserves the right to change prices, and no numeric cap in this table is an armed cost ceiling.  Managed-platform pricing, availability and data-processing terms are tracked in `managed-platform-baseline-decision.md` and re-verified before provisioning.

### Numeric policy status

- The previous Anthropic-based planning thresholds are deprecated; they are not transferred to the DeepSeek route.
- Numeric warning and hard ceilings remain `unarmed` until the gold corpus, benchmark, provider-price snapshot and founder approval gates are complete.
- A scenario budget excludes speech and support; either capability launches only after its own unit-cost scenario exists.
- No auto-reload/usage expansion may be enabled without a reviewed spend alert and an approved ceiling.

## 5. Hard ownership boundary

LenBands must own and version:

```text
Capability semantics
Rubrics and feedback policy
Error taxonomy / Error Graph
Quality benchmark and release gate
User state, recommendation policy and FSRS orchestration
Permission, consent, deletion and retention policy
Canonical event and failure semantics
```

LenBands must not build in MVP:

```text
Password/MFA infrastructure
Payment processing
Database/Redis/S3 operations
Email reputation infrastructure
Generic monitoring platform
Foundation model training or model serving fleet
Speech model hosting
Kafka-scale event infrastructure
```

## 6. Provider contract requirements

Do not choose a provider for a boundary without:

- A Data Processing Agreement/terms compatible with the privacy policy.
- Clear data location, retention, deletion, and training-use policy.
- API versioning, rate limit, incident/SLA, and export path.
- A cost model with ceiling, quota, and alert threshold.
- Fallback behavior that does not lose a draft/submission or send the learner to a dead end.
- A method to redact raw essay/audio from analytics/observability.

## 6.1 Edge-case policy

| Scenario | Decision rule | User-safe outcome | Required artifact action |
|---|---|---|---|
| Vendor shutdown / sustained outage | Freeze new dependent work; activate fallback/queue | draft/submission retained; delayed/unavailable state | run exit exercise; create incident/ADR review |
| Price shock | Freeze optional detail and auto-reload | no retroactive learner penalty; core data retained | re-run cost scenario within 5 business days |
| Data residency/DPA conflict | Do not send new scoped data until legal review | explain availability limit; preserve local draft | suspend provider route; review privacy decision |
| Lock-in escalation | Provider-neutral interface and export test wins over short-term convenience | no data hostage situation | exercise migration within review cycle |
| Quality vs cost conflict | Quality threshold wins; degrade detail before result integrity | transparent delayed/limited feedback | benchmark + founder exception required |
| Two providers disagree materially | Do not silently average scores | low-confidence/hold state until policy decides | dual-run benchmark and audit trace |

## 7. Architecture rules

- Go owns provider adapters and business orchestration; Python receives only the necessary job/inference contract.
- The domain layer uses neutral interfaces (`EvaluationProvider`, `SpeechProvider`, `BillingProvider`) and does not return raw provider responses to the UI.
- Provider request/response, prompt, and model version must have an audit trail; raw content passes only through a service with the appropriate privacy scope.
- The Event/Fault contract retains internal semantics (`evaluation_scored`, `evaluation_delayed`) and emits no vendor-named events.
- Fallback must be product behavior described in the Interaction Model, not an implicit technical exception.

## 8. Review triggers

Review each decision when one of the following conditions occurs:

| Trigger | Action |
|---|---|
| Boundary cost exceeds cost budget for 2 consecutive periods | Benchmark managed vs build/hybrid; update ADR |
| Quality benchmark decreases or drifts | Freeze release, dual-run/fallback, review provider/model |
| Vendor privacy/legal policy changes | Suspend new data flow if needed, legal review |
| Volume exceeds SLO/throughput | Benchmark architecture alternative |
| Vendor outage repeats or lock-in is clear | Test exit/migration path |
| Capability becomes a measured moat | Evaluate moving buy → hybrid/build |
| Regulated-market/data-residency requirement appears | Reassess the full data boundary |

## 9. Procurement gate

Vendor selection is a child artifact of this register. Each vendor choice must have:

```yaml
boundary:
candidate:
benchmark_date:
quality_result:
latency_result:
cost_projection:
privacy_review:
exit_test:
decision:
review_date:
```

Do not treat a provider name as product architecture; review the decision by trigger, not by intuition or vendor advertising.

## 9.1 Procurement instances

### Instance A — Auth / managed platform candidate

```yaml
boundary: identity_and_platform
candidate: Supabase Auth + managed Postgres/Storage
status: deprecated_not_selected_for_current_baseline
superseded_by: managed-platform-baseline-decision.md
public_snapshot: historical desk research; do not use for current procurement
quality_result: pending integration test
privacy_review: pending DPA/region/deletion review
exit_test: pending export of users/profile mapping + Postgres dump restore
decision: not selected; identity provider remains unresolved and must separately pass privacy and exit test
review_date: before closed-pilot provisioning
```

### Instance B — Writing evaluation inference candidate

```yaml
boundary: writing_evaluation_inference
candidate: Anthropic Sonnet 4 API
status: deprecated_not_selected_for_current_baseline
superseded_by: managed-platform-baseline-decision.md
public_snapshot: historical desk snapshot; do not use for current procurement
quality_result: pending benchmark against Evaluation Benchmark Specification
latency_result: pending closed-pilot load test
privacy_review: pending API terms/DPA/data-use review
exit_test: pending provider-adapter dual-run against second candidate
decision: not selected; no learner-facing promotion without benchmark + release gate
review_date: before first evaluation-enabled pilot
```

### Instance C — Founder-selected managed platform baseline

```yaml
boundary: closed_pilot_managed_platform
candidate: Cloudflare + Cloud Run + Google Secret Manager + Neon + Upstash + Resend/Brevo + PostHog/Sentry + DeepSeek V4
status: founder_selected_pre_code_baseline
source_of_truth: managed-platform-baseline-decision.md
quality_result: pending gold-corpus benchmark for learner-visible evaluation route
latency_result: pending deployment/load observation
privacy_review: pending DPA/region/deletion review for every activated processor
exit_test: pending Postgres restore, object copy, Redis replay, email fallback and provider-adapter switch
decision: selected for procurement planning only; no runtime activation or P0-readiness claim
review_date: every 30 days while free-tier assumptions are active, and before every provisioning/release gate
```

## 10. References

- `artifacts/business/decisions/managed-platform-baseline-decision.md` (founder-selected pre-code baseline, 2026-08-10).
- DeepSeek API pricing: <https://api-docs.deepseek.com/quick_start/pricing/> (accessed 2026-08-10).
