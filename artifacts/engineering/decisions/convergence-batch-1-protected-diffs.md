# Privileged-Review Diffs — Convergence Batch 1 (Protected Framework Files)

**Status:** Proposed. Requires external CODEOWNERS review per `agent-trust-policy.yaml`.
**Date:** 2026-08-10
**Audit source:** Converge-documents all — IELTS semantics auditor, red-team reviewer
**Affected protected paths:** `blueprint/framework/microskill-enum.md`, `blueprint/framework/band-descriptor-map.md`, `blueprint/framework/error-taxonomy.md`, `blueprint/framework/speaking-parts-framework.md`

---

## DIFF 1: Fix invented framework ID `R_matching_information` (H4)

**File:** `blueprint/framework/microskill-enum.md`
**Line:** 42
**Rationale:** `R_matching_information` is not a valid question type ID. Real controlled IDs are `R_matching_information_paragraph` and `R_matching_information_section`. Violates controlled-vocabulary rule.
**Affected projections:** `artifacts/operations/catalogs/dependency-graph.yaml:68` — must regenerate after fix.
**Validator impact:** None (content fix).

```diff
-  - R_matching_information             # same main-idea and paraphrase mechanism, advanced
+  - R_matching_information_paragraph   # same main-idea and paraphrase mechanism, advanced
```

---

## DIFF 2: Fix invented framework ID `flow_chart_labelling` (H5)

**File:** `blueprint/framework/microskill-enum.md`
**Line:** 63
**Rationale:** `flow_chart_labelling` is not a valid question type ID. Real controlled ID: `L_flow_chart_completion`.
**Affected projections:** None.
**Validator impact:** None.

```diff
-| `L_stage_tracking` | Follow the process/diagram stage | flow_chart_labelling | 6.0 |
+| `L_stage_tracking` | Follow the process/diagram stage | L_flow_chart_completion | 6.0 |
```

---

## DIFF 3: Fix Speaking PR band 5 descriptor (H6)

**File:** `blueprint/framework/band-descriptor-map.md`
**Line:** 142
**Rationale:** "Shows all 4 positive features band 6" contradicts official IELTS source which says "shows all the positive features of Band 4 and some, but not all, of the positive features of Band 6." Framework rule: "if it conflicts with an official source, the official source prevails."
**Affected projections:** `BAND.Requirement`, `EVAL.Speaking`.
**Validator impact:** None.

```diff
-| 5 | Shows all 4 positive features band 6 **but with some problems** OR shows some band 6 features but not sustained, can be understood generally but effort required by listener |
+| 5 | Shows all positive features of **Band 4** and some, but not all, positive features of Band 6, can be understood generally but effort required by listener |
```

---

## DIFF 4: Fix Chinese character contamination — Writing LR band 3

**File:** `blueprint/framework/band-descriptor-map.md`
**Line:** 62

```diff
-| 3 | Very limited, may repeat frequently |
-| 3 | Very limited, may repeat often, errors frequent |
+| 3 | Very limited, may repeat often, errors frequent |
```

---

## DIFF 5: Fix garbled Speaking FC band 8

**File:** `blueprint/framework/band-descriptor-map.md`
**Line:** 89

```diff
-| 8 | Develops topics coherently+appropriately; fluency relates to language content (not accent) |
-| 8 | Speaks fluently with only occasional repetition or self-correction; hesitation is usually content-related and only rarely to search for language; develops topics coherently and appropriately |
+| 8 | Speaks fluently with only occasional repetition or self-correction; hesitation is usually content-related and only rarely to search for language; develops topics coherently and appropriately |
```

---

## DIFF 6: Fix Chinese char contamination — Speaking PR band 9

**File:** `blueprint/framework/band-descriptor-map.md`
**Line:** 138

```diff
-| 9 | Effortless to understand, full-range features (rhythm, intonation, individual sounds) |
+| 9 | Effortless to understand, uses a full range of pronunciation features with precision and subtlety; sustains flexible use of features throughout |
```

---

## DIFF 7: Fix Chinese char contamination — Speaking PR band 7

**File:** `blueprint/framework/band-descriptor-map.md`
**Line:** 140

```diff
-| 7 | Shows all positive features (6) **and** some use of features band 8 — easy to understand throughout, with occasional individual sound errors that do not affect meaning |
+| 7 | Shows all the positive features of Band 6 and some, but not all, of the positive features of Band 8; easy to understand throughout, with occasional individual sound errors that do not affect meaning |
```

---

## DIFF 8: Fix Chinese char contamination — Speaking PR band 8

**File:** `blueprint/framework/band-descriptor-map.md`
**Line:** 139

```diff
-| 8 | Easy to understand throughout, variety of features, occasional individual sound mispronunciations that do not affect meaning |
+| 8 | Easy to understand throughout, uses a wide variety of pronunciation features; occasional individual sound mispronunciations that do not affect meaning |
```

---

## DIFF 9: Fix Chinese char — error-taxonomy.md

**File:** `blueprint/framework/error-taxonomy.md`
**Line:** 43

```diff
-| `L_ans_wrong_content` | content | Hear the wrong idea and select the wrong answer based on actual content | answer-key | 4.0 | `L_signal_word_detection` |
+| `L_ans_wrong_content` | content | Hear the wrong idea and select the wrong answer based on actual content | answer-key | 4.0 | `L_signal_word_detection` |
```

---

## DIFF 10: Fix Chinese char — speaking-parts-framework.md

**File:** `blueprint/framework/speaking-parts-framework.md`
**Line:** 170

```diff
-| 7.0 | Easy to understand throughout, sustained features, rare errors do not affect meaning |
+| 7.0 | Easy to understand throughout, sustained features, rare errors do not affect meaning |
```

---

## Attestation Required

```yaml
change_id: convergence-batch-1-framework-fixes
change_scope: blueprint/framework/ (4 files, 10 diffs)
protected_changes_reviewed: true
authority_boundaries_changed: false
validators_weakened: false
evidence_modified: false
readiness_claimed: false
commands_run: [tools/bin/lenbands verify, tools/bin/lenbands gate toolchain]
external_review_required: true
```

## Post-Apply

1. Bump each file's frontmatter `version` to `1.0.7` (patch)
2. Bump `blueprint/framework/README.md` `framework_version` to `1.0.7`
3. Regenerate `artifacts/operations/catalogs/dependency-graph.yaml`
4. Run `verify` + `gate toolchain`
5. Confirm `gate p0` remains exit 3
