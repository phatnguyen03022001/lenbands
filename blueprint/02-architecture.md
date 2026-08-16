# 02 — Architecture

This file describes the **system architecture**: domains, capability layers, system boundaries, and skill modeling. It **does not describe detailed features** (feature details are in `03-features.md`). It is the map agents read to understand the overall structure before going deeper.

## Domain Map (23 domains)

### 1. Identity
Authentication, User Profile, Role-based Access, Account Status, Account Recovery, Data Privacy, Delete Account

### 2. Localization
Interface Language, Language Switcher, Locale Formatting, AI Response Language, Language Preference Sync

### 3. Goal Management
Target Band/Date, Weekly/Daily Goal, Study Plan, Exam Plan (Countdown, Checklist, Timeline, Time Management, Anxiety Tips)

### 4. Placement
Placement Test, Skill Diagnosis, Band Estimation, Gap Detection, Initial Learning Path

### 5. Learning
Skill Management (Listening/Reading/Writing/Speaking/Pronunciation), Learning Path, Question Types, and learning features for each skill. Every skill has four layers: Learning / Practice / Evaluation / Review.

### 6. Knowledge Assets
Lesson, Grammar, Vocabulary, Collocation, Template, Strategy, Example, Exercise

### 7. Personal Knowledge (PKM)
Notes, Collections, Word Bank, Saved Items, Drafts, Recordings, Import, Export, Cross-device Sync, Offline

### 8. Practice
Exercise, Practice Set, Skill Drill, Question Type Drill, Timed Practice, Adaptive Practice, Mock Test, Exam Simulation

### 9. Evaluation
AI is the sole scorer for Writing/Speaking/Pronunciation, Examiner, Band Prediction, Rewrite Suggestion, Calibration, Consistency Monitoring, and Anti-Gaming Detection. Quality is controlled by domain #22.

### 10. Coaching
Answer/Vocabulary/Distractor Explanation, Listening/Reading Coach, Feedback, Error Analysis, Recommendation, IELTS Q&A Tutor (context-aware)

### 11. Personalization
Recommendation Engine, Next Best Action, Adaptive Learning Plan, Weakness-based Practice, Goal-based Recommendation, Gap Analysis, Learning Insights

### 12. Band Framework & Progression
Band Descriptor, Requirement, Checklist, Current/Target Band, Band Completion, Readiness Score, Recommended Next Band, Progression Warning, Exam Readiness

### 13. Review & Revision
Bookmark, Mistake Notebook, Wrong Answer/Question Review, Question Review, Review Explanation, Revision Queue, Smart Review Queue, Learning History, Spaced Repetition (FSRS engine)

### 14. Assessment History
All Attempts, Score Timeline, Band Timeline, Skill Timeline, Learning Timeline (events), Writing Portfolio, Speaking Portfolio, Compare Attempts

### 15. Progress & Analytics
Dashboard, Learning/Skill Analytics, Band Progress, Goal Tracking, Motivation (Streak, Milestone, Comeback), Achievement (lightweight milestones)

### 16. Search & Resource Center
Global Search, Knowledge Search, Question Search, Formula, Cheatsheet, Band Descriptor, Writing Sample, Speaking Sample

### 17. Subscription
Plan, Payment, Premium Access, Usage Limit

### 18. Content (Colab)
Lesson/Knowledge/Question Bank/Mock Test/Quiz Management, Tag Management, Publish Workflow, Content Moderation, Content Feedback

### 19. Administration
User/Role/Permission Management, System Setting, Dashboard, Audit Log, Moderation Log, Billing Management, Revenue Reporting, Governance Dashboard

### 20. Study Orchestration
The orchestration layer between Goal (long-term) and Practice (questions), turning the system into concrete daily actions — the backbone of Home. Study Session, Session Summary, Daily Plan, Today's Queue, Continue on Another Device.

### 21. Notification
Study Reminder, Review Reminder, SRS Due, Result, Goal, Smart Delivery, Quiet Hours, Re-engagement, and frequency caps.

### 22. AI Governance
Invisible backend controls for sole-evaluator quality. Confidence Score, Gold-Standard Eval Benchmark, Drift/Bias Monitoring, Anti-Gaming Detection, Evaluation Audit Trail, Governance Dashboard.

### 23. Quality & Economics Operations
A cross-cutting layer that protects outcomes and budget: Content Quality Gate, Evaluation Quality Gate, Release Gate, Outcome Measurement, Model Routing, Cost Budget, Quota, Observability.

## Technology Stack

The technology stack is fixed for the entire system. Every artifact generated from the Blueprint must use this stack.

| Layer | Technology | Notes |
|---|---|---|
| **Backend (BE)** | Go | API service, business logic, orchestration |
| **Engine / AI / Data** | Python | FSRS optimization, evaluation model, recommendation, governance pipeline, analytics |
| **Frontend (FE)** | Next.js | Web UI, SSR/SSG, learner + admin + colab |
| **Mobile** | Future direction: Next.js + PWA or React Native | Sync with FE; decide later based on demand |

### Boundary between Go and Python

Go and Python serve different roles and do not replace one another:

```text
┌─────────────────────────────────────┐
│  Next.js (FE)                        │
└──────────────┬──────────────────────┘
               │ HTTP/gRPC
               ▼
┌─────────────────────────────────────┐
│  Go (Backend)                        │
│  - API gateway, auth, user, billing  │
│  - Orchestrator (STUDY.*, GOAL.*)    │
│  - Content serving, PKM, search      │
│  - FSRS runtime (Go binding)         │
│  - Quota, cache, rate limit          │
└──────────────┬──────────────────────┘
               │ async / job / inference calls
               ▼
┌─────────────────────────────────────┐
│  Python (Engine / AI / Data)         │
│  - EVAL.* models (writing/speaking/  │
│    pronunciation)                    │
│  - GOVERNANCE.* (calibration,        │
│    benchmark, drift, anti-gaming)    │
│  - PERSONAL.* (insights, recommend)  │
│  - FSRS optimization (per learner)   │
│  - Analytics, outcome measurement    │
└─────────────────────────────────────┘
```

**Rules:**
- Go owns the **synchronous request path** (user-facing, low latency, high throughput).
- Python owns the **async/heavy inference path** (model scoring, calibration batches, analytics).
- Go calls Python through an asynchronous job queue; heavy inference must not execute synchronously inside a learner request. HTTP/gRPC inference is allowed only behind the worker/job boundary, never on the learner request path.
- FSRS runtime scoring may use a Go binding for low latency; **optimization** (tuning 19 parameters) runs in Python.
- Database, cache, and object storage are shared infrastructure and are language-independent.

### Build / Buy boundary

The Blueprint fixes ownership principles only: LenBands owns capability semantics, the Error Graph, rubric/quality gates, recommendation policy, consent/retention, and canonical event/failure semantics. Commodity infrastructure or foundation capabilities may be managed/bought when doing so does not surrender that ownership.

The baseline decision, exit strategy, and review triggers live in `artifacts/business/decisions/build-buy-register.md`. Specific vendors are not Blueprint invariants.

### Capability Layer implementation context

Map the Capability Layers below onto the technology stack as follows:

- **Experience Layer (5)** → Next.js (FE).
- **Orchestration Layer (4)** → Go (BE).
- **Capability Layer (3)** → Go (BE), calling an Engine when required.
- **Engine Layer (2)** → Python; FSRS runtime + scoring may use Go bindings.
- **Knowledge & Content Layer (1)** → Go (BE) + DB; content-authoring UI (Colab) is Next.js.

### Cross-cutting infrastructure

- **Database**: Postgres (primary), Redis (cache + queue + rate limit).
- **Object storage**: S3-compatible (audio, image, export file).
- **Queue / job P0**: Redis Streams consumer groups (Go → Python jobs). Kafka is a future option only when measured throughput, retention, or independent-consumer requirements exceed the threshold; it is not a peer choice in P0.
- **Search**: Postgres FTS at MVP, Elasticsearch/Meilisearch when scale requires it.
- **Observability**: OpenTelemetry → Grafana/Datadog.
- **CI/CD**: GitHub Actions, container registry, IaC (Terraform).

### Runtime reliability invariants (P0)

- Delivery may be **at-least-once**; every learner-visible side effect must be idempotent. Do not promise "exactly once" across the queue.
- A domain write plus an enqueue requirement must use a transactional outbox or equivalent reconciliation; never commit a submission and silently lose its evaluation job.
- A worker acknowledges a job only after durable state/effect has been written. Job timeout or worker death must be reclaimable without duplicate evaluations, review cards, or charges.
- Cache is never a source of truth, must never share private learner data across user boundaries, and cache unavailability must not destroy system behavior.
- Public/internal APIs must be versioned and authenticated, include correlation IDs and mutation idempotency, and return user-safe error envelopes.
- Every retry has max attempts, backoff, deadline, cost attribution, and a DLQ/replay path; infinite retry is prohibited.

## Capability Layer

The system has five capability layers, from foundation to experience:

```text
┌─────────────────────────────────────────────┐
│ 5. Experience Layer                          │  ← Home, Journey, Delight
│   (04-experience.md)                         │
├─────────────────────────────────────────────┤
│ 4. Orchestration Layer                       │  ← Study Session, Daily Plan
│   Study Orchestration                        │
├─────────────────────────────────────────────┤
│ 3. Capability Layer (domain feature)         │  ← Learning, Practice, Evaluation,
│   Learning / Practice / Evaluation /         │    Coaching, Review, PKM, Search
│   Coaching / Review / PKM / Search           │
├─────────────────────────────────────────────┤
│ 2. Engine Layer                              │  ← FSRS, Evaluation model,
│   FSRS / Evaluation / Recommendation /       │    Recommendation, Governance,
│   Governance / Quality / Cost                │    Quality & Cost controls
│   (06-engines.md)                            │
├─────────────────────────────────────────────┤
│ 1. Knowledge & Content Layer                 │  ← Knowledge Assets, Taxonomy,
│   Knowledge Assets / Taxonomy /              │    Question Bank (05-content.md)
│   Question Bank (05-content.md)              │
└─────────────────────────────────────────────┘
```

- Lower layers provide foundations for upper layers.
- The Experience Layer only orchestrates existing capabilities; it does not invent new capabilities.
- The Engine Layer implements capabilities (FSRS implements Review; the Evaluation model implements `EVAL.*`).
- Quality & Economics Operations is a guardrail across content, engines, experience, and roadmap; it does not create extra learner-facing features unless they add an outcome.

## IELTS Skill Modeling

Each skill (Listening / Reading / Writing / Speaking / Pronunciation) is modeled with **four internal layers**:

```text
Skill (e.g. Reading)
  ├── Learning   — learning tools (passage reader, highlight, annotation...)
  ├── Practice   — question types (Matching Headings, T/F/NG, Multiple Choice...)
  ├── Evaluation — scoring and feedback (Reading Coach, Answer Explanation)
  └── Review     — error correction and review (Wrong Question Review, add to Mistake Notebook)
```

Pronunciation supports Speaking but is separated because it has its own feedback mechanisms (phoneme, stress, intonation).

## Runtime State Model

Learner state is a **multidimensional state vector**, not a linear state machine. A learner can be `learning` while also `inactive`, or be `exam_ready` while the current session is paused.

```text
Learner State
├── Lifecycle      New → Diagnosed → Active ↔ Inactive → Reactivated
├── Learning       NotStarted → Learning → Practicing → Reviewing → Ready
├── Session        None → Active → Paused → Completed / Abandoned
├── Evaluation     None → Submitted → Processing → Scored / LowConfidence / Invalid / AntiGamingReview / Failed
└── Goal           NoGoal → GoalSet → OnTrack / AtRisk → Achieved / Expired
```

### State definitions

| Axis | State | Meaning / effect |
|---|---|---|
| Lifecycle | `new` | No placement or meaningful session yet; Home prioritizes activation |
| Lifecycle | `diagnosed` | Baseline band/gap exists; the system can create a path |
| Lifecycle | `active` | Meaningful activity exists in the current retention window |
| Lifecycle | `inactive` | No meaningful activity after the threshold; this does not mean failure |
| Lifecycle | `reactivated` | Returned after inactivity; use a short comeback plan |
| Learning | `not_started`, `learning`, `practicing`, `reviewing`, `ready` | Progress state by skill/goal; multiple skills can have different states simultaneously |
| Session | `none`, `active`, `paused`, `completed`, `abandoned` | Current session state and recovery path |
| Evaluation | `none`, `submitted`, `processing`, `scored`, `low_confidence`, `invalid`, `anti_gaming_review`, `failed` | Drives UI, history, readiness, and retry behavior |
| Goal | `no_goal`, `goal_set`, `on_track`, `at_risk`, `achieved`, `expired` | Adjusts plan and notification behavior without guilt mechanics |

### State invariants

- `scored` feeds readiness/recommendation only when the result does not carry an `invalid` or `anti_gaming_review` flag.
- `inactive` does not erase progress, forcibly reset streaks, or create a new backlog.
- `paused` requires a checkpoint; `abandoned` is recorded only after an explicit timeout/recovery policy.
- `reactivated` must pass through a `comeback_plan_started` event before further re-engagement messages are sent.
- State transitions must be idempotent and include timestamp, actor/source, and audit trail.

### State-driven surfaces

Home, Today's Queue, recommendations, notifications, and progressive disclosure read this state vector; role must not substitute for learner state. Every transition maps to the event contract in `03-features.md` and the failure contract in `06-engines.md`.

## Runtime Entity Ownership

Every runtime entity has exactly one canonical owner, privacy class, and lifecycle. This boundary is mandatory before creating an Artifact Data Contract.

| Entity family | Canonical owner | Primary writer | Reader scope | Privacy class | Lifecycle |
|---|---|---|---|---|---|
| Account, goal, preference | Learner | Learner / Identity service | Owner | account | account lifetime / deletion policy |
| Draft, essay, recording | Learner | Learner / session service | Owner | learning / audio | draft → submitted → retained/deleted |
| Attempt, evaluation, feedback | System for learner | Evaluation engine | Owner + aggregate governance | assessment | submitted → scored/failed → retention policy |
| Learning error, notebook, review card | Learner | Review/Evaluation engine + learner action | Owner | learning | open → review → improved/dismissed |
| Published taxonomy/configuration | System | Content workflow | Learner read-only | system | versioned publish lifecycle |
| Billing/quota | System | Billing service | Owner + finance aggregate | billing | legal/financial retention policy |
| Event/audit record | System | Producer service | Authorized operations only | derived privacy class | immutable + retention policy |

Rules:

- Owner does not mean sole writer; every writer must have explicit permission.
- Learner runtime data must never become an Artifact or Knowledge Asset.
- Aggregate governance reads only the minimum data required; raw essays/audio do not enter analytics by default.
- Artifact Data Contracts must reference entity family, privacy class, retention policy, and migration strategy.

## Permission Boundary

| Role | Learner data | Published knowledge/config | Evaluation result | Governance/audit |
|---|---|---|---|---|
| Guest | No personal data | Preview according to policy | None | None |
| Learner | Read/write own data | Read | Read own results, submit feedback | None |
| Collaborator | No access by default | Draft/create within scope | Cannot view learner data | None |
| Admin | Does not read raw learner data by default | Administer according to permission | Aggregate/exception only according to policy | Read aggregate/audit scope |
| System service | Least privilege | According to service scope | According to service scope | According to service scope |

Every API/Data Contract must declare role, resource owner, and data scope; a role name alone must never substitute for permission.

## System Boundary

```text
                    ┌──────────────────────────────┐
   Learner ────────►│   Experience Layer           │
                    │   (Home, Journey)            │
                    └──────────────┬───────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │   System Boundary            │
                    │   ─────────────              │
                    │   AI sole evaluator          │
                    │   No human-in-the-loop       │
                    │   No human examiner/reviewer │
                    └──────────────┬───────────────┘
                                   │
              ┌────────────────────┼────────────────────┐
              ▼                    ▼                    ▼
        Colab (content)     AI Governance         Admin (system)
        - Publish           - invisible           - User/Billing
        - Moderation        - Calibration         - Audit
        - No scoring        - Anti-gaming         - No override
```

**Hard boundaries:**
- Colab → content only, no evaluation
- Admin → system only, no evaluation, no AI-result override
- Human → does not exist in the evaluation flow

## Dependency

High-level domain dependencies (abbreviated; complete dependency definitions are in `03-features.md`):

```text
Identity ──► Goal ──► Placement ──► Learning ──┐
                                               │
Knowledge Assets ◄─── Colab ──► Content ───────┤
                                               │
                              Engines ─────────┤
                              (FSRS/Eval/      │
                               Governance)     │
                                               ▼
                                     Study Orchestration
                                               │
                                               ▼
                                  Assessment History ──► Progress
                                               │
                                               ▼
                                     Personalization
                                     (Insights/NextBestAction)
```

- Personalization reads Assessment History + Review to generate Insights/NextBestAction.
- Engines provide algorithms for Evaluation, Review (FSRS), and Coaching.
- Colab publishes → Knowledge Assets → Learning/Practice consumes them.
- Quality gates release content/models only when outcome, safety, accessibility, and cost requirements are met.
- Cost budgets route requests by value/risk and use cache or batching where appropriate; cost must never become a reason to silently lower quality.

## Suggested reading order

1. Read the Domain Map above for the system overview.
2. Read the Capability Layer to understand layering.
3. Continue to `03-features.md` for detailed capability IDs.
4. Continue to `06-engines.md` for FSRS/Evaluation/Governance implementation contracts.
