# 08 — Roadmap

File này chứa **delivery planning**: Priority (P0/P1/P2), MVP/Version phasing, Release, Deprecation. **Không mô tả feature chi tiết** — chỉ tham chiếu capability id (`03-features.md`).

> **Lưu ý quan trọng:** đây là roadmap cho **delivery**, không phải blueprint. Blueprint đầy đủ ở `README.md` + các spoke. Roadmap này có thể cắt/thay đổi theo thực tế delivery mà không phá blueprint (blueprint là SSOT cho năng lực, roadmap là SSOT cho phasing).

## Priority

### P0 — Closed Pilot (build now)

P0 là scope canonical duy nhất được phép nhận build-ready Artifact. Nó gồm đúng sáu pack ở `03-features.md` § P0 Capability Profile Matrix:

- `IDENTITY.Auth`, `IDENTITY.Profile`, `IDENTITY.Privacy`
- `GOAL.Target`, `PLACE.Test`, `PLACE.BandEstimation`, `PLACE.GapDetection`, `PLACE.InitialPath`, `PLACE.SkillDiagnosis`, `BAND.Current`
- `STUDY.DailyPlan`, `STUDY.CheckIn`, `STUDY.MicroSession`, `PERSONAL.NextBestAction`
- `LEARN.Writing`, `EVAL.Writing`, `COACH.ErrorAnalysis`, `COACH.Feedback`, `PKM.Drafts`
- `REVIEW.MistakeNotebook`, `REVIEW.FSRS`, `REVIEW.SmartQueue`, `PRACTICE.Drill`
- `OPS.CostBudget`, `OPS.ModelRouting`, `OPS.Quota`, `OPS.Observability`, `OPS.ReleaseGate`, `OPS.EvaluationQuality`, `GOVERNANCE.ConfidenceScore`, `GOVERNANCE.AuditTrail`
- `OPS.ContentQuality`, `OPS.OutcomeMeasurement` là shared P0 quality/measurement gates; chúng không mở full Colab/content-management scope.

Một P0 pack chỉ được code khi Build Readiness Matrix báo `ready`; P0 toàn phần chỉ launch khi cả sáu pack `ready`.

### P1 (mở rộng sau evidence từ closed pilot)

- P1 là candidate scope sau P0, không phải phép cộng tự động. `REVIEW.SmartQueue` ở P1 nghĩa là mở rộng queue cross-skill; P0 chỉ dùng queue cho Writing error. `REVIEW.FSRS` ở Expanded MVP chỉ là candidate vocab-only; FSRS grammar/collocation/error mở rộng sau đó cần evidence riêng.
- `PERSONAL.NextBestAction`, `COACH.ErrorAnalysis` và `GOVERNANCE.ConfidenceScore` xuất hiện lại ở P1 chỉ với qualifier **advanced/full**; P0 deterministic/error-analysis/confidence baseline vẫn là scope canonical trước đó.

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
- `LOC.LocaleFormat` (advanced), thêm ngôn ngữ mới
- `GOAL.ExamPlan` (advanced: timeline, anxiety tips)

## MVP

### MVP rebaseline — Closed Pilot (canonical launch scope)

Closed pilot không cố chứng minh "Knowledge OS cho bốn kỹ năng". Nó chứng minh một loop có thể đo outcome:

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

Capability scope canonical nằm ở `03-features.md` § P0 Capability Profile Matrix. Chỉ sáu pack `P0-01` đến `P0-06` được phép nhận build-ready Artifact trong closed pilot.

**Explicitly deferred:** Listening, Reading, Speaking, Pronunciation, Mock Test, full Content/Colab, subscription/payment launch, advanced analytics, search, notification center, multi-device/offline và full Exam Readiness. Chúng vẫn giữ identity Blueprint và sẽ được reintroduce theo evidence sau pilot.

### MVP rộng hơn (candidate sau khi closed pilot chứng minh outcome)

**Mục tiêu:** validate core loop "Placement → Learning → Practice → Evaluation → Review" với 4 kỹ năng, giữ identity "Knowledge OS 4 skill" nhưng gọt bỏ phần nâng cao.

Bao gồm:
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

**Không có trong MVP** (đẩy V1): Interactive Examiner dialogue, Pronunciation phoneme-level, FSRS cho grammar/collocation, Smart Queue, Insights, Exam Readiness, Offline, Import, Achievement, advanced Governance. Tuy nhiên MVP vẫn bắt buộc có baseline `OPS.*`: logging, quota, budget, model routing, release gate và recovery state.

## Version 1

Value cao, mở rộng capability nâng cao:
- `STUDY.Session`, `STUDY.SessionSummary`, `STUDY.Resume`
- `BAND.ExamReadiness`, `BAND.Readiness` (advanced), `BAND.RecommendedNext`
- `PERSONAL.GapAnalysis`, `PERSONAL.NextBestAction`, `PERSONAL.Insights`
- `COACH.*` (full coaching)
- `EVAL.Examiner`, `EVAL.Pronunciation`, `EVAL.Speaking` (advanced), `EVAL.RewriteSuggestion`
- `LEARN.Speaking` (recording, transcript comparison), Writing rewrite loop
- `LEARN.Pronunciation`
- `PRACTICE.Adaptive`, `REVIEW.SmartQueue`
- `REVIEW.FSRS` (mở rộng grammar, collocation, mistake)
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
- `LOC.*` (locale formatting, thêm ngôn ngữ)
- `GOAL.ExamPlan` (advanced)

## Release

- Mỗi Version phát hành theo milestone, không cố định calendar.
- Release note tham chiếu capability id để trace ngược blueprint.
- Breaking change ở data model → migration script + version bump.

## Deprecation

- Capability deprecated khi thay thế bằng capability mới hoặc bỏ hoàn toàn.
- Quy trình: mark `deprecated` → giữ 1 version → `retired`.
- Tương tự content versioning (`05-content.md`).

## Roadmap notation and exit criteria

- `*` là shorthand đọc nhanh, không phải capability id để implement; backlog phải expand thành từng id cụ thể.
- `basic` phải có acceptance criteria, còn `advanced` phải có outcome evidence; không dùng nhãn này để trì hoãn quality/safety.
- Mỗi milestone phải có: capability IDs, dependency graph, owner, capacity estimate, quality gate, cost budget, analytics events và rollback plan.

### Closed-pilot launch gates

Closed pilot chỉ launch khi sáu P0 pack trong `03-features.md` § P0 Capability Profile Matrix đều `ready` trong Build Readiness Matrix, và:

1. learner hoàn thành Placement/goal, nhận Today action và biết next step trong cùng ngày;
2. có một loop **Writing Task 2** hoàn chỉnh: submit → evidence-based feedback → một fix → FSRS review → retest proof;
3. Writing evaluation có rubric/model/prompt version, confidence state, token/cost attribution và recovery khi timeout;
4. task sử dụng được qua rights/content quality gate; nếu chưa có task hợp lệ thì không sinh task ngẫu nhiên;
5. cost/evaluation, queue latency, error rate, quota, DLQ/retry và raw-content telemetry có observability theo P0 runtime contract;
6. Runtime State/Event/Failure contract được test cho onboarding, draft save, duplicate submit, timeout, network loss, quota exhaustion, worker retry và app restart;
7. consent, export/delete boundary và ownership test end-to-end;
8. benchmark, prompt/model/rubric route và release gate không còn claim chưa có evidence; khi evidence chưa có, closed pilot vẫn `not ready`.

### Expanded-MVP launch gates

Expanded MVP chỉ được launch sau closed-pilot evidence và khi:

1. outcome loop `Understand → Practice → Retest → Confirm` có acceptance evidence cho Listening, Reading, Writing và Speaking trong scope công bố;
2. mỗi skill/question-type/band profile dùng controlled coverage framework, calibration status và rights/content gate phù hợp;
3. notification/engagement có opt-out, quiet hours, frequency cap và không gây guilt;
4. multi-skill cost/quality/retention impact được benchmark lại, không suy diễn từ Writing-only pilot.

### Version 1 gates

V1 chỉ mở rộng personalization/engagement khi expanded MVP chứng minh được retest gain, error recurrence giảm, helpfulness và comeback quality; không dùng retention đơn thuần làm bằng chứng sản phẩm có chất lượng.

## Phasing principle

- P0 → Closed Pilot (Placement/goal → Today → Writing Task 2 → feedback → fix → review → retest, với baseline quality/cost controls)
- Expanded MVP → mở rộng có evidence sang 4 skill learning basic và evaluation trong scope công bố
- P1 → Version 1 (capability cao, governance, full personalization)
- P2 → Version 2 (polish, advanced analytics, scale)

Roadmap này **có thể** thay đổi theo thực tế delivery mà không phá blueprint. Blueprint (`README` + spoke) là SSOT năng lực; roadmap là SSOT phasing.
