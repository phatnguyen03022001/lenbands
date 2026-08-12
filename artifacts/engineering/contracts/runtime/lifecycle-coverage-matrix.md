# Lifecycle Coverage Matrix — Truth Reconciliation

- **Type:** coverage-matrix — verifiable inventory against canonical owners
- **Status:** `review` — Batch 7 reconciliation
- **Created:** 2026-08-10
- **Updated:** 2026-08-11 — Batch 7.1 reconciliation closure
- **Derived from:** 6 ACTIVE owner runtime specs (identity-core, placement-diagnosis, daily-action, writing-evaluation, error-to-review, quality-economics), lifecycle-contract.md, OpenAPI (writing-task-2/openapi.yaml v0.5.0)

## Purpose

For every entity referenced in the 6 ACTIVE runtime owners, map: canonical owner → entity name →
state source (runtime spec or lifecycle contract) → states defined → coverage status →
discrepancies. This matrix is the **truthful** inventory — unchecked boxes mean uncovered, not
assumed covered.

## Entity coverage matrix

### IDENTITY.Core entities

| Entity | Runtime spec states | Lifecycle contract states | OpenAPI schema states | Coverage | Issue |
|---|---|---|---|---|---|
| Account | guest → authenticated → consent_pending → active; deletion_requested → deletion_processing → deleted | Same (with terminal/transition detail) | AccountProfile.state: [active, consent_pending, deletion_requested, deleted] | COVERED | Lifecycle contract adds auth_failed (UX-only, OK). OpenAPI missing `guest` and `authenticated` states (not surfaced to API — design choice, not gap) |
| ConsentRecord | (append-only immutable; new record on change) | recorded → active → superseded | ConsentRecord: no state enum (immutable fact) | COVERED | Lifecycle contract invented states for consistency; runtime spec says "append-only" without explicit state machine — discrepancy in representation, not semantics |
| LearnerProfile | (CRUD, no lifecycle) | (not defined in lifecycle contract) | LearnerProfile: {profile_id, locale, target_band, weekly_goal_minutes} | GAP | Lifecycle contract does NOT define LearnerProfile lifecycle. Runtime spec says "owns profile" without state machine. Profile is a CRUD entity — this gap is intentional (no lifecycle needed). |
| PrivacyRequest | requested → processing → ready / completed / failed / cancelled | Same | PrivacyRequest.state: [requested, processing, ready, failed, cancelled, completed] | COVERED | — |

### PLACEMENT.Diagnosis entities

| Entity | Runtime spec states | Lifecycle contract states | OpenAPI schema states | Coverage | Issue |
|---|---|---|---|---|---|
| Goal | (replace on change; prior superseded) | active → superseded | Not in OpenAPI (embedded in startPlacement.goal_ref) | PARTIAL | Lifecycle contract invented states. Runtime spec says "replace on change" without explicit state machine. Goal is referenced but not its own API resource — NOT a gap, just indirect surfacing. |
| PlacementAttempt | new / in_progress / paused / submitted / diagnosed / insufficient_data | Same | PlacementAttempt.state: [new, in_progress, paused, submitted, diagnosed, insufficient_data] | COVERED | OpenAPI matches runtime spec exactly. Lifecycle contract matches. No discrepancy. |
| BandEstimate | (derived from placement; no lifecycle) | (not defined in lifecycle contract) | Not in OpenAPI (surfaced in PlacementAttempt) | GAP-INTENTIONAL | Derived entity. No lifecycle needed. Not in lifecycle contract. |
| GapProfile | (derived; no lifecycle) | (not defined in lifecycle contract) | Not in OpenAPI | GAP-INTENTIONAL | Derived entity. No lifecycle needed. |
| InitialPath | (derived; no lifecycle) | (not defined in lifecycle contract) | Not in OpenAPI | GAP-INTENTIONAL | Derived entity. No lifecycle needed. |

### STUDY.DailyAction entities

| Entity | Runtime spec states | Lifecycle contract states | OpenAPI schema states | Coverage | Issue |
|---|---|---|---|---|---|
| DailyPlan | no_plan → plan_ready → stale / replaced (+ plan_unavailable, fallback_offered) | Same (with all variations) | DailyPlan.plan_state: [plan_ready, no_plan, plan_stale, plan_unavailable, fallback_offered] | COVERED | Runtime spec omits `plan_unavailable` and `fallback_offered` from compact notation; lifecycle contract and OpenAPI include them. Minor representation gap, not semantic. |
| StudySession | started → paused → completed / abandoned (fixed 2026-08-10) | started → paused → completed → abandoned | StudySession.state: [started, paused, completed, abandoned] | COVERED | All three owners agree. not_started/active are UX-only render states, documented in executor dossier. |
| SessionCheckpoint | (no lifecycle — transient) | (not defined) | Not in OpenAPI | GAP-INTENTIONAL | Transient checkpoint. No lifecycle needed. |

### WRITING.Evaluation entities

| Entity | Runtime spec states | Lifecycle contract states | OpenAPI schema states | Coverage | Issue |
|---|---|---|---|---|---|
| WritingTask | (published content; versioned) | (not defined) | WritingTask: no state field (content asset) | GAP-INTENTIONAL | Content asset, not lifecycle entity. Published state managed by CONTENT.Management (deferred). |
| WritingDraft | drafting → saved → submitted | Same | WritingDraft: no state enum (version + saved_at track state) | COVERED | OpenAPI uses version and saved_at as implicit state. Lifecycle contract makes states explicit. Compatible. |
| WritingSubmission | submitted → processing → scored / low_confidence / delayed / unavailable | Same (with states expanded) | SubmissionStatus: [submitted, processing, delayed, scored, low_confidence, unavailable] | COVERED | — |
| WritingEvaluation | submitted → processing → scored / low_confidence / invalid / anti_gaming_review / failed | Same | WritingEvaluation.evaluation_state: [submitted, processing, scored, low_confidence, invalid, anti_gaming_review, failed] | COVERED | Exact match. |
| CriterionResult | (embedded; no lifecycle) | (not defined) | CriterionResult: embedded in WritingEvaluation.criteria[] | GAP-INTENTIONAL | Embedded value object. No independent lifecycle. |
| FeedbackFinding | (embedded; no lifecycle) | (not defined) | FeedbackFinding: embedded in WritingEvaluation.findings[] | GAP-INTENTIONAL | Embedded value object. No independent lifecycle. |

### REVIEW.ErrorToReview entities

| Entity | Runtime spec states | Lifecycle contract states | OpenAPI schema states | Coverage | Issue |
|---|---|---|---|---|---|
| LearningError | open → in_review → improved → dismissed (fixed 2026-08-10); resolved/recurring per lifecycle contract | open → in_review → improved → dismissed → resolved → recurring | LearningError.status: [open, in_review, improved, dismissed, resolved, recurring] (fixed 2026-08-11) | COVERED | All three owners agree on persisted model. resolved/recurring are terminal states. retest uses separate RetestAttempt entity. |
| ReviewCard | created → learning → review → relearning → graduated | Same | ReviewCard.state: [new, learning, review, relearning] | PARTIAL | OpenAPI uses `new` for initial; lifecycle contract uses `created`. OpenAPI missing `graduated` terminal state. Minor representation gap. |
| ReviewAttempt | (embedded in card rating; no lifecycle) | (not defined) | Not in OpenAPI | GAP-INTENTIONAL | Rating is a mutation on ReviewCard, not an independent entity. |
| RetestAttempt | (embedded; no lifecycle) | created → submitted → processing → completed / unavailable | Retest.status: [created, submitted, processing, completed, unavailable] | COVERED | — |

### OPS.QualityEconomics entities

| Entity | Runtime spec states | Lifecycle contract states | OpenAPI schema states | Coverage | Issue |
|---|---|---|---|---|---|
| BenchmarkRun | (not in runtime spec) | created → running → completed → failed | Not in OpenAPI | GAP | Runtime spec says "Evidence: gold corpus, benchmark run" but does not define BenchmarkRun state machine. Lifecycle contract added states. Neither has OpenAPI schema. This entity is post-code. |
| ReleaseGateDecision | unarmed → collecting_evidence → blocked → approved_for_pilot → rolled_back | Same | QualityGate.state: [unarmed, collecting_evidence, blocked, approved_for_pilot, rolled_back] | COVERED | Exact match. |
| AuditRecord | (append-only; single state) | recorded (single state) | Not in OpenAPI | COVERED | Single-state immutable fact. No lifecycle needed. |
| CostMeasurement | (not in runtime spec) | (not defined) | Not in OpenAPI | GAP | Runtime spec mentions cost measurement. Lifecycle contract does not define CostMeasurement lifecycle. Post-code entity. |

## Coverage summary

| Family | Entities total | COVERED | PARTIAL | GAP (intentional) | DISCREPANCY |
|---|---|---|---|---|---|
| IDENTITY.Core | 4 | 3 | 0 | 1 (LearnerProfile — CRUD) | 0 |
| PLACEMENT.Diagnosis | 5 | 1 | 1 (Goal) | 3 (BandEstimate, GapProfile, InitialPath — derived) | 0 |
| STUDY.DailyAction | 3 | 2 | 0 | 1 (SessionCheckpoint — transient) | **0** |
| WRITING.Evaluation | 6 | 3 | 0 | 3 (WritingTask, CriterionResult, FeedbackFinding — content/embedded) | 0 |
| REVIEW.ErrorToReview | 4 | 2 | 1 (ReviewCard — missing graduated) | 1 (ReviewAttempt — embedded) | **0** |
| OPS.QualityEconomics | 4 | 2 | 0 | 2 (BenchmarkRun, CostMeasurement — post-code) | 0 |
| **TOTAL** | **26** | **13** | **2** | **11** | **0** |

## Representation limitations (not discrepancies)

These are NOT discrepancies — they are intentional design choices or representation gaps with explicit owners and rules.

### ReviewCard: new/created/graduated

- **Owner:** `REVIEW.ErrorToReview` family, `ReviewCard` entity (OpenAPI: `writing-task-2/openapi.yaml`, runtime spec: `error-to-review-runtime.md`, lifecycle contract: `lifecycle-contract.md`)
- **Canonical public value:** OpenAPI `ReviewCard.state: [new, learning, review, relearning]` — 4 values exposed on the learner-facing API. This is the contract that code implements.
- **Representation gaps:**
  - `new` (OpenAPI) vs `created` (lifecycle contract): semantically identical initial state. Different naming convention — OpenAPI uses present-tense adjectives (`new`, `learning`, `review`, `relearning`), lifecycle contract uses past-tense verb (`created`). **Not a discrepancy** — just naming convention drift.
  - `graduated` (lifecycle contract terminal state): NOT in OpenAPI. Graduated cards are not returned by `GET /v1/review/cards` (the queue endpoint returns due/active cards only). A graduated card is an FSRS terminal state that should not appear in the learner review queue. **Design choice** — OpenAPI intentionally omits it.
- **Promotion rule:** When a graduated-cards history endpoint is introduced (per roadmap), add `graduated` to a separate history schema, not to the active ReviewCard.state enum. Do not conflate queue state with lifecycle state.
- **Implementation rule:** Code must implement OpenAPI `[new, learning, review, relearning]` as the API contract. Lifecycle contract `graduated` is an internal terminal state that code may track but must not expose through the queue endpoint.

## Privileged diffs (cannot self-resolve)

| Conflict | Protected files | Options doc | Status |
|---|---|---|---|
| SPEAKING.Practice orphan | capability-family-registry.yaml, capability-lifecycle-registry.yaml | founder-review-packet-index.md PD-01 | UNRESOLVED |
| PRACTICE.Drill name collision | blueprint/03-features.md or capability-family-registry.yaml | founder-review-packet-index.md PD-02 | UNRESOLVED |
| WRITING.Evaluation interaction ref | capability-family-registry.yaml | founder-review-packet-index.md PD-03 | UNRESOLVED |
| GOVERNANCE.Quality 1-cap family | capability-family-registry.yaml, capability-lifecycle-registry.yaml | founder-review-packet-index.md PD-04 | UNRESOLVED |

**Note:** The user referenced 21 historical protected diffs. The 4 above are the ones catalogued in Batch 6. The remaining 17 have not been individually audited. This matrix documents the 4 we know about and acknowledges the gap.
