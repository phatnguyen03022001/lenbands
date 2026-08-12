# Owner Runtime Spec — OPS.QualityEconomics

## Identity

- `family_id`: `OPS.QualityEconomics`
- `family_version`: `1.0.0`
- `lifecycle`: `ACTIVE`
- `build_status`: `candidate`
- `owner`: operations

## Purpose and non-goals

Prevent pilot release or runtime degradation when quality, privacy, cost, quota, observability, or evaluator drift controls are not satisfied. It is an operational gate, not a learner-facing recommendation feature.

## Actors and commands

Operations: `OpenQualityDashboard`, `ReviewBenchmark`, `ApproveGate`, `BlockRelease`, `Rollback`. Runtime: `RecordMetric`, `CreateBenchmarkRun`, `EvaluateGate`, `EmitAlert`.

## Interaction path

Runtime facts → immutable evidence records → benchmark/cost/quality aggregation → gate evaluation → approve/block/rollback decision → audit record and operator notification.

## Runtime boundary and state

`unarmed → collecting_evidence → blocked | approved_for_pilot → rolled_back`.

An unarmed threshold cannot produce approval.

## Entities and ownership

`BenchmarkRun`, `CostMeasurement`, `ReleaseGateDecision`, `AuditRecord`, `DriftFinding`. Operations owns gate decisions and audit records; evaluator runtimes own source facts.

## Contract references

- `artifacts/operations/evaluation-benchmark-spec.md`
- `artifacts/operations/release-gate.md`
- `artifacts/engineering/contracts/runtime/observability-slo-contract.md`
- `artifacts/engineering/contracts/events/event-schema-pack.md`
- `artifacts/engineering/contracts/quota-usage/quota-usage-contract.md`

## Events

`benchmark_run_completed`, `drift_threshold_exceeded`, `quota_warning_shown`, `quota_exceeded`, `release_gate_blocked`, `release_gate_approved`.

Events contain metric references and aggregate values; never raw learner content.

## Deferred scope and gap annotation

- `GOVERNANCE.AntiGaming` and `GOVERNANCE.DriftDetection`/`GOVERNANCE.BiasMonitoring` are **P1** (`capability-phase-index.md`). The `DriftFinding` entity and `drift_threshold_exceeded` event here are **unresolved_gap** when no P0 drift engine exists; do not use them to claim that drift is active. The founder decides whether to retain `drift_threshold_exceeded` as a P0 metric placeholder (emit only when threshold config is valid) or defer the entire event.
- `anti_gaming_flagged` is NOT a P0-06 published event (see `convergence-batch-3-protected-diffs.md` DIFF B3-3). P0 anti-gaming is a placeholder adapter returning `anti_gaming_status: unchecked` (`writing-task-2.md` M10 note).
- Benchmark/cost gate events have meaning only when a real immutable-evidence run exists; a stub metric does not activate `release_gate_approved`.

## Failure and recovery

`BENCHMARK_MISSING` and `COST_CEILING_UNARMED` block approval. `DRIFT_THRESHOLD_EXCEEDED` blocks or rolls back according to policy. Evidence write failure is durable/retryable and cannot be silently ignored.

## Acceptance

- missing corpus cannot produce approved gate;
- immutable evidence hash mismatch blocks approval;
- cost ceiling missing blocks release;
- rollback decision is auditable;
- raw learner content is excluded from telemetry.

## Evidence and dependencies

Evidence: gold corpus, benchmark run, approved numeric cost thresholds, rollout/rollback record. Dependencies: `IDENTITY.Core`, `WRITING.Evaluation`, `REVIEW.ErrorToReview`, `ADR-0001`, `ADR-0002`.

## Executor dossier — permission, data, UI, observability, adapter

- **Permission**: `admin:governance` (single governance scope; auth-identity-contract.md). No learner surface. `read:governance_raw_submission_preview` break-glass un-granted pending founder policy.
- **Data read/write**: reads immutable benchmark/cost/metric records and event aggregates; writes `ReleaseGateDecision`, `AuditRecord`, governance disposition (append-only). Never writes learner essay/audio.
- **API**: `GET/POST /v1/ops/quality-gate`, `GET /v1/me/quota` (learner); admin governance surface per dashboard spec (bound to `admin:governance`).
- **Events**: producer `benchmark_run_completed`, `drift_threshold_exceeded` (P1-gated), `quota_warning_shown`, `quota_exceeded`, `release_gate_blocked`, `release_gate_approved`; consumer `evaluation_submitted/scored/failed/delayed`, `retest_completed`.
- **UI/UX states**: dashboard `unknown → loading → healthy | warning | incident`, `stale_snapshot` never shown as healthy; empty/loading states per `governance-ops-dashboard.md`. Not learner-facing; no accessibility requirement beyond admin (WCAG AA keyboard).
- **Observability**: metric aggregates daily, ≤ 24h freshness for dashboard; cost/quality telemetry per `observability-slo-contract.md`; raw learner content excluded.
- **Rollback/kill-switch**: block route via feature-flag/config (no API/event migration); rollback decision auditable; kill-switch applicable to a degraded route, not to evidence records.
- **Provider adapter boundary**: none directly — OPS consumes provider-neutral metrics/events; no provider vocabulary leaks into gate semantics.
- **Non-goals**: not a learner-facing feature, not a full admin console (user/billing/role out of scope), no automated re-tune pipeline in P0.
- **Deferred**: anti-gaming/drift/bias/gold-standard-benchmark engines P1; `GOVERNANCE.Dashboard` P1 (dashboard surface is P0 via `governance-ops-dashboard.md` but engine-backed sections are P1-gated).
