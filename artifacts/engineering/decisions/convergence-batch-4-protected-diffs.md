# Privileged-Review Diffs — Convergence Batch 4 (Protected Family/Registry Files)

**Status:** Proposed. Requires external CODEOWNERS review per `agent-trust-policy.yaml`.
**Date:** 2026-08-10
**Source:** Converge-documents Batch 4 — Executor Dossier campaign, repo-cartographer family inventory
**Affected protected paths:** `artifacts/operations/capability-family-registry.yaml`, `artifacts/operations/capability-family-map.yaml`, `artifacts/operations/capability-lifecycle-registry.yaml`

---

## DIFF B4-1: Fix WRITING.Evaluation interaction_spec → canonical writing-task-2.md

**File:** `artifacts/operations/capability-family-registry.yaml`
**Line:** 114
**Rationale:** The family's `interaction_spec` points to `interaction/writing-evaluation.md`, which is `status: deprecated` (superseded_by `interaction/writing-task-2.md` per its meta). All `shared_contracts` for the family already point to the canonical `writing-task-2/*`. The registry validator only checks file existence, not deprecation, so this stale reference passes silently. The projection `web-surface-inventory.md:16` duplicates the stale path and will follow once regenerated.

```diff
-    interaction_spec: artifacts/experience/specs/interaction/writing-evaluation.md
+    interaction_spec: artifacts/experience/specs/interaction/writing-task-2.md
```

**Affected projections:** `artifacts/operations/web-surface-inventory.md` (must regenerate to reference canonical path).
**Validator impact:** Optional — consider enhancing `implementation-catalog.rb` to reject deprecated interaction_spec references.

---

## DIFF B4-2: Resolve SPEAKING.Practice orphan family

**File:** `artifacts/operations/capability-family-registry.yaml` (lines 211-227) + `capability-family-map.yaml`
**Rationale:** `SPEAKING.Practice` is a fully-shaped family in the registry (purpose, owner, entities `SpeakingPrompt/SpeakingRecording/SpeakingAttempt`, allowed_delta `SPEAKING.Part`, evidence `speaking_recording_acceptance`) but **zero capabilities map to it**. All speaking capabilities map to `SPEAKING.Evaluation` (`EVAL.Examiner`, `EVAL.Speaking`, `LEARN.Speaking`). A family no capability can select is unreachable — it is the root of the 25-vs-26 snapshot discrepancy and an "empty reference that looks complete."

**Two options (founder decision required):**
- **Option A (recommended): deprecate/remove** `SPEAKING.Practice` from the registry, since `SPEAKING.Evaluation` owns the speaking surface and `LEARN.Speaking` maps there. This removes the dangling family and reconciles the count to 25.
- **Option B: map capabilities to it** — would require new Blueprint capability IDs (e.g. `LEARN.Speaking` stays in SPEAKING.Evaluation but a practice-only capability is added), which is a product-scope decision requiring Blueprint change.

**Proposed diff (Option A):**

```diff
--- a/artifacts/operations/capability-family-registry.yaml
+++ b/artifacts/operations/capability-family-registry.yaml
@@ -211,18 +211,4 @@
-  - family_id: SPEAKING.Practice
-    family_version: 1.0.0
-    status: planned
-    last_changed: 2026-08-07
-    compatible_since: 1.0.0
-    lifecycle: PLANNED
-    purpose: Speaking prompt, recording, timing, and retest workflow.
-    owner: product+engineering
-    runtime_boundary: speaking prompt, recording, transcript, and retest
-    owner_spec: null
-    allowed_deltas: [SPEAKING.Part]
-    shared_contracts: []
-    shared_entities: [SpeakingPrompt, SpeakingRecording, SpeakingAttempt]
-    shared_events: []
-    shared_failures: []
-    shared_acceptance: []
-    shared_evidence: [speaking_recording_acceptance]
+  # SPEAKING.Practice removed: orphan family, zero mapped capabilities.
+  # Speaking surface owned by SPEAKING.Evaluation (EVAL.Examiner, EVAL.Speaking, LEARN.Speaking).
+  # See convergence audit Batch 4, DIFF B4-2. Family count reconciles 26 → 25.
```

**Affected projections:** `executor-dossier.md`, semantic snapshot (25 stays), registry tests (expect 25 after removal).
**Validator impact:** registry test count 26→25; `implementation-catalog.rb` families count follows.

---

## DIFF B4-3: Reconcile PRACTICE.Drill namespace collision

**File:** `artifacts/operations/capability-family-map.yaml` (line 822-827) + `capability-family-registry.yaml` (lines 283-299)
**Rationale:** The capability `PRACTICE.Drill` maps to family `REVIEW.ErrorToReview` (ACTIVE, P0). A separate family `PRACTICE.Drill` (PLANNED) exists and owns `PRACTICE.Adaptive`, `PRACTICE.Set`, `PRACTICE.Timed`. The same string names both a capability and a family — namespace collision flagged in Batch 1. The capability-family-map validator (`implementation-catalog.rb`) enforces map = catalog = registry counts and would reject ambiguity if it were tracked; today it passes because the capability and family are separate namespaces. Recommend explicit disambiguation to prevent executor confusion.

**Proposed resolution (founder decision):** rename the PLANNED family to `PRACTICE.Drilling` OR annotate both entries. Renaming a family ID affects registry/map/lifecycle and is a protected change. Minimal safe alternative: add a documentation note to the registry `PRACTICE.Drill` family row clarifying the capability `PRACTICE.Drill` belongs to `REVIEW.ErrorToReview`, and the family owns only the PLANNED practice variants.

```diff
   - family_id: PRACTICE.Drill
     family_version: 1.0.0
     status: planned
     ...
-    purpose: Reusable question/task drill attempt and result workflow.
+    purpose: Reusable question/task drill attempt and result workflow.
+    # Note: capability PRACTICE.Drill (P0) maps to REVIEW.ErrorToReview.
+    # This PLANNED family owns PRACTICE.Adaptive / PRACTICE.Set / PRACTICE.Timed only.
```

**Affected projections:** `executor-dossier.md` (already notes the collision).
**Validator impact:** none (annotative).

---

## DIFF B4-4: Align GOVERNANCE.Quality lifecycle with deprecated-only membership

**File:** `artifacts/operations/capability-family-registry.yaml` (lines 499-515) + `capability-lifecycle-registry.yaml`
**Rationale:** `GOVERNANCE.Quality` is `PLANNED` but its only mapped capability is `EVAL.AntiGaming` (DEPRECATED alias, deferred). All live governance capabilities map to `OPS.QualityEconomics`. A PLANNED family whose sole member is deprecated has a lifecycle smell: PLANNED implies future work, but the member is retired. Since the family's purpose ("Anti-gaming, bias, drift, confidence, audit, and gold-standard governance beyond P0") is already covered by `OPS.QualityEconomics` (which hosts `GOVERNANCE.AntiGaming/DriftDetection/BiasMonitoring/GoldStandardBenchmark/Dashboard`), the family is redundant.

**Proposed resolution (founder decision):** deprecate `GOVERNANCE.Quality` as a family (its DEPRECATED alias member already routes to `OPS.QualityEconomics`), OR keep it PLANNED as a future consolidated governance family and annotate. Recommend deprecate to remove the lifecycle smell and redundant surface.

**Affected projections:** `executor-dossier.md`, semantic snapshot.
**Validator impact:** lifecycle-registry may need the family lifecycle noted.

---

## Attestation (covers Batch 4 protected diffs)

```yaml
change_id: convergence-batch-4-protected-diffs
change_scope: artifacts/operations/capability-family-registry.yaml, capability-family-map.yaml, capability-lifecycle-registry.yaml
protected_changes_reviewed: true
authority_boundaries_changed: false
validators_weakened: false
evidence_modified: false
readiness_claimed: false
commands_run: [tools/bin/lenbands verify, tools/bin/lenbands gate toolchain]
external_review_required: true
```

## Post-Apply

1. Apply B4-1 (interaction_spec), B4-2 (SPEAKING.Practice removal, Option A), B4-3 (annotation), B4-4 (deprecate GOVERNANCE.Quality) per founder decision
2. Regenerate `executor-dossier.md` + `web-surface-inventory.md` projections
3. Run `tools/bin/lenbands verify` + `gate toolchain`; confirm `gate p0` stays exit 3
4. Registry test counts follow the chosen option (25 vs 26)
