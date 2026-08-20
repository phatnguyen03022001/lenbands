# 01 — Product

This file answers **WHY / WHO / WHAT**, not HOW (HOW belongs in `02-architecture.md` and later files).

## Vision

LenBands is an **evidence-first IELTS Learning OS** designed to help a learner:

- understand the IELTS performance target;
- know what is currently supported by real evidence rather than activity completion;
- identify the smallest useful gap to work on next;
- receive an appropriate intervention;
- prove improvement through independent retest, transfer, and maintenance evidence.

LenBands is not merely an LMS that stores lessons, a quiz app, or an AI wrapper around model APIs.

The durable product loop is:

```text
Target
  -> Evidence
  -> Gap / uncertainty
  -> Smallest useful intervention
  -> Independent practice
  -> Novel retest
  -> Transfer
  -> Readiness update
```

Model providers, prompts, scoring models, speech services, and recommendation implementations are replaceable mechanisms. They are never the source of curriculum truth, learner identity, readiness policy, entitlement, or canonical learner state.

## Target users

- IELTS learners from band 3.0 to 8.5
- Learners who want to know exactly where they are weak or under-measured and what to learn next
- Learners who need IELTS practice organized by module, skill, question type, target profile, and a concrete plan
- Learners whose need may be primarily English foundation, IELTS task technique, criterion-level precision, or a mixture of these

## Core value

- Model IELTS as a structured knowledge, performance, and assessment system
- Personalize learning paths by target profile, evidence, skill, question type, recurring error, uncertainty, and exam relevance
- Automate learner-facing Writing, Speaking, and Pronunciation evaluation without a runtime human dependency, under benchmarked scorer routes and governed evidence contracts
- Convert feedback into a traceable remediation loop rather than stopping at a score or explanation
- Use deterministic logic for product truth and routine decisions; use AI/speech models only where language, judgment, generation, transcription, or acoustic analysis materially requires them
- Colab adds, updates, reviews, moderates, and publishes content; it does not score learner work
- Admin manages the system, users, billing, release/governance controls, and access permissions; it does not score learner work or overwrite evaluation results

## Product positioning

**Evidence-first IELTS Learning OS** — not an LMS, quiz app, or AI-scoring wrapper.

The intended moat is the governed learner evidence loop:

```text
Evidence -> diagnosis -> intervention -> novel retest -> transfer -> readiness
```

A competitor using the same model provider must not automatically reproduce LenBands semantics, learner state, remediation mapping, or readiness behavior.

## Principles

1. **Evidence-first** — learning state and readiness come from governed evidence; activity completion, model confidence, card maturity, or repeated familiar-item success are not mastery by themselves.
2. **Deterministic-first** — rules, typed data, controlled vocabulary, retrieval, scoring keys, SQL aggregation, schedulers, and explicit policies are preferred whenever they can meet the required quality. AI is invoked only when deterministic mechanisms are insufficient for the user outcome.
3. **Automated evaluation + governance** — learner-facing evaluation is automated with no runtime human dependency. Scorer quality must be established through benchmark evidence, route gating, reproducibility, drift/bias monitoring, and rollback; automation itself is not evidence of correctness.
4. **AI is not a role or authority** — model/speech systems are implementation adapters. They do not own curriculum truth, authorization, entitlement, readiness policy, content publication, or canonical learner state.
5. **No-AI-label UI** — documentation may describe model-assisted capabilities so developers understand implementation origin; the learner UI uses functional language rather than provider/model branding. See `07-conventions.md`.
6. **Content taxonomy earns its cost** — a metadata field exists only when it changes a governed product decision such as diagnosis, recommendation, evaluation, review, search, or quality analysis. Shallow metadata can reduce quality, but unused metadata is operational waste. See `05-content.md`.
7. **SSOT** — each capability has exactly one capability ID and one canonical description in `03-features.md`; other spokes reference it rather than duplicating it.
8. **Progress over pressure** — retention is a consequence of real progress, not notification pressure, streak anxiety, or dark patterns.
9. **Outcome loop** — every meaningful error or weakness should move through `Understand -> Practice -> Retest -> Transfer` where the construct permits it; completing an activity alone is not an outcome.
10. **Quality/cost guardrail** — optimize for **cost per verified learner improvement**, not merely cost per request. Cost reduction is allowed only when it preserves the required quality, accessibility, privacy, and learner trust.

> **Evidence boundary:** automated evaluation and governance are product design decisions. Benchmark corpus, numeric thresholds, drift detector, and cost ceilings are not quality claims until governed evidence exists.

## Role Model

Web personas:

```text
Guest
  ↓
Learner
  + premium entitlement when active
```

Operational personas:

```text
Colab
  -> author/review/publish content within granted permissions

Admin
  -> users, configuration, billing, release/governance operations
```

Automated capabilities are **not personas**:

```text
Evaluation / speech / recommendation adapters
  -> produce typed observations, judgments, generated text, or features
  -> domain policy validates/adopts/rejects their output
```

### Role boundaries

- **Learner** studies, practices, takes tests, and owns their learning data within product policy
- **Premium Learner** is a learner with a premium entitlement; premium does not create a separate authorization hierarchy
- **Colab** manages content according to author/review/publish permissions; it never scores learner work or intervenes in evaluation results
- **Admin** operates accounts, configuration, billing, release gates, audit, and aggregate governance; it never manually changes a learner score
- **Internal service principals** receive the minimum scope required for one function such as evaluation, billing webhook processing, workflow execution, or content jobs; a generic service credential must not imply blanket domain access
- **AI/model providers** are not roles and have no business authority

## Scope

### In scope

- Learn IELTS by module, target profile, band-learning bucket, skill, and question type
- Model the four IELTS skills plus Pronunciation as one Learning domain, with explicit Learning / Practice / Evaluation / Review boundaries
- Evaluation: automated Writing/Speaking/Pronunciation assessment, including scoped band estimates, evidence, feedback, calibration, and consistency monitoring
- Coaching: answer/vocabulary/distractor explanation, listening/reading coach, feedback, error analysis, recommendation, and contextual IELTS Q&A
- Personalization: uncertainty-aware gap analysis, next best action, adaptive learning plan, weakness/evidence-based practice, and learning insights
- Review & revision: bookmark, mistake notebook, wrong-answer/question review, revision queue, FSRS spaced repetition for suitable retrievable units, and smart review queue
- Assessment history: attempts, scoped score/band/skill timelines, learning timeline, writing/speaking portfolio, compare attempts
- Progress & analytics: dashboard, learning/skill analytics, band progress, goal tracking, lightweight motivation, and evidence-centered progress
- Study orchestration: study session, daily plan, today's queue, continue/resume behavior
- System Knowledge Assets plus Personal Knowledge (personal notes, word bank, collections, drafts, recordings, import, export, offline where phased)
- Band framework & progression (readiness, exam readiness, soft recommendations)
- Target profile & exam plan: IELTS module, target overall, optional per-skill minima, target date, study capacity, purpose where useful, countdown/checklist/timeline according to phase
- Search & resource center
- Multilingual UI and model-assisted explanations; IELTS test content remains English
- Evaluation Governance: benchmark route gates, confidence/uncertainty policy, drift/bias monitoring, anti-gaming/integrity signals, audit and rollback
- Colab content workflow and learner content-feedback handling
- Admin system, user, billing, permission, release, and governance operations

### Out of scope

- Live classes
- Real-time 1:1 video calls
- Runtime human examiner dependency for learner-facing scoring
- Manual score overwrite by Colab/Admin
- Complex community forum
- Heavy game-style gamification such as leaderboards, badge hierarchies, or avatars
- Marketplace outside the scope of IELTS learning
- Treating a model provider, prompt, or agent as curriculum/readiness authority

### Scope notes

- Automated Writing/Speaking/Pronunciation evaluation must have an explicit `score_scope`; a task-level diagnostic estimate must never be presented as an official IELTS section or overall score.
- There is no human examiner in the learner-facing runtime transaction path. Examiner-rated or otherwise qualified reference data may be required offline for benchmark and calibration; this is evidence governance, not runtime human review.
- Re-evaluation creates a new governed result/version or status transition according to contract; Admin does not edit a numeric score in place.
- Speaking evaluation should preserve staged evidence provenance (audio quality, transcript/features, acoustic evidence where relevant, rubric judgment) rather than rely on one opaque black-box score.
- Pronunciation analysis uses an appropriate speech/acoustic mechanism when required; a general-purpose LLM must not be the sole phoneme/stress/intonation measurement mechanism.
- Colab only intervenes at the content layer, never at the evaluation layer.
- Admin operates the system and governance layer; it never becomes an examiner.
- The band framework and learner evidence model are core product IP and must not be treated as incidental metadata.
- Band progression does not hard-lock learning; the system recommends, warns, measures evidence, and preserves learner agency.
- Question type is a learning unit as important as a lesson when it materially affects performance.
- Multilingual behavior applies to interface and explanations; IELTS test stimuli/prompts remain authentic English.
- Assessment History is the single source of truth for learner evaluation results and feeds Personalization and Progress; duplicate score timelines must not become separate truths.
- AI/model-generated outputs are observations or candidate judgments until validated by the owning domain contract; they do not directly mutate readiness/mastery by authority of the model alone.

## Product success contract

### North Star

**Weekly Verified Progress** — active learners who produce at least one governed piece of evidence that supports meaningful improvement, such as lower error recurrence on independent items, a successful novel retest, stronger transfer evidence, reduced uncertainty, or improved scoped Writing/Speaking performance.

### Metric tree

| Layer | Metric | Guardrail |
|---|---|---|
| Activation | complete placement or first meaningful session within 24 hours | do not force a long placement; allow quick start |
| First value | time to first useful diagnosis/action/feedback | do not trade correctness for superficial speed |
| Retention | D7/W4 retention, meaningful study days, comeback quality | notification opt-out; do not punish broken streaks |
| Learning | independent retest gain, transfer evidence, error recurrence, readiness evidence coverage | do not optimize only minutes/questions/cards |
| Trust/quality | benchmark agreement, invalid/limited-evidence rate, helpfulness, content report rate | uncertainty must have explicit state and recovery |
| Economics | cost/active learner, cost/evaluation, **cost/verified improvement**, escalation rate | degrade optional depth before assessment integrity |

### Retention promise

- Every return should answer: **where am I, what should I do today, why this action, and what evidence would show improvement?**
- Provide `5–10 minute` sessions for busy days, standard sessions for normal days, and deeper sessions when useful.
- After an absence, create a short comeback plan rather than dumping backlog or using blame-oriented language.
- Notifications only exist when they provide clear learner value and respect preference, quiet hours, frequency caps, and priority.

### Quality promise

- Feedback states the evidence, meaning/criterion, one high-leverage action, and how to verify improvement.
- Every score stores rubric version, scorer route/model version, task version, timestamp, quality state, and evidence provenance required by the evaluation contract.
- Invalid, insufficient/limited-evidence, or integrity-review results do not feed readiness as ordinary accepted results.
- Learner-facing uncertainty uses calibrated language; raw model confidence percentages are not shown as scientific certainty without empirical validation.

### Cost principles

- Prefer deterministic computation when it meets the quality contract.
- Precompute reusable curriculum, exemplars, explanations, mappings, and batch analytics where freshness does not require runtime generation.
- Use small/cheap models for bounded classification/generation only when deterministic alternatives are insufficient.
- Use stronger/specialist models only for high-value or high-risk cases where benchmark evidence justifies the escalation.
- Keep model context minimal: send the task plus a compact relevant learner-state snapshot rather than unbounded history.
- Every provider request has a budget, quota, timeout, retry limit, observability, and explicit fallback/degraded state.
- Optimize total cost against verified learner outcomes; a cheap response that does not improve learning is still waste.

## Runtime contract boundary

The contracts below are mandatory Blueprint inputs before build but remain purpose-specific:

- **Runtime State Model** (`02-architecture.md`) determines Home, plan, recommendation, notification, evaluation and recovery from multidimensional state.
- **Event Contract** (`03-features.md`) is the SSOT for product/learning facts, analytics, experimentation, and outcome measurement.
- **Failure Contract** (`06-engines.md`) defines retry, fallback, data safety, quota, user-facing state, and telemetry for failure.
- **Intelligence Boundary** (`02-architecture.md` and `06-engines.md`) determines when deterministic logic is authoritative and when model/speech adapters may be invoked.

Role, UI clicks, provider responses, prompts, or exception text must not substitute for these contracts.
