# Founder Review — Detailed 21-Diff Annex

- **Type:** detailed-annex — all 21 historical diffs migrated from `engineering/decisions/founder-review-packet-index.md` (the old index).
- **Status:** `review`
- **Created:** 2026-08-11
- **Source:** `convergence-batch-1-protected-diffs.md`, `convergence-batch-2-protected-diffs.md`, `convergence-batch-3-protected-diffs.md`, `convergence-batch-4-protected-diffs.md`
- **Bidirectional link:** canonical index at `artifacts/operations/founder-review-packet-index.md`

## Count arithmetic

- **21 historical diffs** from 4 convergence batches (B1:10 + B2:4 + B3:3 + B4:4 = 21).
- **4 historical diffs verified and promoted** to current PD-IDs: B4-1→PD-03, B4-2→PD-01, B4-3→PD-02, B4-4→PD-04.
- **16 separately tracked historical B-IDs:** B1-1..B1-10, B2-M3/B2-M6/B2-P0-02/B2-P0-04, B3-1, B3-2. These retain their original batch identifiers. They are NOT PD-IDs. B3-3 is routed as a subdecision under PD-05 and is not counted in this separate list.
- **PD-05 is NOT one of the 21.** It is a current protected P0-06 phase/scope decision; B3-3 is canonically routed to it as a subdecision alongside the OPS.ContentQuality question.
- **PD-06 (event authority) and PD-07 (readiness-matrix fail-closed) were added in canonical index v0.1.2 (2026-08-11).** They are tracked only in the canonical index and do not correspond to any historical batch diff.
- **Non-overlapping ledger:** 21 historical B-IDs total; B4-1..B4-4 are represented by PD-03, PD-01, PD-02, and PD-04 respectively; B3-3 is routed under PD-05; 16 historical B-IDs remain separately tracked; 7 current PD records; 6 current D records. These categories overlap and must not be summed into a single total.

## Purpose

This annex preserves the full historical record of 21 protected diffs across 4 convergence batches.
Historical batch IDs (B1-*, B2-*, B3-*) are preserved in their original form and are distinct from
current PD-IDs (PD-01..PD-07; this annex details PD-01..PD-05 while PD-06 and PD-07 are defined in the canonical index only). The canonical index summarizes decisions and priority.

## Batch 1 — framework files (10 diffs)

Source: `convergence-batch-1-protected-diffs.md`. Protected path: `blueprint/framework/**`.

| # | Diff | Decision | Options | Revalidation status |
|---|---|---|---|---|
| B1-1 | `microskill-enum.md:42` `R_matching_information` → `R_matching_information_paragraph` | Approve correction | (a) fix to real ID (b) mark unknown_* | **still_applies** — `R_matching_information` present at `blueprint/framework/microskill-enum.md:42`; correction not applied. Needs engineering/CODEOWNERS framework review; bump file version. |
| B1-2 | `microskill-enum.md:63` `flow_chart_labelling` → `L_flow_chart_completion` | Approve correction | (a) fix to real ID (b) mark unknown_* | **still_applies** — `flow_chart_labelling` present at `blueprint/framework/microskill-enum.md:63` in `applies_to` column; correction not applied. Needs engineering/CODEOWNERS framework review; bump file version, regenerate projections. |
| B1-3 | `band-descriptor-map.md:142` Speaking PR band 5 → official source (Band 4) | Approve correction | fix to official descriptor | **needs_external_source** — current text at `blueprint/framework/band-descriptor-map.md:142` reads band 5 descriptor. Claim that this matches official IELTS Band 4 cannot be verified within this session. Requires: named official IELTS source (URL + retrieval date) confirming the band 4/5 distinction before any apply recommendation. Do not infer IELTS descriptors from memory. |
| B1-4 | `band-descriptor-map.md:62` Chinese char (LR band 3) | Approve cleanup | English rewrite | **still_applies** — Chinese characters present at `blueprint/framework/band-descriptor-map.md:62`. Cleanup not applied. Needs engineering/CODEOWNERS framework review (hygiene only, no semantic change). |
| B1-5 | `band-descriptor-map.md:89` garbled FC band 8 | Approve rewrite | official-source rewrite | **still_applies** — garbled text "fluency chia" present at `blueprint/framework/band-descriptor-map.md:89`. Needs engineering review + official IELTS FC band 8 source to verify correct wording. |
| B1-6 | `band-descriptor-map.md:138` Chinese char (PR band 9) | Approve cleanup | English rewrite | **still_applies** — Chinese characters present at `blueprint/framework/band-descriptor-map.md:138`. Cleanup not applied. |
| B1-7 | `band-descriptor-map.md:140` Chinese char (PR band 7) | Approve cleanup | English rewrite | **still_applies** — Chinese characters present at `blueprint/framework/band-descriptor-map.md:140`. Cleanup not applied. |
| B1-8 | `error-taxonomy.md:43` Chinese char | Approve cleanup | English rewrite | **still_applies** — Chinese characters present at `blueprint/framework/error-taxonomy.md:43`. Cleanup not applied. |
| B1-9 | `speaking-parts-framework.md:170` Chinese char | Approve cleanup | English rewrite | **still_applies** — Chinese characters present at `blueprint/framework/speaking-parts-framework.md:170`. Cleanup not applied. |
| B1-10 | `band-descriptor-map.md:139` Chinese char (PR band 8) | Approve cleanup | English rewrite | **still_applies** — Chinese characters present at `blueprint/framework/band-descriptor-map.md:139`. Cleanup not applied. |

Post-apply: bump 4 framework files to 1.0.7, update README framework_version.

## Batch 2 — capability manifest + review mapping (4 diffs)

Source: `convergence-batch-2-protected-diffs.md`. Protected path: `artifacts/operations/capability-manifest.yaml`, `blueprint/framework/review-mapping.md`.

| # | Diff | Decision | Options | Revalidation status |
|---|---|---|---|---|
| B2-M6 | `review-mapping.md` fsrs_card_kind composition rule + 6 compound cells | Approve composition rule | (a) add rule (b) rename cells | **still_applies** — compound cells present at `blueprint/framework/review-mapping.md:59,60,66,83` (e.g. `recall_grammar_rule + rewrite`, `apply_grammar_correct + rule`, `recall_meaning + drill`). No composition rule declared. Needs engineering framework review; if composition is intended, add a rule; otherwise normalize cells to single values. |
| B2-M3 | `capability-manifest.yaml:21` P0-01 identity states → guest/authenticated/consent_pending/active/deletion_* | Approve alignment | (a) align to auth contract (b) keep + document | **still_applies** — manifest line 21 states: `[anonymous, authenticating, active, consent_required, recovery_required, deletion_requested]`; canonical auth-identity-contract states: `guest → authenticated → consent_pending → active; deletion_requested → deletion_processing → deleted`. Vocabulary mismatch. Needs engineering/CODEOWNERS review to align manifest to contract. |
| B2-P0-02 | `capability-manifest.yaml:53` P0-02 placement states → new/in_progress/paused/submitted/diagnosed/insufficient_data | Approve alignment | (a) align to contract | **still_applies** — manifest line 53 states: `[not_started, in_progress, scored, insufficient_evidence, retry_required]`; canonical OpenAPI/lifecycle states: `[new, in_progress, paused, submitted, diagnosed, insufficient_data]`. Vocabulary mismatch. Needs engineering/CODEOWNERS review to align manifest to contract. |
| B2-P0-04 | `capability-manifest.yaml:119` P0-04 states → submission-only (remove eval states) | Approve separation | (a) submission-only (b) split axes | **still_applies** — manifest line 119 states: `[drafting, submitted, processing, scored, low_confidence, delayed, unavailable, invalid, anti_gaming_review, failed]` — mixes submission lifecycle with evaluation lifecycle. Needs engineering/CODEOWNERS review to separate into distinct axes. |

## Batch 3 — privacy enum + event scope (3 diffs)

Source: `convergence-batch-3-protected-diffs.md`. Protected path: `blueprint/03-features.md`, `artifacts/operations/capability-manifest.yaml`.

| # | Diff | Decision | Options | Revalidation status |
|---|---|---|---|---|
| B3-1 | `blueprint/03-features.md:314` P0-04 privacy `learning/assessment` → `assessment` | Approve enum fix | (a) assessment (single member) | **still_applies** — `blueprint/03-features.md:314` privacy column still reads `learning/assessment` (compound). Should be single member `assessment` per data classification model. Needs engineering/CODEOWNERS review. |
| B3-2 | `blueprint/03-features.md:316` P0-06 privacy `assessment` → `derived` | Approve reconciliation | (a) derived (b) keep assessment + note | **still_applies** — `blueprint/03-features.md:316` privacy column still reads `assessment`. Governance/quality data is derived from assessment facts, should be `derived`. Needs engineering/CODEOWNERS review. |
| B3-3 | `capability-manifest.yaml:202` remove `anti_gaming_flagged` from P0-06 events | Approve scope fix | (a) remove (b) keep + P1 gate note | **still_applies** — `anti_gaming_flagged` still in P0-06 events_published at `capability-manifest.yaml:202` and `event-ownership-registry.yaml:43`, but governance dashboard marks anti-gaming P1-gated per `governance-ops-dashboard.meta.yaml:14-15`. The event already has canonical ownership (owner_pack P0-06, owner_family OPS.QualityEconomics, producer governance_worker at `event-ownership-registry.yaml:43`). This is NOT an event-authority gap (PD-06 concerns events with no owner; this event has one). The open question is P0-vs-P1 scope — whether to keep it in P0-06 as a placeholder until P1 or remove it now. This is an unassigned founder scope decision adjacent to PD-05 (both concern P0-06 scope boundaries) but independent of it. See aggregate category (e). |

## Batch 4 — family registry structure (4 diffs)

Source: `convergence-batch-4-protected-diffs.md`. Protected path: `capability-family-registry.yaml`, `capability-lifecycle-registry.yaml`, `blueprint/03-features.md`.

These 4 diffs correspond to PD-01..PD-04 in the canonical index. Revalidation status: verified against current protected-path file contents on 2026-08-10.

| # | Canonical ID | Diff | Decision | Options | Revalidation |
|---|---|---|---|---|---|
| B4-1 | PD-03 | `capability-family-registry.yaml:114` WRITING.Evaluation interaction_spec → writing-task-2.md | Approve ref fix | (a) point to canonical | verified 2026-08-10 — still applies |
| B4-2 | PD-01 | SPEAKING.Practice orphan family (0 caps) | Founder decides | (a) remove (b) add caps (c) keep idle | verified 2026-08-10 — still applies |
| B4-3 | PD-02 | PRACTICE.Drill namespace collision (cap vs family) | Founder decides | (a) annotate (b) rename family (c) rename cap | verified 2026-08-10 — still applies |
| B4-4 | PD-04 | GOVERNANCE.Quality deprecated-only member | Founder decides | (a) deprecate family (b) keep + annotate | verified 2026-08-10 — still applies |

## Aggregate decision summary — 5-category classification (all 21 historical diffs)

| Category | Count | Diffs | Precondition before apply |
|---|---|---|---|
| (a) Hygiene candidate — protected review only | 6 | B1-4, B1-6, B1-7, B1-8, B1-9, B1-10 | engineering/CODEOWNERS framework review; no semantic change |
| (b) Controlled-vocabulary target — needs verification | 2 | B1-1, B1-2 | verify replacement IDs resolve to current controlled vocabulary before applying |
| (c) External-source blocker — needs IELTS source | 2 | B1-3, B1-5 | named official IELTS source with retrieval date confirming the exact descriptor wording |
| (d) Technical protected alignment / framework semantics | 7 | B2-M3, B2-P0-02, B2-P0-04, B3-1, B3-2, B2-M6, B4-1 | engineering/CODEOWNERS review; align manifest/blueprint/framework to canonical contracts or resolve framework design choice |
| (e) Founder scope/structure decision | 4 | B4-2/PD-01, B4-3/PD-02, B4-4/PD-04, B3-3 | founder decision required before any apply |

Count verification: 6 + 2 + 2 + 7 + 4 = 21 ✓

### Category (e) details — founder scope/structure decisions

These diffs require founder product/scoping choices that cannot be resolved by engineering review alone.

| Diff | PD-ID | Decision | Evidence |
|---|---|---|---|
| B4-2 | PD-01 | SPEAKING.Practice orphan family | Remove / assign capabilities / keep idle |
| B4-3 | PD-02 | PRACTICE.Drill name collision | Rename cap / rename family / document |
| B4-4 | PD-04 | GOVERNANCE.Quality 1-cap family | Merge / keep / demote |
| B3-3 | — (routed to PD-05) | `anti_gaming_flagged` in P0-06 events: P0 or P1 scope? | Event has canonical owner (`event-ownership-registry.yaml:43`, `OPS.QualityEconomics`); the open question is P0-vs-P1 scope, not missing ownership. Governance dashboard marks anti-gaming P1-gated per `governance-ops-dashboard.meta.yaml:14-15`. Not covered by PD-06 (which concerns events without any owner). Canonically routed to PD-05 as a second P0-06 scope-boundary sub-decision (alongside OPS.ContentQuality phase exception). Independent of the OPS.ContentQuality question but constrains the same P0-06 pack boundary. See PD-05 in canonical index for options. |

B4-1/PD-03 is classified in category (d), not (e): it is a technical reference alignment in a protected registry where the canonical replacement (`writing-task-2.md`) is already known. Being in a protected path requires CODEOWNERS review but does not make the fix a founder scope decision.

B3-3 is canonically routed to PD-05 in the canonical index (not a separate PD-ID). PD-05 now covers two independent P0-06 scope-boundary sub-decisions: (a) OPS.ContentQuality ACTIVE+deferred phase exception; (b) anti_gaming_flagged P0-vs-P1 event scope. Both constrain what belongs in the P0-06 pack but are decided independently.

## References

- `artifacts/operations/founder-review-packet-index.md` — canonical index (bidirectional)
- `convergence-batch-1-protected-diffs.md` through `convergence-batch-4-protected-diffs.md` — original batch documents
- `artifacts/engineering/decisions/founder-review-packet-index.md` — old index (historical; superseded by this annex)
