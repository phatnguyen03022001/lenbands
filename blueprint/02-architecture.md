# 02 — Architecture

File này mô tả **kiến trúc hệ thống**: domain, capability layer, system boundary, skill modeling. **Không mô tả feature chi tiết** (feature chi tiết ở `03-features.md`). Đây là bản đồ để AI hiểu cấu trúc tổng thể trước khi đi sâu.

## Domain Map (23 domain)

### 1. Identity
Authentication, User Profile, Role-based Access, Account Status, Account Recovery, Data Privacy, Delete Account

### 2. Localization
Interface Language, Language Switcher, Locale Formatting, AI Response Language, Language Preference Sync

### 3. Goal Management
Target Band/Date, Weekly/Daily Goal, Study Plan, Exam Plan (Countdown, Checklist, Timeline, Time Management, Anxiety Tips)

### 4. Placement
Placement Test, Skill Diagnosis, Band Estimation, Gap Detection, Initial Learning Path

### 5. Learning
Skill Management (Listening/Reading/Writing/Speaking/Pronunciation), Learning Path, Question Types, và feature learning của từng skill. Mỗi skill có 4 layer: Learning / Practice / Evaluation / Review.

### 6. Knowledge Assets
Lesson, Grammar, Vocabulary, Collocation, Template, Strategy, Example, Exercise

### 7. Personal Knowledge (PKM)
Notes, Collections, Word Bank, Saved Items, Drafts, Recordings, Import, Export, Cross-device Sync, Offline

### 8. Practice
Exercise, Practice Set, Skill Drill, Question Type Drill, Timed Practice, Adaptive Practice, Mock Test, Exam Simulation

### 9. Evaluation
AI sole scorer cho Writing/Speaking/Pronunciation, Examiner, Band Prediction, Rewrite Suggestion, Calibration, Consistency Monitoring, Anti-Gaming Detection. (Chất lượng đảm bảo bởi domain #22.)

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
Dashboard, Learning/Skill Analytics, Band Progress, Goal Tracking, Motivation (Streak, Milestone, Comeback), Achievement (milestone nhẹ)

### 16. Search & Resource Center
Global Search, Knowledge Search, Question Search, Formula, Cheatsheet, Band Descriptor, Writing Sample, Speaking Sample

### 17. Subscription
Plan, Payment, Premium Access, Usage Limit

### 18. Content (Colab)
Lesson/Knowledge/Question Bank/Mock Test/Quiz Management, Tag Management, Publish Workflow, Content Moderation, Content Feedback

### 19. Administration
User/Role/Permission Management, System Setting, Dashboard, Audit Log, Moderation Log, Billing Management, Revenue Reporting, Governance Dashboard

### 20. Study Orchestration
Lớp orchestration giữa Goal (dài hạn) và Practice (câu hỏi), biến toàn bộ hệ thống thành hành động mỗi ngày — xương sống màn Home. Study Session, Session Summary, Daily Plan, Today's Queue, Continue on Another Device.

### 21. Notification
Study Reminder, Review Reminder, SRS Due, Result, Goal, Smart Delivery, Quiet Hours, Re-engagement và frequency cap.

### 22. AI Governance
Backend invisible kiểm soát chất lượng sole evaluator. Confidence Score, Gold-Standard Eval Benchmark, Drift/Bias Monitoring, Anti-Gaming Detection, Evaluation Audit Trail, Governance Dashboard.

### 23. Quality & Economics Operations
Cross-cutting layer bảo vệ outcome và ngân sách: Content Quality Gate, Evaluation Quality Gate, Release Gate, Outcome Measurement, Model Routing, Cost Budget, Quota, Observability.

## Technology Stack

Stack công nghệ cố định cho toàn bộ hệ thống. Mọi artifact sinh ra từ blueprint phải dùng stack này.

| Tầng | Công nghệ | Ghi chú |
|---|---|---|
| **Backend (BE)** | Go | API service, business logic, orchestration |
| **Engine / AI / Data** | Python | FSRS optimization, evaluation model, recommendation, governance pipeline, analytics |
| **Frontend (FE)** | Next.js | Web UI, SSR/SSG, học + admin + colab |
| **Mobile** | (định hướng) Next.js + PWA hoặc React Native | sync với FE; quyết định sau theo demand |

### Ranh giới giữa Go và Python

Go và Python có vai trò khác nhau — không thay thế nhau:

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
               │ gọi async / job / inference
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

**Quy tắc:**
- Go là **synchronous request path** (user-facing, low latency, high throughput).
- Python là **async/heavy inference path** (model chấm, calibration batch, analytics).
- Go gọi Python qua job queue bất đồng bộ; không gọi heavy inference đồng bộ trong request người dùng. HTTP/gRPC inference chỉ được dùng phía worker sau job boundary, không nằm trên learner request path.
- FSRS: runtime scoring có thể ở Go (binding) để low-latency; **optimization** (tune 19 tham số) ở Python.
- Database, cache, object storage là shared infra, không phụ thuộc ngôn ngữ.

### Build / Buy boundary

Blueprint chỉ khóa nguyên tắc ownership: LenBands tự sở hữu capability semantics, Error Graph, rubric/quality gate, recommendation policy, consent/retention và canonical event/failure semantics. Commodity infrastructure hoặc foundation capability có thể dùng managed/buy khi không làm mất các ownership trên.

Baseline decision, exit strategy và review trigger nằm ở `artifacts/business/decisions/build-buy-register.md`. Vendor cụ thể không phải Blueprint invariant.

### Ngữ cảnh triển khai Capability Layer

Ánh xạ Capability Layer (trên) sang tech stack:

- **Experience Layer (5)** → Next.js (FE).
- **Orchestration Layer (4)** → Go (BE).
- **Capability Layer (3)** → Go (BE), gọi Engine khi cần.
- **Engine Layer (2)** → Python; FSRS runtime + scoring có thể Go binding.
- **Knowledge & Content Layer (1)** → Go (BE) + DB; content authoring UI (Colab) là Next.js.

### Cross-cutting infra (không phụ thuộc ngôn ngữ)

- **Database**: Postgres (primary), Redis (cache + queue + rate limit).
- **Object storage**: S3-compatible (audio, image, export file).
- **Queue / job P0**: Redis Streams consumer groups (Go → Python jobs). Kafka chỉ là phương án future khi throughput, retention hoặc nhiều consumer độc lập vượt ngưỡng đã đo; không phải lựa chọn ngang hàng ở P0.
- **Search**: Postgres FTS ở MVP, Elasticsearch/Meilisearch khi scale.
- **Observability**: OpenTelemetry → Grafana/Datadog.
- **CI/CD**: GitHub Actions, container registry, IaC (Terraform).

### Runtime reliability invariants (P0)

- Delivery có thể **at-least-once**; mọi side effect learner-visible phải idempotent. Không hứa "exactly once" qua queue.
- Một write domain + yêu cầu enqueue phải đi qua transactional outbox hoặc reconciliation tương đương; không được commit submission rồi âm thầm mất evaluation job.
- Worker chỉ ack job sau khi durable state/effect đã được ghi. Job timeout/worker chết phải reclaim được mà không tạo evaluation, review card hoặc charge trùng.
- Cache không là source of truth, không được chia sẻ private learner data qua user boundary và không được làm mất behavior khi cache unavailable.
- API public/internal phải versioned, authenticated, có correlation ID, idempotency ở mutation và error envelope user-safe.
- Mọi retry có max attempts, backoff, deadline, cost attribution và đường DLQ/replay; không có retry vô hạn.

## Capability Layer

Hệ thống chia thành 5 layer capability, từ dưới lên trên:

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

- Layer dưới cung cấp nền cho layer trên.
- Experience Layer (cùng) chỉ orchestrate các capability, không chứa capability mới.
- Engine Layer là implementation của capability (FSRS implement Review, Evaluation model implement EVAL.*).
- Quality & Economics Operations là guardrail chạy ngang qua content, engines, experience và roadmap; không tạo thêm learner-facing feature nếu không cần.

## IELTS Skill Modeling

Mỗi skill (Listening / Reading / Writing / Speaking / Pronunciation) được mô hình hóa theo **4 layer bên trong skill**:

```text
Skill (vd: Reading)
  ├── Learning   — công cụ học (passage reader, highlight, annotation...)
  ├── Practice   — dạng bài (Matching Headings, T/F/NG, Multiple Choice...)
  ├── Evaluation — chấm và feedback (Reading Coach, Answer Explanation)
  └── Review     — xử lý sai và ôn lại (Wrong Question Review, add to Mistake Notebook)
```

Pronunciation là skill phụ trợ của Speaking nhưng tách riêng vì có cơ chế feedback riêng (phoneme, stress, intonation).

## Runtime State Model

Learner state là **state vector đa trục**, không phải một state machine tuyến tính. Một learner có thể vừa `learning`, vừa `inactive`, hoặc đã `exam_ready` nhưng đang ở một session bị pause.

```text
Learner State
├── Lifecycle      New → Diagnosed → Active ↔ Inactive → Reactivated
├── Learning       NotStarted → Learning → Practicing → Reviewing → Ready
├── Session        None → Active → Paused → Completed / Abandoned
├── Evaluation     None → Submitted → Processing → Scored / LowConfidence / Invalid / AntiGamingReview / Failed
└── Goal           NoGoal → GoalSet → OnTrack / AtRisk → Achieved / Expired
```

### State definitions

| Trục | State | Ý nghĩa / tác động |
|---|---|---|
| Lifecycle | `new` | Chưa có placement hoặc meaningful session; Home ưu tiên activation |
| Lifecycle | `diagnosed` | Có baseline band/gap; hệ thống có thể tạo path |
| Lifecycle | `active` | Có meaningful activity trong cửa sổ retention hiện tại |
| Lifecycle | `inactive` | Không có meaningful activity sau threshold; không đồng nghĩa thất bại |
| Lifecycle | `reactivated` | Quay lại sau inactive; dùng comeback plan ngắn |
| Learning | `not_started`, `learning`, `practicing`, `reviewing`, `ready` | Mức độ tiến triển theo skill/goal; có thể tồn tại đồng thời cho nhiều skill |
| Session | `none`, `active`, `paused`, `completed`, `abandoned` | Trạng thái phiên hiện tại và recovery path |
| Evaluation | `none`, `submitted`, `processing`, `scored`, `low_confidence`, `invalid`, `anti_gaming_review`, `failed` | Quyết định UI, history, readiness và retry |
| Goal | `no_goal`, `goal_set`, `on_track`, `at_risk`, `achieved`, `expired` | Điều chỉnh plan và notification, không dùng để gây guilt |

### State invariants

- `scored` chỉ được feed vào readiness/recommendation khi result không có `invalid` hoặc `anti_gaming_review` flag.
- `inactive` không xóa progress, không reset streak bắt buộc và không tạo backlog mới.
- `paused` phải có checkpoint; `abandoned` chỉ được ghi sau timeout/recovery policy rõ ràng.
- `reactivated` phải đi qua một `comeback_plan_started` event trước khi gửi re-engagement tiếp theo.
- State transition phải idempotent, có timestamp, actor/source và audit trail.

### State-driven surfaces

Home, Today's Queue, recommendation, notification và progressive disclosure đọc state vector này; role không được dùng thay cho learner state. Mỗi transition phải map tới event contract ở `03-features.md` và failure contract ở `06-engines.md`.

## Runtime Entity Ownership

Runtime entity có đúng một canonical owner, privacy class và lifecycle. Đây là ranh giới bắt buộc trước khi tạo Data Contract trong Artifact.

| Entity family | Canonical owner | Writer chính | Reader scope | Privacy class | Lifecycle |
|---|---|---|---|---|---|
| Account, goal, preference | Learner | Learner / Identity service | Chủ sở hữu | account | account lifetime / deletion policy |
| Draft, essay, recording | Learner | Learner / session service | Chủ sở hữu | learning / audio | draft → submitted → retained/deleted |
| Attempt, evaluation, feedback | System cho learner | Evaluation engine | Chủ sở hữu + aggregate governance | assessment | submitted → scored/failed → retention policy |
| Learning error, notebook, review card | Learner | Review/Evaluation engine + learner action | Chủ sở hữu | learning | open → review → improved/dismissed |
| Published taxonomy/configuration | System | Content workflow | Learner read-only | system | versioned publish lifecycle |
| Billing/quota | System | Billing service | Chủ sở hữu + finance aggregate | billing | legal/financial retention policy |
| Event/audit record | System | Producer service | Authorized operations only | derived privacy class | immutable + retention policy |

Quy tắc:

- Owner không đồng nghĩa với writer duy nhất; writer phải có permission rõ.
- Learner runtime data không được biến thành Artifact hoặc Knowledge Asset.
- Aggregate governance chỉ đọc dữ liệu tối thiểu cần thiết; raw essay/audio không vào analytics mặc định.
- Artifact Data Contract phải reference entity family, privacy class, retention policy và migration strategy.

## Permission Boundary

| Role | Learner data | Published knowledge/config | Evaluation result | Governance/audit |
|---|---|---|---|---|
| Guest | Không có personal data | Preview theo policy | Không có | Không có |
| Learner | Đọc/ghi dữ liệu của mình | Read | Đọc kết quả của mình, gửi feedback | Không có |
| Collaborator | Không truy cập mặc định | Draft/create theo scope | Không xem dữ liệu learner | Không có |
| Admin | Không đọc raw learner data mặc định | Quản trị theo permission | Chỉ aggregate/exception theo policy | Read aggregate/audit scope |
| System service | Least privilege | Theo service scope | Theo service scope | Theo service scope |

Mỗi API/Data Contract phải khai báo role, resource owner và data scope; không dùng role name đơn lẻ thay cho permission.

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
        - Không chấm        - Anti-gaming         - Không override
```

**Ranh giới cứng:**
- Colab → chỉ content, không evaluation
- Admin → chỉ system, không evaluation, không override AI result
- Human → không tồn tại trong evaluation flow

## Dependency

Sự phụ thuộc giữa các domain chính (rút gọn, dependency đầy đủ ở `03-features.md`):

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

- Personalization đọc từ Assessment History + Review để sinh Insights/NextBestAction.
- Engines cung cấp thuật toán cho Evaluation, Review (FSRS), Coaching.
- Colab publish → Knowledge Assets → Learning/Practice tiêu thụ.
- Quality gate → chỉ release content/model khi đạt chuẩn outcome, safety, accessibility và cost.
- Cost budget → route request theo value/risk, cache hoặc batch khi có thể; không dùng chi phí làm lý do âm thầm hạ chất lượng.

## Reading order gợi ý

1. Đọc Domain Map (trên) để thấy toàn cảnh.
2. Đọc Capability Layer để hiểu phân tầng.
3. Sang `03-features.md` để xem capability id chi tiết.
4. Sang `06-engines.md` để xem implementation của FSRS/Evaluation/Governance.
