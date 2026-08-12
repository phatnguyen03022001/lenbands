# Privileged-Review Diffs — Convergence Batch 3 (Protected Files)

**Status:** Proposed. Requires external CODEOWNERS review per `agent-trust-policy.yaml`.
**Date:** 2026-08-10
**Source:** Converge-documents Batch 3 — M4 audit (repo-cartographer), M10 audit
**Affected protected paths:** `blueprint/03-features.md`, `artifacts/operations/capability-manifest.yaml`

---

## DIFF B3-1: Fix invalid P0-04 privacy class compound in blueprint

**File:** `blueprint/03-features.md`
**Line:** 314
**Rationale:** `privacy_class` is a single-value controlled enum (`account | learning | assessment | audio | billing | system | derived`, defined at `blueprint/README.md:49`, `03-features.md:300`, `07-conventions.md:171`, `event-schema-pack.md:22`). The P0-04 row uses `learning/assessment` — a compound of two members, not a valid member. The capability manifest (`capability-manifest.yaml:128`) — the typed projection seed that is authoritative for the P0 capability graph — sets P0-04 to the single member `assessment`. Writing evaluation produces learner assessment results, so `assessment` is the correct single member. This is a controlled-vocabulary violation that currently passes silently (no validator checks `privacy_class`).

```diff
-| `P0-04 Writing evaluation` | `LEARN.Writing`, `EVAL.Writing`, `COACH.ErrorAnalysis`, `COACH.Feedback`, `PKM.Drafts` | Write, save, submit, and understand evidence-backed feedback | product + engineering | published task, rubric, evaluation contract | evaluation_submitted, evaluation_scored | low confidence/delay/unavailable user-safe states | learning/assessment | writing_eval_pilot |
+| `P0-04 Writing evaluation` | `LEARN.Writing`, `EVAL.Writing`, `COACH.ErrorAnalysis`, `COACH.Feedback`, `PKM.Drafts` | Write, save, submit, and understand evidence-backed feedback | product + engineering | published task, rubric, evaluation contract | evaluation_submitted, evaluation_scored | low confidence/delay/unavailable user-safe states | assessment | writing_eval_pilot |
```

---

## DIFF B3-2: Reconcile P0-06 privacy class — blueprint assessment vs manifest derived

**File:** `blueprint/03-features.md` (line 316) + `artifacts/operations/capability-manifest.yaml` (line 208)
**Rationale:** The P0-06 Quality & economics row is `assessment` in the blueprint but `derived` in the manifest. `OPS.QualityEconomics` owns `BenchmarkRun`, `CostMeasurement`, `ReleaseGateDecision`, `AuditRecord` — operational/derived aggregates, not learner assessment content. `blueprint/02-architecture.md` Runtime Entity Ownership assigns `derived` privacy class to "Event/audit record | System | Producer service | Authorized operations only". OPS processes derived operational data; `derived` is the semantically correct single member. Recommend aligning blueprint P0-06 to `derived`.

```diff
-| `P0-06 Quality & economics` | ... | ... | operations | benchmark, content, event/failure contracts | evaluation_failed, evaluation_delayed, retest_completed | release blocked / deterministic fallback | assessment | quality_release_gate |
+| `P0-06 Quality & economics` | ... | ... | operations | benchmark, content, event/failure contracts | evaluation_failed, evaluation_delayed, retest_completed | release blocked / deterministic fallback | derived | quality_release_gate |
```

Manifest (line 208) already reads `privacy_class: derived` — no manifest change needed for this row.

---

## DIFF B3-3: Remove `anti_gaming_flagged` from P0-06 published events (M10)

**File:** `artifacts/operations/capability-manifest.yaml`
**Line:** 202
**Rationale:** `anti_gaming_flagged` is produced by `GOVERNANCE.AntiGaming`, which is P1 (`capability-phase-index.md:69`) with no P0 owner. P0 anti-gaming is a placeholder adapter (`anti_gaming_status: unchecked`, `writing-task-2.md:49`). A P0 pack must not publish an event whose producer capability is out of P0 scope; this overstates P0 governance readiness. Until `GOVERNANCE.AntiGaming` is promoted to P0 (requires founder decision + evidence), `anti_gaming_flagged` must not be a P0-06 published event.

```diff
-    events_published: [benchmark_run_completed, drift_threshold_exceeded, anti_gaming_flagged, quota_warning_shown, quota_exceeded]
+    events_published: [benchmark_run_completed, drift_threshold_exceeded, quota_warning_shown, quota_exceeded]
```

Note: `drift_threshold_exceeded` has the same class (GOVERNANCE.DriftDetection is P1) — recommend a follow-up decision to either keep as P0 placeholder metric or defer. Flagged for founder review rather than silently removed, since drift telemetry is a P0-06 observability requirement.

---

## Attestation (covers Batch 3 protected diffs)

```yaml
change_id: convergence-batch-3-protected-diffs
change_scope: blueprint/03-features.md, artifacts/operations/capability-manifest.yaml
protected_changes_reviewed: true
authority_boundaries_changed: false
validators_weakened: false
evidence_modified: false
readiness_claimed: false
commands_run: [tools/bin/lenbands verify, tools/bin/lenbands gate toolchain]
external_review_required: true
```

## Post-Apply

1. Apply B3-1 and B3-2 to `blueprint/03-features.md`
2. Apply B3-3 to `capability-manifest.yaml`
3. Add a `privacy_class` enum validator (optional but recommended): `tools/commands/validate/*` should reject non-single-member values
4. Run `tools/bin/lenbands verify` + `gate toolchain`; confirm `gate p0` stays exit 3
