# Deferred Families Reference — Executor-Grade

- **Type:** deferred-contract-reference
- **Status:** `review`
- **Owner:** product + engineering
- **Purpose:** Provide executor-grade traceability for all 20 PLANNED implementation families. Each family has a deferred contract that is ready for promotion when its phase gate fires, but is explicitly NOT build-ready, NOT P0, and contains no runtime activation claim.
- **Derived from:** `capability-family-registry.yaml`, `capability-lifecycle-registry.yaml`, `blueprint/03-features.md`, `blueprint/08-roadmap.md`

## Reading guide

For each PLANNED family, this reference provides:
- ✅ Family identity, purpose, and phase rationale
- ✅ Capability-to-family mapping
- ✅ Deferred actors, entities, contracts, events, failures
- ✅ Dependencies on ACTIVE families
- ✅ Promotion gate (exact evidence or policy change needed)
- ✅ Non-goals for the deferred scope

Fields marked `deferred` have no runtime contract and are not expected to until phase promotion. Fields marked
`awaiting_promotion` have a known shape but no artifact yet.

---

## Batch B — Learning and Practice Families

### 1. READING.Practice

```yaml
family_id: READING.Practice
family_version: 1.0.0
lifecycle: PLANNED
phase: P1
status: planned
purpose: Passage-based reading practice, answer evaluation, review, and retest.
owner: product+engineering
runtime_boundary: reading passage, attempt, answer result, review, and retest
dependencies_on_active: [IDENTITY.Core]  # identity only; no evaluation pipeline dependency
capabilities:
  - LEARN.Reading
allowed_deltas: [READING.QuestionType]
deferred_entities: [ReadingPassage, ReadingAttempt, ReadingAnswer, ReadingReview]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [reading_answer_key_benchmark]
promotion_gate:
  - reading question bank published (≥ N passages with answer keys)
  - answer evaluation accuracy benchmark against answer-key baseline
  - deterministic scoring for at least 3 question types (TFNG, MC, short-answer)
  - founder approval per roadmap P1 decision
non_goals: [IELTS Academic + GT full module simulation, speaking integration, free-text reading comprehension scoring]
```

### 2. LISTENING.Practice

```yaml
family_id: LISTENING.Practice
family_version: 1.0.0
lifecycle: PLANNED
phase: P1
status: planned
purpose: Audio-based listening practice, answer evaluation, review, and retest.
owner: product+engineering
runtime_boundary: audio stimulus, attempt, answer result, review, and retest
dependencies_on_active: [IDENTITY.Core]
capabilities:
  - LEARN.Listening
allowed_deltas: [LISTENING.QuestionType]
deferred_entities: [ListeningAudio, ListeningAttempt, ListeningAnswer, ListeningReview]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [listening_answer_key_benchmark]
promotion_gate:
  - audio content published (≥ N audio passages with transcripts and answer keys)
  - answer evaluation accuracy benchmark against answer-key baseline
  - audio streaming + resume working end-to-end
  - founder approval per roadmap P1 decision
non_goals: [full IELTS Listening module simulation, section-based timing, headphone-free speaker mode]
```

### 3. PRACTICE.Drill (family)

```yaml
family_id: PRACTICE.Drill
family_version: 1.0.0
lifecycle: PLANNED
phase: P1
status: planned
purpose: Reusable question/task drill attempt and result workflow beyond retest.
owner: product+engineering
runtime_boundary: drill selection, attempt, result, review, and retest
dependencies_on_active: [IDENTITY.Core, REVIEW.ErrorToReview]
cross_family_note: >
  The PRACTICE.Drill *capability* (P0 ACTIVE) lives in REVIEW.ErrorToReview family for
  retest-only execution. This PRACTICE.Drill *family* hosts general drill types
  (PRACTICE.Set, PRACTICE.Timed, PRACTICE.Adaptive) which are PLANNED.
capabilities:
  - PRACTICE.Set
  - PRACTICE.Timed
  - PRACTICE.Adaptive
allowed_deltas: [PRACTICE.Type]
deferred_entities: [PracticeSet, PracticeAttempt, PracticeResult]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [practice_workflow_acceptance]
promotion_gate:
  - drill content or question bank available for at least 2 skills
  - adaptive difficulty calibration run
  - timed drill workflow acceptance
  - founder approval per roadmap P1 decision
non_goals: [mock test composite, speaking drill with audio recording, pronunciation drill]
```

---

## Batch C — Assessment Families

### 4. SPEAKING.Practice

```yaml
family_id: SPEAKING.Practice
family_version: 1.0.0
lifecycle: PLANNED
phase: P1
status: planned
purpose: Speaking prompt, recording, timing, and retest workflow.
owner: product+engineering
runtime_boundary: speaking prompt, recording, transcript, and retest
dependencies_on_active: [IDENTITY.Core]
note: >
  This family has 0 capabilities assigned in the lifecycle registry.
  All speaking capabilities (EVAL.Examiner, EVAL.Speaking, LEARN.Speaking) map to
  SPEAKING.Evaluation. Verify intent at family promotion — this family may be a
  practice-only entry point separate from evaluation.
capabilities: []  # 0 assigned — verify at promotion
allowed_deltas: [SPEAKING.Part]
deferred_entities: [SpeakingPrompt, SpeakingRecording, SpeakingAttempt]
deferred_contracts:
  - artifacts/experience/specs/interaction/speaking-transcription-feedback.md
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [speaking_recording_acceptance]
promotion_gate:
  - speaking prompts published (≥ N across 3 parts)
  - recording workflow with browser MediaRecorder accepted
  - recording storage/retention policy approved
  - founder approval per roadmap P1 decision
non_goals: [real-time examiner simulation, pronunciation scoring, full Part 2/3 timing]
```

### 5. SPEAKING.Evaluation

```yaml
family_id: SPEAKING.Evaluation
family_version: 1.0.0
lifecycle: PLANNED
phase: P1
status: planned
purpose: Evidence-backed speaking evaluation and feedback.
owner: product+engineering
runtime_boundary: speaking recording, evaluation, feedback, and recovery
dependencies_on_active: [IDENTITY.Core, WRITING.Evaluation]  # inherits evaluation contract patterns
capabilities:
  - EVAL.Speaking
  - EVAL.Examiner
  - LEARN.Speaking
allowed_deltas: [SPEAKING.Part]
deferred_entities: [SpeakingEvaluation, SpeakingFinding]
deferred_contracts:
  - artifacts/engineering/decisions/speaking-speech-processing-routing-decision.md
  - artifacts/experience/specs/interaction/speaking-transcription-feedback.md
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [speaking_evaluator_benchmark]
promotion_gate:
  - STT provider DPA and benchmark completed
  - speaking gold corpus with examiner labels
  - evaluation accuracy benchmark against human examiner scores
  - pronunciation feature scoring not required for speaking evaluation launch
  - founder approval per roadmap P1 decision
non_goals: [real-time examiner avatar, video analysis, accent identification]
```

### 6. PRONUNCIATION.Practice

```yaml
family_id: PRONUNCIATION.Practice
family_version: 1.0.0
lifecycle: PLANNED
phase: P1
status: planned
purpose: Pronunciation target, model, recording, feature feedback, and retest.
owner: product+engineering
runtime_boundary: pronunciation target, audio attempt, feature result, and retest
dependencies_on_active: [IDENTITY.Core]
capabilities:
  - EVAL.Pronunciation
  - LEARN.Pronunciation
allowed_deltas: [PRONUNCIATION.Unit]
deferred_entities: [PronunciationTarget, PronunciationAttempt, PronunciationResult]
deferred_contracts:
  - artifacts/engineering/decisions/speaking-speech-processing-routing-decision.md
  - artifacts/experience/specs/interaction/speaking-transcription-feedback.md
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [pronunciation_feature_benchmark]
promotion_gate:
  - pronunciation targets/labels published for phoneme-level feedback
  - audio alignment and feature-extraction acceptance
  - phoneme accuracy benchmark
  - founder approval per roadmap P1 decision
non_goals: [accent coaching, prosody/intonation scoring, real-time pronunciation overlay]
```

### 7. MOCK.ExamSimulation

```yaml
family_id: MOCK.ExamSimulation
family_version: 1.0.0
lifecycle: PLANNED
phase: P1
status: planned
purpose: Composite IELTS exam simulation, timing, resume, scoring, and routing.
owner: product+engineering
runtime_boundary: composite test session, section timing, score aggregation, and recovery
dependencies_on_active: [IDENTITY.Core, WRITING.Evaluation, REVIEW.ErrorToReview, PLACEMENT.Diagnosis]
capabilities:
  - PRACTICE.MockTest
  - PRACTICE.ExamSimulation
  - CONTENT.MockTest
allowed_deltas: [MOCK.Module]
deferred_entities: [MockSession, MockSection, MockResult]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [mock_composite_benchmark]
promotion_gate:
  - reading + listening practice families activated (sections require them)
  - composite timing and resume acceptance across all 4 skills
  - score aggregation calibrated against official band conversion
  - founder approval per roadmap P1 decision
non_goals: [official IELTS mock test certification, speaking examiner simulation, writing + speaking simultaneous]
```

---

## Batch D — Content, Knowledge, Search, PKM, Localization

### 8. CONTENT.Management

```yaml
family_id: CONTENT.Management
family_version: 1.0.0
lifecycle: PLANNED
phase: P1
status: planned
purpose: Content authoring, question bank, knowledge, moderation, tagging, and publishing workflow.
owner: content+operations
runtime_boundary: content lifecycle, moderation, publication, and learner availability
dependencies_on_active: [IDENTITY.Core]
capabilities:
  - CONTENT.Publish, CONTENT.Moderation, CONTENT.Feedback, CONTENT.QuestionBank
  - CONTENT.Quiz, CONTENT.Lesson, CONTENT.Tag, CONTENT.TagReview
  - CONTENT.AutoTag, CONTENT.BlueprintUpdate, CONTENT.Knowledge
  - CONTENT.MockTest  # mock test content, not mock test runtime (MOCK.ExamSimulation)
allowed_deltas: [CONTENT.AssetType]
deferred_entities: [ContentAsset, ContentRevision, PublicationRecord]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [content_quality_acceptance]
promotion_gate:
  - content authoring workflow spec approved
  - question-bank schema and import pipeline defined
  - moderation and publish-state lifecycle specified
  - knowledge-manifest schema versioned
  - P0-04 shared content contract (WritingTask seed) already exists at review and is sufficient for P0
  - founder approval per roadmap P1 decision
non_goals: [full CMS/headless CMS, learner-facing content search (SEARCH.Knowledge), AI content generation]
```

### 9. CONTENT.Knowledge

```yaml
family_id: CONTENT.Knowledge
family_version: 1.0.0
lifecycle: PLANNED
phase: deferred
status: planned
purpose: Canonical grammar, vocabulary, collocation, strategy, lesson, and exercise knowledge assets.
owner: content
runtime_boundary: canonical knowledge asset retrieval and learner consumption
dependencies_on_active: [IDENTITY.Core, CONTENT.Management]
capabilities:
  - KA.Grammar, KA.Vocabulary, KA.Collocation, KA.Strategy
  - KA.Lesson, KA.Exercise, KA.Example, KA.Template
allowed_deltas: [CONTENT.KnowledgeType]
deferred_entities: [KnowledgeAsset, KnowledgeManifest]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [knowledge_quality_acceptance]
promotion_gate:
  - Knowledge Asset spawn pipeline validated (already exists: spawn-prompts/)
  - asset rights review and provenance complete for each knowledge type
  - content-usage analytics defined
  - founder approval per roadmap decision
non_goals: [automated asset generation pipeline (colab-only), learner content authoring, asset marketplace]
```

### 10. SEARCH.Knowledge

```yaml
family_id: SEARCH.Knowledge
family_version: 1.0.0
lifecycle: PLANNED
phase: P1
status: planned
purpose: Search across canonical knowledge, questions, descriptors, and learner-accessible samples.
owner: product+engineering
runtime_boundary: query, retrieval, permission filtering, and result presentation
dependencies_on_active: [IDENTITY.Core, CONTENT.Management]
capabilities:
  - SEARCH.Global, SEARCH.Knowledge, SEARCH.Question, SEARCH.BandDescriptor
  - SEARCH.Cheatsheet, SEARCH.Formula, SEARCH.SpeakingSample, SEARCH.WritingSample
allowed_deltas: [SEARCH.Index]
deferred_entities: [SearchQuery, SearchResult]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [search_relevance_acceptance]
promotion_gate:
  - searchable content index populated (≥ N knowledge assets)
  - full-text search relevance benchmark
  - permission-scoped retrieval (public vs premium vs colab-internal)
  - founder approval per roadmap P1 decision
non_goals: [vector/semantic search in P1, learner data search, admin content search, external IELTS search]
```

### 11. PKM.Content

```yaml
family_id: PKM.Content
family_version: 1.0.0
lifecycle: PLANNED
phase: P1
status: planned
purpose: Learner-owned drafts, notes, recordings, collections, import/export, and sync.
owner: product+engineering
runtime_boundary: learner content ownership, persistence, sync, and export boundary
dependencies_on_active: [IDENTITY.Core]
capabilities:
  - PKM.Notes, PKM.WordBank, PKM.Collections, PKM.SavedItems, PKM.Sync
  - PKM.Import, PKM.Export, PKM.Offline, PKM.Recordings
allowed_deltas: [PKM.ContentType]
deferred_entities: [LearnerContent, Collection, SyncCursor]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [content_ownership_acceptance]
promotion_gate:
  - learner content ownership and privacy policy approved
  - export format (Markdown/JSON) specified
  - offline sync conflict-resolution strategy defined
  - founder approval per roadmap P1 decision
non_goals: [collaborative editing, public sharing, SRS for wordbank (FSRS covers review cards)]
note: >
  PKM.Drafts (P0 ACTIVE) already handled by WRITING.Evaluation family.
  This family covers the remaining PKM scope.
```

### 12. LOCALIZATION.Preference

```yaml
family_id: LOCALIZATION.Preference
family_version: 1.0.0
lifecycle: PLANNED
phase: P2/deferred
status: planned
purpose: Interface language, response language, locale format, and preference sync.
owner: product+engineering
runtime_boundary: locale preference and localized web rendering
dependencies_on_active: [IDENTITY.Core]
capabilities:
  - LOC.InterfaceLanguage, LOC.AIResponseLanguage, LOC.LocaleFormat
  - LOC.PreferenceSync, LOC.Switcher
allowed_deltas: [LOCALIZATION.Locale]
deferred_entities: [LocalePreference]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [localization_acceptance]
promotion_gate:
  - Vietnamese-only for closed/public pilot (P0/P1); localization gate fires when second language is requested
  - i18n framework selected and integrated with Next.js
  - AI response language preference contract specified (prompt locale injection)
  - founder approval per roadmap P2 decision
non_goals: [multi-locale date/number/currency formatting in P0/P1, RTL support, content translation pipeline]
```

### 13. HISTORY.Assessment

```yaml
family_id: HISTORY.Assessment
family_version: 1.0.0
lifecycle: PLANNED
phase: P1
status: planned
purpose: Assessment history, comparison, portfolio, and timeline projections.
owner: product+engineering
runtime_boundary: persisted assessment facts and learner history views
dependencies_on_active: [IDENTITY.Core, WRITING.Evaluation, PLACEMENT.Diagnosis, REVIEW.ErrorToReview]
capabilities:
  - HISTORY.Attempts, HISTORY.BandTimeline, HISTORY.Compare
  - HISTORY.LearningTimeline, HISTORY.ScoreTimeline, HISTORY.SkillTimeline
  - HISTORY.SpeakingPortfolio, HISTORY.WritingPortfolio
allowed_deltas: [HISTORY.View]
deferred_entities: [AssessmentHistory, AssessmentSnapshot]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [history_consistency_acceptance]
promotion_gate:
  - assessment facts from WRITING.Evaluation and PLACEMENT.Diagnosis are canonical and queryable
  - history projection design-approved (band timeline, skill comparison, portfolio views)
  - consistency acceptance: derived projections match source facts
  - founder approval per roadmap P1 decision
non_goals: [teacher/parent dashboard, group analytics, official score certificate generation]
```

---

## Batch E — Progress, Personal, Notification, Subscription, Admin, Governance, Coach

### 14. PROGRESS.Learning

```yaml
family_id: PROGRESS.Learning
family_version: 1.0.0
lifecycle: PLANNED
phase: P1/deferred
status: planned
purpose: Progress, band, goal, and learning analytics projections.
owner: product+engineering
runtime_boundary: evidence-derived progress and learner-facing progress views
dependencies_on_active: [IDENTITY.Core, WRITING.Evaluation, PLACEMENT.Diagnosis, REVIEW.ErrorToReview]
capabilities:
  - PROGRESS.Dashboard, PROGRESS.BandProgress, PROGRESS.GoalTracking, PROGRESS.SkillAnalytics
  - PROGRESS.LearningAnalytics, PROGRESS.Achievement, PROGRESS.Motivation, PROGRESS.Wellbeing
  - PROGRESS.Reactivation, PROGRESS.WeeklyRecap
  - BAND.Checklist, BAND.Completion, BAND.Descriptor, BAND.Map
  - BAND.ProgressionWarning, BAND.Requirement, BAND.Target, BAND.RecommendedNext
  - BAND.Readiness, BAND.ExamReadiness
  - EVAL.BandPrediction
allowed_deltas: [PROGRESS.View]
deferred_entities: [ProgressSnapshot, BandTimeline, GoalProgress]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [progress_projection_acceptance]
promotion_gate:
  - enough learner data exists to make projections meaningful (at least N weeks of activity per learner)
  - progress metrics defined and acceptance-tested against projection correctness
  - band prediction guarded: always shows "estimate" label, never "official"
  - founder approval per roadmap decision
non_goals: [predictive analytics beyond band, external reporting, teacher progress reports, normative comparison]
```

### 15. PERSONAL.Recommendation

```yaml
family_id: PERSONAL.Recommendation
family_version: 1.0.0
lifecycle: PLANNED
phase: P1/P2/deferred
status: planned
purpose: Evidence-backed personalization, gaps, recommendations, and next action selection beyond P0.
owner: product+engineering
runtime_boundary: learner evidence to recommendation decision boundary
dependencies_on_active: [IDENTITY.Core, STUDY.DailyAction, WRITING.Evaluation, REVIEW.ErrorToReview]
capabilities:
  - PERSONAL.Insights, PERSONAL.GapAnalysis, PERSONAL.Recommendation
  - PERSONAL.WeaknessPractice, PERSONAL.AdaptivePlan, PERSONAL.GoalRecommendation
allowed_deltas: [PERSONAL.Strategy]
deferred_entities: [Recommendation, GapProfile, PersonalPlan]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [recommendation_outcome_evidence]
promotion_gate:
  - P0 deterministic NextBestAction baseline measured (retention + outcome data)
  - recommendation model/candidate contract specified
  - A/B framework or shadow-mode evaluation path defined
  - founder approval per roadmap decision
non_goals: [general-purpose recommendation engine, content discovery feed, social/peer recommendations]
note: >
  PERSONAL.NextBestAction (P0 ACTIVE) already in STUDY.DailyAction family as deterministic baseline.
```

### 16. NOTIFICATION.Delivery

```yaml
family_id: NOTIFICATION.Delivery
family_version: 1.0.0
lifecycle: PLANNED
phase: P1/P2
status: planned
purpose: Preference-aware delivery of study, result, review, and goal notifications.
owner: product+engineering
runtime_boundary: notification decision, preference, delivery, and suppression
dependencies_on_active: [IDENTITY.Core, STUDY.DailyAction]
capabilities:
  - NOTIF.Study, NOTIF.Result, NOTIF.Review, NOTIF.SRS, NOTIF.Goal
  - NOTIF.Reengagement, NOTIF.Preference, NOTIF.QuietHours, NOTIF.SmartDelivery
allowed_deltas: [NOTIFICATION.Channel]
deferred_entities: [Notification, NotificationPreference, DeliveryAttempt]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [notification_delivery_acceptance]
promotion_gate:
  - notification frequency and suppression policy approved (no spam, no guilt)
  - delivery channel acceptance (push + email minimum)
  - quiet-hours and preference sync working end-to-end
  - founder approval per roadmap P2 decision
non_goals: [marketing push, third-party channel integration, A/B notification optimization]
```

### 17. SUBSCRIPTION.Usage

```yaml
family_id: SUBSCRIPTION.Usage
family_version: 1.0.0
lifecycle: PLANNED
phase: P1
status: planned
purpose: Plan, payment, premium entitlement, quota, and usage boundary.
owner: product+engineering
runtime_boundary: entitlement, usage measurement, quota, and graceful degradation
dependencies_on_active: [IDENTITY.Core, OPS.QualityEconomics]
capabilities:
  - SUB.Plan, SUB.Premium, SUB.Payment, SUB.UsageLimit
allowed_deltas: [SUBSCRIPTION.Plan]
deferred_entities: [Subscription, Entitlement, UsageLedger]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [quota_and_entitlement_acceptance]
promotion_gate:
  - payment provider (PayOS) DPA and integration tested
  - free/premium quota boundary specified in quota-usage-contract.md (already review)
  - entitlement revocation and grace-period behavior defined
  - founder pricing and plan decision
non_goals: [multi-currency billing, invoicing, marketplace, family/team plans, promo engine]
```

### 18. ADMIN.Governance

```yaml
family_id: ADMIN.Governance
family_version: 1.0.0
lifecycle: PLANNED
phase: P1/P2/deferred
status: planned
purpose: Administrative users, permissions, billing views, moderation logs, and governance dashboard.
owner: operations
runtime_boundary: privileged administration and audit boundary
dependencies_on_active: [IDENTITY.Core, OPS.QualityEconomics]
capabilities:
  - ADMIN.User, ADMIN.Role, ADMIN.Permission, ADMIN.AccountStatus
  - ADMIN.Billing, ADMIN.Revenue, ADMIN.Premium, ADMIN.Dashboard
  - ADMIN.GovernanceDashboard, ADMIN.ModerationLog, ADMIN.AuditLog
  - ADMIN.SystemSetting
allowed_deltas: [ADMIN.Surface]
deferred_entities: [AdminUser, Permission, AuditLog]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [admin_permission_acceptance]
promotion_gate:
  - admin UI surface spec approved (governance-ops-dashboard.md already review for P0)
  - role-based permission model specified
  - admin audit trail acceptance
  - founder approval per roadmap decision
non_goals: [customer support ticketing, community moderation, content moderation UI (CONTENT.Management owns that)]
```

### 19. GOVERNANCE.Quality

```yaml
family_id: GOVERNANCE.Quality
family_version: 1.0.0
lifecycle: PLANNED
phase: P1
status: planned
purpose: Anti-gaming, bias, drift, confidence, audit, and gold-standard governance beyond P0.
owner: operations
runtime_boundary: evaluator governance and quality decision boundary
dependencies_on_active: [OPS.QualityEconomics, WRITING.Evaluation]
capabilities:
  - GOVERNANCE.AntiGaming  # supersedes deprecated EVAL.AntiGaming
  - GOVERNANCE.BiasMonitoring, GOVERNANCE.DriftDetection
  - GOVERNANCE.GoldStandardBenchmark, GOVERNANCE.Dashboard
allowed_deltas: [GOVERNANCE.Control]
deferred_entities: [GovernanceFinding, QualityDecision]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [governance_benchmark]
promotion_gate:
  - P0 governance baseline operational (GOVERNANCE.ConfidenceScore + GOVERNANCE.AuditTrail in OPS.QualityEconomics)
  - anti-gaming detection spec and threshold defined
  - gold-standard benchmark corpus curated (beyond writing evaluation corpus)
  - drift detection acceptance test defined
  - founder approval per roadmap P1 decision
non_goals: [automatic model retraining, external certification/audit, fairness/bias regulatory compliance framework]
```

### 20. COACH.Feedback (family)

```yaml
family_id: COACH.Feedback
family_version: 1.0.0
lifecycle: PLANNED
phase: P1
status: planned
purpose: Cross-skill explanatory feedback and tutoring behavior after P0.
owner: product+engineering
runtime_boundary: learner result to explainable feedback response
dependencies_on_active: [WRITING.Evaluation, REVIEW.ErrorToReview]
capabilities:
  - COACH.AnswerExplanation, COACH.VocabularyExplanation, COACH.DistractorExplanation
  - COACH.ListeningCoach, COACH.ReadingCoach, COACH.Recommendation, COACH.Tutor
allowed_deltas: [COACH.FeedbackType]
deferred_entities: [FeedbackResponse, Explanation]
deferred_contracts: []
deferred_events: []
deferred_failures: []
deferred_acceptance: []
deferred_evidence: [feedback_helpfulness_evidence]
cross_family_note: >
  COACH.ErrorAnalysis and COACH.Feedback *capabilities* (P0 ACTIVE) live in WRITING.Evaluation family
  for writing-specific error analysis. This COACH.Feedback *family* hosts the cross-skill,
  general-purpose coaching capabilities (listening, reading, tutor, vocabulary).
promotion_gate:
  - at least 2 skills beyond Writing have active evaluation/data (listening + reading)
  - each feedback type has a specified contract (input shape, prompt bounds, output format)
  - helpfulness benchmark designed (learner-reported + outcome-correlated)
  - founder approval per roadmap P1 decision
non_goals: [real-time tutor chat, voice tutor, domain-agnostic general AI assistant, human tutor matching]
```

---

## Unified promotion gate criteria

Every PLANNED family shares the same minimum bar for promotion to ACTIVE:

1. **Phase alignment** — family is listed in the next phase per `blueprint/08-roadmap.md`.
2. **Dependency satisfaction** — all ACTIVE dependencies are operational (evidence present).
3. **Family contract** — at minimum: owner_spec, entities, contracts, events, failures, and acceptance defined.
4. **Founder approval** — explicit, attested founder decision.
5. **Evidence gate** — deferred_evidence items have known intake path.

No family is promoted by proximity, momentum, or partial readiness.

## Node

This is a deferred-contract reference, not a set of 20 canonical owner specs. When a family is promoted
to ACTIVE, its individual `owner_spec` file must be created following the pattern in `architecture-frozen.md`
and the existing ACTIVE runtime specs. This document provides the traceability scaffolding; the real depth
comes from individual promotion.
