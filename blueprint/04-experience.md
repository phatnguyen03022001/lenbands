# 04 — Experience Blueprint

File này mô tả **trải nghiệm và hành trình** của người học — "người học cảm thấy thế nào". **Không mô tả feature** (feature ở `03-features.md`); chỉ tham chiếu capability bằng id dạng `DOMAIN.Capability` để AI trace được.

> **Scope guard:** file này là experience horizon cho toàn sản phẩm. Closed-pilot P0 chỉ dùng `identity-consent`, `placement-and-plan`, `daily-action`, `writing-task-2`, `error-to-review` và `governance-ops-dashboard` khi Build Readiness Matrix cho phép. Mock Test, Exam Readiness, Exam Day, After Exam và capability deferred khác không phải build input P0.

## Nguyên tắc UX

1. **Experience-centric, không feature-centric** — người dùng nghĩ theo hành trình ("tôi muốn đạt Band 7 → hôm nay học gì"), không theo feature ("tôi muốn dùng Practice").
2. **Progressive Disclosure** — band thấp thấy ít, band cao thấy nhiều; không đổ toàn bộ Advanced Analytics/Rubric/Calibration lên đầu. UI mở dần theo readiness.
3. **Always know the next step** — mọi màn kết thúc bằng 1 câu hỏi: "bước tiếp theo là gì?" (`PERSONAL.NextBestAction`).
4. **Delight ở moment tiến bộ, không ở gamification** — celebration khi Band Readiness tăng, không phải XP/leaderboard.
5. **Recovery trước panic** — khi AI chấm lỗi / mạng mất / session timeout, hệ thống recover êm, user không mất dữ liệu.
6. **Context-aware** — AI luôn biết user đang ở đâu (passage/question/skill) để trả lời trong ngữ cảnh (`COACH.Tutor`).
7. **Energy-aware** — hệ thống hỏi thời gian/năng lượng hôm nay và đưa ra phiên phù hợp, thay vì luôn đẩy cùng một workload.
8. **Trust before persuasion** — trạng thái chấm, giới hạn, dữ liệu được dùng thế nào và vì sao có recommendation phải dễ hiểu; retention không được đánh đổi bằng dark pattern.
9. **One clear next step** — mỗi màn có một primary action; các lựa chọn phụ nằm sau progressive disclosure để giảm cognitive load.

## Home (mở nhiều nhất)

Home là orchestration của `STUDY.*`, không phải feature mới.

```text
┌───────────────────────────────────┐
│  Greeting + Streak                │  ← PROGRESS.Motivation
├───────────────────────────────────┤
│  Today's Goal (progress bar)      │  ← GOAL.Daily
├───────────────────────────────────┤
│  ▶ Continue (resume session)      │  ← STUDY.Resume / STUDY.Continue
├───────────────────────────────────┤
│  Today's Plan                     │  ← STUDY.DailyPlan
│    • Today's Review (N due)       │     REVIEW.SmartQueue
│    • Today's Practice             │     PRACTICE.*
│    • Today's Lesson               │     LEARN.Path
├───────────────────────────────────┤
│  Insight of the day               │  ← PERSONAL.Insights
│  ("Bạn đang yếu Matching Heading")│
├───────────────────────────────────┤
│  Next Best Action                 │  ← PERSONAL.NextBestAction
└───────────────────────────────────┘
```

Empty state (người mới): Home hiển thị "Bắt đầu Placement Test" (`PLACE.Test`) thay vì Today's Plan.

## 8 User Journeys

### 01. First Day (Onboarding)

Trải nghiệm đầu tiên — phải trả lời "hệ thống này có hiểu mình không?".

```text
Bạn là ai? (profile cơ bản)
   ↓
Band hiện tại? (self-report hoặc quick test)
   ↓
Band mục tiêu?            ┐
   ↓                      │
Bao lâu nữa thi?          │ → GOAL.Target, GOAL.ExamPlan (horizon; không active P0)
   ↓                      │
Mỗi ngày học bao lâu?     │ → GOAL.Daily (horizon; P0 dùng daily budget trong placement contract)
   ↓                      │
Placement Test            │ → PLACE.Test (nếu chưa có band chuẩn)
   ↓                      │
Gap Detection             │ → PLACE.GapDetection
   ↓                      │
Tạo kế hoạch cá nhân      │ → PLACE.InitialPath + STUDY.DailyPlan
   ↓
First Home (Today's Plan xuất hiện)
```

**Emotional goal:** cảm giác "hệ thống hiểu mình, có lộ trình rõ ràng, không bị overwhelmed".

### 02. Daily Study

Loop lặp mỗi ngày — phải trả lời "hôm nay bắt đầu từ đâu, học xong biết mình tiến bộ".

```text
Mở app → Home (Today's Plan)     ← STUDY.DailyPlan
   ↓
Chọn "Continue" hoặc item trong Today
   ↓
Study Session (timer, goal)      ← STUDY.Session
   ↓
Học / Luyện / Review (theo plan)
   ↓
Session Summary                  ← STUDY.SessionSummary
   ("42 phút, 18 câu Reading, 6 từ mới, 3 lỗi Grammar")
   ↓
Streak / Goal cập nhật           ← PROGRESS.Motivation, PROGRESS.GoalTracking
   ↓
Next Best Action cho ngày mai    ← PERSONAL.NextBestAction
```

**Emotional goal:** cảm giác "hoàn thành, có thành tựu nhỏ, biết ngày mai làm gì".

### 03. Mock Test

Trải nghiệm thi thử — phải giống thi thật nhưng an toàn (được sai, được hiểu vì sao).

```text
Chọn Mock Test                  ← PRACTICE.MockTest
   ↓
Exam Mode (timed, không gợi ý)  ← PRACTICE.ExamSimulation
   ↓
[Interrupt: cuộc gọi đến]       ← STUDY.Resume (khôi phục timer, state)
   ↓
Resume từ đúng chỗ
   ↓
Nộp bài
   ↓
Band Score + Result Analysis    ← PRACTICE.MockTest, EVAL.*
   ↓
Compare với lần trước           ← HISTORY.Compare
   ↓
Exam Readiness cập nhật         ← BAND.ExamReadiness
```

**Emotional goal:** căng thẳng (đúng vibe thi) nhưng không hoảng; sau khi chấm thấy "tôi đang ở đâu, còn thiếu gì".

### 04. Wrong Answer

Moment dễ nản nhất — phải biến thất bại thành học.

```text
Làm sai câu (Reading/Listening)
   ↓
Giải thích đáp án                ← COACH.AnswerExplanation
   ↓
Giải thích bẫy distractor        ← COACH.DistractorExplanation
   ↓
[Optional] hỏi thêm trong ngữ cảnh ← COACH.Tutor (context-aware)
   ↓
Save to Mistake Notebook         ← REVIEW.MistakeNotebook
   ↓
Auto-add vào FSRS queue          ← REVIEW.FSRS
   ↓
Sẽ gặp lại trong Smart Queue     ← REVIEW.SmartQueue
   ↓
Retest khi due                   ← REVIEW.SmartQueue (Exam/Priority Queue)
```

**Emotional goal:** từ "tôi dở" → "tôi hiểu vì sao sai, và sẽ nhớ lần sau".

### 05. Review (Spaced Repetition)

Loop ôn tập — phải nhẹ, nhanh, có tiến độ rõ.

```text
Notification "X bài cần ôn hôm nay"  ← NOTIF.SRS
   ↓
Mở Today's Queue                ← REVIEW.SmartQueue
   ↓
Review card (FSRS)              ← REVIEW.FSRS
   Rating: Again/Hard/Good/Easy
   ↓
FSRS cập nhật stability/difficulty/due
   ↓
Forecast 7 ngày                 ← REVIEW.FSRS
   ↓
Retention rate                  ← REVIEW.FSRS
```

**Emotional goal:** "ôn nhanh, nhớ lâu, không bị quá tải".

### 06. Before Exam

Giai đoạn nước rút — phải trả lời "tôi sẵn sàng chưa, còn thiếu gì, ưu tiên gì".

```text
Countdown hiển thị              ← GOAL.ExamPlan
   ↓
Exam Readiness check            ← BAND.ExamReadiness
   (Overall + per-skill + Confidence + Risk)
   ↓
Insight: "chỉ còn thiếu Task Response" ← PERSONAL.Insights
   ↓
Ưu tiên ôn weak skill           ← REVIEW.SmartQueue (Weak Skill/Exam Queue)
   ↓
Last-minute Review Plan         ← GOAL.ExamPlan
   ↓
Mock Test Readiness Check       ← PRACTICE.MockTest
```

**Emotional goal:** tự tin (vì biết mình ở đâu), tập trung (vì biết ưu tiên gì).

### 07. Exam Day

Ngày thi — app lui xuống nền, chỉ hỗ trợ nhẹ.

```text
Timeline ngày thi               ← GOAL.ExamPlan
   ↓
Pre-exam Checklist              ← GOAL.ExamPlan
   ↓
Time Management Strategy        ← GOAL.ExamPlan
   ↓
Test Day Anxiety Tips           ← GOAL.ExamPlan
   ↓
[Không push notification nặng]
```

**Emotional goal:** bình tĩnh, không bị phân tâm bởi app.

### 08. After Exam

Sau thi thật — cập nhật target, điều chỉnh lộ trình, celebrate.

```text
Nhập kết quả thi thật           ← IDENTITY.Profile (optional)
   ↓
Compare kết quả thật vs dự đoán ← HISTORY.Compare (vs EVAL.BandPrediction)
   ↓
Calibrate lại (feed vào Governance) ← GOVERNANCE.GoldStandardBenchmark
   ↓
Đặt target mới (nếu cần)        ← GOAL.Target
   ↓
Celebration nếu đạt             ← PROGRESS.Motivation
   ↓
Adjust Learning Path            ← LEARN.Path + PERSONAL.NextBestAction
```

**Emotional goal:** khép vòng, nhìn lại tiến bộ, có hướng đi tiếp.

## Delight Moments

Không phải gamification (no XP/leaderboard). Là celebration tại moment tiến bộ:

| Moment | Trigger | Delight |
|---|---|---|
| Band Readiness tăng | `BAND.Readiness` tăng 0.5+ | "Bạn vừa đạt Band Readiness 6.5 — chỉ còn thiếu Task Response" (`PERSONAL.Insights`) |
| Gần hoàn thành daily goal | Còn <15 phút | "Hôm nay chỉ còn 12 phút nữa là hoàn thành mục tiêu" |
| Streak milestone | 7/30/100 ngày | Celebration nhẹ + recap |
| 100 Reviews | `REVIEW.FSRS` đạt 100 | Achievement badge nhẹ (`PROGRESS.Achievement`) |
| Band improvement | `HISTORY.BandTimeline` tăng | "Bạn đã từ 6.0 → 6.5 trong Reading sau 3 tuần" |
| Comeback | Quay lại sau vắng | "Chào mừng trở lại — bạn đã nhớ 85% từ vựng" (`PROGRESS.Motivation` comeback nudge) |

## Error Recovery

Khi sự cố xảy ra, user không được để trống — phải có recovery path rõ.

| Sự cố | Recovery | Capability |
|---|---|---|
| AI chấm lỗi / timeout | Thông báo "đang chấm lại", kết quả có sau; không mất bài | `EVAL.*` + `GOVERNANCE.ConfidenceScore` flag |
| Upload Writing/Speaking fail | Auto-retry + lưu local; "sẽ nộp khi có mạng" | `PKM.Drafts` + `PKM.Offline` |
| Network loss giữa session | Auto-save state; resume đúng chỗ khi có mạng | `STUDY.Resume` + `PKM.Sync` |
| Session timeout (Mock Test) | Timer khôi phục; không mất câu đã làm | `STUDY.Resume` |
| Low-confidence score | Flag backend (invisible), có thể yêu cầu chấm lại qua pipeline calibration | `GOVERNANCE.ConfidenceScore` |
| Anti-gaming flag | Nếu bài nộp bị nghi sample/AI-generated, thông báo nhẹ + hướng dẫn | `GOVERNANCE.AntiGaming` |

Các recovery trên phải map vào Failure Contract trong `06-engines.md`: user-facing state chỉ dùng `processing`, `delayed`, `unavailable` hoặc `action_required`; failure code kỹ thuật không được hiển thị thay cho hướng dẫn hành động.

## Empty States

Mỗi màn rỗng (người mới) phải có onboarding inline, không để trống.

| Màn | Empty state | Neo capability |
|---|---|---|
| Home | "Bắt đầu Placement Test để tạo kế hoạch" | `PLACE.Test` |
| Dashboard | "Làm bài đầu tiên để xem tiến độ" | `PRACTICE.MockTest` |
| Mistake Notebook | "Chưa có lỗi — sai câu nào sẽ xuất hiện ở đây" | `REVIEW.MistakeNotebook` |
| Word Bank | "Thêm từ khi học Vocabulary hoặc từ bài Reading" | `PKM.WordBank` |
| Assessment History | "Chưa có bài làm — kết quả sẽ hiển thị ở đây" | `HISTORY.Attempts` |

## Progressive Disclosure theo Band

UI không đổ hết thông tin; mở dần theo readiness của learner.

| Band | Hiển thị | Ẩn |
|---|---|---|
| 3.0–4.5 | Learning cơ bản, Practice, Mistake Notebook, Dashboard đơn giản | Advanced Analytics, Band Rubric chi tiết, Calibration metrics, Exam Readiness risk |
| 5.0–6.5 | + Band Framework, Insights, Exam Readiness, Smart Queue | Governance dashboard, Raw calibration data |
| 7.0+ | + Advanced Analytics, full Rubric, Compare attempts sâu | (gần như đầy đủ) |

Nguyên tắc: band thấp cần "học gì tiếp", band cao cần "tại sao chưa tới band kế tiếp".

## Context Awareness

`COACH.Tutor` và các Coach khác luôn biết context hiện tại của user để trả lời đúng:

| User đang ở | AI biết context | Câu trả lời ví dụ |
|---|---|---|
| Reading Passage 2, Q18, Matching Heading | passage, question, type, history sai dạng này | "Ở câu Matching Heading này, bạn chọn nhánh B vì keyword trùng, nhưng đáp án là D vì paraphrase..." |
| Writing Task 2, draft đang viết | nội dung draft, task | "Đoạn 2 của bạn thiếu topic sentence rõ" |
| Speaking Part 2, vừa record xong | transcript, cue card | "Bạn dùng được 'I suppose' nhưng phát âm /θ/ chưa chuẩn" |

Implementation ở `06-engines.md` (context injection vào prompt).

## Retention loop lành mạnh

Retention được thiết kế như một vòng giá trị, không phải vòng ép mở app:

```text
Mở app
  ↓
Check-in thời gian + năng lượng          ← STUDY.CheckIn
  ↓
Chọn Micro / Standard / Deep Session     ← STUDY.MicroSession / STUDY.Session
  ↓
Làm một outcome loop                      ← Understand → Practice → Retest → Confirm
  ↓
Thấy bằng chứng tiến bộ                   ← PROGRESS.WeeklyRecap / PROGRESS.Motivation
  ↓
Chọn lịch quay lại phù hợp                ← NOTIF.Preference / NOTIF.SmartDelivery
```

### Quy tắc giữ chân

- Không reset tiến bộ khi learner nghỉ; chuyển sang `comeback plan` ngắn (`PROGRESS.Reactivation`).
- Không hiển thị backlog khổng lồ ngay khi quay lại; ưu tiên một việc có tác động cao.
- Streak là thông tin tùy chọn, không là điều kiện mở khóa, không dùng thông báo “mất streak”.
- Mọi notification có frequency cap, quiet hours, unsubscribe rõ ràng và lý do gửi.
- Đo `meaningful study days`, retest gain và error recurrence; không tối ưu retention bằng minutes, clicks hoặc số notification.

## Quality loop trong trải nghiệm

Mỗi feedback phải có bốn phần:

1. **Evidence** — hệ thống dựa vào câu, audio, đáp án hoặc hành vi nào.
2. **Meaning** — điều đó ảnh hưởng rubric/skill nào.
3. **Action** — một bài học, drill hoặc rewrite cụ thể.
4. **Verification** — retest hoặc compare attempt để learner thấy đã cải thiện.

Nếu chấm không hoàn tất, UI phải hiển thị trạng thái `processing`, `delayed`, `low_confidence` hoặc `unavailable`; không giả vờ đã có kết quả và không tạo insight từ dữ liệu chưa hợp lệ.

## Cost-aware experience

- Cho phép learner chọn độ sâu feedback: `Quick`, `Standard`, `Deep`; mặc định dùng mức đủ để hành động.
- Hiển thị transcript, explanation và insight đã cache ngay khi có; phần phân tích sâu chạy nền.
- Với mạng yếu hoặc quota thấp, ưu tiên save draft, basic scoring/status và queue retry; không mất dữ liệu.
- Không expose model/provider trong UI, nhưng expose rõ giới hạn sử dụng, thời gian chờ dự kiến và trạng thái kết quả.

## Experience measurement

| Moment | Event cần đo | Outcome |
|---|---|---|
| First day | `placement_completed`, `first_meaningful_session_completed` | activation và time-to-first-value |
| Wrong answer | `explanation_viewed`, `practice_started`, `retest_completed` | error recurrence giảm |
| Evaluation | `writing_feedback_viewed`, `practice_started`, `evaluation_submitted`, `retest_completed` | feedback helpfulness và score improvement |
| Comeback | `comeback_plan_started`, `comeback_plan_completed` | return quality, không chỉ login |
| Notification | delivered/opened/dismissed/opted_out | incremental value và notification fatigue |

## UX quality gates

Trước khi release journey mới, phải kiểm tra: first meaningful action ≤ 3 bước, primary action rõ, keyboard/screen reader dùng được, offline/retry path có thật, copy không gây guilt, event tracking đầy đủ và cost budget không vượt ngưỡng.
