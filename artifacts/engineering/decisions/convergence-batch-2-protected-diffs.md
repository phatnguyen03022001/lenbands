# Privileged-Review Diffs — Convergence Batch 2 (Protected Framework Files)

**Status:** Proposed. Requires external CODEOWNERS review.
**Date:** 2026-08-10
**Source:** Red-team audit M6, M3 (partial)
**Affected protected paths:** `blueprint/framework/review-mapping.md`, `artifacts/operations/capability-manifest.yaml`

---

## DIFF M6: Document fsrs_card_kind composition rule

**File:** `blueprint/framework/review-mapping.md`
**Lines:** 15-26 (enum declaration), 59, 66, 82-85 (compound values)
**Rationale:** The `fsrs_card_kind` enum declares 8 single values, but 6 table rows use compound/non-enum values: `recall_grammar_rule + rewrite` (line 59), `apply_grammar_correct + rule` (line 66), `apply_grammar_correct (oral)` (line 82), `recall_meaning + drill` (line 83), `recall_form + drill` (line 84), `retest_question_type (shadowing)` (line 85). The data contract stores `fsrs_card_kind: string` from this table. An implementer cannot determine whether `apply_grammar_correct + rule` is one value or two. This is a controlled-vocabulary violation inside the SSOT framework.
**Resolution:** Add a composition rule to the enum declaration, then standardize the compound notation in table cells.

### Part A — Add composition rule after the enum table

```diff
--- a/blueprint/framework/review-mapping.md
+++ b/blueprint/framework/review-mapping.md
@@ -26,6 +26,14 @@
 | `retest_question_type` | Retake the same question type and micro-skill | 1 new Reading Matching Headings question |

+### Composition rule
+
+When a review card needs multiple modes, the table uses the notation `base_kind + modifier`.
+`base_kind` must be one of the 8 enum values above. `modifier` describes the additional mode
+and comes from the controlled set: `rewrite`, `rule`, `drill`, `oral`, `shadowing`.
+The data contract (`error-to-review/data-contract.md`) stores only `base_kind`;
+`modifier` is a UI/display hint, not an independent enum value.
+
 ## Listening — error → review mapping
```

### Part B — Normalize compound cells

Line 59:
```diff
-| `W_cc_mechanical_cohesive` | Practice cohesive range | `recall_grammar_rule` + rewrite | 3 → 7 | connector list |
+| `W_cc_mechanical_cohesive` | Practice cohesive range | `recall_grammar_rule` (`+ rewrite`) | 3 → 7 | connector list |
```

Line 66:
```diff
-| `W_gra_relative_clause` | Practice relative clauses | `apply_grammar_correct` + rule | 2 → 7 → 21 | — |
+| `W_gra_relative_clause` | Practice relative clauses | `apply_grammar_correct` (`+ rule`) | 2 → 7 → 21 | — |
```

Line 82:
```diff
-| `S_gra_only_simple` | Practice complex spoken grammar | `apply_grammar_correct` (oral) | 7 → 21 | record |
+| `S_gra_only_simple` | Practice complex spoken grammar | `apply_grammar_correct` (`+ oral`) | 7 → 21 | record |
```

Line 83:
```diff
-| `S_pr_phoneme` | Practice phonemes | `recall_meaning` + drill | 1 → 3 → 7 → 21 | sample audio + record |
+| `S_pr_phoneme` | Practice phonemes | `recall_meaning` (`+ drill`) | 1 → 3 → 7 → 21 | sample audio + record |
```

Line 84:
```diff
-| `S_pr_word_stress` | Practice word stress | `recall_form` + drill | 1 → 3 → 7 | word list |
+| `S_pr_word_stress` | Practice word stress | `recall_form` (`+ drill`) | 1 → 3 → 7 | word list |
```

Line 85:
```diff
-| `S_pr_intonation_flat` | Practice intonation | `retest_question_type` (shadowing) | 7 → 21 | shadowing sample audio |
+| `S_pr_intonation_flat` | Practice intonation | `retest_question_type` (`+ shadowing`) | 7 → 21 | shadowing sample audio |
```

**Affected projections:** `error-to-review/data-contract.md` (consumes `fsrs_card_kind` as string; no change needed if only base value is stored).
**Validator impact:** None (content fix). Future validator could enforce `base_kind` ∈ declared enum.
**Post-apply:** Bump `review-mapping.md` frontmatter `version` to `1.0.7`.

---

## DIFF M3 (protected): Align capability-manifest.yaml P0-01 identity states

**File:** `artifacts/operations/capability-manifest.yaml`
**Line:** 21 (P0-01 `states` field)
**Rationale:** The manifest declares P0-01 states as `[anonymous, authenticating, active, consent_required, recovery_required, deletion_requested]`. The canonical auth contract uses `guest → authenticated → consent_pending → active`, plus `deletion_requested → deletion_processing → deleted`. The manifest uses different names for 5 of 6 states. `recovery_required` references `IDENTITY.Recovery` which is deferred/P1 and not in P0-01 capability_ids. This is a cross-owner contradiction with the canonical auth contract.

```diff
--- a/artifacts/operations/capability-manifest.yaml
+++ b/artifacts/operations/capability-manifest.yaml
@@ -21,7 +21,7 @@
-    states: [anonymous, authenticating, active, consent_required, recovery_required, deletion_requested]
+    states: [guest, authenticated, consent_pending, active, deletion_requested, deletion_processing, deleted]
```

**Affected projections:** `capability-manifest.yaml` is `source_of_truth: false` (typed projection seed). Semantic validator checks manifest states against family registry.
**Validator impact:** `implementation-catalog.rb` cross-checks family states. May need to update expected state set for `IDENTITY.Core`.
**Post-apply:** Run `tools/bin/lenbands validate implementation-catalog` to confirm.

---

## DIFF (cumulative from Batch 1): P0-02 and P0-04 manifest states

These are documented in Batch 1's privileged-review diffs (`convergence-batch-1-protected-diffs.md` did NOT include them — they are NEW):

### P0-02 Placement states (H1 protected side)

**File:** `artifacts/operations/capability-manifest.yaml`
**Line:** 53 (P0-02 `states` field)
**Rationale:** Manifest uses `[not_started, in_progress, scored, insufficient_evidence, retry_required]`. Canonical placement-diagnosis-contract.md uses `new | in_progress | paused | submitted | diagnosed | insufficient_data`. Must align manifest with canonical data contract.

```diff
-    states: [not_started, in_progress, scored, insufficient_evidence, retry_required]
+    states: [new, in_progress, paused, submitted, diagnosed, insufficient_data]
```

### P0-04 Writing evaluation states (H3 protected side)

**File:** `artifacts/operations/capability-manifest.yaml`
**Line:** 119 (P0-04 `states` field)
**Rationale:** Manifest mixes submission states with evaluation states (`invalid`, `anti_gaming_review`, `failed`). Runtime-spec explicitly separates `submission.status` from `evaluation.evaluation_state`. Manifest should use only submission states.

```diff
-    states: [drafting, submitted, processing, scored, low_confidence, unavailable, delayed, invalid, anti_gaming_review, failed]
+    states: [submitted, processing, scored, low_confidence, unavailable, delayed]
```

Note: `drafting` is pre-submission (draft service state); `invalid`, `anti_gaming_review`, `failed` are evaluation states (separate axis per runtime-spec §5.2).

---

## Attestation (covers all Batch 1 + Batch 2 protected diffs)

```yaml
change_id: convergence-batch-2-protected-diffs
change_scope: blueprint/framework/review-mapping.md, artifacts/operations/capability-manifest.yaml
protected_changes_reviewed: true
authority_boundaries_changed: false
validators_weakened: false
evidence_modified: false
readiness_claimed: false
commands_run: [tools/bin/lenbands verify, tools/bin/lenbands gate toolchain, tools/bin/lenbands validate implementation-catalog]
external_review_required: true
```
