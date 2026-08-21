# AI Evaluation and Cost Decisions

STATUS: SUPPORTING
ROLE: FOUNDER DECISION HISTORY
AUTHORITY: NONE

Source authority at lock time: `A1_FOUNDER_SELECTED_UNRECORDED`.

This file preserves all 12 V6 founder decisions. Model/provider activation, benchmark acceptance, calibration, privacy, and scoring authority remain governed by current canonical contracts.

## V6 — AI evaluation and cost architecture

| ID | Decision | Rationale |
|---|---|---|
| V6.1 | Flash-first evaluator; stronger/Pro route only for hard cases. | Control variable AI cost while preserving an escalation path. |
| V6.2 | Disagreement handling depends on risk/level. | Not every disagreement deserves the same spend or workflow. |
| V6.3 | Asynchronous evaluation acceptable; show truthful coarse states instead of forcing low latency at quality expense. | Learner trust is better served by durable work and truthful delay than rushed scoring. |
| V6.4 | 5–10× stronger-model cost is acceptable only for justified hard cases. | Spend follows marginal value/risk. |
| V6.5 | Second pass only for high-risk/high-uncertainty cases. | Avoid doubling cost on routine evaluations. |
| V6.6 | Feedback is progressive: summary/main issues first, drill-down optional. | Reduce cognitive load and runtime generation cost. |
| V6.7 | Precompute reusable curriculum/explanations; generate personalized fragments at runtime. | Move repeatable work offline and stabilize quality. |
| V6.8 | Speaking uses staged STT/features + AI/multimodal where required, not a single black-box score. | Keep evidence provenance and cost control by criterion/stage. |
| V6.9 | Free may include meaningful AI allowance but must remain sustainable. | Free must demonstrate the real learning loop without unlimited expensive inference. |
| V6.10 | Quota pressure may choose cheaper only if the calibrated quality floor still passes. | Cost cannot lower rubric/evidence integrity. |
| V6.11 | Offline/batch generation and benchmark work allowed when learner-visible latency is irrelevant. | Move expensive noninteractive work out of the critical path. |
| V6.12 | Provider routing uses hard privacy/quality/reliability eligibility before cost optimization. | Provider price never overrides minimum trust/quality constraints. |

## Durable invariants extracted from V6

These are navigation summaries, not new authority:

```text
quality/privacy/reliability eligibility
        ↓
candidate route set
        ↓
cost optimization
```

and:

```text
AI result ≠ mastery by itself
cheap route ≠ allowed route
fallback ≠ silent quality downgrade
```

## Traceability

Original source: `artifacts/operations/decisions/lenbands-decision-register-v1.0.0-founder-locked-2026-08-12.md`.

Speech-specific routing is separately captured in `../repository/speech-processing.md` because that later repository decision refines how V6.8 is implemented without replacing the founder principle.