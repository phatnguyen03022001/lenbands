# 01 — Product

File này trả lời **WHY / WHO / WHAT**, không trả lời HOW (HOW thuộc `02-architecture.md` trở đi).

## Vision

Đây là một app học IELTS theo hướng **AI-first Knowledge OS**:

- Không chỉ là LMS chứa lesson
- Không chỉ là app làm quiz
- Là hệ thống giúp learner hiểu toàn bộ IELTS blueprint, biết mình đang ở đâu, thiếu gì, và cần học gì tiếp theo

## Đối tượng người dùng

- Người học IELTS từ band 3.0 đến 8.5
- Người muốn biết mình đang yếu ở đâu và cần học gì tiếp theo
- Người cần luyện IELTS theo kỹ năng, dạng bài, band target và kế hoạch cụ thể

## Giá trị cốt lõi

- Mô hình hóa IELTS thành một hệ tri thức có cấu trúc
- Cá nhân hóa lộ trình theo band, kỹ năng, dạng bài và lỗi sai
- AI chấm Writing, Speaking và Pronunciation — hệ thống tự chấm 100%, không có con người can thiệp
- AI phân tích gap, gợi ý next best action và hỗ trợ giải thích kiến thức
- Colab chỉ thêm, cập nhật, kiểm duyệt và publish nội dung (không chấm bài)
- Admin quản lý hệ thống, người dùng, billing và quyền truy cập (không chấm bài)

## Định vị sản phẩm

AI-first Knowledge OS — không phải LMS, không phải quiz app.

## Principles (nguyên tắc xuyên suốt)

1. **Blueprint structured** — IELTS được mô hình hóa thành blueprint có cấu trúc, không phải danh sách lesson. Band progression là khuyến nghị mềm, không khóa cứng.
2. **Sole evaluator + governance** — toàn bộ tầng evaluation do AI xử lý 100%, không human-in-the-loop. Quality-control target là AI Governance (backend invisible): confidence scoring, gold-standard benchmark, drift/bias monitoring, anti-gaming detection — chưa phải guarantee cho tới khi có evidence thật.
3. **No-AI-label UI** — trong docs dùng chữ "AI" ở capability để dev hiểu nguồn gốc; trong UI người dùng không hiển thị chữ "AI" hay icon AI, chỉ tên chức năng thuần túy. Chi tiết `07-conventions.md`.
4. **Content taxonomy depth** — FSRS, Adaptive Practice, Gap Analysis, Learning Insights, AI Error Analysis chỉ chính xác khi Colab tagging siêu chi tiết (band, micro-skill, question type, distractor type, paraphrase pattern, grammar point). Metadata nông = garbage in, garbage out. Chi tiết `05-content.md`.
5. **SSOT** — mỗi năng lực có một capability id duy nhất, mô tả ở `03-features.md`, được reference ở các spoke khác chứ không lặp lại.
6. **Progress over pressure** — retention là hệ quả của tiến bộ thật, không phải notification dồn dập, streak anxiety hay dark pattern.
7. **Outcome loop** — mọi lỗi hoặc điểm yếu phải đi qua vòng `Understand → Practice → Retest → Confirm`; không xem việc hoàn thành activity là outcome.
8. **Quality/cost guardrail** — giảm chi phí chỉ được phép khi không làm giảm rubric accuracy, helpfulness, accessibility hoặc learner trust.

> **Evidence boundary:** sole-evaluator và governance là product design decision. Benchmark corpus, numeric thresholds, drift detector và cost ceiling chưa được founder/evidence activate; không dùng prose này để claim evaluation đã calibrated hoặc governance đang chạy.

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

- **Learner** học, luyện tập, làm bài và xem tiến độ
- **Premium Learner** truy cập nội dung, phân tích và AI feature nâng cao
- **AI** là evaluator duy nhất: chấm Writing, Speaking, Pronunciation, giải thích đáp án, phân tích lỗi, dự đoán band và đề xuất học tập — không có con người đứng giữa
- **Colab** chỉ làm content (thêm, kiểm duyệt, publish), không bao giờ chấm bài hay can thiệp vào kết quả evaluation
- **Admin** chỉ vận hành hệ thống (user, role, billing, audit), không bao giờ chấm bài hay override kết quả AI

## Scope

### In scope

- Học IELTS theo band, kỹ năng và dạng bài
- Mô hình hóa 4 kỹ năng (Listening/Reading/Writing/Speaking) + Pronunciation thành domain Learning thống nhất, mỗi skill có 4 layer: Learning / Practice / Evaluation / Review
- Evaluation: AI chấm 100% Writing/Speaking/Pronunciation, không human-in-the-loop; kèm band prediction, rewrite suggestion, calibration và consistency monitoring
- Coaching: answer/vocabulary/distractor explanation, listening/reading coach, feedback, error analysis, recommendation, IELTS Q&A tutor
- Personalization: gap analysis, next best action, adaptive learning plan, weakness-based practice, learning insights
- Review & revision: bookmark, mistake notebook, wrong answer/question review, revision queue + FSRS spaced repetition + smart review queue
- Assessment history: all attempts, score/band/skill timeline, learning timeline, writing/speaking portfolio, compare attempts
- Progress & analytics: dashboard, learning/skill analytics, band progress, goal tracking + motivation + achievement nhẹ
- Study orchestration: study session, daily plan, today's queue, continue on another device
- Knowledge assets (hệ thống) + Personal knowledge (cá nhân: notes, word bank, collections, drafts, recordings, import, export, offline)
- Band framework & progression (readiness, exam readiness, khuyến nghị mềm)
- Goal & exam plan (target band/date, weekly/daily goal, countdown, checklist, timeline)
- Search & resource center
- Đa ngôn ngữ cho UI và AI response; nội dung IELTS giữ nguyên tiếng Anh
- AI Governance: confidence scoring, gold-standard eval benchmark, drift/bias monitoring, anti-gaming detection (backend invisible)
- Colab quản lý, kiểm duyệt, publish nội dung + xử lý content feedback
- Admin quản lý hệ thống, user, billing và permission

### Out of scope

- Live class trực tiếp
- Video call 1:1 real-time
- Human examiner / human-in-the-loop trong đánh giá (AI là nguồn chấm điểm duy nhất)
- Community forum phức tạp
- Gamification nặng kiểu game (leaderboard, badge hierarchy, avatar)
- Marketplace ngoài phạm vi học IELTS

### Scope note

- AI là nguồn chấm điểm duy nhất cho Writing, Speaking và Pronunciation; hệ thống tự chấm 100%, không có con người can thiệp (no human-in-the-loop) ở bất kỳ tầng nào của evaluation
- Không tồn tại vai trò human examiner hay human reviewer trong flow đánh giá; mọi band score, feedback và recommendation đều do AI phát ra
- Chất lượng chấm được đảm bảo bằng calibration trên dataset chuẩn, monitoring độ nhất quán, tuning model và AI Governance (`06-engines.md`), chứ không bằng con người chấm lại từng bài
- AI Examiner là nguồn chấm Speaking duy nhất, không phải "mô phỏng" hay "thay thế" ai khác
- Pronunciation analysis là kết quả của speech engine, được tối ưu liên tục để tiệm cận độ chính xác của hệ thống chuẩn
- Colab chỉ can thiệp ở tầng content, không bao giờ ở tầng evaluation
- Admin chỉ vận hành hệ thống (user, billing, audit), không bao giờ chấm bài hay override kết quả AI
- Band framework là core IP của sản phẩm, không nên chỉ là metadata phụ
- Band progression không khóa cứng việc học; hệ thống khuyến nghị, cảnh báo và đo readiness thay vì ép learner đi theo một đường duy nhất
- Band access chỉ nên dùng để mô tả trạng thái truy cập hoặc khuyến nghị, không dùng để khóa toàn bộ kiến thức của band cao hơn
- Question type là đơn vị học quan trọng ngang với lesson
- Đa ngôn ngữ chỉ áp dụng cho giao diện và AI response; nội dung IELTS (audio, passage, question, writing task, speaking prompt) luôn giữ tiếng Anh nguyên bản vì learner cần học với ngôn ngữ thi thật
- AI response language tuân theo ngôn ngữ user chọn, giúp learner hiểu feedback và giải thích dễ dàng; ngôn ngữ AI không ảnh hưởng đến kết quả chấm (band score vẫn chuẩn theo IELTS rubric)
- Personal Knowledge là không gian cá nhân của từng user; nội dung Colab publish đi vào hệ thống chung (Knowledge Assets), còn Personal Knowledge là nơi user tự thu thập và tổ chức lại theo nhu cầu riêng
- Assessment History là nguồn sự thật duy nhất về toàn bộ kết quả đánh giá của learner, feed ngược về Personalization và Progress; tránh duplicate timeline rải rác ở nhiều nơi
- Content Taxonomy Depth: FSRS, Adaptive Practice, Gap Analysis, Learning Insights và AI Error Analysis chỉ chính xác khi Colab tagging siêu chi tiết (band, micro-skill, question type, distractor, paraphrase, grammar) — chi tiết `05-content.md`
- AI Governance là tầng kiểm soát chất lượng **được thiết kế** cho sole evaluator: confidence scoring, gold-standard benchmark, drift/bias monitoring, anti-gaming detection — tất cả invisible với user, không mở lại luồng human-in-the-loop. Các control chưa active nếu thiếu corpus/threshold/run — chi tiết `06-engines.md`

## Product success contract

### North Star

**Weekly Meaningful Progress** — số learner active mỗi tuần có ít nhất một bằng chứng tiến bộ thật: giảm error recurrence, hoàn thành retest với kết quả tốt hơn, cải thiện readiness hoặc tạo được output Writing/Speaking tốt hơn.

### Metric tree

| Tầng | Chỉ số | Guardrail |
|---|---|---|
| Activation | hoàn thành placement hoặc first meaningful session trong 24 giờ | không ép placement dài; cho phép quick start |
| Retention | D7/W4 retention, meaningful study days, comeback rate | notification opt-out, không phạt bỏ streak |
| Learning | readiness lift, error recurrence, retest gain, skill balance | không tối ưu theo minutes hoặc số câu đơn thuần |
| Trust/quality | calibration error, low-confidence rate, helpfulness, content report rate | low-confidence phải có trạng thái và recovery |
| Economics | cost/active learner, cost/evaluation, cache hit, model escalation rate | vượt budget thì degrade có kiểm soát, không âm thầm giảm chất lượng |

### Retention promise

- Mỗi lần quay lại phải thấy: **mình đang ở đâu, hôm nay nên làm gì, làm xong sẽ cải thiện gì**.
- Có phiên `5–10 phút` cho ngày bận, phiên chuẩn cho ngày bình thường và phiên sâu cho ngày có nhiều năng lượng.
- Sau thời gian vắng mặt, hệ thống tạo **comeback plan** ngắn, không dồn toàn bộ backlog và không dùng ngôn ngữ trách móc.
- Notification chỉ gửi khi có giá trị rõ ràng, theo preference, quiet hours, frequency cap và mức độ ưu tiên.

### Quality promise

- Feedback phải nêu evidence, lỗi/điểm mạnh, hành động tiếp theo và cách kiểm chứng lại.
- Score luôn gắn với rubric version, model version, timestamp và confidence state.
- Không ghi kết quả có trạng thái `invalid`, `low_confidence` hoặc `anti_gaming_review` vào readiness như kết quả bình thường.

### Cost principles

- Rẻ nhất ở nơi không làm giảm outcome: cache explanation, batch tagging/analytics, precompute queue và dùng model nhỏ cho routing/classification.
- Chỉ dùng model lớn cho task có tác động trực tiếp tới learning outcome hoặc evaluation quality.
- Mọi request có budget, quota, timeout, retry limit, observability và fallback rõ ràng.

## Runtime contract boundary

Ba contract dưới đây là phần bắt buộc của blueprint trước khi build, nhưng được giữ mỏng và có mục đích rõ:

- **Runtime State Model** (`02-architecture.md`) quyết định Home, plan, recommendation, notification và recovery theo state vector đa trục.
- **Event Contract** (`03-features.md`) là SSOT cho fact product/learning, analytics, experimentation và outcome measurement.
- **Failure Contract** (`06-engines.md`) quy định retry, fallback, data safety, quota, user-facing state và telemetry cho mọi failure.

Không được dùng role, UI click hoặc exception text thay thế cho ba contract này.
