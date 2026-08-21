# Coverage and Product Support Decisions

STATUS: SUPPORTING
ROLE: FOUNDER DECISION HISTORY
AUTHORITY: NONE

This file preserves all 20 founder decisions from 10F. The 10F block closed the founder decision phase by defining integrated product coverage, demand derivation, support promotion, and validation boundaries.

## 10F — Integrated coverage, demand, and support

| ID | Decision | Rationale |
|---|---|---|
| 10F.1 | Coverage is evaluated against a versioned `TargetCoverageSpecification` scoped to a TargetProfile / requirement claim, not a band-wide scalar. | Makes every coverage judgment auditable and prevents one global “Band 7 coverage” number from hiding missing conditions. |
| 10F.2 | Integrated coverage uses logical condition composition (`required`, `alternative`, `supporting`; AND/OR as specified), never a weighted aggregate score. | A mandatory timed or transfer condition cannot be averaged away by strong coverage elsewhere. |
| 10F.3 | Every material coverage condition keeps its own status; minimum operational statuses are `UNKNOWN`, `DEFINED`, `PARTIAL`, `SATISFIED`, `BLOCKED`, `NOT_APPLICABLE`, and `CALIBRATION_REQUIRED`. | Allows precise blockers without inventing false percentages. Product-level MODELLED/COVERED/SUPPORTED/VALIDATED remain separate namespaces. |
| 10F.4 | Integrated coverage evaluates the material chain: requirement → competency/behaviour/context → intervention/learning path → evidence/re-evidence/transfer → experience/transition → cost viability, subject to rights/privacy/reliability quality gates. | Coverage must represent an executable learner path, not just curriculum inventory. |
| 10F.5 | A coverage hole is a product-level `CoverageGap`, never a learner `GapEvaluation`. | Prevents product defects from being misinterpreted as learner weakness. |
| 10F.6 | Each CoverageGap records scope, failed/missing condition, gap class, blocking consequence, dependencies, provenance/version, and required demand outputs; it does not require a numeric severity score. | Enough structure for planning/audit without fake precision. |
| 10F.7 | Coverage-gap classes may include model/spec, intervention/activity, content/asset, evidence/evaluator, experience, transition, cost/operations, rights/privacy/reliability, and calibration/validation; taxonomy is operational and may be refined without changing learner ontology. | Different holes require different fixes; not every problem is “make more content.” |
| 10F.8 | A coverage gap first derives a `DemandClass`; only appropriate gaps produce asset demand. | Prevents asset factories from becoming the universal answer to missing evaluator, UX, rights, reliability, or calibration capability. |
| 10F.9 | Demand derivation runs backward: CoverageGap → missing semantic capability → required activity/evidence/transition contract → demand class → asset/capability specification. | Keeps demand causally tied to a missing product path. |
| 10F.10 | For content demand, derive asset role, required contexts/variation, reuse constraints, novelty/transfer role, rights/provenance requirements, evaluator compatibility, and only then quantity. | Asset count becomes an output of semantic coverage requirements rather than a founder quota. |
| 10F.11 | Reuse an existing eligible asset/template/generator before creating a new asset when rights, quality, context, exposure/novelty, and evidence semantics permit. | Reduces cost and duplication without allowing overexposed material to masquerade as transfer evidence. |
| 10F.12 | Coverage symmetry means the same completeness standard across supported target profiles, not equal asset volume or equal difficulty distribution. | Different targets may need different quantities while still passing the same semantic coverage gate. |
| 10F.13 | `MODELLED → COVERED` only when the required semantic model is defined and every blocking integrated-coverage condition for the scoped target is satisfied; no blocking CoverageGap may remain. | Defines COVERED as a condition-satisfaction claim, not “lots of assets exist.” |
| 10F.14 | A `CALIBRATION_REQUIRED` condition blocks COVERED only when that calibration is necessary for the covered path/claim to operate truthfully; otherwise it remains a declared non-blocking validation backlog item. | Allows learning-path coverage before outcome validation while preventing uncalibrated scoring/readiness claims from slipping through. |
| 10F.15 | `COVERED → SUPPORTED_FOR_PRODUCT` requires an explicit versioned TargetSupportDeclaration plus all release-critical quality, rights, privacy/security, reliability, cost-viability, and claim-specific calibration gates required by that declaration. | Separates semantic path completeness from the decision to expose/support that target in the product. |
| 10F.16 | `SUPPORTED_FOR_PRODUCT → VALIDATED` requires scoped empirical evidence over the declared target/profile, learner population, product/evaluator/intervention versions, outcome, operating conditions, and evidence period. | Validation is an empirical claim with scope; it never follows from architectural coherence alone. |
| 10F.17 | Explicit support blockers include any unresolved mandatory construct/requirement ambiguity, missing required learning/intervention path, missing admissible independent/re-evidence/transfer path where required, experience dead-end, failed rights/privacy/security/reliability gate, non-viable operating path, or missing claim-critical calibration. | Makes “not supported” deterministic and reviewable rather than a discretionary product judgment. |
| 10F.18 | Product support is versioned and revocable: new quality, rights, provider, cost, calibration, or construct evidence may suspend/downgrade future support without rewriting historical declarations. | Support status must react to real regressions while preserving audit history. |
| 10F.19 | Validation backlog is separate from support blockers: a validation item is non-blocking only when the current product promise does not depend on that empirical claim; if the promise depends on it, the item becomes a blocking release gate. | Prevents both extremes: requiring outcome RCTs before any useful product, or marketing unvalidated claims as truth. |
| 10F.20 | 10F produces four operational outputs: Target Coverage Matrix, CoverageGap Register, Demand Register (asset and non-asset), and TargetSupportDeclaration/Validation Backlog; coverage summaries may report blocker/count metadata but never a single completeness percentage. | Creates the implementation bridge from model to work demand while preserving non-aggregate semantics. |

## Promotion semantics

```text
TargetCoverageSpecification
        ↓
logical condition evaluation
        ↓
no blocking CoverageGap
        ↓
COVERED
        ↓
TargetSupportDeclaration + release gates
        ↓
SUPPORTED_FOR_PRODUCT
        ↓
scoped empirical evidence
        ↓
VALIDATED
```

`SUPPORTED_FOR_PRODUCT` is a product-support claim. It is not the same as a learner readiness result named `SUPPORTED`.

Original source: `artifacts/operations/decisions/lenbands-decision-register-v1.0.0-founder-locked-2026-08-12.md`.