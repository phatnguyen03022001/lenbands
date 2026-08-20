# 03 — Features (Capability Catalog)

This is the **Capability Catalog** — the list of system capabilities, each with a unique capability ID. Each capability describes **what exists**, not the emotional experience (defined in `04-experience.md`) or the algorithm (defined in `06-engines.md`). Architecture and context are defined in `02-architecture.md`.

## Conventions

- Every capability has a unique `id` in the form `{DOMAIN}.{Capability}`.
- `04-experience.md` and `06-engines.md` reference capabilities by ID rather than duplicating descriptions.
- UI labels follow `07-conventions.md` (no AI wording, no AI icon).
- Capability identity is independent of implementation mechanism. A capability may be implemented by deterministic logic, a maintained library, precomputed content, a specialist model, an LLM, or a combination according to `02-architecture.md` and `06-engines.md`.
- AI/model providers are not product roles and do not own capability semantics.
- The learner-facing primary path is intentionally smaller than this catalog: capabilities support the target path; the learner is not expected to navigate the catalog.

---

## Learner Features

### Identity (IDENTITY)

| id | Capability |
|---|---|
| `IDENTITY.Auth` | Sign-up / sign-in / authorization |
| `IDENTITY.Profile` | Account profile, display/locale/timezone preferences, and optional sourced prior official-result references; goal/target semantics belong to `GOAL.Target` |
| `IDENTITY.Recovery` | Forgot Password, Email Verification, Change Email |
| `IDENTITY.Privacy` | Export Data, Delete Data, Consent, model/AI data usage controls |
| `IDENTITY.DeleteAccount` | Delete account |

### Localization (LOC)

| id | Capability |
|---|---|
| `LOC.InterfaceLanguage` | Interface language (Vietnamese by default) |
| `LOC.Switcher` | Language switcher |
| `LOC.LocaleFormat` | Date/time/number formatting |
| `LOC.AIResponseLanguage` | Model-assisted explanations/responses follow the user's selected language; capability ID retained for compatibility |
| `LOC.PreferenceSync` | Sync language preference across devices |

> IELTS content always remains in its original English and is not translated.

### Goal Management (GOAL)

| id | Capability |
|---|---|
| `GOAL.Target` | Target Profile: IELTS module, overall target, optional per-skill minima, target date/purpose/study constraints plus a derived planning-feasibility state that never represents exam-success probability |
| `GOAL.Weekly`, `GOAL.Daily` | Weekly / Daily Goal |
| `GOAL.StudyPlan` | Study Plan |
| `GOAL.ExamPlan` | Countdown, Pre-exam Checklist, Exam Day Timeline, Time Management Strategy, Test Day Anxiety Tips |

### Placement (PLACE)

| id | Capability |
|---|---|
| `PLACE.Test` | Placement test / minimum useful evidence collection |
| `PLACE.SkillDiagnosis` | Per-skill/construct diagnosis with evidence coverage/uncertainty and supported cause class: English foundation, IELTS technique, integrated performance, mixed, or evidence-needed |
| `PLACE.BandEstimation` | Scoped diagnostic band estimation; may return insufficient evidence instead of false precision |
| `PLACE.GapDetection` | Target-relevant gap vs evidence-needed detection; missing evidence is not weakness and cause is only assigned when it changes intervention |
| `PLACE.InitialPath` | Compressed initial path: target status → one supported priority → smallest useful intervention → independent verification; missing coverage returns content gap |

### Learning (LEARN)

Each skill has four layers: Learning / Practice / Evaluation / Review. The Evaluation and Review layers are owned by the EVAL/REVIEW domains below; this section lists only the Learning and Practice surfaces.

| id | Capability |
|---|---|
| `LEARN.Path` | Target-aware learning path ordered by prerequisites, supported cause, minimum sufficient challenge and verification need; internal path depth must not become primary learner choice overload |
| `LEARN.QuestionTypes` | Question/task types for the four IELTS skills; pronunciation uses practice units that support Speaking |
| `LEARN.Listening` | Audio Player, Transcript, Replay, Playback Speed, Section Practice, Keyword Highlight, Dictation, Shadowing |
| `LEARN.Reading` | Passage Reader, Paragraph Navigation, Highlight, Underline, Annotation, Vocabulary Lookup, Bookmark Paragraph |
| `LEARN.Writing` | Workspace (Word Count, Task Timer, Auto-save), Draft History |
| `LEARN.Speaking` | Part 1/2/3 Simulation, Cue Card, Timer, Recording, Transcript |
| `LEARN.Pronunciation` | Phoneme Recognition, Intonation, Word/Sentence Stress, Drill, Side-by-side Audio Comparison |

### Knowledge Assets (KA)

| id | Capability |
|---|---|
| `KA.Lesson`, `KA.Grammar`, `KA.Vocabulary`, `KA.Collocation`, `KA.Template`, `KA.Strategy`, `KA.Example`, `KA.Exercise` | System knowledge published by Colab |

> Detailed structure, curriculum sufficiency and challenge-fit rules are defined in `05-content.md`.

### Personal Knowledge / PKM (PKM)

| id | Capability |
|---|---|
| `PKM.Notes` | Personal notes (free-form, not hard-bound to a passage) |
| `PKM.Collections` | Group items by topic |
| `PKM.WordBank` | Vocabulary collected by the user |
| `PKM.SavedItems` | Bookmark (question, passage, lesson, vocab, cue card) |
| `PKM.Drafts` | Saved writing drafts |
| `PKM.Recordings` | Saved recordings |
| `PKM.Import` | Import Vocabulary / Notes / CSV / Anki package |
| `PKM.Export` | Export PDF / CSV / Anki package |
| `PKM.Sync` | Cross-device Sync (Continue on another device, current session handoff, conflict resolution) |
| `PKM.Offline` | Download Lesson, Download Audio, Offline Vocabulary, Offline Review Queue |

### Practice (PRACTICE)

| id | Capability |
|---|---|
| `PRACTICE.Set` | Exercise, Practice Set |
| `PRACTICE.Drill` | Skill Drill, Question Type Drill |
| `PRACTICE.Timed` | Timed Practice |
| `PRACTICE.Adaptive` | Item-level routing balancing supported weakness/cause, uncertainty, coverage, exposure/novelty, transfer need, target relevance, prerequisite/challenge fit, due review and learner load |
| `PRACTICE.MockTest` | Full Test, Practice/Exam/Timed/Review Mode, scoped estimate, Result Analysis |
| `PRACTICE.ExamSimulation` | Exam mode, Timed mode, Review mode |

### Evaluation (EVAL)

Learner-facing Writing/Speaking/Pronunciation evaluation is automated at runtime with no human examiner dependency in the transaction path. Capability semantics are governed by score scope, evidence validity, benchmark-approved routes, and `GOVERNANCE.*`; a model/provider is an implementation adapter, not the scorer authority by itself.

| id | Capability | Notes |
|---|---|---|
| `EVAL.Writing` | Writing Evaluation | staged automated governed scorer; task/criterion score scope preserved |
| `EVAL.Speaking` | Speaking Evaluation | staged transcript/features/acoustic/rubric evidence where applicable |
| `EVAL.Pronunciation` | Pronunciation Evaluation (phoneme, stress, intonation, mispronunciation) | specialist speech/acoustic evidence where required |
| `EVAL.Examiner` | Examiner — interactive dialogue Part 1/2/3, follow-up generation | conversation/question generation is separate from scoring |
| `EVAL.BandPrediction` | Band Prediction | derived from admissible scoped evidence + uncertainty; never a guaranteed future official result |
| `EVAL.RewriteSuggestion` | Rewrite Suggestion (sentence-level feedback, scorecard) | coaching output; never proof of independent learner production |
| `EVAL.AntiGaming` | Deprecated alias; identity is retained for compatibility, while canonical implementation is `GOVERNANCE.AntiGaming` | |

### Coaching (COACH)

| id | Capability |
|---|---|
| `COACH.AnswerExplanation` | Answer explanation (Listening/Reading); reuse governed explanation before runtime generation where sufficient |
| `COACH.VocabularyExplanation` | Vocabulary explanation |
| `COACH.DistractorExplanation` | Distractor explanation |
| `COACH.ListeningCoach` | Listening Coach |
| `COACH.ReadingCoach` | Reading Coach |
| `COACH.Feedback` | General feedback |
| `COACH.ErrorAnalysis` | Evidence-backed error/cause analysis |
| `COACH.Recommendation` | Improvement recommendation |
| `COACH.Tutor` | IELTS Q&A, context-aware using the minimum relevant passage/question/skill context |

### Personalization (PERSONAL)

| id | Capability |
|---|---|
| `PERSONAL.Recommendation` | Recommendation Engine |
| `PERSONAL.NextBestAction` | One eligible high-value action + controlled reason + verification rule + at most one lighter alternative |
| `PERSONAL.AdaptivePlan` | Versioned TargetProfile/evidence/feasibility-aware plan adjustment; cannot preserve stale priorities merely for engagement |
| `PERSONAL.WeaknessPractice` | Evidence/weakness-based Practice with cause, uncertainty, coverage, exposure and challenge-fit constraints |
| `PERSONAL.GoalRecommendation` | Goal/constraint recommendation without guaranteed-band probability |
| `PERSONAL.GapAnalysis` | Target-vs-evidence gap including cause/uncertainty/insufficiency, not numeric band subtraction alone |
| `PERSONAL.Insights` | Structured learning insight derived from governed evidence; model-generated wording is optional rendering, not analytical truth |

### Band Framework & Progression (BAND)

| id | Capability |
|---|---|
| `BAND.Descriptor` | Official Band Descriptor reference (IELTS rubric) |
| `BAND.Requirement` | Band-level requirements (grammar points, question types, vocab/topic, micro-skills) — data layer feeding `BAND.Map`; LenBands curriculum metadata is not an official IELTS requirement unless explicitly sourced |
| `BAND.Checklist` | Cross-skill checklist by band-learning bucket — data layer feeding `BAND.Map` |
| `BAND.Map` | Learner-facing evidence/coverage toward target X; distinguishes curriculum completion from readiness evidence |
| `BAND.Current`, `BAND.Target` | Current estimate / Target Profile band values with score scope |
| `BAND.Completion` | Curriculum/evidence coverage view; must not be presented as mastery/readiness by percentage alone |
| `BAND.Readiness` | Evidence-based Band Readiness state/estimate with uncertainty and blockers; does not guarantee official result |
| `BAND.RecommendedNext` | Optional recommended next target only when learner actually wants progression; target completion never automatically forces a higher band |
| `BAND.ProgressionWarning` | Progression Warning |
| `BAND.ExamReadiness` | Exam Readiness (Overall / per-skill readiness, evidence coverage, uncertainty, blockers) |

### Review & Revision (REVIEW)

| id | Capability |
|---|---|
| `REVIEW.Bookmark` | Bookmark |
| `REVIEW.MistakeNotebook` | Mistake Notebook |
| `REVIEW.WrongAnswer`, `REVIEW.WrongQuestion` | Wrong Answer / Wrong Question Review |
| `REVIEW.QuestionReview` | Question Review, Review Explanation |
| `REVIEW.Queue` | Revision Queue |
| `REVIEW.SmartQueue` | Smart Review Queue (Today's Queue, Priority Queue, Weak Skill Queue, Exam Queue) |
| `REVIEW.History` | Learning History |
| `REVIEW.FSRS` | Spaced Repetition scheduling for suitable retrievable units; not a universal complex-skill mastery model |

### Assessment History (HISTORY)

| id | Capability |
|---|---|
| `HISTORY.Attempts` | All Attempts |
| `HISTORY.ScoreTimeline`, `HISTORY.BandTimeline`, `HISTORY.SkillTimeline` | Scoped Score / Band / Skill Timeline with result validity/provenance |
| `HISTORY.LearningTimeline` | Learning Timeline (events: Started, Completed, Transfer/Retest Evidence, Goal Achieved, Writing Submitted) |
| `HISTORY.WritingPortfolio`, `HISTORY.SpeakingPortfolio` | Writing / Speaking Portfolio |
| `HISTORY.Compare` | Compare Attempts preserving prompt/task/mode/exposure context |

### Progress & Analytics (PROGRESS)

| id | Capability |
|---|---|
| `PROGRESS.Dashboard` | Progress Dashboard |
| `PROGRESS.LearningAnalytics`, `PROGRESS.SkillAnalytics` | Learning / Skill Analytics |
| `PROGRESS.BandProgress` | Band Progress based on appropriate evidence, not activity count alone |
| `PROGRESS.GoalTracking` | Goal/feasibility tracking without guaranteed-attainment semantics |
| `PROGRESS.Motivation` | Streak, Milestone, Goal Completion Celebration, Band Improvement Highlight, Progress Recap, Comeback Nudge |
| `PROGRESS.Achievement` | Achievement (Band X Ready when evidence policy supports it, review/streak milestones — lightweight, no leaderboard/XP/avatar) |
| `PROGRESS.WeeklyRecap` | Outcome-based progress recap: independent improvement, strengths, reduced errors, retest/transfer gain, uncertainty and next priority |
| `PROGRESS.Reactivation` | Comeback plan after absence; restore learning rhythm without dumping backlog or creating guilt |
| `PROGRESS.Wellbeing` | Track study load and overload signals and recommend an appropriate slowdown or break |

### Search & Resource Center (SEARCH)

| id | Capability |
|---|---|
| `SEARCH.Global`, `SEARCH.Knowledge`, `SEARCH.Question` | Global / Knowledge / Question Search |
| `SEARCH.Formula`, `SEARCH.Cheatsheet` | Formula, Cheatsheet |
| `SEARCH.BandDescriptor`, `SEARCH.WritingSample`, `SEARCH.SpeakingSample` | Band Descriptor, Writing/Speaking Sample |

### Study Orchestration (STUDY)

The orchestration layer between Goal and Practice is the backbone of Home. The internal plan may contain multiple candidates, while the primary learner surface exposes one action-first path.

| id | Capability |
|---|---|
| `STUDY.Session` | Study Session (Start, Resume, Pause, End, Session Goal) |
| `STUDY.SessionSummary` | Session Summary (action, evidence produced, errors, uncertainty/verification state; activity metrics are secondary) |
| `STUDY.DailyPlan` | Derived target/evidence/feasibility-aware plan with one primary action + at most one lighter alternative on the primary surface |
| `STUDY.TodayQueue` | Internal/secondary queue of eligible review/evidence/weakness/transfer/exam actions; not a competing primary Home decision |
| `STUDY.Continue` | Continue on Another Device (current session handoff) |
| `STUDY.Resume` | Resume after interruption (Mock Test, network loss, session timeout) — Error Recovery belongs here |
| `STUDY.MicroSession` | A 5–10 minute session for busy days, still tied to a concrete goal and outcome |
| `STUDY.CheckIn` | Check in on energy/available time to adjust burden without changing scoring/evidence truth |

### Notification (NOTIF)

| id | Capability |
|---|---|
| `NOTIF.Study`, `NOTIF.Review`, `NOTIF.SRS`, `NOTIF.Result`, `NOTIF.Goal` | Study / revision / SRS due / evaluation result / weekly-goal reminders |
| `NOTIF.Preference` | Study Reminder, Review Reminder, Goal Reminder |
| `NOTIF.QuietHours` | Quiet Hours |
| `NOTIF.SmartDelivery` | Choose timing/channel according to expected value, preference, quiet hours, and frequency cap |
| `NOTIF.Reengagement` | Return reminder aligned with the comeback plan; no guilt and no streak-loss punishment |

### Subscription (SUB)

| id | Capability |
|---|---|
| `SUB.Plan`, `SUB.Payment`, `SUB.Premium`, `SUB.UsageLimit` | Learning plan / payment / premium / usage limit; premium changes volume/depth/entitlement, not semantic truth or minimum scoring-quality floor |

---

## Content Features (Colab)

### Content Management (CONTENT)

| id | Capability |
|---|---|
| `CONTENT.Lesson`, `CONTENT.Knowledge`, `CONTENT.QuestionBank`, `CONTENT.MockTest`, `CONTENT.Quiz`, `CONTENT.Tag` | Content management |
| `CONTENT.Publish` | Permission-scoped Publish Workflow |
| `CONTENT.Moderation` | Review content, check errors, useful/required tags, rights/calibration state, curriculum coverage and unpublish |
| `CONTENT.BlueprintUpdate` | Update content when the IELTS blueprint changes |
| `CONTENT.Feedback` | Handle Content Feedback from learners (Report Content, Suggest Fix, Report Wrong Answer) |
| `CONTENT.AutoTag` | Suggest only taxonomy/tags that feed a governed decision; never auto-publish |
| `CONTENT.TagReview` | Colab reviews and accepts/rejects suggested tags |

> Colab never scores learner work. Author/reviewer/publisher permissions are separable according to `artifacts/engineering/api/access-control.md`.

---

## Admin Features

### Administration (ADMIN)

| id | Capability |
|---|---|
| `ADMIN.User`, `ADMIN.Role`, `ADMIN.Permission`, `ADMIN.AccountStatus` | User / Role / Permission / Account Status |
| `ADMIN.SystemSetting`, `ADMIN.Dashboard`, `ADMIN.AuditLog`, `ADMIN.ModerationLog` | System Management |
| `ADMIN.GovernanceDashboard` | View evaluation-quality metrics (agreement, uncertainty/calibration, drift, bias slices when valid, integrity signals, cost) — see `06-engines.md` |
| `ADMIN.Billing`, `ADMIN.Revenue`, `ADMIN.Premium` | Billing Management |

---

## Quality & Economics Operations (OPS)

These backend/cross-functional capabilities protect quality and cost. They must have an owner, threshold, escalation policy, and dashboard; they should not become complex learner UI unless doing so creates additional learner outcome.

| id | Capability |
|---|---|
| `OPS.ContentQuality` | Content quality gate: correctness, decision-useful taxonomy, curriculum sufficiency, challenge fit, calibration, accessibility, licensing/rights |
| `OPS.EvaluationQuality` | Scorer quality gate: criterion/task agreement, ordinal agreement, stability, evidence quality, uncertainty calibration, drift/bias where valid, reproducibility |
| `OPS.ReleaseGate` | Gate before publishing a scorer/content/feature; checks quality, safety, accessibility, rights/privacy, learner-path integrity and cost |
| `OPS.OutcomeMeasurement` | Measure independent learning outcome, retest/transfer gain, error recurrence, uncertainty reduction, target-planning usefulness and helpfulness |
| `OPS.ModelRouting` | Route by deterministic-first ladder: rules/library/SQL → precomputed → bounded small/specialist model → benchmark-approved stronger route → fallback |
| `OPS.CostBudget` | Budget by learner, capability, scorer route/model, audio units, retry/escalation, batch job and verified outcome |
| `OPS.Quota` | Rate limit, usage limit, fair use, reservation and graceful degradation |
| `OPS.Observability` | Track latency, errors, token/audio usage, retries/escalation, quality and cost-per-verified-improvement |

### Capability contract

The catalog owns identity and short descriptions. Every capability moved into an active phase, build candidate, or build-ready state must have a canonical **Capability Profile**; capabilities in the future horizon do not yet need their own profile.

```yaml
capability_id: DOMAIN.Capability
user_outcome: <observable outcome>
owner: product | engineering | operations | legal
phase: P0 | P1 | P2 | deferred
dependencies: []
inputs: []
outputs: []
permission: <role + data scope>
primary_events: []
quality_gate: <gate id or condition>
cost_budget: <budget id or n/a>
fallback: <user-safe fallback>
privacy_class: account | learning | assessment | audio | billing | system | derived
```

A capability is a `build candidate` only when its profile is complete. It is `build ready` only when the relevant Vertical Slice Spec/contract exists in `artifacts/`. The phase of the entire catalog is projected in `artifacts/operations/catalogs/capability-phase-index.md`; a capability without an active phase is treated as `deferred`, not as implicit scope.

### P0 Capability Profile Matrix — closed pilot canonical scope

P0 proves one outcome loop; it does not claim a complete four-skill learner solution.

| Profile | Capability IDs | User outcome | Owner | Dependencies | Primary events | Quality / fallback | Privacy | Cost boundary |
|---|---|---|---|---|---|---|---|---|
| `P0-01 Identity` | `IDENTITY.Auth`, `IDENTITY.Profile`, `IDENTITY.Privacy` | Has an account/preferences/consent and ownership of their data | engineering | managed auth boundary | account_created, consent_recorded | deny-by-default; export/delete recovery | account | managed_auth_pilot |
| `P0-02 Diagnosis` | `GOAL.Target`, `PLACE.Test`, `PLACE.BandEstimation`, `PLACE.GapDetection`, `PLACE.InitialPath`, `PLACE.SkillDiagnosis`, `BAND.Current` | Has a TargetProfile, truthful evidence state, supported cause/evidence-gap state, planning-feasibility state and one credible initial priority | product | published placement configuration + curriculum coverage projection | placement_started/completed | insufficient evidence stays insufficient; missing path → content gap; no attainment probability | learning | placement_pilot |
| `P0-03 Daily action` | `STUDY.DailyPlan`, `STUDY.CheckIn`, `STUDY.MicroSession`, `PERSONAL.NextBestAction` | Knows one useful thing to do now, why, and how it will be verified | product | P0-02 + learner/content state | daily_plan_generated, session_started | evidence gap → collect evidence; content gap → truthful blocker; primary surface at most one lighter alternative | learning | deterministic_rules_first |
| `P0-04 Writing evaluation` | `LEARN.Writing`, `EVAL.Writing`, `COACH.ErrorAnalysis`, `COACH.Feedback`, `PKM.Drafts` | Writes, saves, submits, and understands evidence-backed task-scoped feedback | product + engineering | published task, rubric, evaluation contract | evaluation_submitted, evaluation_scored | limited/insufficient/delay/unavailable states; no silent scorer downgrade | learning/assessment | staged_writing_eval_pilot |
| `P0-05 Error-to-review` | `REVIEW.MistakeNotebook`, `REVIEW.FSRS`, `REVIEW.SmartQueue`, `PRACTICE.Drill` | Selects one evidence-backed error, fixes it, reviews a suitable retrievable unit, and demonstrates an independent retest | product | P0-04 + error/remediation taxonomy + retest coverage | learning_error_saved, review_completed, retest_completed | no valid remediation/retest → content gap/no false resolution | learning | deterministic_fsrs |
| `P0-06 Quality & economics` | `OPS.CostBudget`, `OPS.ModelRouting`, `OPS.Quota`, `OPS.Observability`, `OPS.ReleaseGate`, `OPS.EvaluationQuality`, `OPS.ContentQuality`, `OPS.OutcomeMeasurement`, `GOVERNANCE.ConfidenceScore`, `GOVERNANCE.AuditTrail` | Does not sacrifice trust/data safety/learner-path integrity for feature speed or cheap inference | operations | benchmark, content, event/failure contracts | evaluation_failed, evaluation_delayed, retest_completed | release blocked / deterministic or delayed safe fallback | assessment | quality_plus_verified_outcome_cost_gate |

Capabilities outside this matrix remain canonical Blueprint capabilities but are not part of closed-pilot P0. They can enter launch scope only through governed phasing/readiness, never by being present in this catalog.

---

## Event Contract (analytics/recommendation SSOT)

All analytics, recommendations, dashboards, experiments, and notifications must read from one event contract. Events are immutable facts; a UI click must not be used as a proxy for learning outcome unless a corresponding outcome event exists.

### Event envelope

```json
{
  "event_type": "retest_completed",
  "event_version": "1.0.0",
  "event_id": "uuid",
  "trace_id": "trace_id",
  "occurred_at": "timestamp",
  "user_id_hash": "hashed_user_id",
  "session_id": "session_id",
  "schema_version": "1.0.0",
  "source": "service|offline_sync|backfill",
  "entity_refs": {"attempt_id": "id", "content_id": "id"},
  "properties": {},
  "privacy_class": "account|learning|assessment|audio|billing|system|derived",
  "schema_hash": "hash"
}
```

### Canonical events

| Event | When emitted | Primary consumer |
|---|---|---|
| `account_created` / `consent_recorded` | An account or effective consent is created | IDENTITY, privacy audit |
| `privacy_export_requested` / `privacy_deletion_requested` | Learner requests data export/deletion | IDENTITY, privacy operation |
| `placement_started` / `placement_completed` | A valid placement begins/completes with termination/evidence/cause/feasibility refs | PLACE, PERSONAL, activation |
| `goal_set` | A valid target profile/goal is stored | GOAL, PLACE, STUDY |
| `daily_plan_generated` | Today creates/refreshes a plan with controlled reason, verification and target-feasibility state | STUDY, PERSONAL, UX diagnosis |
| `session_started` | Learner begins a study session with intent | STUDY, outcome measurement |
| `session_completed` | Session satisfies its completion rule | STUDY, outcome measurement |
| `first_meaningful_session_completed` | The first session produces an outcome rather than merely opening the app | PROGRESS, retention |
| `lesson_completed` | Lesson satisfies its completion rule | LEARN, REVIEW, recommendation; not mastery by itself |
| `practice_finished` | Practice set ends validly | HISTORY, PROGRESS, PERSONAL |
| `evaluation_submitted` | Writing/Speaking/Pronunciation is submitted | EVAL, quota, cost |
| `evaluation_scored` | A governed result is created; result validity is a property/state, not implied by event name alone | HISTORY, BAND, PROGRESS |
| `evaluation_failed` | A valid result cannot be created | recovery, observability |
| `evaluation_delayed` | Evaluation exceeds the published waiting-time threshold | recovery, quota, observability |
| `explanation_viewed` | Learner views evidence/explanation | COACH, helpfulness |
| `learning_error_saved` | An evidence-backed error is stored in the mistake system | REVIEW, outcome measurement |
| `practice_started` | Learner starts an action from feedback | PERSONAL, outcome |
| `retest_completed` | Independent/declared retest after feedback completes with novelty/exposure context | OPS.OutcomeMeasurement |
| `review_completed` | FSRS review is rated and stored successfully | REVIEW, retention; not transfer by itself |
| `quota_warning_shown` | Learner is warned about low quota before a costly action | OPS.Quota, UX |
| `quota_exceeded` | A costly action is blocked because quota/reservation has no remaining slot | OPS.Quota, UX, recovery |
| `goal_completed` | Goal satisfies its completion rule | GOAL, PROGRESS |
| `session_paused` / `session_resumed` | Session checkpoints / recovers | STUDY, recovery |
| `session_abandoned` | Session ends according to abandonment policy | STUDY, UX diagnosis |
| `comeback_plan_started` / `comeback_plan_completed` | Learner returns and starts/completes a comeback plan | PROGRESS.Reactivation, retention |
| `returned_after_14_days` | First meaningful return after 14 days | PROGRESS, experiment |
| `notification_delivered` / `notification_opened` / `notification_opted_out` | Notification lifecycle | NOTIF, fatigue control |

### Registered slice/internal extensions

| Event family | Registered event types |
|---|---|
| Writing detail | `writing_task_opened`, `writing_draft_saved`, `writing_submission_started`, `writing_submission_accepted`, `writing_feedback_viewed` |
| Error/review detail | `learning_error_fix_started`, `learning_error_fix_completed`, `review_queue_opened`, `review_card_created`, `review_card_rated`, `review_card_graduated`, `learning_error_resolved`, `retest_started` |
| Recommendation detail | `next_best_action_shown`, `next_best_action_taken` |
| Quota/subscription detail (P1) | `upgrade_cta_shown`, `upgrade_completed` |
| Governance internal | `benchmark_run_completed`, `drift_threshold_exceeded`, `anti_gaming_flagged` |

### Event rules

- Event types use `snake_case` and have an owner and consumers; schema/semantic changes require a semver increase of `event_version`.
- Event producers must be idempotent by `event_id` + stable `entity_refs` + `occurred_at` window; offline sync must deduplicate. Raw `actor_id` does not appear in the envelope; identity uses only `user_id_hash`.
- Do not send PII or raw audio/text into general analytics; use references, allow-listed derived properties and a privacy class.
- Outcome events carry enough result/evidence state to distinguish accepted, limited/insufficient, invalid and integrity-review outcomes; event existence alone does not prove success/mastery.
- Feasibility/cause/event properties are derived domain state, never client-authored exam-success probability.
- Backfills use `source=backfill`, record a reason and time range, and must not trigger unintended notifications/recommendations.
- Data deletion cascades according to privacy policy and may leave anonymized aggregates only when policy/consent permits it.

---

## Engine Capabilities (reference)

The Engine layer (`06-engines.md`) implements the following capabilities. Their descriptions are not duplicated here; this list exists only for traceability:

- `REVIEW.FSRS` ← FSRS engine
- `EVAL.Writing`, `EVAL.Speaking`, `EVAL.Pronunciation`, `EVAL.Examiner` ← Evaluation engine
- `PERSONAL.Recommendation`, `PERSONAL.NextBestAction`, `PERSONAL.Insights` ← Recommendation engine
- `GOVERNANCE.*` ← Evaluation Governance engine (see `06-engines.md`)
- `OPS.*` ← Quality & Cost Control Plane (see `06-engines.md`)

## Evaluation Governance Capabilities (GOVERNANCE)

Invisible backend controls for automated evaluation; they are not a quality guarantee while qualified corpus, thresholds, route configuration and benchmark runs are missing. Implementation details are in `06-engines.md`.

| id | Capability |
|---|---|
| `GOVERNANCE.ConfidenceScore` | Route/result uncertainty signal; raw confidence is governance telemetry until a learner-facing interpretation is empirically calibrated |
| `GOVERNANCE.GoldStandardBenchmark` | Benchmark approved scorer routes against qualified reference data/corpus with provenance and rights; no quality claim before real runs exist |
| `GOVERNANCE.DriftDetection` | Detect scoring-route/model performance drift over time |
| `GOVERNANCE.BiasMonitoring` | Monitor relevant scoring slices only where data quantity/governance makes interpretation valid |
| `GOVERNANCE.AntiGaming` | Integrity-risk signals using exposure/provenance/similarity and optional weak generated-text signals; never a cheating oracle |
| `GOVERNANCE.AuditTrail` | Log benchmark, route/rubric/config/model promotion and re-evaluation provenance |
| `GOVERNANCE.Dashboard` | Admin view of evaluation quality, uncertainty, drift, integrity, latency and economics metrics |
