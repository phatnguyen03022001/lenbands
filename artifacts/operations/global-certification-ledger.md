# Global Certification Ledger

- **Type:** projection — derived from canonical owners, not a source of truth.
- **Derived from:** `capability-lifecycle-registry.yaml`, `capability-family-registry.yaml`, `build-readiness-matrix.md`, `capability-manifest.yaml`
- **Generated:** 2026-08-11
- **Status:** `review` — verification-in-progress
- **Regenerate when:** lifecycle registry, family registry, or build-readiness matrix changes.

## Purpose

Single-page projection showing every capability's certification status across the axes that matter for
executor-grade convergence. Axes: lifecycle, family, phase, owner_spec, contracts, entities,
events, failures, acceptance, evidence, privacy_class, cost_boundary, and blocker status.

This ledger does **not** replace any canonical owner. Numbers are derived; always check the source.

## P0 — ACTIVE capabilities (33)

### IDENTITY.Core (3 capabilities)

| Capability | Phase | Status | Contracts | Events | Failures | Evidence | Blockers |
|---|---|---|---|---|---|---|---|
| IDENTITY.Auth | P0 | candidate | auth-identity-contract (review) | account_created | AUTH_UNAVAILABLE, PERMISSION_DENIED | provider_dpa, export_delete_acceptance_run | provider_dpa_missing, export_delete_acceptance_not_run, founder_approval_pending |
| IDENTITY.Profile | P0 | candidate | auth-identity-contract (review) | — | — | — | same as IDENTITY.Auth |
| IDENTITY.Privacy | P0 | candidate | auth-identity-contract (review) | privacy_export_requested, privacy_deletion_requested | PRIVACY_EXPORT_FAILED | — | same as IDENTITY.Auth |

**Family certification:** `not_ready` — identity provider and DPA unselected. Owner spec: `identity-core-runtime.md` (present). Interaction spec: `identity-core.md` (present).

### PLACEMENT.Diagnosis (7 capabilities)

| Capability | Phase | Status | Contracts | Events | Failures | Evidence | Blocker |
|---|---|---|---|---|---|---|---|
| GOAL.Target | P0 | candidate | placement-diagnosis-contract (review) | goal_set | INSUFFICIENT_EVIDENCE | calibration_evidence, acceptance | — |
| PLACE.Test | P0 | candidate | placement-diagnosis-contract (review) | placement_started | CONFIG_NOT_PUBLISHED | — | — |
| PLACE.BandEstimation | P0 | candidate | placement-diagnosis-contract (review) | — | SCORING_UNAVAILABLE | — | — |
| PLACE.GapDetection | P0 | candidate | placement-diagnosis-contract (review) | — | — | — | — |
| PLACE.InitialPath | P0 | candidate | placement-diagnosis-contract (review) | — | — | — | — |
| PLACE.SkillDiagnosis | P0 | candidate | placement-diagnosis-contract (review) | — | — | — | — |
| BAND.Current | P0 | candidate | placement-diagnosis-contract (review) | placement_completed | — | — | — |

**Family certification:** `not_ready` — calibration evidence missing, acceptance not run.

### STUDY.DailyAction (4 capabilities)

| Capability | Phase | Status | Contracts | Events | Failures | Evidence | Blocker |
|---|---|---|---|---|---|---|---|
| STUDY.DailyPlan | P0 | candidate | daily-action-contract (review) | daily_plan_generated | NO_ELIGIBLE_ACTION, STALE_PLAN | acceptance_run | acceptance_not_run, founder_approval_pending |
| STUDY.CheckIn | P0 | candidate | daily-action-contract (review) | session_started | SESSION_RESTORE_FAILED | — | — |
| STUDY.MicroSession | P0 | candidate | daily-action-contract (review) | session_paused, session_resumed, session_completed, session_abandoned | — | — | — |
| PERSONAL.NextBestAction | P0 | candidate | daily-action-contract (review) | next_best_action_shown, next_best_action_taken, first_meaningful_session_completed | — | — | — |

**Family certification:** `not_ready` — acceptance run pending, founder approval pending.

### WRITING.Evaluation (5 capabilities + 1 PLANNED)

| Capability | Phase | Status | Contracts | Events | Failures | Evidence | Blocker |
|---|---|---|---|---|---|---|---|
| LEARN.Writing | P0 | candidate | runtime-spec, openapi, data, event, failure, evaluation (all review) | writing_task_opened, writing_draft_saved | — | gold_corpus, benchmark_run | gold_corpus_missing, benchmark_not_run |
| EVAL.Writing | P0 | candidate | same pack + evaluation-contract (review) | writing_submission_started, writing_submission_accepted, evaluation_submitted, evaluation_scored, evaluation_failed, evaluation_delayed | EVAL_LOW_CONFIDENCE, EVAL_INSUFFICIENT_EVIDENCE, EVAL_TIMEOUT, EVAL_PROVIDER_UNAVAILABLE | gold_corpus, benchmark_run | same |
| COACH.ErrorAnalysis | P0 | candidate | same pack (review) | — | — | — | same |
| COACH.Feedback | P0 | candidate | same pack (review) | writing_feedback_viewed | — | — | same |
| PKM.Drafts | P0 | candidate | same pack (review) | — | QUOTA_EXCEEDED | — | same |
| EVAL.RewriteSuggestion | P1 | planned | — | — | — | — | deferred |

**Family certification:** `not_ready` — gold corpus missing, benchmark not run, numeric thresholds unapproved.

### REVIEW.ErrorToReview (4 capabilities + 6 PLANNED)

| Capability | Phase | Status | Contracts | Events | Failures | Evidence | Blocker |
|---|---|---|---|---|---|---|---|
| REVIEW.MistakeNotebook | P0 | candidate | data, event, failure contracts (all review) | learning_error_saved, review_card_created | NO_EVIDENCE_NO_CARD | acceptance_run | acceptance_not_run |
| REVIEW.FSRS | P0 | candidate | same pack (review) | review_card_rated, review_card_graduated | REVIEW_QUEUE_EMPTY | — | — |
| REVIEW.SmartQueue | P0 | candidate | same pack (review) | review_queue_opened, review_completed | — | — | — |
| PRACTICE.Drill | P0 | candidate | same pack (review) | retest_started, retest_completed, learning_error_resolved | RETEST_INVALID | — | — |

**Family certification:** `not_ready` — acceptance not run.

### OPS.QualityEconomics (10 capabilities + 5 PLANNED)

| Capability | Phase | Status | Contracts | Events | Failures | Evidence | Blocker |
|---|---|---|---|---|---|---|---|
| OPS.CostBudget | P0 | candidate | cost-budget (draft), release-gate (review), quota-usage-contract (review) | — | COST_CEILING_UNARMED | numeric_cost_threshold_approval | numeric_thresholds_unapproved |
| OPS.ModelRouting | P0 | candidate | evaluation-benchmark-spec (review), provider-adapter-contract (review) | — | — | — | — |
| OPS.Quota | P0 | candidate | quota-usage-contract (review) | quota_warning_shown, quota_exceeded | — | — | — |
| OPS.Observability | P0 | candidate | observability-slo-contract (review) | — | — | — | — |
| OPS.ReleaseGate | P0 | candidate | release-gate (review) | — | RELEASE_BLOCKED | rollout_rollback_record | — |
| OPS.EvaluationQuality | P0 | candidate | evaluation-benchmark-spec (review) | — | BENCHMARK_MISSING | gold_corpus, benchmark_run | gold_corpus_missing |
| OPS.ContentQuality | P0 | candidate | — | — | — | — | — |
| OPS.OutcomeMeasurement | P0 | candidate | — | — | — | — | — |
| GOVERNANCE.ConfidenceScore | P0 | candidate | evaluation-contract (review) | benchmark_run_completed, drift_threshold_exceeded | DRIFT_THRESHOLD_EXCEEDED | — | — |
| GOVERNANCE.AuditTrail | P0 | candidate | event-schema-pack (review) | anti_gaming_flagged | — | — | — |

**Family certification:** `not_ready` — gold corpus missing, benchmark not run, numeric thresholds unapproved.

---

## P1 — PLANNED families (summary)

| Family | Capabilities | Phase | Owner spec | Owner spec status | Contracts |
|---|---|---|---|---|---|
| READING.Practice | 1 (LEARN.Reading) | P1 | null | no-owner-spec | none |
| LISTENING.Practice | 1 (LEARN.Listening) | P1 | null | no-owner-spec | none |
| SPEAKING.Practice | 0 | P1 | null | no-owner-spec | none (UNUSED family) |
| SPEAKING.Evaluation | 3 (EVAL.Speaking, EVAL.Examiner, LEARN.Speaking) | P1 | null | no-owner-spec | none |
| PRONUNCIATION.Practice | 2 (EVAL.Pronunciation, LEARN.Pronunciation) | P1 | null | no-owner-spec | none |
| MOCK.ExamSimulation | 3 (CONTENT.MockTest, PRACTICE.ExamSimulation, PRACTICE.MockTest) | P1 | null | no-owner-spec | none |
| PRACTICE.Drill (family) | 3 (PRACTICE.Set, PRACTICE.Timed, PRACTICE.Adaptive) | P1 | null | no-owner-spec | none |
| HISTORY.Assessment | 8 | P1 | null | no-owner-spec | none |
| PROGRESS.Learning | 21 (BAND.* + PROGRESS.* + EVAL.BandPrediction) | P1/deferred | null | no-owner-spec | none |
| PERSONAL.Recommendation | 6 | P1/P2/deferred | null | no-owner-spec | none |
| NOTIFICATION.Delivery | 9 | P1/P2 | null | no-owner-spec | none |
| SUBSCRIPTION.Usage | 4 | P1 | null | no-owner-spec | none |
| PKM.Content | 9 | P1 | null | no-owner-spec | none |
| LOCALIZATION.Preference | 5 | P2/deferred | null | no-owner-spec | none |
| SEARCH.Knowledge | 8 | P1 | null | no-owner-spec | none |
| CONTENT.Management | 11 | P1 | null | no-owner-spec | none |
| CONTENT.Knowledge | 8 | deferred | null | no-owner-spec | none |
| COACH.Feedback (family) | 7 | P1 | null | no-owner-spec | none |
| ADMIN.Governance | 12 | P1/P2/deferred | null | no-owner-spec | none |
| GOVERNANCE.Quality | 1 (GOVERNANCE.* beyond P0) | P1 | null | no-owner-spec | none |

Note: `PRACTICE.Drill` capability (P0-ACTIVE) lives in `REVIEW.ErrorToReview` family, NOT in the `PRACTICE.Drill` family. This is an intentional architecture decision — drill execution is the Error-to-Review family's responsibility.

---

## DEPRECATED (1)

| Capability | Replacement | Family |
|---|---|---|
| EVAL.AntiGaming | GOVERNANCE.AntiGaming | GOVERNANCE.Quality |

## Gap summary

| Axis | P0 ACTIVE (33) | PLANNED (146) | Notes |
|---|---|---|---|
| Non-null owner_spec | 33/33 ✅ | 25/146 ⚠️ | 25 PLANNED capabilities point to existing ACTIVE-family owner specs; 121 have no capability-level owner_spec. This does not promote a PLANNED family. |
| Contracts present (≥1) | 6/6 families ✅ | 0/20 families ⚠️ | ACTIVE families have contracts (all at review); PLANNED families have none — expected until phase promotion |
| Events defined | 6/6 families ✅ | 0/20 families ⚠️ | ACTIVE families have canonical event definitions |
| Failure modes defined | 6/6 families ✅ | 0/20 families ⚠️ | ACTIVE families have failure taxonomy |
| Acceptance defined | 6/6 families ✅ | 0/20 families ⚠️ | Acceptance tests exist as references; not yet run |
| Evidence present | 0/6 families ❌ | 0/20 families ⚠️ | **Universally blocked** — no runtime evidence exists for any family |
| Founder approval | 0/6 families ❌ | N/A | Pending for all P0 packs |
| DPA/legal review | 0/6 families ❌ | N/A | Pending for identity, evaluation, and all data processors |

## Key blocker chain

```text
Founder identity decision (unresolved)
    → IDENTITY.Auth blocked
        → P0-01 blocked
    → DPA/data-use review blocked

Gold corpus (missing)
    → benchmark not run
        → numeric thresholds unarmed
            → EVAL.Writing blocked
                → P0-04 blocked
            → OPS.QualityEconomics blocked
                → P0-06 blocked

Acceptance runs (not executed)
    → P0-02, P0-03, P0-05 blocked

External payment/speech provider decisions (deferred)
    → SUBSCRIPTION.Usage, speaking/pronunciation families blocked
```

## Source references

- `artifacts/operations/capability-lifecycle-registry.yaml` (canonical lifecycle)
- `artifacts/operations/capability-family-registry.yaml` (canonical families)
- `artifacts/operations/capability-manifest.yaml` (P0 typed seed)
- `artifacts/operations/build-readiness-matrix.md` (P0 readiness)
- `blueprint/03-features.md` (canonical capability identity)

**Node: this is a projection. Regenerate when source registries change. Do not edit capabilities here — edit the canonical owner.**
