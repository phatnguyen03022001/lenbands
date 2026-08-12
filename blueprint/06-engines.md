# 06 — Engines (Learning Engine Layer)

File này mô tả **implementation** của các engine cung cấp thuật toán cho Capability Layer (`03-features.md`). Đều thuộc cùng một lớp "Learning Engine". FSRS không tách riêng — nó là một implementation của engine.

```text
Learning Engine
  ├── FSRS Engine          → implement REVIEW.FSRS
  ├── Evaluation Engine    → implement EVAL.Writing/Speaking/Pronunciation/Examiner
  ├── Recommendation Engine→ implement PERSONAL.Recommendation/NextBestAction/Insights
  ├── Quality & Cost Plane → implement OPS.*
  └── Governance Engine    → implement GOVERNANCE.*
```

---

## 1. FSRS Engine (implement `REVIEW.FSRS`)

FSRS (Free Spaced Repetition Scheduler) là thuật toán spaced repetition chính, dùng cho mọi review card (vocabulary, grammar, collocation, mẫu câu, câu hỏi sai).

### Tại sao FSRS

- Tự tối ưu interval theo lịch sử review từng learner, ít yêu cầu tự đánh giá lại so với SM-2
- Review forecast chính xác hơn
- Personalization qua optimization (tune 19 tham số per learner)
- Open source, có benchmark tốt (spec FSRS-5.x: https://github.com/open-spaced-repetition/fsrs4anki)

### Card model

| Trường | Mô tả |
|---|---|
| `card_id`, `user_id` | id |
| `content_ref` | link tới vocab/grammar/collocation/question |
| `content_type` | vocab/grammar/collocation/template/question |
| `due` | timestamp review tiếp theo |
| `stability` | số ngày nhớ với xác suất cao |
| `difficulty` | độ khó cảm nhận (1-10) |
| `elapsed_days` | ngày kể từ review cuối |
| `scheduled_days` | interval lên lịch |
| `reps` | số lần đã review |
| `lapses` | số lần quên |
| `state` | New / Learning / Review / Relearning |
| `last_review` | timestamp |

### Card state machine

```text
New
  ↓ (first review)
Learning
  ↓ (graduated)
Review
  ↓ (forgot)
Relearning
  ↓ (regraduated)
Review
```

### Rating

- **Again (1)** — hoàn toàn quên → Relearning
- **Hard (2)** — nhớ nhưng khó → tăng difficulty
- **Good (3)** — nhớ bình thường → interval theo FSRS
- **Easy (4)** — nhớ rất dễ → tăng interval mạnh, giảm difficulty

### Core parameters

19 tham số optimize per learner:
- `w0-w17` — weights cho stability/difficulty init
- `request_retention` — tỷ lệ ghi nhớ mong muốn (default 0.9, config per user)
- `maximum_interval` — interval tối đa (default 36500 ngày)

### Stability formula (concept)

```text
Stability mới = f(stability cũ, difficulty, rating, retrievability)
```

- Again → stability giảm mạnh / reset
- Hard → tăng nhẹ
- Good → tăng theo factor
- Easy → tăng mạnh

### Review flow

```text
Card due
  ↓
Learner xem mặt trước → tự recall → xem mặt sau
  ↓
Rating (Again/Hard/Good/Easy)
  ↓
FSRS tính stability, difficulty, due mới
  ↓
Cập nhật card → ra khỏi queue đến due mới
```

### Card sources

- Vocabulary từ Knowledge Assets (`KA.Vocabulary`)
- Collocation (`KA.Collocation`)
- Grammar rule (`KA.Grammar`)
- Wrong question từ Mistake Notebook (`REVIEW.MistakeNotebook`)
- Speaking template phrase
- Writing template phrase
- Pronunciation drill item

### FSRS Optimization

- MVP: dùng bộ tham số global/cohort đã kiểm định; không optimize per learner khi dữ liệu chưa đủ.
- Khi đạt tối thiểu `1000` review hợp lệ và đủ đa dạng rating, chạy optimization offline.
- V1: tune theo cohort hoặc skill; chỉ áp dụng nếu validation set không giảm retention/recall.
- V2: per-learner optimization, có minimum sample, rollback và model/version audit.
- Re-optimize định kỳ nhưng chỉ promote tham số mới qua `OPS.ReleaseGate`.

### Review Forecast

- Dự báo card due 7/30 ngày tới
- Cảnh báo retention overload (forecast quá cao)
- Gợi ý điều chỉnh `request_retention`

### Integration points

- Vocabulary lesson hoàn thành → auto tạo card
- Wrong question → option add vào SRS
- Vocabulary Explanation (`COACH.VocabularyExplanation`) → nút add to SRS
- Daily notification nhắc review due (`NOTIF.SRS`)
- Weekly goal có thể bao gồm SRS review target

---

## 2. Evaluation Engine (implement `EVAL.*`)

AI sole scorer, chấm 100%, không human-in-the-loop. Governance Engine là control design (mục 5 dưới), không phải bằng chứng quality đang active.

### Sub-engines

| Engine | Implement | Input | Output |
|---|---|---|---|
| Writing Scorer | `EVAL.Writing` | essay text (+ task prompt) | band 4 criteria (TR, CC, LR, GRA), overall band, sentence-level feedback |
| Speaking Scorer | `EVAL.Speaking` | audio → transcript + features | band 4 criteria (FC, LR, GRA, PR), overall band |
| Pronunciation Scorer | `EVAL.Pronunciation` | audio | phoneme score, word/sentence stress, intonation, mispronunciation list |
| Examiner | `EVAL.Examiner` | user answer (Part 1/2/3) | follow-up question generated in context |
| Band Predictor | `EVAL.BandPrediction` | history of attempts | predicted band + confidence |
| Rewrite Suggester | `EVAL.RewriteSuggestion` | essay draft | sentence-level rewrite suggestions |

### Context injection

`COACH.Tutor` và Coach khác nhận **context hiện tại của user**:

```text
context = {
  current_skill,
  current_passage_id,
  current_question_id,
  current_question_type,
  user_history (sai dạng này bao nhiêu lần),
  user_band
}
→ inject vào prompt
→ trả lời trong ngữ cảnh
```

### Scoring rubric

- Tuân thủ IELTS public band descriptors (TR/CC/LR/GRA cho Writing; FC/LR/GRA/PR cho Speaking).
- Output có **Confidence Score** (`GOVERNANCE.ConfidenceScore`) cho mỗi bài.
- Low-confidence → flag backend (invisible với user).

### Evaluation result contract

Mọi evaluation result phải lưu cùng:

| Field | Mục đích |
|---|---|
| `rubric_version` | biết rubric nào tạo ra score |
| `model_version` | tái lập và audit kết quả |
| `quality_status` | `accepted`, `low_confidence`, `insufficient_evidence`, `invalid` |
| `evaluation_state` | `none`, `submitted`, `processing`, `scored`, `low_confidence`, `invalid`, `anti_gaming_review`, `failed` |
| `evidence` | câu/audio segment/feature làm căn cứ |
| `feedback_actions` | lesson/drill/rewrite được đề xuất |
| `quality_flags` | anti-gaming, audio quality, off-topic, missing input |
| `cost_metadata` | model tier, token/audio usage, cache hit, latency |

Score chỉ feed vào readiness, history và recommendation khi state hợp lệ. Low-confidence phải có recovery hoặc resubmission path; không âm thầm biến thành band bình thường.

### Failure Contract

Failure là một phần của product behavior, không chỉ là log kỹ thuật. Mọi service/engine phải trả cùng một failure envelope:

```json
{
  "failure_code": "EVAL_TIMEOUT",
  "failure_version": "1.0.0",
  "source": "transcription|scoring|recommendation|sync|quota",
  "severity": "recoverable|degraded|terminal",
  "retryable": true,
  "retry_after_seconds": 30,
  "user_state": "processing|delayed|unavailable|action_required",
  "data_action": "preserve|discard_invalid|await_sync",
  "fallback": "queue_retry|basic_result|save_draft|none",
  "quota_effect": "charged|not_charged|reserved_released",
  "telemetry_event": "evaluation_failed",
  "trace_id": "id"
}
```

### Failure taxonomy

Concrete P0 failure codes và mapping sang user-safe HTTP error nằm trong `artifacts/engineering/contracts/runtime/failure-taxonomy-contract.md`. Artifact đó là registry duy nhất; service không tự tạo code mới trong implementation.

### Failure rules

- `retryable=true` luôn đi kèm retry limit, backoff, idempotency key và `retry_after`.
- Không retry vô hạn hoặc charge learner nhiều lần vì một failure nội bộ.
- Preserve user-created data trước khi xử lý fallback; chỉ discard dữ liệu được đánh dấu invalid.
- UI dùng user state dễ hiểu; error code, trace ID và provider detail chỉ nằm trong support/admin view.
- Mọi failure phát event tương ứng; không dùng exception text làm analytics contract.
- Failure policy phải được test cho timeout, duplicate submit, network loss, quota exhaustion, model rollback và app restart.

### Anti-gaming

- `GOVERNANCE.AntiGaming` phát hiện: sample essay có sẵn, plagiarism, generated-submission signal.
- Implementation: similarity search vs corpus + AI-generated detector.
- Khi flag: thông báo nhẹ cho user + không ghi band vào history (hoặc ghi với flag).

Anti-gaming là tín hiệu rủi ro, không phải bằng chứng tuyệt đối. Hệ thống phải có false-positive monitoring, giải thích trung tính, quyền submit lại và policy rõ ràng cho việc ghi/không ghi kết quả.

---

## 3. Recommendation Engine (implement `PERSONAL.*`)

Biến kết quả học thành next best action, insights, adaptive plan.

### Inputs

- Assessment History (`HISTORY.*`)
- Review state (`REVIEW.FSRS`, `REVIEW.MistakeNotebook`)
- Goal (`GOAL.*`)
- Band Framework (`BAND.*`)
- Content taxonomy (`05-content.md`)
- Current energy/time, modality và notification preferences (`STUDY.CheckIn`, `PROGRESS.Wellbeing`)

### Outputs

| Capability | Logic |
|---|---|
| `PERSONAL.NextBestAction` | "hôm nay nên làm X" — dựa trên due queue + weakness + goal |
| `PERSONAL.Insights` | "bạn sai Matching Headings vì thiếu paraphrase" — aggregate theo `question_type` + `micro_skill` + `paraphrase_pattern` |
| `PERSONAL.AdaptivePlan` | điều chỉnh Learning Path theo progress |
| `PERSONAL.WeaknessPractice` | chọn câu theo weakness tag |
| `PERSONAL.GapAnalysis` | gap giữa current band và target band theo descriptor |

### Insights generation

```text
Aggregate wrong answers by (question_type, micro_skill, paraphrase_pattern)
   ↓
Tìm pattern yếu nhất (frequency + recency)
   ↓
Map sang natural language insight
   ↓
Recommend action (học lesson nào, luyện dạng nào)
```

Yêu cầu taxonomy depth (`05-content.md`) — thiếu tag = không sinh được insight.

### Cold start và safety

- Cold start dùng self-report + placement + curated baseline, không giả vờ cá nhân hóa khi chưa có evidence.
- Mỗi recommendation phải có lý do, confidence và alternative nhẹ hơn.
- Không recommend thêm workload khi learner có tín hiệu quá tải hoặc backlog vượt capacity.

---

## 4. Quality & Cost Control Plane (implement `OPS.*`)

Đây là lớp chạy ngang qua FSRS, Evaluation, Recommendation, Content và Experience.

### Model routing ladder

```text
Request
  ↓
Rule / deterministic lookup
  ↓ miss
Cache / precomputed result
  ↓ miss
Small model hoặc batch model
  ↓ low confidence / high-risk task
Large model / specialist scorer
  ↓ failure
Safe fallback + retry queue + trạng thái rõ cho user
```

### Quality gates

- **Content**: correctness, taxonomy completeness, calibration, accessibility, rights.
- **Evaluation**: rubric agreement, calibration error, confidence coverage, drift/bias, reproducibility.
- **Recommendation**: actionability, completion, retest lift, error recurrence và overload rate.
- **Experience**: first meaningful action, recovery success, notification fatigue, accessibility.

Không promote model/content chỉ vì accuracy offline tốt; phải có outcome và cost impact trên cohort holdout.

### Cost controls

| Control | Policy |
|---|---|
| Cache | cache theo normalized input + version; invalidate khi content/rubric/model đổi |
| Batch | auto-tag, embeddings, weekly recap và analytics chạy batch |
| Routing | rule/small model cho classification; large model cho high-value/high-risk |
| Quota | token, audio phút, retries và concurrent jobs theo plan/capability |
| Budget | hard/soft budget theo learner, feature và cohort; alert trước khi vượt |
| Fallback | degraded but useful: save draft, basic explanation, delayed result, retry queue |
| Observability | đo cost cùng quality để phát hiện “rẻ hơn nhưng học kém hơn” |

### Cost-quality SLOs

- Không tăng cost/active learner nếu không tạo tăng outcome có ý nghĩa.
- Không hạ model tier cho evaluation high-risk chỉ để đạt budget.
- Request quá budget phải fail gracefully, không retry vô hạn.
- Mọi thay đổi routing phải được canary, rollback và ghi vào `GOVERNANCE.AuditTrail`.

### Cache, worker và API reliability

Đây là invariant product/runtime, không phải lựa chọn library:

- Cache chỉ tăng tốc; canonical state vẫn ở runtime store. Cache miss hoặc cache outage không được thay đổi entitlement, score, review schedule hay làm mất draft.
- Cache key của dữ liệu learner phải contain subject scope + contract/version; tuyệt đối không cache raw essay/audio vào shared key.
- Evaluation, sync và batch chạy at-least-once. Idempotency key + durable state quyết định side effect đúng một lần ở domain layer; queue không tự đảm bảo điều đó.
- Mọi job phải có deadline, max attempts, backoff, DLQ/replay path, trace/correlation ID, quota/cost attribution và owner.
- API mutation phải idempotent, return semantic user-safe failure và hỗ trợ migration backward-compatible. OpenAPI chỉ là representation của HTTP contract; không thay thế data/event/failure contract.

---

## 5. Governance Engine (implement `GOVERNANCE.*`)

Backend invisible, thiết kế để kiểm soát chất lượng của sole evaluator mà không mở luồng human-in-the-loop; chưa phải quality guarantee khi thiếu corpus, threshold và benchmark run thật.

### Sub-engines

| Engine | Implement | Mô tả |
|---|---|---|
| Confidence Scorer | `GOVERNANCE.ConfidenceScore` | mỗi bài chấm có confidence; low → flag |
| Gold-Standard Benchmark | `GOVERNANCE.GoldStandardBenchmark` | proposal: chấm lại corpus examiner-graded theo cadence/kích thước do founder approve, đo độ lệch (variance/bias) |
| Drift Detector | `GOVERNANCE.DriftDetection` | phát hiện model chấm lệch chuẩn theo thời gian |
| Bias Monitor | `GOVERNANCE.BiasMonitoring` | chênh lệch chấm theo nhóm user/dạng bài/band |
| Anti-Gaming | `GOVERNANCE.AntiGaming` | canonical owner; `EVAL.AntiGaming` chỉ là deprecated alias |
| Audit Trail | `GOVERNANCE.AuditTrail` | log calibration, model version, mọi thay đổi |

### Workflow

```text
Mỗi bài chấm (EVAL.*), khi route đã qua release gate
   ↓
Gắn Confidence Score
   ↓
[Low confidence] → Flag → chạy qua pipeline calibration lại (invisible)
   ↓
Cadence benchmark theo corpus/threshold đã founder approve
   ↓
Đo drift/bias → nếu vượt threshold → re-tune model
   ↓
Audit Trail ghi lại
   ↓
Governance Dashboard hiển thị cho Admin (ADMIN.GovernanceDashboard)
```

### Tại sao không phải human review

- Triết lý sole evaluator (`01-product.md`): user thấy "100% AI".
- Mục tiêu kiểm soát chất lượng là **data-driven governance**, không mở human review runtime; cơ chế này chỉ có hiệu lực sau khi có corpus, threshold và run thật.
- Calibration dùng gold-standard dataset nếu founder có rights/provenance và run thật — đây là "human in the dataset", không phải "human in the loop".

### Key metrics

| Metric | Ý nghĩa | Threshold gợi ý |
|---|---|---|
| Mean Absolute Error vs gold | độ lệch trung bình | candidate `< 0.5 band`; chưa approve |
| Low-confidence rate | % bài flag | candidate `< 5%`; chưa approve |
| Drift (month over month) | độ lệch theo thời gian | candidate alert threshold; chưa active cho tới khi founder approve benchmark baseline |
| Bias (group diff) | chênh lệch theo nhóm | candidate alert; chưa approve |
| Anti-gaming catch rate | % sample/AI-detected | track (không có threshold cố định) |

## Cross-references

- Capability id: `03-features.md`
- Taxonomy feed: `05-content.md`
- UX recovery khi AI fail: `04-experience.md` § Error Recovery
- Conventions (no AI label): `07-conventions.md`
