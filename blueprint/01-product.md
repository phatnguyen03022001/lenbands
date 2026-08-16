# 01 — Product

This file answers **WHY / WHO / WHAT**, not HOW (HOW belongs in `02-architecture.md` and later files).

## Vision

This is an IELTS learning application designed as an **AI-first Knowledge OS**:

- Not merely an LMS that stores lessons
- Not merely a quiz app
- A system that helps learners understand the full IELTS blueprint, know where they are, identify what is missing, and decide what to learn next

## Target users

- IELTS learners from band 3.0 to 8.5
- Learners who want to know exactly where they are weak and what to learn next
- Learners who need IELTS practice organized by skill, question type, target band, and a concrete plan

## Core value

- Model IELTS as a structured knowledge system
- Personalize learning paths by band, skill, question type, and recurring error
- AI scores Writing, Speaking, and Pronunciation — the system scores 100% automatically with no human intervention
- AI analyzes gaps, recommends the next best action, and supports knowledge explanation
- Colab only adds, updates, moderates, and publishes content; it does not score learner work
- Admin manages the system, users, billing, and access permissions; it does not score learner work

## Product positioning

AI-first Knowledge OS — not an LMS and not a quiz app.

## Principles

1. **Blueprint structured** — IELTS is modeled as a structured blueprint rather than a list of lessons. Band progression is a soft recommendation and does not hard-lock access.
2. **Sole evaluator + governance** — the entire evaluation layer is handled 100% by AI, with no human in the loop. The quality-control target is AI Governance (invisible backend): confidence scoring, gold-standard benchmark, drift/bias monitoring, and anti-gaming detection. This is not a guarantee until real evidence exists.
3. **No-AI-label UI** — documentation may use the term "AI" on capabilities so developers understand their origin; the user interface does not display the word "AI" or an AI icon and instead uses plain functional names. See `07-conventions.md`.
4. **Content taxonomy depth** — FSRS, Adaptive Practice, Gap Analysis, Learning Insights, and AI Error Analysis are only as accurate as Colab's detailed tagging across band, micro-skill, question type, distractor type, paraphrase pattern, and grammar point. Shallow metadata means garbage in, garbage out. See `05-content.md`.
5. **SSOT** — each capability has exactly one capability ID and one canonical description in `03-features.md`; other spokes reference it rather than duplicating it.
6. **Progress over pressure** — retention is a consequence of real progress, not notification pressure, streak anxiety, or dark patterns.
7. **Outcome loop** — every error or weakness must pass through `Understand → Practice → Retest → Confirm`; completing an activity alone is not an outcome.
8. **Quality/cost guardrail** — cost reduction is allowed only when it does not reduce rubric accuracy, helpfulness, accessibility, or learner trust.

> **Evidence boundary:** sole-evaluator and governance are product design decisions. Benchmark corpus, numeric thresholds, drift detector, and cost ceiling have not yet been activated by founder/evidence; this prose must not be used to claim that evaluation is calibrated or governance is currently operational.

## Role Model

```text
Guest
  ↓
Learner
  ↓
Premium Learner
```

```text
AI (sole evaluator — no human-in-the-loop)
  ↓
Score Writing / Speaking / Pronunciation
Explain Listening / Reading answers
Analyze errors
Recommend next best action
```

```text
Content (Colab)
  ↓
Add content
Moderate content
Publish content
```

```text
Administration
  ↓
Manage users, permissions, billing, and system settings
```

### Role boundaries

- **Learner** studies, practices, takes tests, and reviews progress
- **Premium Learner** accesses advanced content, analysis, and AI-powered features
- **AI** is the sole evaluator: it scores Writing, Speaking, and Pronunciation, explains answers, analyzes errors, predicts bands, and recommends learning actions — no human stands in the evaluation path
- **Colab** only manages content (add, moderate, publish); it never scores learner work or intervenes in evaluation results
- **Admin** only operates the system (user, role, billing, audit); it never scores learner work or overrides AI evaluation results

## Scope

### In scope

- Learn IELTS by band, skill, and question type
- Model the four skills (Listening/Reading/Writing/Speaking) plus Pronunciation as one Learning domain, with four layers for each skill: Learning / Practice / Evaluation / Review
- Evaluation: AI scores 100% of Writing/Speaking/Pronunciation without a human in the loop, including band prediction, rewrite suggestion, calibration, and consistency monitoring
- Coaching: answer/vocabulary/distractor explanation, listening/reading coach, feedback, error analysis, recommendation, IELTS Q&A tutor
- Personalization: gap analysis, next best action, adaptive learning plan, weakness-based practice, learning insights
- Review & revision: bookmark, mistake notebook, wrong-answer/question review, revision queue, FSRS spaced repetition, and smart review queue
- Assessment history: all attempts, score/band/skill timeline, learning timeline, writing/speaking portfolio, compare attempts
- Progress & analytics: dashboard, learning/skill analytics, band progress, goal tracking, lightweight motivation, and lightweight achievement
- Study orchestration: study session, daily plan, today's queue, continue on another device
- System Knowledge Assets plus Personal Knowledge (personal notes, word bank, collections, drafts, recordings, import, export, offline)
- Band framework & progression (readiness, exam readiness, soft recommendations)
- Goal & exam plan (target band/date, weekly/daily goal, countdown, checklist, timeline)
- Search & resource center
- Multilingual UI and AI responses; IELTS test content remains in English
- AI Governance: confidence scoring, gold-standard evaluation benchmark, drift/bias monitoring, anti-gaming detection (invisible backend)
- Colab manages, moderates, and publishes content and handles content feedback
- Admin manages the system, users, billing, and permissions

### Out of scope

- Live classes
- Real-time 1:1 video calls
- Human examiner / human-in-the-loop evaluation; AI is the sole scoring source
- Complex community forum
- Heavy game-style gamification such as leaderboards, badge hierarchies, or avatars
- Marketplace outside the scope of IELTS learning

### Scope note

- AI is the sole scoring source for Writing, Speaking, and Pronunciation; the system scores 100% automatically and no human intervenes at any layer of evaluation
- There is no human examiner or human reviewer role in the evaluation flow; every band score, feedback item, and recommendation is emitted by AI
- Evaluation quality is designed to be controlled through calibration on a standard dataset, consistency monitoring, model tuning, and AI Governance (`06-engines.md`), not by humans re-scoring individual submissions
- AI Examiner is the sole Speaking scoring source, not a simulation of, or replacement for, a separate human role inside LenBands
- Pronunciation analysis is produced by the speech engine and is intended to be continuously optimized toward the accuracy of a reference-quality system
- Colab only intervenes at the content layer, never at the evaluation layer
- Admin only operates the system (users, billing, audit); it never scores learner work or overrides AI results
- The band framework is core product IP and must not be treated as incidental metadata
- Band progression does not hard-lock learning; the system recommends, warns, and measures readiness instead of forcing learners through one path
- Band access may describe access state or recommendation but must not lock all knowledge at higher bands
- Question type is a learning unit as important as a lesson
- Multilingual behavior applies only to interface and AI responses; IELTS content (audio, passage, question, writing task, speaking prompt) always remains in its original English because learners need authentic exam-language exposure
- AI response language follows the user's selected language so feedback and explanations are easier to understand; response language does not affect scoring, which remains aligned to the IELTS rubric
- Personal Knowledge is each user's private learning space; Colab-published content becomes shared system Knowledge Assets, while Personal Knowledge lets a learner collect and reorganize material for personal use
- Assessment History is the single source of truth for all learner evaluation results and feeds Personalization and Progress; do not duplicate timelines across domains
- Content Taxonomy Depth: FSRS, Adaptive Practice, Gap Analysis, Learning Insights, and AI Error Analysis depend on highly detailed Colab tagging across band, micro-skill, question type, distractor, paraphrase, and grammar; see `05-content.md`
- AI Governance is the quality-control layer **designed** for the sole evaluator: confidence scoring, gold-standard benchmark, drift/bias monitoring, and anti-gaming detection, all invisible to the user and without reopening a human-in-the-loop path. These controls are not active when corpus/threshold/run evidence is missing; see `06-engines.md`

## Product success contract

### North Star

**Weekly Meaningful Progress** — the number of active learners each week with at least one piece of evidence of real progress: lower error recurrence, a better retest result, improved readiness, or stronger Writing/Speaking output.

### Metric tree

| Layer | Metric | Guardrail |
|---|---|---|
| Activation | complete placement or first meaningful session within 24 hours | do not force a long placement; allow quick start |
| Retention | D7/W4 retention, meaningful study days, comeback rate | notification opt-out; do not punish broken streaks |
| Learning | readiness lift, error recurrence, retest gain, skill balance | do not optimize only for minutes or number of questions |
| Trust/quality | calibration error, low-confidence rate, helpfulness, content report rate | low-confidence must have explicit state and recovery |
| Economics | cost/active learner, cost/evaluation, cache hit, model escalation rate | if budget is exceeded, degrade in a controlled way; never silently reduce quality |

### Retention promise

- Every return should answer: **where am I, what should I do today, and what will improve if I complete it?**
- Provide `5–10 minute` sessions for busy days, standard sessions for normal days, and deeper sessions when the learner has more energy.
- After an absence, create a short **comeback plan** rather than dumping the entire backlog or using blame-oriented language.
- Send notifications only when they provide clear value and respect preference, quiet hours, frequency caps, and priority.

### Quality promise

- Feedback must state evidence, strengths/errors, the next action, and how to verify improvement.
- Every score is associated with rubric version, model version, timestamp, and confidence state.
- Results in `invalid`, `low_confidence`, or `anti_gaming_review` state must not be fed into readiness as ordinary results.

### Cost principles

- Save cost where outcome quality is unaffected: cache explanations, batch tagging/analytics, precompute queues, and use smaller models for routing/classification.
- Use larger models only for tasks with direct impact on learning outcome or evaluation quality.
- Every request has a budget, quota, timeout, retry limit, observability, and fallback.

## Runtime contract boundary

The three contracts below are mandatory Blueprint inputs before build, but intentionally remain narrow and purpose-specific:

- **Runtime State Model** (`02-architecture.md`) determines Home, plan, recommendation, notification, and recovery from a multidimensional state vector.
- **Event Contract** (`03-features.md`) is the SSOT for product/learning facts, analytics, experimentation, and outcome measurement.
- **Failure Contract** (`06-engines.md`) defines retry, fallback, data safety, quota, user-facing state, and telemetry for every failure.

Role, UI clicks, or exception text must not be used as substitutes for these three contracts.
