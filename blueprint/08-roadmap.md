# 08 — Roadmap

This file contains **delivery planning**: Priority (P0/P1/P2), MVP/version phasing, Release, and Deprecation. It **does not define feature details**; it references capability IDs from `03-features.md`.

> **Important:** this is the roadmap for **delivery**, not the product blueprint. The complete Blueprint lives in `README.md` plus its spokes. This roadmap may be cut or changed according to delivery reality without breaking the Blueprint: the Blueprint is the SSOT for capabilities, while the roadmap is the SSOT for phasing.

## Priority

### P0 — Closed Pilot (build now)

P0 is the only canonical scope allowed to receive build-ready Artifacts. It contains exactly the six packs in `03-features.md` § P0 Capability Profile Matrix:

- `IDENTITY.Auth`, `IDENTITY.Profile`, `IDENTITY.Privacy`
- `GOAL.Target`, `PLACE.Test`, `PLACE.BandEstimation`, `PLACE.GapDetection`, `PLACE.InitialPath`, `PLACE.SkillDiagnosis`, `BAND.Current`
- `STUDY.DailyPlan`, `STUDY.CheckIn`, `STUDY.MicroSession`, `PERSONAL.NextBestAction`
- `LEARN.Writing`, `EVAL.Writing`, `COACH.ErrorAnalysis`, `COACH.Feedback`, `PKM.Drafts`
- `REVIEW.MistakeNotebook`, `REVIEW.FSRS`, `REVIEW.SmartQueue`, `PRACTICE.Drill`
- `OPS.CostBudget`, `OPS.ModelRouting`, `OPS.Quota`, `OPS.Observability`, `OPS.ReleaseGate`, `OPS.EvaluationQuality`, `GOVERNANCE.ConfidenceScore`, `GOVERNANCE.AuditTrail`
- `OPS.ContentQuality`, `OPS.OutcomeMeasurement` are shared P0 quality/measurement gates; they do not open the full Colab/content-management scope.

A P0 pack may be coded only when the Build Readiness Matrix reports `ready`; full P0 may launch only when all six packs are `ready`.

### P1 (expansion after closed-pilot evidence)

- P1 is candidate scope after P0, not an automatic addition. `REVIEW.SmartQueue` in P1 means cross-skill queue expansion; P0 uses it only for Writing errors. `REVIEW.FSRS` in Expanded MVP is only a candidate for vocabulary; expanding FSRS to grammar/collocation/errors later requires separate evidence.
- `PERSONAL.NextBestAction`, `COACH.ErrorAnalysis`, and `GOVERNANCE.ConfidenceScore` appear again in P1 only with the **advanced/full** qualifier; their P0 deterministic/error-analysis/confidence baseline remains the earlier canonical scope.

- `STUDY.Session`, `STUDY.SessionSummary`, `STUDY.Continue`, `STUDY.Resume`
- `BAND.Readiness` (advanced), `BAND.RecommendedNext`, `BAND.ExamReadiness`
- `PERSONAL.GapAnalysis`, `PERSONAL.NextBestAction`, `PERSONAL.Insights`
- `COACH.ErrorAnalysis`, `COACH.Recommendation`, `COACH.ListeningCoach`, `COACH.ReadingCoach`, `COACH.DistractorExplanation`
- `EVAL.Speaking` (advanced), `EVAL.Pronunciation`, `EVAL.Examiner`
- `LEARN.Speaking` (recording, transcript comparison), `EVAL.RewriteSuggestion` (rewrite loop, draft history, portfolio)
- `LEARN.Pronunciation` (phoneme, stress, intonation)
- `PRACTICE.Adaptive`
- `REVIEW.SmartQueue`
- `PRACTICE.ExamSimulation` (exam, timed, review mode)
- `HISTORY.*` (timeline, learning events, portfolio, compare)
- `PKM.WordBank`, `PKM.Collections`, `PKM.Import`, `PKM.Export`, `PKM.Sync`, `PKM.Offline`
- `NOTIF.Preference`, `NOTIF.QuietHours`
- `NOTIF.SmartDelivery`, `NOTIF.Reengagement`
- `CONTENT.Feedback`
- `SEARCH.*`, `SEARCH.Global`
- `CONTENT.*` (full management)
- `SUB.*`, `SUB.Premium`
- `PROGRESS.Motivation` (basic), `PROGRESS.Achievement`
- `PROGRESS.Reactivation`, `PROGRESS.Wellbeing`
- `GOVERNANCE.ConfidenceScore`, `GOVERNANCE.GoldStandardBenchmark`, `GOVERNANCE.DriftDetection`, `GOVERNANCE.AntiGaming`
- Content taxonomy depth (`CONTENT.AutoTag`, `CONTENT.TagReview`)

### P2 (nice-to-have, Version 2)

- `PERSONAL.AdaptivePlan` (advanced), `PERSONAL.NextBestAction` (advanced)
- `PROGRESS.LearningAnalytics`, `PROGRESS.SkillAnalytics` (advanced)
- `NOTIF.*` (notification center)
- `CONTENT.Moderation` (advanced workflow)
- `ADMIN.Revenue`
- `ADMIN.AuditLog` (deep view)
- `REVIEW.FSRS` optimization (tuning per learner)
- `LOC.LocaleFormat` (advanced), additional languages
- `GOAL.ExamPlan` (advanced: timeline, anxiety tips)

## MVP

### MVP rebaseline — Closed Pilot (canonical launch scope)

The closed pilot does not attempt to prove a "four-skill Knowledge OS." It proves one measurable outcome loop:

```text
Placement / goal
  → Today action
  → Writing Task 2
  → evidence-based evaluation
  → Error Graph
  → fix drill
  → FSRS review
  → retest proof
```

Canonical capability scope lives in `03-features.md` § P0 Capability Profile Matrix. Only the six packs `P0-01` through `P0-06` may receive build-ready Artifacts in the closed pilot.

**Explicitly deferred:** Listening, Reading, Speaking, Pronunciation, Mock Test, full Content/Colab, subscription/payment launch, advanced analytics, search, notification center, multi-device/offline, and full Exam Readiness. They retain their Blueprint identity and are reintroduced according to evidence after the pilot.

### Expanded MVP (candidate after the closed pilot proves outcome)

**Goal:** validate the core loop "Placement → Learning → Practice → Evaluation → Review" across four skills while retaining the "4-skill Knowledge OS" identity and removing advanced scope.

Includes:
- Guest preview
- `IDENTITY.Auth`, `IDENTITY.Profile`, `IDENTITY.Recovery`
- `LOC.InterfaceLanguage` (vi/en), `LOC.AIResponseLanguage`
- `GOAL.Target`, `GOAL.Daily`, `GOAL.Weekly`
- `PLACE.Test`
- `LEARN.Path`, `LEARN.QuestionTypes` (core), `LEARN.Listening/Reading/Writing/Speaking` (basic), `KA.*` (basic)
- `LEARN.Writing` workspace (word count, task timer)
- `STUDY.DailyPlan`, `STUDY.TodayQueue` (Home)
- `PRACTICE.*` (basic)
- `PRACTICE.MockTest`
- `EVAL.Writing`, `EVAL.Speaking` (basic)
- `COACH.AnswerExplanation` (L/R basic)
- `BAND.*` (basic progression)
- `REVIEW.FSRS` (vocab only)
- `PKM.Notes`, `PKM.SavedItems`
- `PROGRESS.Dashboard`
- `REVIEW.MistakeNotebook` (basic)
- `CONTENT.*` (basic management)
- `ADMIN.User`, `ADMIN.Role` (basic)

**Not in MVP** (move to V1): Interactive Examiner dialogue, phoneme-level Pronunciation, FSRS for grammar/collocation, Smart Queue, Insights, Exam Readiness, Offline, Import, Achievement, advanced Governance. MVP still requires baseline `OPS.*`: logging, quota, budget, model routing, release gate, and recovery state.

## Version 1

High-value advanced capability expansion:
- `STUDY.Session`, `STUDY.SessionSummary`, `STUDY.Resume`
- `BAND.ExamReadiness`, `BAND.Readiness` (advanced), `BAND.RecommendedNext`
- `PERSONAL.GapAnalysis`, `PERSONAL.NextBestAction`, `PERSONAL.Insights`
- `COACH.*` (full coaching)
- `EVAL.Examiner`, `EVAL.Pronunciation`, `EVAL.Speaking` (advanced), `EVAL.RewriteSuggestion`
- `LEARN.Speaking` (recording, transcript comparison), Writing rewrite loop
- `LEARN.Pronunciation`
- `PRACTICE.Adaptive`, `REVIEW.SmartQueue`
- `REVIEW.FSRS` (expanded to grammar, collocation, mistakes)
- `HISTORY.*` (full)
- `PRACTICE.ExamSimulation`
- `SEARCH.*`, `SEARCH.Global`
- `PROGRESS.Motivation`, `PROGRESS.Achievement`
- `PKM.*` (full: word bank, collections, import, export, sync, offline)
- `NOTIF.Preference`, `NOTIF.QuietHours`
- `CONTENT.Feedback`
- `GOVERNANCE.*` (full governance backend)
- Content taxonomy depth (auto-tag)
- `SUB.*`, `SUB.Premium`

## Version 2

Polish + advanced:
- `PERSONAL.*` (advanced)
- `PROGRESS.*` (advanced analytics)
- `NOTIF.*` (notification center)
- `CONTENT.Moderation` (advanced)
- `ADMIN.Revenue`, `ADMIN.AuditLog` (deep)
- `REVIEW.FSRS` optimization (per-learner tuning)
- `LOC.*` (locale formatting, additional languages)
- `GOAL.ExamPlan` (advanced)

## Release

- Each Version releases by milestone rather than a fixed calendar date.
- Release notes reference capability IDs for traceability back to the Blueprint.
- Breaking data-model changes require a migration script + version bump.

## Deprecation

- A capability is deprecated when replaced by a new capability or removed entirely.
- Process: mark `deprecated` → retain for 1 version → `retired`.
- This parallels content versioning in `05-content.md`.

## Roadmap notation and exit criteria

- `*` is shorthand for readability, not an implementable capability ID; backlog entries must expand it into concrete IDs.
- `basic` requires acceptance criteria, while `advanced` requires outcome evidence; these labels must not be used to postpone quality/safety.
- Every milestone contains capability IDs, dependency graph, owner, capacity estimate, quality gate, cost budget, analytics events, and rollback plan.

### Closed-pilot launch gates

The closed pilot may launch only when all six P0 packs in `03-features.md` § P0 Capability Profile Matrix are `ready` in the Build Readiness Matrix and:

1. the learner completes Placement/goal, receives a Today action, and knows the next step on the same day;
2. a complete **Writing Task 2** loop exists: submit → evidence-based feedback → one fix → FSRS review → retest proof;
3. Writing evaluation records rubric/model/prompt version, confidence state, token/cost attribution, and timeout recovery;
4. the task passes rights/content quality gates; if no valid task exists, the system does not generate an arbitrary task;
5. cost/evaluation, queue latency, error rate, quota, DLQ/retry, and raw-content telemetry have observability under the P0 runtime contract;
6. Runtime State/Event/Failure contracts are tested for onboarding, draft save, duplicate submit, timeout, network loss, quota exhaustion, worker retry, and app restart;
7. consent, export/delete boundaries, and ownership are tested end-to-end;
8. benchmark, prompt/model/rubric route, and release gate contain no unevidenced claims; while evidence is missing, the closed pilot remains `not ready`.

### Expanded-MVP launch gates

Expanded MVP may launch only after closed-pilot evidence exists and when:

1. the outcome loop `Understand → Practice → Retest → Confirm` has acceptance evidence for Listening, Reading, Writing, and Speaking within the announced scope;
2. every skill/question-type/band profile uses the controlled coverage framework, calibration status, and appropriate rights/content gate;
3. notification/engagement has opt-out, quiet hours, frequency caps, and no guilt mechanics;
4. multi-skill cost/quality/retention impact is benchmarked again rather than inferred from the Writing-only pilot.

### Version 1 gates

V1 expands personalization/engagement only after Expanded MVP demonstrates retest gain, reduced error recurrence, helpfulness, and comeback quality; retention alone is not evidence of product quality.

## Phasing principle

- P0 → Closed Pilot (Placement/goal → Today → Writing Task 2 → feedback → fix → review → retest, with baseline quality/cost controls)
- Expanded MVP → evidence-backed expansion into basic four-skill learning and evaluation within announced scope
- P1 → Version 1 (higher-level capabilities, governance, full personalization)
- P2 → Version 2 (polish, advanced analytics, scale)

This roadmap **may** change according to delivery reality without breaking the Blueprint. The Blueprint (`README` + spokes) is the capability SSOT; the roadmap is the phasing SSOT.
