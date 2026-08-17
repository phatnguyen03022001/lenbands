# Owner Runtime Spec — OPS.QualityEconomics

## Identity

- `family_id`: `OPS.QualityEconomics`
- `family_version`: `1.0.0`
- `lifecycle`: `ACTIVE`
- `build_status`: `candidate`
- `owner`: operations

## Purpose and non-goals

Prevent pilot release or runtime degradation when quality, privacy, cost, quota, observability, evaluator-quality or evidence controls are not satisfied. This family governs whether probabilistic workloads may run; it does not make those governance decisions probabilistic.

Stable decision units are declared by `quality-economics-runtime.meta.yaml`; `artifacts/operations/execution-policy.yaml` only projects their allowed compute modes.

## Core compute boundary

The following are deterministic domain decisions:

- eligible model/provider route selection;
- quota reservation/charge/release/denial;
- cost aggregation;
- benchmark metric calculation;
- governed confidence-state derivation;
- release approve/block/rollback decision;
- audit-record creation.

A probabilistic workload may be selected **by** these policies, but a model may not choose its own route, approve itself, change quota, interpret raw confidence as calibrated quality, or decide that a release is ready.

```text
immutable runtime/evidence facts
  -> deterministic metric/eligibility calculation
  -> deterministic route/quota/quality/release policy
  -> canonical gate decision
  -> append-only audit record
```

## Actors and commands

Operations: `OpenQualityDashboard`, `ReviewBenchmark`, `ApproveGate`, `BlockRelease`, `Rollback`.
Runtime: `RecordMetric`, `CreateBenchmarkRun`, `EvaluateGate`, `EmitAlert`.

Human founder/operator authorization may be required by release policy, but it does not turn the underlying metric/eligibility calculation into model inference.

## Runtime boundary and state

`unarmed → collecting_evidence → blocked | approved_for_pilot → rolled_back`.

An unarmed threshold cannot produce approval. Missing required evidence is blocking, not an invitation to infer a plausible release state.

## Entities and ownership

`BenchmarkRun`, `CostMeasurement`, `ReleaseGateDecision`, `AuditRecord`, `DriftFinding`.

- evaluator runtimes own raw/normalized source facts;
- evidence contracts own immutable evidence truth;
- Operations owns release-gate decisions and governance audit records;
- provider/model output cannot write `ReleaseGateDecision` directly.

## Model route selection

`quality.model_route_selection` receives only provider-neutral eligible-route facts already supported by benchmark/release policy.

```text
workload decision unit
  + canonical compute mode
  + active route approvals
  + privacy/cost/circuit facts
  -> deterministic eligible route set
  -> deterministic route selection
```

Rules:

- a deterministic decision unit has no model route;
- a probabilistic unit may use only executor types allowed by the execution-policy projection;
- fallback cannot silently change the canonical compute mode;
- learner-visible scoring fallback stays inside the benchmark-approved scorer-route policy;
- no model/classifier/reranker may select itself merely because it returns higher confidence.

## Quota and cost

Quota is a deterministic entitlement/usage policy. Model output, user wording or provider error messages cannot alter quota state.

Cost aggregation uses measured provider-neutral usage facts. A probabilistic estimate may be used for planning/forecasting only when separately governed; canonical billed/consumed usage comes from measured records.

## Benchmark metrics and confidence

Benchmark expectations come from the approved gold/reference source, not candidate inference output. Metric calculations are deterministic over immutable evidence records.

Raw model confidence is an inference signal. `quality.confidence_state_derivation` converts validated evidence/confidence inputs into the governed state under an active versioned policy. It cannot be treated as a calibrated probability unless benchmark evidence explicitly supports that interpretation.

## Release gate

The release gate is a deterministic evaluation of armed policy and validated evidence, followed by any explicitly required founder/operator authorization.

```text
quality/privacy/security/cost/evidence facts
  -> deterministic policy evaluation
  -> blocked | eligible_for_authorization
  -> required external authorization if configured
  -> approved_for_pilot
```

No provider output, benchmark candidate result or generated explanation may directly produce `approved_for_pilot`.

## Contract references

- `artifacts/operations/evaluation-benchmark-spec.md`
- `artifacts/operations/evidence-integrity.yaml`
- `artifacts/operations/release-gate.md`
- `artifacts/operations/execution-policy.yaml`
- `artifacts/engineering/contracts/runtime/observability-slo-contract.md`
- `artifacts/engineering/contracts/events/event-schema-pack.md`
- `artifacts/engineering/contracts/quota-usage/quota-usage-contract.md`

## Events

`benchmark_run_completed`, `drift_threshold_exceeded`, `quota_warning_shown`, `quota_exceeded`, `release_gate_blocked`, `release_gate_approved`.

Events contain metric references and aggregate values, never raw learner assessment content.

## Deferred scope

- `GOVERNANCE.AntiGaming`, `GOVERNANCE.DriftDetection` and `GOVERNANCE.BiasMonitoring` remain P1 unless promoted through roadmap/eligibility governance.
- A drift/bias/statistical monitor may use statistical computation, but its signal cannot silently rewrite historical learner results or release state.
- P0 anti-gaming remains unarmed unless an approved policy/evidence path exists; probabilistic detector output is a risk signal, not proof.
- Benchmark/cost events have meaning only when a real immutable-evidence run exists.

## Failure and recovery

`BENCHMARK_MISSING` and `COST_CEILING_UNARMED` block approval. Armed drift/quality failures block or roll back according to versioned policy. Evidence-write failure is durable/retryable and cannot be silently ignored.

## Acceptance

- [ ] missing corpus cannot produce an approved gate;
- [ ] immutable evidence hash mismatch blocks approval;
- [ ] cost ceiling missing blocks release when the policy requires one;
- [ ] deterministic decision units cannot acquire a provider route through fallback;
- [ ] raw model confidence cannot self-promote quality state;
- [ ] route selection cannot be delegated to the routed model;
- [ ] rollback decisions are auditable;
- [ ] raw learner content is excluded from general telemetry.

## Evidence and dependencies

Evidence: gold/reference corpus, benchmark run, approved numeric thresholds where required, measured cost records, rollout/rollback record. Dependencies: `IDENTITY.Core`, `WRITING.Evaluation`, `REVIEW.ErrorToReview`, evidence integrity and release policy.

## Executor dossier

- **Permission**: `admin:governance`; no learner mutation surface for release approval.
- **Data**: reads immutable benchmark/cost/metric records and aggregate events; writes release-gate/audit governance state. Never writes learner essay/audio.
- **API**: canonical operations are owned through `artifacts/engineering/api/operation-ownership.yaml`; this spec does not create alternate endpoints.
- **Observability**: provider-neutral metrics; raw learner content excluded.
- **Rollback/kill-switch**: disable a degraded route without mutating historical evidence; rollback remains auditable.
- **Provider boundary**: OPS consumes provider-neutral facts; provider vocabulary does not enter release/quality semantics.
- **Non-goals**: no learner recommendation logic, no model-selected governance decision, no automated self-promotion/re-tuning pipeline in P0.
