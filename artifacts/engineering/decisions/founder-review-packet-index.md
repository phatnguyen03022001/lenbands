# Founder Review Packet — Index of 21 Protected Diffs

**Status:** Index only. No protected diff is applied by this document.
**Date:** 2026-08-10
**Purpose:** Give the founder one decision table for all protected diffs awaiting review (21 diffs, 4 documents). Each diff lists: decision required | options | affected canonical owner | consequences | migration/validator impact | attestation/CODEOWNERS requirement.

**No diff is applied here.** Application occurs through the privileged workflow + attestation + external CODEOWNERS review after founder approval.

---

## Batch 1 — `convergence-batch-1-protected-diffs.md` (10 diffs, framework files)

| # | Diff | Decision required | Options | Affected owner | Consequences | Migration/validator impact | Attestation/CODEOWNERS |
|---|---|---|---|---|---|---|---|
| B1-1 | `microskill-enum.md:42` `R_matching_information` → `R_matching_information_paragraph` | Approve correction | (a) fix to real ID (b) mark unknown_* | `blueprint/framework/microskill-enum.md` (protected) | Controlled-vocab violation resolved; dependency-graph.yaml regenerated | validator unchanged; regenerator re-runs projection | required (blueprint/CODEOWNERS) |
| B1-2 | `microskill-enum.md:63` `flow_chart_labelling` → `L_flow_chart_completion` | Approve correction | (a) fix to real ID (b) mark unknown_* | `microskill-enum.md` (protected) | Controlled-vocab resolved | validator unchanged | required |
| B1-3 | `band-descriptor-map.md:142` Speaking PR band 5 → official source (Band 4) | Approve correction | fix to official descriptor | `band-descriptor-map.md` (protected) | EVAL.Speaking/BAND.Requirement alignment | validator unchanged; framework version 1.0.6→1.0.7 | required |
| B1-4 | `band-descriptor-map.md:62` Chinese char (LR band 3) | Approve cleanup | English rewrite | same | Descriptor hygiene | framework patch bump | required |
| B1-5 | `band-descriptor-map.md:89` garbled FC band 8 | Approve rewrite | official-source rewrite | same | FC scoring clarity | framework patch bump | required |
| B1-6 | `band-descriptor-map.md:138` Chinese char (PR band 9) | Approve cleanup | English rewrite | same | Descriptor hygiene | framework patch bump | required |
| B1-7 | `band-descriptor-map.md:140` Chinese char (PR band 7) | Approve cleanup | English rewrite | same | Descriptor hygiene | framework patch bump | required |
| B1-8 | `error-taxonomy.md:43` Chinese char | Approve cleanup | English rewrite | `error-taxonomy.md` (protected) | Taxonomy hygiene | framework patch bump | required |
| B1-9 | `speaking-parts-framework.md:170` Chinese char | Approve cleanup | English rewrite | `speaking-parts-framework.md` (protected) | Hygiene | framework patch bump | required |
| B1-10 | `band-descriptor-map.md:139` Chinese char (PR band 8) | Approve cleanup | English rewrite | `band-descriptor-map.md` (protected) | Hygiene | framework patch bump | required |

**Batch 1 post-apply:** bump 4 framework files to 1.0.7, README framework_version 1.0.7, regenerate dependency-graph.yaml.

## Batch 2 — `convergence-batch-2-protected-diffs.md` (4 diffs)

| # | Diff | Decision required | Options | Affected owner | Consequences | Migration/validator impact | Attestation/CODEOWNERS |
|---|---|---|---|---|---|---|---|
| B2-M6 | `review-mapping.md` fsrs_card_kind composition rule + 6 compound cells | Approve composition rule | (a) add composition rule (b) rename compound cells | `blueprint/framework/review-mapping.md` (protected) | Controlled-vocab FSRS card kinds; data contract stores base_kind only | framework patch bump 1.0.7; optional validator for enum | required |
| B2-M3 | `capability-manifest.yaml:21` P0-01 identity states → guest/authenticated/consent_pending/active/deletion_* | Approve alignment | (a) align to auth contract (b) keep + document divergence | `capability-manifest.yaml` (protected) | Cross-owner state vocabulary resolved | implementation-catalog.rb expected-state update | required |
| B2-P0-02 | `capability-manifest.yaml:53` P0-02 placement states → new/in_progress/paused/submitted/diagnosed/insufficient_data | Approve alignment | (a) align to contract | `capability-manifest.yaml` | State vocab resolved (H1) | impl-catalog update | required |
| B2-P0-04 | `capability-manifest.yaml:119` P0-04 states → submission-only (remove eval states) | Approve separation | (a) submission-only (b) split axes | `capability-manifest.yaml` | submission vs evaluation state de-conflated (H3) | impl-catalog update | required |

## Batch 3 — `convergence-batch-3-protected-diffs.md` (3 diffs)

| # | Diff | Decision required | Options | Affected owner | Consequences | Migration/validator impact | Attestation/CODEOWNERS |
|---|---|---|---|---|---|---|---|
| B3-1 | `blueprint/03-features.md:314` P0-04 privacy `learning/assessment` → `assessment` | Approve enum fix | (a) assessment (single member) | `blueprint/03-features.md` (protected) | Controlled-vocab privacy class fixed | optional privacy_class validator | required |
| B3-2 | `blueprint/03-features.md:316` P0-06 privacy `assessment` → `derived` | Approve reconciliation | (a) derived (manifest) (b) keep assessment + note | `blueprint/03-features.md` + manifest (protected) | P0-06 privacy class reconciled | optional validator | required |
| B3-3 | `capability-manifest.yaml:202` remove `anti_gaming_flagged` from P0-06 events | Approve scope fix | (a) remove (b) keep + P1 gate note | `capability-manifest.yaml` | No P1-produced event in P0 pack; drift event flagged for follow-up decision | impl-catalog event-check | required |

## Batch 4 — `convergence-batch-4-protected-diffs.md` (4 diffs)

| # | Diff | Decision required | Options | Affected owner | Consequences | Migration/validator impact | Attestation/CODEOWNERS |
|---|---|---|---|---|---|---|---|
| B4-1 | `capability-family-registry.yaml:114` WRITING.Evaluation interaction_spec → writing-task-2.md | Approve ref fix | (a) point to canonical | `capability-family-registry.yaml` (protected) | Deprecated interaction_spec resolved; web-surface-inventory regenerates | optional validator rejects deprecated ref | required |
| B4-2 | SPEAKING.Practice orphan family | Decide | (a) remove/deprecate (b) keep + add capabilities (Blueprint change) | registry + map + lifecycle (protected) | Family count 26→25 (a); orphan eliminated | registry test count; impl-catalog families | required + founder scope decision |
| B4-3 | PRACTICE.Drill namespace collision | Decide | (a) annotate (b) rename family | registry + map (protected) | Executor confusion removed | none (annotative) | required |
| B4-4 | GOVERNANCE.Quality lifecycle (deprecated-only member) | Decide | (a) deprecate family (b) keep PLANNED + annotate | registry + lifecycle (protected) | Lifecycle smell removed (a) | lifecycle-registry update | required |

---

## Aggregate decision summary

| Decision type | Count | Diffs |
|---|---|---|
| Content correction (approve & apply) | 13 | B1-1..B1-10, B2-M6, B3-1, B3-2, B3-3 |
| State/reference alignment (approve & apply) | 5 | B2-M3, B2-P0-02, B2-P0-04, B4-1 (+ B3-2 overlaps) |
| Scope/structure decision (founder chooses option) | 3 | B4-2 (remove vs keep), B4-3 (annotate vs rename), B4-4 (deprecate vs keep) |

**Priorities:**
1. **B4-2** — orphan SPEAKING.Practice; blocks family-count/ownership reconciliation (req 8).
2. **B1-3** — official-descriptor correction; blocks IELTS semantics (req 3).
3. **B3-1/B3-2** — privacy class enum; blocks controlled vocabulary (req 3).
4. **B2-M6/B2-M3** — controlled-vocab FSRS + identity states (req 3/8).
5. Batch 1 hygiene (B1-4..B1-10) — low risk, can batch-approve.

## How to apply (after founder decision)

1. Founder approves each diff (or option choice).
2. Each batch doc is applied via privileged workflow with attestation (validators_weakened: false, evidence_modified: false).
3. Post-apply: run `verify`, `gate toolchain`; confirm `gate p0` exit 3.
4. Re-audit changed owners (framework/registry) before certifying req 1/3/8 in the certification ledger.
5. Regenerate affected projections (dependency-graph, web-surface-inventory, executor-dossier, capability-index).

## References

- `convergence-batch-1-protected-diffs.md` (10 diffs)
- `convergence-batch-2-protected-diffs.md` (4 diffs)
- `convergence-batch-3-protected-diffs.md` (3 diffs)
- `convergence-batch-4-protected-diffs.md` (4 diffs)
- `artifacts/operations/catalogs/global-certification-ledger.md`
