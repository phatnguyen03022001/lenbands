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

P0 principles are fixed:

- deterministic-first implementation;
- no model/provider as product authority;
- placement may return insufficient evidence;
- Writing produces a task-scoped diagnostic result, not an official IELTS Writing score;
- FSRS schedules only suitable retrievable remediation units;
- success requires an **independent retest**, not merely a familiar-item repeat;
- cost is measured against quality and verified learner improvement.

### P1 (expansion after closed-pilot evidence)

P1 is candidate scope after P0, not an automatic addition.

- `REVIEW.SmartQueue` expands cross-skill only after P0 evidence.
- `REVIEW.FSRS` expansion requires proof that the candidate unit is meaningfully retrievable; FSRS never becomes the complex-skill mastery model.
- `PERSONAL.NextBestAction`, `COACH.ErrorAnalysis`, and `GOVERNANCE.ConfidenceScore` advanced forms must preserve the P0 deterministic/evidence boundaries.
- Model-based recommendation is not introduced merely because more data exists; it requires measured benefit over the deterministic policy.

Candidate P1 capabilities:

- `STUDY.Session`, `STUDY.SessionSummary`, `STUDY.Continue`, `STUDY.Resume`
- `BAND.Readiness` (advanced), `BAND.RecommendedNext`, `BAND.ExamReadiness`
- `PERSONAL.GapAnalysis`, `PERSONAL.NextBestAction`, `PERSONAL.Insights`
- `COACH.ErrorAnalysis`, `COACH.Recommendation`, `COACH.ListeningCoach`, `COACH.ReadingCoach`, `COACH.DistractorExplanation`
- `EVAL.Speaking` (advanced staged scoring), `EVAL.Pronunciation`, `EVAL.Examiner`
- `LEARN.Speaking`, `EVAL.RewriteSuggestion`
- `LEARN.Pronunciation`
- `PRACTICE.Adaptive`
- `REVIEW.SmartQueue`
- `PRACTICE.ExamSimulation`
- `HISTORY.*`
- `PKM.WordBank`, `PKM.Collections`, `PKM.Import`, `PKM.Export`, `PKM.Sync`, `PKM.Offline`
- `NOTIF.Preference`, `NOTIF.QuietHours`, `NOTIF.SmartDelivery`, `NOTIF.Reengagement`
- `CONTENT.Feedback`
- `SEARCH.*`
- `CONTENT.*` (full management)
- `SUB.*`, `SUB.Premium`
- `PROGRESS.Motivation`, `PROGRESS.Achievement`, `PROGRESS.Reactivation`, `PROGRESS.Wellbeing`
- `GOVERNANCE.GoldStandardBenchmark`, `GOVERNANCE.DriftDetection`, `GOVERNANCE.AntiGaming`
- content auto-tag/review only for metadata that feeds a governed decision

### P2 (nice-to-have, Version 2)

- `PERSONAL.AdaptivePlan` (advanced), `PERSONAL.NextBestAction` (advanced)
- `PROGRESS.LearningAnalytics`, `PROGRESS.SkillAnalytics` (advanced)
- `NOTIF.*` (notification center)
- `CONTENT.Moderation` (advanced workflow)
- `ADMIN.Revenue`
- `ADMIN.AuditLog` (deep view)
- `REVIEW.FSRS` optimization (tuning per learner only after sample sufficiency and measurable benefit)
- `LOC.LocaleFormat` (advanced), additional languages
- `GOAL.ExamPlan` (advanced)

## MVP

### MVP rebaseline — Closed Pilot (canonical launch scope)

The closed pilot does not attempt to prove a four-skill platform. It proves one measurable outcome/economics loop:

```text
Target profile / Placement
  → evidence state
  → Today action + Why
  → Writing Task 2
  → task-scoped evidence-based evaluation
  → one evidence-backed error/remediation unit
  → fix drill
  → FSRS review only if suitable
  → independent retest on sufficiently novel context
  → evidence update
  → measured cost per verified improvement
```

Canonical capability scope lives in `03-features.md` § P0 Capability Profile Matrix. Only the six packs `P0-01` through `P0-06` may receive build-ready Artifacts in the closed pilot.

**Explicitly deferred:** Listening, Reading, Speaking, Pronunciation, Mock Test, full Content/Colab, subscription/payment launch, advanced analytics, search, notification center, multi-device/offline, and full Exam Readiness. They retain Blueprint identity and are reintroduced according to evidence after the pilot.

### Expanded MVP (candidate after closed-pilot outcome proof)

**Goal:** validate the core loop `Diagnose → Understand → Practice → Independent Retest → Transfer` across the announced four-skill scope without abandoning deterministic-first economics.

Includes candidate basic scope:

- Guest preview
- `IDENTITY.Auth`, `IDENTITY.Profile`, `IDENTITY.Recovery`
- `LOC.InterfaceLanguage` (vi/en), `LOC.AIResponseLanguage` compatibility capability
- `GOAL.Target`, `GOAL.Daily`, `GOAL.Weekly`
- `PLACE.Test`
- `LEARN.Path`, `LEARN.QuestionTypes`, basic `LEARN.Listening/Reading/Writing/Speaking`, basic `KA.*`
- `STUDY.DailyPlan`, `STUDY.TodayQueue`
- basic `PRACTICE.*`
- `PRACTICE.MockTest` only with score-scope/evidence-validity contract
- `EVAL.Writing`, basic staged `EVAL.Speaking`
- deterministic objective scoring for Listening/Reading + `COACH.AnswerExplanation`
- basic `BAND.*` evidence views
- `REVIEW.FSRS` (vocabulary/suitable retrievable units only)
- `PKM.Notes`, `PKM.SavedItems`
- `PROGRESS.Dashboard`
- `REVIEW.MistakeNotebook`
- basic `CONTENT.*`
- `ADMIN.User`, `ADMIN.Role`

**Not in Expanded MVP by default:** interactive examiner dialogue, phoneme-level pronunciation, broad FSRS expansion, advanced Smart Queue, generated Insights, full Exam Readiness, Offline, Import, Achievement, advanced Governance. Baseline `OPS.*` remains mandatory: observability, quota, budget, deterministic/model routing, release gate and recovery/result-validity state.

## Version 1

High-value advanced capability expansion:

- advanced study/resume orchestration
- evidence-based Exam Readiness
- uncertainty-aware personalization and adaptive selection
- full coaching where reusable/deterministic content is insufficient
- staged Speaking/Pronunciation/Examiner features
- Writing rewrite loop as coaching, not mastery evidence
- adaptive practice with exposure/novelty/coverage controls
- full History/portfolio/compare
- Exam Simulation
- Search
- healthy motivation/reactivation
- expanded PKM and notification controls
- full governed Content feedback/operations
- full Governance backend
- subscription/premium with shared semantic truth and scoring-quality floor

## Version 2

Polish + advanced:

- advanced personalization after outcome evidence
- advanced learning analytics
- notification center
- advanced moderation
- revenue/deep audit views
- per-learner FSRS tuning if justified
- additional locales
- advanced exam-day planning

## Release

- Each version releases by milestone rather than a fixed calendar date.
- Release notes reference capability IDs for traceability.
- Breaking data-model changes require migration + version bump.
- Inference/provider changes affecting evaluation or learner evidence require the appropriate benchmark/release gate even when the HTTP API is unchanged.

## Deprecation

- A capability is deprecated when replaced or removed.
- Process: `deprecated` → retain for one version → `retired`.
- This parallels content versioning in `05-content.md`.

## Roadmap notation and exit criteria

- `*` is shorthand only; implementation backlogs expand concrete IDs.
- `basic` requires acceptance criteria; `advanced` requires measured outcome evidence.
- Every milestone contains capability IDs, dependency graph, owner, capacity estimate, quality gate, cost budget, analytics/outcome events, privacy class, fallback and rollback plan.
- Any inference-using milestone states why deterministic/precomputed mechanisms are insufficient and defines escalation/context limits.

### Closed-pilot launch gates

The closed pilot may launch only when all six P0 packs are `ready` and:

1. target profile/placement produces a truthful evidence state; insufficient coverage/precision returns insufficient evidence rather than a fabricated estimate;
2. learner receives one Today action with a structured reason on the same day;
3. complete Writing Task 2 loop exists: submit → task-scoped evidence-based feedback → one remediation → suitable review → **independent retest**;
4. Writing evaluation records score scope, rubric/task/scorer-route/prompt-config provenance, result validity, evidence, cost/escalation and timeout recovery;
5. stronger/second scoring pass runs only for a governed hard/high-risk condition and no unbenchmarked scorer fallback exists;
6. a missing/invalid task blocks evaluation rather than generating arbitrary assessment content;
7. cost/evaluation, cost/successful-evaluation, cost/verified-improvement, latency, error, quota, retry/escalation and raw-content telemetry controls are observable;
8. Runtime State/Event/Failure/result-validity contracts are tested for onboarding, draft save, duplicate submit, timeout, network loss, quota exhaustion, worker retry and app restart;
9. access tests prove scoped internal workers and no blanket generic service authority;
10. consent/export/delete/ownership and model-context minimization are tested end-to-end;
11. benchmark, scorer route, rubric and release gate contain no unevidenced quality claims; while required evidence is missing, the pilot remains `not ready`.

### Expanded-MVP launch gates

Expanded MVP may launch only after closed-pilot evidence exists and when:

1. `Diagnose → Understand → Practice → Independent Retest → Transfer` has acceptance evidence for each announced skill/scope;
2. placement/mock/readiness preserve score scope, content coverage, exposure/novelty and insufficient-evidence behavior;
3. objective Listening/Reading scoring remains deterministic where answer keys suffice;
4. staged Speaking/speech processing passes quality/privacy/cost gates for the exact announced use;
5. every activated taxonomy field demonstrably feeds diagnosis, recommendation, evaluation, review, search or governed quality analysis;
6. notification/engagement has opt-out, quiet hours, frequency caps and no guilt mechanics;
7. multi-skill cost/quality/verified-learning impact is benchmarked again rather than inferred from the Writing-only pilot.

### Version 1 gates

V1 expands personalization/engagement only after Expanded MVP demonstrates independent retest/transfer gain, lower error recurrence, useful uncertainty reduction, helpfulness and comeback quality. Retention or model sophistication alone is not evidence of product quality.

## Phasing principle

- P0 → prove one Writing evidence→intervention→independent-retest loop and its unit economics
- Expanded MVP → prove the same semantic loop across announced four-skill scope
- P1/V1 → expand only mechanisms that add measured learner value over simpler policies
- P2/V2 → polish, deeper analytics and scale after the core evidence/economics system works

This roadmap **may** change according to delivery reality without breaking the Blueprint. The Blueprint (`README` + spokes) is the capability SSOT; the roadmap is the phasing SSOT.
