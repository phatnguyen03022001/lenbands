# Governance Ops Dashboard (founder surface)

Canonical metadata is in `governance-ops-dashboard.meta.yaml`.

Founder/admin surface for operating calibration/drift/anti-gaming in the closed pilot. **Not learner-facing.** P0: minimal, sufficient for decisions (whether to re-tune or block a route). The anti-gaming surface is P1-gated: `GOVERNANCE.AntiGaming` is P1 (`capability-phase-index.md`); until a real detector exists, the anti-gaming queue shows an empty/placeholder queue and `anti_gaming_status: unchecked` (see M10).

## Outcome and scope

- User outcome: the founder knows whether the evaluation engine scores correctly, has drift, or is being gamed; makes re-tune/block/investigate decisions.
- In scope (P0): read-only dashboard of governance metrics + manual action (block route, flag submission).
- Out of scope: full admin console (user/billing/role), advanced moderation UI, automated re-tune pipeline.

## User & permission

- Role: admin (founder P0).
- Permission: collapse to `admin:governance` (auth-identity-contract.md) — read aggregate/audit, block route, write governance disposition; every mutation has an audit record. Do not define a new scope in this spec.
- Learners must not see this dashboard.
- Break-glass `read:governance_raw_submission_preview`: not granted; a founder-approved policy and an expiring scope in the auth contract are required before showing a raw preview.

## Entry / exit

- Entry: admin login → `/admin/governance`.
- Exit: no "completion" — continuous monitoring.

## Dashboard state machine

```text
unknown → loading → healthy
                   ├→ warning (metric threshold exceeded)
                   └→ incident (route block required)
loading → stale_snapshot → healthy | warning | incident
```

`stale_snapshot` must not be displayed as healthy; every manual route action requires an audit record.

## Screen inventory

| Screen | Purpose | Primary action |
|---|---|---|
| `GOV-01 Overview` | One summary page: MAE, low-confidence rate, drift, anti-gaming | drill into metric alert |
| `GOV-02 Benchmark runs` | Benchmark run history + MAE trend | view run detail |
| `GOV-03 Drift/bias` | Monthly drift, bias by group/question_type | investigate |
| `GOV-04 Anti-gaming` | Sample/detector flags queue | record governance disposition |
| `GOV-05 Route & release gate` | Route active, benchmark pass status, release gate | block route |

### GOV-01 Overview

Sections:
1. **Health summary**: 4 cards (MAE vs threshold, Low-confidence rate, Drift status, Anti-gaming pending count). The anti-gaming card displays "unchecked/placeholder" until `GOVERNANCE.AntiGaming` (P1) has a real detector.
2. **Alerts**: list new alerts (drift exceed, MAE fail, anti-gaming spike).
3. **Recent benchmark**: latest run (MAE, corpus, timestamp).
4. **Cost snapshot**: cost/active learner this week vs budget.

State: `healthy` / `warning` (1 metric over) / `incident` (block required).

### GOV-02 Benchmark runs

- Table: run_id, timestamp, corpus_id, route_id, MAE, pass/fail, model_version, prompt_hash.
- Drill: per-criterion MAE, outlier essays.

### GOV-03 Drift/bias

- Line chart MAE month-over-month per route.
- Bias: band difference by question_type / topic group.
- Threshold line + alert.

### GOV-04 Anti-gaming

- Queue submission flagged (sample_match, ai_generated). P1-gated: show an empty queue + `anti_gaming_status: unchecked` until `GOVERNANCE.AntiGaming` (P1) has a real detector; do not claim detection without an engine.
- Each item: opaque submission ref, similarity score, detector score. Raw preview is disabled by default.
- Action: write governance disposition (hold/release flag); do not edit or human-override the score. A held result does not enter history until the evaluation route is rerun according to contract.

### GOV-05 Route & release gate

- Table route: route_id (vd evaluation_primary), active, model_version, prompt_hash, last_benchmark_pass, gate_status.
- Action: block route (set inactive → submissions go to fallback or delayed/unavailable).

## Runtime data

| Entity | Read | Write |
|---|---|---|
| BenchmarkRun | yes | (governance engine emit) |
| DriftMetric | yes | (governance engine emit) |
| AntiGamingFlag | yes | confirm/reject (admin) |
| Route | yes | block/unblock (admin) |
| AuditTrail | yes | append-only |

## Contracts

- API: `GET /admin/governance/overview`, `GET /admin/governance/benchmark-runs`, `GET /admin/governance/anti-gaming-queue`, `POST /admin/routes/{id}/block`.
- Event: subscribe `benchmark_run_completed`, `drift_threshold_exceeded` (P1-gated). Do NOT subscribe to `anti_gaming_flagged` until `GOVERNANCE.AntiGaming` (P1) has a real engine; the queue shows empty/placeholder (see B3-3, M10).
- Failure: dashboard unavailable → static "last known" snapshot fallback; do not block the pilot (the founder uses logs directly).

## Quality, cost, privacy

- Quality gate: dashboard must reflect data ≤ 24h old (governance metric aggregate daily).
- Cost: dashboard query does not call an LLM; it only reads aggregates.
- Privacy: raw submission preview is not a default admin permission. If the founder needs to open a break-glass preview, it must have `read:governance_raw_submission_preview`, purpose, policy version, scope/time expiry, redaction, no-download, and append-only audit. Until the policy is approved, the dashboard shows only opaque refs/metrics.

## Acceptance tests

- [ ] Founder opens `/admin/governance` and sees 4 health cards + alerts (≤ 24h data).
- [ ] MAE card shows value + threshold + pass/fail color.
- [ ] Benchmark run table has the latest run and supports drill-down.
- [ ] Anti-gaming queue (when `GOVERNANCE.AntiGaming` P1 has a real engine): flag is shown, founder records disposition → flag resolves, score is not human-overridden, and submission band does not enter history while held. Before the engine exists: queue is empty/placeholder and makes no detection claim.
- [ ] Founder blocks a route → writing slice returns delayed/unavailable without crashing.
- [ ] Dashboard does not expose learner PII / essay text; break-glass preview runs only when real policy + audit permission exist.
- [ ] Dashboard loads ≤ 2s (reads aggregate, does not query raw data).

## Readiness

- Review. Ready when the benchmark corpus (gold-standard essay) and governance engine emit real metrics. Stub metrics or manual prose do not make the dashboard/build gate ready. Treat the anti-gaming section as build input only when `GOVERNANCE.AntiGaming` is promoted into P0 scope with real evidence.
