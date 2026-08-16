# 03 — Features (Capability Catalog)

This is the **Capability Catalog** — the list of system capabilities, each with a unique capability ID. Each capability describes **what exists**, not the emotional experience (defined in `04-experience.md`) or the algorithm (defined in `06-engines.md`). Architecture and context are defined in `02-architecture.md`.

## Conventions

- Every capability has a unique `id` in the form `{DOMAIN}.{Capability}`.
- `04-experience.md` and `06-engines.md` reference capabilities by ID rather than duplicating descriptions.
- UI labels follow `07-conventions.md` (no AI wording, no AI icon).

---

## Learner Features

### Identity (IDENTITY)

| id | Capability |
|---|---|
| `IDENTITY.Auth` | Sign-up / sign-in / authorization |
| `IDENTITY.Profile` | Profile, preferred language, target band/date, weekly/daily goal, progress |
| `IDENTITY.Recovery` | Forgot Password, Email Verification, Change Email |
| `IDENTITY.Privacy` | Export Data, Delete Data, Consent, AI Data Usage |
| `IDENTITY.DeleteAccount` | Delete account |

### Localization (LOC)

| id | Capability |
|---|---|
| `LOC.InterfaceLanguage` | Interface language (Vietnamese by default) |
| `LOC.Switcher` | Language switcher |
| `LOC.LocaleFormat` | Date/time/number formatting |
| `LOC.AIResponseLanguage` | AI responds in the user's selected language |
| `LOC.PreferenceSync` | Sync language preference across devices |

> IELTS content always remains in its original English and is not translated.

### Goal Management (GOAL)

| id | Capability |
|---|---|
| `GOAL.Target` | Target Band / Target Date |
| `GOAL.Weekly`, `GOAL.Daily` | Weekly / Daily Goal |
| `GOAL.StudyPlan` | Study Plan |
| `GOAL.ExamPlan` | Countdown, Pre-exam Checklist, Exam Day Timeline, Time Management Strategy, Test Day Anxiety Tips |

### Placement (PLACE)

| id | Capability |
|---|---|
| `PLACE.Test` | Placement test |
| `PLACE.SkillDiagnosis` | Per-skill diagnosis |
| `PLACE.BandEstimation` | Overall band estimation |
| `PLACE.GapDetection` | Initial gap detection |
| `PLACE.InitialPath` | Initial learning-path recommendation |

### Learning (LEARN)

Each skill has four layers: Learning / Practice / Evaluation / Review. The Evaluation and Review layers are owned by the EVAL/REVIEW domains below; this section lists only the Learning and Practice surfaces.

| id | Capability |
|---|---|
| `LEARN.Path` | Path by band / skill / question type, Next Best Lesson, Learning Milestone |
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

> Detailed structure and taxonomy are defined in `05-content.md`.

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
| `PRACTICE.Adaptive` | Item-level Difficulty, Skill-level Routing, Weakness-driven Selection |
| `PRACTICE.MockTest` | Full Test, Practice/Exam/Timed/Review Mode, Band Score, Result Analysis |
| `PRACTICE.ExamSimulation` | Exam mode, Timed mode, Review mode |

### Evaluation (EVAL)

AI is the sole scorer and performs 100% of scoring without a human in the loop. UI names do not use AI wording (`07-conventions.md`). Quality is **designed to be controlled** by `GOVERNANCE.*`; no calibrated-quality claim is made before the evidence gate passes.

| id | Capability | Notes |
|---|---|---|
| `EVAL.Writing` | Writing Evaluation | sole scorer |
| `EVAL.Speaking` | Speaking Evaluation | sole scorer |
| `EVAL.Pronunciation` | Pronunciation Evaluation (phoneme, stress, intonation, mispronunciation) | sole scorer |
| `EVAL.Examiner` | Examiner — interactive dialogue Part 1/2/3, follow-up generation | sole scorer |
| `EVAL.BandPrediction` | Band Prediction | |
| `EVAL.RewriteSuggestion` | Rewrite Suggestion (sentence-level feedback, scorecard) | |
| `EVAL.AntiGaming` | Deprecated alias; identity is retained for compatibility, while canonical implementation is `GOVERNANCE.AntiGaming` | |

### Coaching (COACH)

| id | Capability |
|---|---|
| `COACH.AnswerExplanation` | Answer explanation (Listening/Reading) |
| `COACH.VocabularyExplanation` | Vocabulary explanation |
| `COACH.DistractorExplanation` | Distractor explanation |
| `COACH.ListeningCoach` | Listening Coach |
| `COACH.ReadingCoach` | Reading Coach |
| `COACH.Feedback` | General feedback |
| `COACH.ErrorAnalysis` | Error analysis |
| `COACH.Recommendation` | Improvement recommendation |
| `COACH.Tutor` | IELTS Q&A, context-aware (knows the current passage/question/skill and answers in context) |

### Personalization (PERSONAL)

| id | Capability |
|---|---|
| `PERSONAL.Recommendation` | Recommendation Engine |
| `PERSONAL.NextBestAction` | Next Best Action |
| `PERSONAL.AdaptivePlan` | Adaptive Learning Plan |
| `PERSONAL.WeaknessPractice` | Weakness-based Practice |
| `PERSONAL.GoalRecommendation` | Goal-based Recommendation |
| `PERSONAL.GapAnalysis` | Gap Analysis |
| `PERSONAL.Insights` | Learning Insights — AI explains why the learner is weak (for example, consistently missing Matching Headings because of paraphrase weakness, or losing Task Response points rather than Grammar points) |

### Band Framework & Progression (BAND)

| id | Capability |
|---|---|
| `BAND.Descriptor` | Official Band Descriptor reference (IELTS rubric) |
| `BAND.Requirement` | Band-level requirements (grammar points, question types, vocab count/topic, micro-skills) — data layer feeding `BAND.Map` |
| `BAND.Checklist` | Cross-skill checklist by band — data layer feeding `BAND.Map` |
| `BAND.Map` | **Band Map** — learner-facing overview of what remains to reach band X: per-skill completion, achieved/unachieved question types, micro-skills, grammar points, and vocabulary count by topic. It is the zoomed-out counterpart of Today. |
| `BAND.Current`, `BAND.Target` | Current / Target Band |
| `BAND.Completion` | Band Completion (per-skill %, aggregate) |
| `BAND.Readiness` | Band Readiness Score |
| `BAND.RecommendedNext` | Recommended Next Band, Recommended Access |
| `BAND.ProgressionWarning` | Progression Warning |
| `BAND.ExamReadiness` | Exam Readiness (Overall / per-skill readiness, Confidence, Risk — whether the learner is ready to take the exam) |

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
| `REVIEW.FSRS` | Spaced Repetition engine (see `06-engines.md`) |

### Assessment History (HISTORY)

| id | Capability |
|---|---|
| `HISTORY.Attempts` | All Attempts |
| `HISTORY.ScoreTimeline`, `HISTORY.BandTimeline`, `HISTORY.SkillTimeline` | Score / Band / Skill Timeline |
| `HISTORY.LearningTimeline` | Learning Timeline (events: Started, Completed, Band Improved, Goal Achieved, Writing Submitted) |
| `HISTORY.WritingPortfolio`, `HISTORY.SpeakingPortfolio` | Writing / Speaking Portfolio |
| `HISTORY.Compare` | Compare Attempts |

### Progress & Analytics (PROGRESS)

| id | Capability |
|---|---|
| `PROGRESS.Dashboard` | Progress Dashboard |
| `PROGRESS.LearningAnalytics`, `PROGRESS.SkillAnalytics` | Learning / Skill Analytics |
| `PROGRESS.BandProgress` | Band Progress |
| `PROGRESS.GoalTracking` | Goal Tracking |
| `PROGRESS.Motivation` | Streak, Milestone, Goal Completion Celebration, Band Improvement Highlight, Progress Recap, Comeback Nudge |
| `PROGRESS.Achievement` | Achievement (Band X Ready, 100 Reviews, 30-day Streak — lightweight milestones, no leaderboard/XP/avatar) |
| `PROGRESS.WeeklyRecap` | Outcome-based progress recap: strengths, reduced errors, retest gain, and what to prioritize next week |
| `PROGRESS.Reactivation` | Comeback plan after absence; restore learning rhythm without dumping backlog or creating guilt |
| `PROGRESS.Wellbeing` | Track study load and overload signals and recommend an appropriate slowdown or break |

### Search & Resource Center (SEARCH)

| id | Capability |
|---|---|
| `SEARCH.Global`, `SEARCH.Knowledge`, `SEARCH.Question` | Global / Knowledge / Question Search |
| `SEARCH.Formula`, `SEARCH.Cheatsheet` | Formula, Cheatsheet |
| `SEARCH.BandDescriptor`, `SEARCH.WritingSample`, `SEARCH.SpeakingSample` | Band Descriptor, Writing/Speaking Sample |

### Study Orchestration (STUDY)

The orchestration layer between Goal (long-term) and Practice (questions) — the backbone of Home.

| id | Capability |
|---|---|
| `STUDY.Session` | Study Session (Start, Resume, Pause, End, Session Goal) |
| `STUDY.SessionSummary` | Session Summary (time, number of questions, new words, errors) |
| `STUDY.DailyPlan` | Daily Plan (Today's Lesson, Today's Practice, Today's Review) |
| `STUDY.TodayQueue` | Today's Queue (review SRS due, weak skill practice, exam prep) |
| `STUDY.Continue` | Continue on Another Device (current session handoff) |
| `STUDY.Resume` | Resume after interruption (Mock Test, network loss, session timeout) — Error Recovery belongs here |
| `STUDY.MicroSession` | A 5–10 minute session for busy days, still tied to a concrete goal and outcome |
| `STUDY.CheckIn` | Check in on energy, available time, and study intent to adjust today's session |

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
| `SUB.Plan`, `SUB.Payment`, `SUB.Premium`, `SUB.UsageLimit` | Learning plan / payment / premium / usage limit |

---

## Content Features (Colab)

### Content Management (CONTENT)

| id | Capability |
|---|---|
| `CONTENT.Lesson`, `CONTENT.Knowledge`, `CONTENT.QuestionBank`, `CONTENT.MockTest`, `CONTENT.Quiz`, `CONTENT.Tag` | Content management |
| `CONTENT.Publish` | Publish Workflow |
| `CONTENT.Moderation` | Review content, check errors, check tags, unpublish |
| `CONTENT.BlueprintUpdate` | Update content when the IELTS blueprint changes |
| `CONTENT.Feedback` | Handle Content Feedback from learners (Report Content, Suggest Fix, Report Wrong Answer) |
| `CONTENT.AutoTag` | Suggest taxonomy/tags from content; never auto-publish |
| `CONTENT.TagReview` | Colab reviews and accepts/rejects suggested tags |

> Colab never scores learner work. See `05-content.md` for the Knowledge System and taxonomy.

---

## Admin Features

### Administration (ADMIN)

| id | Capability |
|---|---|
| `ADMIN.User`, `ADMIN.Role`, `ADMIN.Permission`, `ADMIN.AccountStatus` | User / Role / Permission / Account Status |
| `ADMIN.SystemSetting`, `ADMIN.Dashboard`, `ADMIN.AuditLog`, `ADMIN.ModerationLog` | System Management |
| `ADMIN.GovernanceDashboard` | View evaluation-quality metrics (confidence, drift, bias, anti-gaming) — see `06-engines.md` |
| `ADMIN.Billing`, `ADMIN.Revenue`, `ADMIN.Premium` | Billing Management |

---

## Quality & Economics Operations (OPS)

These backend/cross-functional capabilities protect quality and cost. They must have an owner, threshold, escalation policy, and dashboard; they should not become complex learner UI unless doing so creates additional learner outcome.

| id | Capability |
|---|---|
| `OPS.ContentQuality` | Content quality gate: correctness, taxonomy completeness, difficulty calibration, accessibility, licensing |
| `OPS.EvaluationQuality` | Scorer quality gate: rubric alignment, calibration, confidence, drift, bias, reproducibility |
| `OPS.ReleaseGate` | Gate before publishing a model/content/feature; checks quality, safety, accessibility, and cost |
| `OPS.OutcomeMeasurement` | Measure learning outcome, retest gain, error recurrence, helpfulness, and long-term skill transfer |
| `OPS.ModelRouting` | Route requests by risk/value/latency: rules/cache/small model/large model/fallback |
| `OPS.CostBudget` | Budget by learner, capability, model, audio minutes, and batch job |
| `OPS.Quota` | Rate limit, usage limit, fair use, and graceful degradation |
| `OPS.Observability` | Track latency, errors, token/audio usage, cache hit, escalation, and quality impact |

### Capability contract

The catalog owns identity and short descriptions. Every capability moved into an active phase, build candidate, or build-ready state must have a canonical **Capability Profile**; capabilities in the future horizon do not yet need their own profile. A profile contains build/governance metadata and may be represented as an Artifact when the capability enters build, but the following fields are mandatory and must not exist only in an implementation backlog:

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

P0 no longer means every capability that might exist at launch. The P0 closed pilot contains only the capabilities required to prove one outcome: **a Writing Task 2 learner receives evidence-backed feedback, fixes one error, reviews it, and successfully retests it**. A row is a shared profile for capabilities that may not diverge within the same vertical slice; if they need to diverge, split the profile.

| Profile | Capability IDs | User outcome | Owner | Dependencies | Primary events | Quality / fallback | Privacy | Cost boundary |
|---|---|---|---|---|---|---|---|---|
| `P0-01 Identity` | `IDENTITY.Auth`, `IDENTITY.Profile`, `IDENTITY.Privacy` | Has an account, consent, and ownership of their data | engineering | managed auth boundary | account_created, consent_recorded | deny-by-default; export/delete recovery | account | managed_auth_pilot |
| `P0-02 Diagnosis` | `GOAL.Target`, `PLACE.Test`, `PLACE.BandEstimation`, `PLACE.GapDetection`, `PLACE.InitialPath`, `PLACE.SkillDiagnosis`, `BAND.Current` | Has a baseline and goal from which to generate a plan | product | published placement configuration | placement_started/completed | insufficient data → explain + retry | learning | placement_pilot |
| `P0-03 Daily action` | `STUDY.DailyPlan`, `STUDY.CheckIn`, `STUDY.MicroSession`, `PERSONAL.NextBestAction` | Knows one useful thing to do today | product | P0-02 + user state | daily_plan_generated, session_started | no confidence → at most 3 choices with clear reasons | learning | rules_first |
| `P0-04 Writing evaluation` | `LEARN.Writing`, `EVAL.Writing`, `COACH.ErrorAnalysis`, `COACH.Feedback`, `PKM.Drafts` | Writes, saves, submits, and understands evidence-backed feedback | product + engineering | published task, rubric, evaluation contract | evaluation_submitted, evaluation_scored | low confidence/delay/unavailable user-safe states | learning/assessment | writing_eval_pilot |
| `P0-05 Error-to-review` | `REVIEW.MistakeNotebook`, `REVIEW.FSRS`, `REVIEW.SmartQueue`, `PRACTICE.Drill` | Selects one error, fixes it, reviews it, and retests | product | P0-04 + error taxonomy | learning_error_saved, review_completed, retest_completed | missing evidence → no review card; empty queue → alternative action | learning | deterministic_fsrs |
| `P0-06 Quality & economics` | `OPS.CostBudget`, `OPS.ModelRouting`, `OPS.Quota`, `OPS.Observability`, `OPS.ReleaseGate`, `OPS.EvaluationQuality`, `OPS.ContentQuality`, `OPS.OutcomeMeasurement`, `GOVERNANCE.ConfidenceScore`, `GOVERNANCE.AuditTrail` | Does not sacrifice trust/data safety for feature speed | operations | benchmark, content, event/failure contracts | evaluation_failed, evaluation_delayed, retest_completed | release blocked / deterministic fallback | assessment | quality_release_gate |

Capabilities outside this matrix remain canonical Blueprint capabilities but are not part of closed-pilot P0. They can enter launch scope only through an Artifact decision plus the Build Readiness Matrix, never by copy/pasting them into P0.

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
| `placement_started` / `placement_completed` | A valid placement begins/completes | PLACE, PERSONAL, activation |
| `goal_set` | A valid goal is stored | GOAL, PLACE, STUDY |
| `daily_plan_generated` | Today creates or refreshes a plan with a reason | STUDY, PERSONAL, UX diagnosis |
| `session_started` | Learner begins a study session with intent | STUDY, outcome measurement |
| `session_completed` | Session satisfies its completion rule | STUDY, outcome measurement |
| `first_meaningful_session_completed` | The first session produces an outcome rather than merely opening the app | PROGRESS, retention |
| `lesson_completed` | Lesson satisfies its completion rule | LEARN, REVIEW, recommendation |
| `practice_finished` | Practice set ends validly | HISTORY, PROGRESS, PERSONAL |
| `evaluation_submitted` | Writing/Speaking/Pronunciation is submitted | EVAL, quota, cost |
| `evaluation_scored` | A valid result is created | HISTORY, BAND, PROGRESS |
| `evaluation_failed` | A valid result cannot be created | recovery, observability |
| `evaluation_delayed` | Evaluation exceeds the published waiting-time threshold | recovery, quota, observability |
| `explanation_viewed` | Learner views evidence/explanation | COACH, helpfulness |
| `learning_error_saved` | An evidence-backed error is stored in the mistake system | REVIEW, outcome measurement |
| `practice_started` | Learner starts an action from feedback | PERSONAL, outcome |
| `retest_completed` | Retest after feedback completes | OPS.OutcomeMeasurement |
| `review_completed` | FSRS review is rated and stored successfully | REVIEW, retention |
| `quota_warning_shown` | Learner is warned about low quota before a costly action | OPS.Quota, UX |
| `quota_exceeded` | A costly action is blocked because quota/reservation has no remaining slot | OPS.Quota, UX, recovery |
| `goal_completed` | Goal satisfies its completion rule | GOAL, PROGRESS |
| `session_paused` / `session_resumed` | Session checkpoints / recovers | STUDY, recovery |
| `session_abandoned` | Session ends according to abandonment policy | STUDY, UX diagnosis |
| `comeback_plan_started` / `comeback_plan_completed` | Learner returns and starts/completes a comeback plan | PROGRESS.Reactivation, retention |
| `returned_after_14_days` | First meaningful return after 14 days | PROGRESS, experiment |
| `notification_delivered` / `notification_opened` / `notification_opted_out` | Notification lifecycle | NOTIF, fatigue control |

### Registered slice/internal extensions

The events below use the same envelope and registry but are detail/operational extensions; they do not replace canonical outcome events. Their producer must be a backend service, not the SPA directly.

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
- Do not send PII or raw audio/text into analytics unless required; use references and a privacy class.
- Outcome events must have a quality state; `evaluation_failed`, `low_confidence`, and `invalid` must not count as success.
- Backfills must use `source=backfill`, record a reason and time range, and must not trigger unintended notifications/recommendations.
- Data deletion must cascade according to privacy policy and may leave anonymized aggregates only when consent allows it.

---

## Engine Capabilities (reference)

The Engine layer (`06-engines.md`) implements the following capabilities. Their descriptions are not duplicated here; this list exists only for traceability:

- `REVIEW.FSRS` ← FSRS engine
- `EVAL.Writing`, `EVAL.Speaking`, `EVAL.Pronunciation`, `EVAL.Examiner` ← Evaluation engine
- `PERSONAL.Recommendation`, `PERSONAL.NextBestAction`, `PERSONAL.Insights` ← Recommendation engine
- `GOVERNANCE.*` ← AI Governance engine (see `06-engines.md`)
- `OPS.*` ← Quality & Cost Control Plane (see `06-engines.md`)

## AI Governance Capabilities (GOVERNANCE)

Invisible backend control targets for the sole evaluator; they are not a quality guarantee while real corpus, thresholds, and benchmark runs are missing. Implementation details are in `06-engines.md`.

| id | Capability |
|---|---|
| `GOVERNANCE.ConfidenceScore` | Every evaluation has a confidence score; low-confidence evaluations are flagged |
| `GOVERNANCE.GoldStandardBenchmark` | Proposal: weekly re-scoring of an examiner-graded corpus whose size is approved by the founder to measure deviation; no active corpus/run currently exists |
| `GOVERNANCE.DriftDetection` | Detect scoring-model drift over time |
| `GOVERNANCE.BiasMonitoring` | Monitor scoring differences across user groups / task types / bands |
| `GOVERNANCE.AntiGaming` | Detect sample / plagiarism / ChatGPT-generated submissions |
| `GOVERNANCE.AuditTrail` | Log every calibration and model-version change |
| `GOVERNANCE.Dashboard` | Admin view of evaluation-quality metrics |
