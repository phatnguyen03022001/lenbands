# 03 — Features (Capability Catalog)

Đây là **Capability Catalog** — danh sách năng lực hệ thống với capability id duy nhất. Mỗi năng lực mô tả **có gì**, không mô tả cảm xúc (cảm xúc ở `04-experience.md`) hay thuật toán (thuật toán ở `06-engines.md`). Architecture/context ở `02-architecture.md`.

## Quy ước

- Mỗi capability có `id` duy nhất dạng `{DOMAIN}.{Capability}`.
- `04-experience.md` và `06-engines.md` tham chiếu bằng id, không lặp mô tả.
- UI label theo `07-conventions.md` (không chữ AI, không icon AI).

---

## Learner Features

### Identity (IDENTITY)

| id | Capability |
|---|---|
| `IDENTITY.Auth` | Đăng ký / đăng nhập / phân quyền |
| `IDENTITY.Profile` | Hồ sơ, ngôn ngữ ưu tiên, target band/date, weekly/daily goal, tiến độ |
| `IDENTITY.Recovery` | Forgot Password, Email Verification, Change Email |
| `IDENTITY.Privacy` | Export Data, Delete Data, Consent, AI Data Usage |
| `IDENTITY.DeleteAccount` | Xóa tài khoản |

### Localization (LOC)

| id | Capability |
|---|---|
| `LOC.InterfaceLanguage` | Ngôn ngữ giao diện (mặc định Tiếng Việt) |
| `LOC.Switcher` | Language switcher |
| `LOC.LocaleFormat` | Định dạng ngày/giờ/số |
| `LOC.AIResponseLanguage` | AI trả lời theo ngôn ngữ user chọn |
| `LOC.PreferenceSync` | Sync ngôn ngữ across devices |

> Nội dung IELTS luôn giữ tiếng Anh nguyên bản, không dịch.

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
| `PLACE.Test` | Kiểm tra đầu vào |
| `PLACE.SkillDiagnosis` | Đánh giá từng kỹ năng |
| `PLACE.BandEstimation` | Đánh giá band tổng quan |
| `PLACE.GapDetection` | Phát hiện gap ban đầu |
| `PLACE.InitialPath` | Gợi ý lộ trình ban đầu |

### Learning (LEARN)

Mỗi skill có 4 layer: Learning / Practice / Evaluation / Review. Evaluation/Review của skill nằm ở domain EVAL/REVIEW (xem dưới), đây chỉ liệt kê Learning + Practice layer.

| id | Capability |
|---|---|
| `LEARN.Path` | Lộ trình theo band / kỹ năng / dạng bài, Next Best Lesson, Learning Milestone |
| `LEARN.QuestionTypes` | Question/task types cho 4 kỹ năng IELTS; pronunciation dùng practice units hỗ trợ Speaking |
| `LEARN.Listening` | Audio Player, Transcript, Replay, Playback Speed, Section Practice, Keyword Highlight, Dictation, Shadowing |
| `LEARN.Reading` | Passage Reader, Paragraph Navigation, Highlight, Underline, Annotation, Vocabulary Lookup, Bookmark Paragraph |
| `LEARN.Writing` | Workspace (Word Count, Task Timer, Auto-save), Draft History |
| `LEARN.Speaking` | Part 1/2/3 Simulation, Cue Card, Timer, Recording, Transcript |
| `LEARN.Pronunciation` | Phoneme Recognition, Intonation, Word/Sentence Stress, Drill, Side-by-side Audio Comparison |

### Knowledge Assets (KA)

| id | Capability |
|---|---|
| `KA.Lesson`, `KA.Grammar`, `KA.Vocabulary`, `KA.Collocation`, `KA.Template`, `KA.Strategy`, `KA.Example`, `KA.Exercise` | Tri thức hệ thống do Colab publish |

> Cấu trúc chi tiết + taxonomy ở `05-content.md`.

### Personal Knowledge / PKM (PKM)

| id | Capability |
|---|---|
| `PKM.Notes` | Notes cá nhân (viết tự do, không gắn cứng passage) |
| `PKM.Collections` | Gộp theo chủ đề |
| `PKM.WordBank` | Từ vựng user tự thu thập |
| `PKM.SavedItems` | Bookmark (question, passage, lesson, vocab, cue card) |
| `PKM.Drafts` | Bài viết lưu |
| `PKM.Recordings` | Bản ghi âm lưu |
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

AI sole scorer, chấm 100%, không human-in-the-loop. Tên UI không dùng chữ AI (`07-conventions.md`). Chất lượng được **thiết kế để kiểm soát** bởi `GOVERNANCE.*`; không claim calibrated khi evidence gate chưa pass.

| id | Capability | Ghi chú |
|---|---|---|
| `EVAL.Writing` | Writing Evaluation | sole scorer |
| `EVAL.Speaking` | Speaking Evaluation | sole scorer |
| `EVAL.Pronunciation` | Pronunciation Evaluation (phoneme, stress, intonation, mispronunciation) | sole scorer |
| `EVAL.Examiner` | Examiner — interactive dialogue Part 1/2/3, follow-up generation | sole scorer |
| `EVAL.BandPrediction` | Band Prediction | |
| `EVAL.RewriteSuggestion` | Rewrite Suggestion (sentence-level feedback, scorecard) | |
| `EVAL.AntiGaming` | Deprecated alias; identity giữ để tương thích, implementation canonical là `GOVERNANCE.AntiGaming` |

### Coaching (COACH)

| id | Capability |
|---|---|
| `COACH.AnswerExplanation` | Giải thích đáp án (Listening/Reading) |
| `COACH.VocabularyExplanation` | Giải thích từ vựng |
| `COACH.DistractorExplanation` | Giải thích bẫy distractor |
| `COACH.ListeningCoach` | Listening Coach |
| `COACH.ReadingCoach` | Reading Coach |
| `COACH.Feedback` | Feedback chung |
| `COACH.ErrorAnalysis` | Phân tích lỗi |
| `COACH.Recommendation` | Đề xuất cải thiện |
| `COACH.Tutor` | IELTS Q&A, context-aware (biết user đang ở passage/question/skill nào → trả lời trong ngữ cảnh) |

### Personalization (PERSONAL)

| id | Capability |
|---|---|
| `PERSONAL.Recommendation` | Recommendation Engine |
| `PERSONAL.NextBestAction` | Next Best Action |
| `PERSONAL.AdaptivePlan` | Adaptive Learning Plan |
| `PERSONAL.WeaknessPractice` | Weakness-based Practice |
| `PERSONAL.GoalRecommendation` | Goal-based Recommendation |
| `PERSONAL.GapAnalysis` | Gap Analysis |
| `PERSONAL.Insights` | Learning Insights — AI giải thích vì sao yếu ("bạn luôn sai Matching Headings vì thiếu paraphrase", "bạn mất điểm Task Response không phải Grammar") |

### Band Framework & Progression (BAND)

| id | Capability |
|---|---|
| `BAND.Descriptor` | Band Descriptor chính thức (reference IELTS rubric) |
| `BAND.Requirement` | Yêu cầu theo band (grammar points, question types, vocab count/topic, micro-skills) — data layer, feed `BAND.Map` |
| `BAND.Checklist` | Checklist theo band (cross-skill) — data layer, feed `BAND.Map` |
| `BAND.Map` | **Band Map** — render learner-facing "toàn cảnh còn thiếu gì để lên band X": per-skill completion, question types đạt/chưa, micro-skills, grammar points, vocab count theo topic. Mặt đối xứng của Today (zoom-out). |
| `BAND.Current`, `BAND.Target` | Current / Target Band |
| `BAND.Completion` | Band Completion (per-skill %, aggregate) |
| `BAND.Readiness` | Band Readiness Score |
| `BAND.RecommendedNext` | Recommended Next Band, Recommended Access |
| `BAND.ProgressionWarning` | Progression Warning |
| `BAND.ExamReadiness` | Exam Readiness (Overall / per-skill readiness, Confidence, Risk — "bạn đã sẵn sàng thi chưa?") |

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
| `REVIEW.FSRS` | Spaced Repetition engine (chi tiết `06-engines.md`) |

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
| `PROGRESS.Achievement` | Achievement (Band X Ready, 100 Reviews, 30-day Streak — milestone nhẹ, không leaderboard/XP/avatar) |
| `PROGRESS.WeeklyRecap` | Recap tiến bộ theo outcome: điểm mạnh, lỗi giảm, retest gain, tuần tới nên ưu tiên gì |
| `PROGRESS.Reactivation` | Comeback plan sau thời gian vắng; khôi phục nhịp học mà không dồn backlog hoặc gây guilt |
| `PROGRESS.Wellbeing` | Theo dõi tải học, dấu hiệu quá tải và đề xuất giảm nhịp/nghỉ hợp lý |

### Search & Resource Center (SEARCH)

| id | Capability |
|---|---|
| `SEARCH.Global`, `SEARCH.Knowledge`, `SEARCH.Question` | Global / Knowledge / Question Search |
| `SEARCH.Formula`, `SEARCH.Cheatsheet` | Formula, Cheatsheet |
| `SEARCH.BandDescriptor`, `SEARCH.WritingSample`, `SEARCH.SpeakingSample` | Band Descriptor, Writing/Speaking Sample |

### Study Orchestration (STUDY)

Lớp orchestration giữa Goal (dài hạn) và Practice (câu hỏi) — xương sống Home.

| id | Capability |
|---|---|
| `STUDY.Session` | Study Session (Start, Resume, Pause, End, Session Goal) |
| `STUDY.SessionSummary` | Session Summary (thời gian, số câu, từ mới, lỗi) |
| `STUDY.DailyPlan` | Daily Plan (Today's Lesson, Today's Practice, Today's Review) |
| `STUDY.TodayQueue` | Today's Queue (review SRS due, weak skill practice, exam prep) |
| `STUDY.Continue` | Continue on Another Device (current session handoff) |
| `STUDY.Resume` | Resume sau interrupt (Mock Test, network loss, session timeout) — Error Recovery nằm ở đây |
| `STUDY.MicroSession` | Phiên 5–10 phút cho ngày bận, vẫn gắn với mục tiêu và outcome cụ thể |
| `STUDY.CheckIn` | Check-in năng lượng, thời gian và ý định học để điều chỉnh phiên hôm nay |

### Notification (NOTIF)

| id | Capability |
|---|---|
| `NOTIF.Study`, `NOTIF.Review`, `NOTIF.SRS`, `NOTIF.Result`, `NOTIF.Goal` | Nhắc học / revision / SRS due / kết quả evaluation / mục tiêu tuần |
| `NOTIF.Preference` | Study Reminder, Review Reminder, Goal Reminder |
| `NOTIF.QuietHours` | Quiet Hours |
| `NOTIF.SmartDelivery` | Chọn thời điểm/kênh theo giá trị dự kiến, preference, quiet hours và frequency cap |
| `NOTIF.Reengagement` | Nhắc quay lại theo comeback plan; không dùng guilt, không phạt mất streak |

### Subscription (SUB)

| id | Capability |
|---|---|
| `SUB.Plan`, `SUB.Payment`, `SUB.Premium`, `SUB.UsageLimit` | Gói học / thanh toán / premium / usage limit |

---

## Content Features (Colab)

### Content Management (CONTENT)

| id | Capability |
|---|---|
| `CONTENT.Lesson`, `CONTENT.Knowledge`, `CONTENT.QuestionBank`, `CONTENT.MockTest`, `CONTENT.Quiz`, `CONTENT.Tag` | Quản lý nội dung |
| `CONTENT.Publish` | Publish Workflow |
| `CONTENT.Moderation` | Review nội dung, kiểm lỗi, kiểm tag, unpublish |
| `CONTENT.BlueprintUpdate` | Cập nhật nội dung khi IELTS blueprint thay đổi |
| `CONTENT.Feedback` | Xử lý Content Feedback từ learner (Report Content, Suggest Fix, Report Wrong Answer) |
| `CONTENT.AutoTag` | Đề xuất tag/taxonomy từ content; không tự publish |
| `CONTENT.TagReview` | Colab review và chấp nhận/từ chối tag đề xuất |

> Colab không bao giờ chấm bài. Chi tiết Knowledge System + taxonomy ở `05-content.md`.

---

## Admin Features

### Administration (ADMIN)

| id | Capability |
|---|---|
| `ADMIN.User`, `ADMIN.Role`, `ADMIN.Permission`, `ADMIN.AccountStatus` | User / Role / Permission / Account Status |
| `ADMIN.SystemSetting`, `ADMIN.Dashboard`, `ADMIN.AuditLog`, `ADMIN.ModerationLog` | System Management |
| `ADMIN.GovernanceDashboard` | Xem metrics chất lượng chấm (confidence, drift, bias, anti-gaming) — chi tiết `06-engines.md` |
| `ADMIN.Billing`, `ADMIN.Revenue`, `ADMIN.Premium` | Billing Management |

---

## Quality & Economics Operations (OPS)

Các capability backend/cross-functional này bảo vệ chất lượng và chi phí. Chúng phải có owner, threshold, escalation policy và dashboard; không biến thành UI phức tạp cho learner nếu không tạo thêm outcome.

| id | Capability |
|---|---|
| `OPS.ContentQuality` | Quality gate cho content: correctness, taxonomy completeness, difficulty calibration, accessibility, licensing |
| `OPS.EvaluationQuality` | Quality gate cho scorer: rubric alignment, calibration, confidence, drift, bias và reproducibility |
| `OPS.ReleaseGate` | Gate trước khi publish model/content/feature; kiểm tra quality, safety, accessibility và cost |
| `OPS.OutcomeMeasurement` | Đo learning outcome, retest gain, error recurrence, helpfulness và long-term skill transfer |
| `OPS.ModelRouting` | Route request theo risk/value/latency: rules/cache/small model/large model/fallback |
| `OPS.CostBudget` | Ngân sách theo learner, capability, model, audio phút và batch job |
| `OPS.Quota` | Rate limit, usage limit, fair use và graceful degradation |
| `OPS.Observability` | Theo dõi latency, errors, token/audio usage, cache hit, escalation và quality impact |

### Capability contract

Catalog giữ identity và mô tả ngắn. Mỗi capability được đưa vào phase active, build candidate hoặc build-ready phải có **Capability Profile** canonical; capability ở future horizon chưa cần profile riêng. Profile giữ metadata build/governance, có thể được biểu diễn thành Artifact khi capability bước vào build, nhưng các field sau là bắt buộc và không được chỉ tồn tại trong implementation backlog:

```yaml
capability_id: DOMAIN.Capability
user_outcome: <outcome có thể quan sát>
owner: product | engineering | operations | legal
phase: P0 | P1 | P2 | deferred
dependencies: []
inputs: []
outputs: []
permission: <role + data scope>
primary_events: []
quality_gate: <gate id hoặc điều kiện>
cost_budget: <budget id hoặc n/a>
fallback: <user-safe fallback>
privacy_class: account | learning | assessment | audio | billing | system | derived
```

Capability chỉ là `build candidate` khi profile hoàn chỉnh. Capability chỉ là `build ready` khi đã có Vertical Slice Spec/contract liên quan trong `artifacts/`. Phase của toàn catalog được projection trong `artifacts/operations/catalogs/capability-phase-index.md`; capability không có phase active được xem là `deferred`, không phải implicit scope.

### P0 Capability Profile Matrix — closed pilot canonical scope

P0 không còn được hiểu là toàn bộ capability có thể tồn tại ở launch. P0 closed pilot là các capability cần thiết để chứng minh một outcome: **người học Writing Task 2 nhận feedback có evidence, sửa một lỗi, ôn và retest được lỗi đó**. Một row là profile chung cho các capability không được phép diverge trong cùng vertical slice; muốn diverge phải tách profile.

| Profile | Capability IDs | User outcome | Owner | Dependencies | Primary events | Quality / fallback | Privacy | Cost boundary |
|---|---|---|---|---|---|---|---|---|
| `P0-01 Identity` | `IDENTITY.Auth`, `IDENTITY.Profile`, `IDENTITY.Privacy` | Có tài khoản, consent và dữ liệu thuộc về mình | engineering | managed auth boundary | account_created, consent_recorded | deny-by-default; export/delete recovery | account | managed_auth_pilot |
| `P0-02 Diagnosis` | `GOAL.Target`, `PLACE.Test`, `PLACE.BandEstimation`, `PLACE.GapDetection`, `PLACE.InitialPath`, `PLACE.SkillDiagnosis`, `BAND.Current` | Có baseline và mục tiêu để tạo plan | product | published placement configuration | placement_started/completed | insufficient data → explain + retry | learning | placement_pilot |
| `P0-03 Daily action` | `STUDY.DailyPlan`, `STUDY.CheckIn`, `STUDY.MicroSession`, `PERSONAL.NextBestAction` | Biết một việc hữu ích nên làm hôm nay | product | P0-02 + user state | daily_plan_generated, session_started | no confidence → tối đa 3 lựa chọn rõ lý do | learning | rules_first |
| `P0-04 Writing evaluation` | `LEARN.Writing`, `EVAL.Writing`, `COACH.ErrorAnalysis`, `COACH.Feedback`, `PKM.Drafts` | Viết, lưu, nộp và hiểu feedback có evidence | product + engineering | published task, rubric, evaluation contract | evaluation_submitted, evaluation_scored | low confidence/delay/unavailable user-safe states | learning/assessment | writing_eval_pilot |
| `P0-05 Error-to-review` | `REVIEW.MistakeNotebook`, `REVIEW.FSRS`, `REVIEW.SmartQueue`, `PRACTICE.Drill` | Chọn một lỗi, sửa, ôn và retest | product | P0-04 + error taxonomy | learning_error_saved, review_completed, retest_completed | missing evidence → no review card; empty queue → alternative action | learning | deterministic_fsrs |
| `P0-06 Quality & economics` | `OPS.CostBudget`, `OPS.ModelRouting`, `OPS.Quota`, `OPS.Observability`, `OPS.ReleaseGate`, `OPS.EvaluationQuality`, `OPS.ContentQuality`, `OPS.OutcomeMeasurement`, `GOVERNANCE.ConfidenceScore`, `GOVERNANCE.AuditTrail` | Không hy sinh trust/data safety để lấy feature nhanh | operations | benchmark, content, event/failure contracts | evaluation_failed, evaluation_delayed, retest_completed | release blocked / deterministic fallback | assessment | quality_release_gate |

Các capability ngoài matrix vẫn là Blueprint canonical nhưng không là closed-pilot P0. Chúng chỉ được nâng vào launch scope qua Artifact decision + Build Readiness Matrix, không qua copy/paste vào P0.

---

## Event Contract (analytics/recommendation SSOT)

Mọi analytics, recommendation, dashboard, experiment và notification phải đọc từ cùng một event contract. Event là fact bất biến; không dùng UI click làm proxy cho learning outcome nếu chưa có event outcome tương ứng.

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

| Event | Khi phát sinh | Consumer chính |
|---|---|---|
| `account_created` / `consent_recorded` | Account hoặc consent có hiệu lực được tạo | IDENTITY, privacy audit |
| `privacy_export_requested` / `privacy_deletion_requested` | Learner yêu cầu export/xóa dữ liệu | IDENTITY, privacy operation |
| `placement_started` / `placement_completed` | Bắt đầu / hoàn tất placement hợp lệ | PLACE, PERSONAL, activation |
| `goal_set` | Goal hợp lệ được lưu | GOAL, PLACE, STUDY |
| `daily_plan_generated` | Today tạo hoặc refresh plan có lý do | STUDY, PERSONAL, UX diagnosis |
| `session_started` | Learner bắt đầu một study session có intent | STUDY, outcome measurement |
| `session_completed` | Session đạt completion rule | STUDY, outcome measurement |
| `first_meaningful_session_completed` | Phiên đầu có outcome, không chỉ mở app | PROGRESS, retention |
| `lesson_completed` | Lesson đạt completion rule | LEARN, REVIEW, recommendation |
| `practice_finished` | Practice set kết thúc hợp lệ | HISTORY, PROGRESS, PERSONAL |
| `evaluation_submitted` | Writing/Speaking/Pronunciation được submit | EVAL, quota, cost |
| `evaluation_scored` | Result hợp lệ được tạo | HISTORY, BAND, PROGRESS |
| `evaluation_failed` | Không thể tạo result hợp lệ | recovery, observability |
| `evaluation_delayed` | Evaluation vượt ngưỡng thời gian chờ đã công bố | recovery, quota, observability |
| `explanation_viewed` | Learner xem evidence/explanation | COACH, helpfulness |
| `learning_error_saved` | Error có evidence được lưu vào mistake system | REVIEW, outcome measurement |
| `practice_started` | Learner bắt đầu action từ feedback | PERSONAL, outcome |
| `retest_completed` | Retest sau feedback hoàn tất | OPS.OutcomeMeasurement |
| `review_completed` | FSRS review được rating và lưu thành công | REVIEW, retention |
| `quota_warning_shown` | Learner được thông báo còn ít quota trước costly action | OPS.Quota, UX |
| `quota_exceeded` | Costly action bị chặn vì quota/reservation không còn slot | OPS.Quota, UX, recovery |
| `goal_completed` | Goal đạt completion rule | GOAL, PROGRESS |
| `session_paused` / `session_resumed` | Session có checkpoint / khôi phục | STUDY, recovery |
| `session_abandoned` | Session kết thúc theo abandonment policy | STUDY, UX diagnosis |
| `comeback_plan_started` / `comeback_plan_completed` | Learner quay lại và hoàn tất comeback plan | PROGRESS.Reactivation, retention |
| `returned_after_14_days` | First meaningful return sau 14 ngày | PROGRESS, experiment |
| `notification_delivered` / `notification_opened` / `notification_opted_out` | Vòng đời notification | NOTIF, fatigue control |

### Registered slice/internal extensions

Các event dưới đây vẫn dùng cùng envelope và registry này nhưng là detail/operational extensions; chúng không thay thế outcome event canonical. Producer phải là backend service, không phải SPA trực tiếp.

| Event family | Registered event types |
|---|---|
| Writing detail | `writing_task_opened`, `writing_draft_saved`, `writing_submission_started`, `writing_submission_accepted`, `writing_feedback_viewed` |
| Error/review detail | `learning_error_fix_started`, `learning_error_fix_completed`, `review_queue_opened`, `review_card_created`, `review_card_rated`, `review_card_graduated`, `learning_error_resolved`, `retest_started` |
| Recommendation detail | `next_best_action_shown`, `next_best_action_taken` |
| Quota/subscription detail (P1) | `upgrade_cta_shown`, `upgrade_completed` |
| Governance internal | `benchmark_run_completed`, `drift_threshold_exceeded`, `anti_gaming_flagged` |

### Event rules

- Event type dùng `snake_case`, có owner và consumer; schema/semantics thay đổi phải tăng semver `event_version`.
- Event producer phải idempotent theo `event_id` + stable `entity_refs` + `occurred_at` window; offline sync phải deduplicate. Raw `actor_id` không nằm trong envelope; identity chỉ dùng `user_id_hash`.
- Không gửi PII hoặc raw audio/text vào analytics nếu không cần; dùng reference và privacy class.
- Event outcome phải có quality state; `evaluation_failed`, `low_confidence` và `invalid` không được tính như success.
- Backfill phải có `source=backfill`, lý do, time range và không kích hoạt notification/recommendation ngoài ý muốn.
- Xóa dữ liệu phải cascade theo privacy policy và để lại aggregate anonymized nếu consent cho phép.

---

## Engine Capabilities (reference)

Engine layer (`06-engines.md`) implement các capability sau (không lặp mô tả ở đây, chỉ liệt kê để trace):

- `REVIEW.FSRS` ← FSRS engine
- `EVAL.Writing`, `EVAL.Speaking`, `EVAL.Pronunciation`, `EVAL.Examiner` ← Evaluation engine
- `PERSONAL.Recommendation`, `PERSONAL.NextBestAction`, `PERSONAL.Insights` ← Recommendation engine
- `GOVERNANCE.*` ← AI Governance engine (xem `06-engines.md`)
- `OPS.*` ← Quality & Cost Control Plane (xem `06-engines.md`)

## AI Governance Capabilities (GOVERNANCE)

Backend invisible, là control target cho sole evaluator; chưa phải quality guarantee khi thiếu corpus, threshold và benchmark run thật. Chi tiết implementation ở `06-engines.md`.

| id | Capability |
|---|---|
| `GOVERNANCE.ConfidenceScore` | Mỗi bài chấm có điểm tự tin; bài low-confidence bị flag |
| `GOVERNANCE.GoldStandardBenchmark` | Proposal: hàng tuần chấm lại corpus examiner-graded có kích thước do founder approve để đo độ lệch; hiện chưa có corpus/run active |
| `GOVERNANCE.DriftDetection` | Phát hiện model chấm lệch chuẩn theo thời gian |
| `GOVERNANCE.BiasMonitoring` | Theo dõi chênh lệch chấm theo nhóm user / dạng bài / band |
| `GOVERNANCE.AntiGaming` | Phát hiện sample / plagiarism / ChatGPT-generated submission |
| `GOVERNANCE.AuditTrail` | Log mọi thay đổi calibration, version model |
| `GOVERNANCE.Dashboard` | Admin xem metrics chất lượng chấm |
