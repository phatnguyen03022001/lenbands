# 07 — Conventions

File này chứa các **cross-cutting convention** áp đặt lên mọi file trên (naming, icon, accessibility, localization, privacy). Đây là "luật chơi" thống nhất, không phải feature.

## 1. UI Naming & Icon Convention (No-AI-label)

### Nguyên tắc

Trong docs dùng chữ "AI" ở capability để dev hiểu nguồn gốc (calibration, model, engine). Trong **UI người dùng cuối** không dùng chữ "AI" và không dùng icon AI. User chỉ thấy tên chức năng thuần túy. Việc này nâng cao trải nghiệm: user không cần quan tâm công nghệ bên dưới, chỉ cần kết quả.

Quy tắc này chỉ áp dụng cho primary product label. Ở Privacy, Help, consent, evaluation detail và error state phải minh bạch rằng kết quả được tạo bởi hệ thống tự động, giới hạn độ tin cậy và cách xử lý dữ liệu.

### Quy tắc

- Không prefix "AI" trong label, nút bấm, menu, tên tab
- Không icon tượng trưng cho AI (tia sáng ✨, robot 🤖, não 🧠)
- Dùng icon chức năng (bút, mic, bảng điểm, người hướng dẫn, bóng đèn)
- Docs giữ "AI Writing Evaluation (sole scorer)" ở capability id; UI hiển thị "Writing Evaluation"

### Mapping docs capability → UI label

| Capability id | UI hiển thị |
|---|---|
| `EVAL.Writing` | Writing Evaluation |
| `EVAL.Speaking` | Speaking Evaluation |
| `EVAL.Pronunciation` | Pronunciation Evaluation |
| `EVAL.Examiner` | Examiner |
| `COACH.AnswerExplanation` | Answer Explanation |
| `COACH.VocabularyExplanation` | Vocabulary Explanation |
| `COACH.DistractorExplanation` | Distractor Explanation |
| `COACH.ListeningCoach` | Listening Coach |
| `COACH.ReadingCoach` | Reading Coach |
| `COACH.Feedback` | Feedback |
| `COACH.ErrorAnalysis` | Error Analysis |
| `COACH.Recommendation` | Recommendation |
| `COACH.Tutor` | Tutor |
| `EVAL.BandPrediction` | Band Prediction |
| `EVAL.RewriteSuggestion` | Rewrite Suggestion |
| `PERSONAL.Insights` | Insights |
| `PERSONAL.NextBestAction` | Next Step (hoặc "Gợi ý tiếp theo") |
| `GOVERNANCE.*` | (invisible — không hiển thị với user) |

### Ví dụ icon

| Capability | Icon |
|---|---|
| Writing Evaluation | bút chì / tờ giấy chấm điểm |
| Speaking Evaluation | mic |
| Examiner | người hỏi / tai nghe |
| Tutor | người hướng dẫn / bóng đèn |
| Band Prediction | biểu đồ / đích |
| FSRS review | thẻ flashcard / vòng lặp |

## 2. Accessibility (a11y)

Áp dụng cross-cutting, không phải feature riêng.

### Listening

- Transcript luôn có
- Subtitle đồng bộ audio
- Keyboard navigation đầy đủ
- Playback speed (0.75x–1.5x)
- Phím tắt play/pause/seek

### Reading

- Highlight, underline bằng keyboard
- Dark mode
- Font size adjustable
- Contrast đủ (WCAG AA)

### Writing

- Autosave (không mất draft)
- Word count realtime
- Keyboard-friendly editor

### Speaking

- Recording có visual indicator
- Transcript sau khi record
- Playback speed điều chỉnh được

### General

- Mọi action có keyboard equivalent
- Screen reader friendly (semantic HTML / ARIA)
- Color không là kênh thông tin duy nhất
- Focus visible
- Touch target ≥ 44px
- Reduced motion và pause/stop với animation, audio, notification
- Không dùng countdown, màu đỏ hoặc âm thanh để tạo áp lực ngoài exam mode

## 3. Localization

### Phạm vi

- **UI** đa ngôn ngữ (label, menu, nút, thông báo)
- **AI response** đa ngôn ngữ (giải thích đáp án, feedback Writing/Speaking, giải thích kiến thức)
- **Nội dung IELTS** luôn tiếng Anh nguyên bản, KHÔNG dịch (audio, passage, question, writing task, speaking prompt)

### Ngôn ngữ

- Mặc định: Tiếng Việt
- Đầu tiên: Tiếng Việt + English
- Sau: mở rộng theo demand

### Locale formatting

- Ngày/tháng/năm theo locale
- Số thập phân theo locale
- Giờ 12h/24h theo locale

### AI response language

- Tuân theo `user.preferred_language`
- Không ảnh hưởng kết quả chấm (band score vẫn chuẩn IELTS rubric)
- Giúp learner hiểu feedback bằng ngôn ngữ quen thuộc
- Giữ nguyên thuật ngữ IELTS cần thiết; có glossary thay vì dịch sai band/rubric term
- Fallback ngôn ngữ rõ ràng khi response chưa được bản địa hóa

## 4. Data Privacy

### Nguyên tắc

- User sở hữu dữ liệu của mình; có quyền export và delete
- Minh bạch về AI data usage
- Consent rõ ràng

### Capability

| id | Mô tả |
|---|---|
| `IDENTITY.Privacy` | Export Data, Delete Data, Consent, AI Data Usage |
| `IDENTITY.DeleteAccount` | Xóa tài khoản |
| `PKM.Export` | Export dữ liệu học (notes, word bank, history) |

### AI Data Usage disclosure

- User biết: dữ liệu bài làm có thể dùng để cải thiện model (nếu consent)
- User có thể opt-out
- Dữ liệu gold-standard cho benchmark được tách danh tính

### Data retention

- Drafts/Recordings: giữ theo user (cho đến khi delete account)
- Assessment History: giữ vĩnh viễn (cho portfolio/timeline)
- Review logs (FSRS): giữ vĩnh viễn (cần cho optimization)
- Account deletion: xóa PII, giữ aggregated anonymous cho benchmark (nếu consent)

### Trust and evaluation disclosure

- Trước lần submit đầu tiên, user biết input nào được xử lý, dùng cho mục đích gì và retention period.
- Mỗi kết quả có link “How this was assessed”: rubric, evidence, confidence state và model/rubric version ở mức dễ hiểu.
- Không dùng chữ “official score” nếu không phải kết quả thi thật; dùng “estimated band” hoặc “practice result”.
- Anti-gaming flag là trạng thái cần xử lý, không mặc định kết luận gian lận.
- User có thể export/delete dữ liệu theo policy; UI phải hiển thị trạng thái xử lý, không chỉ một nút biến mất.

## 5. Naming convention (cross-cutting)

- **Capability id**: `{DOMAIN}.{Capability}` (PascalCase) — vd `EVAL.Writing`, `REVIEW.SmartQueue`
- **File trong docs**: `NN-name.md` (snake hoặc kebab tùy team)
- **UI label**: clear, verb-first khi là action ("Evaluate Writing"), noun-first khi là entity ("Writing Portfolio")
- **Status value**: snake_case — `published`, `in_review`, `deprecated`
- **Evaluation state**: the learner aggregate may be `none`, `submitted`, `processing`, `scored`, `low_confidence`, `invalid`, `anti_gaming_review`, or `failed`. The persisted `Evaluation` entity and its HTTP projection start at `submitted` and therefore intentionally omit aggregate-only `none`.
- **Quality status**: `accepted`, `low_confidence`, `insufficient_evidence`, `invalid`; đây là quality axis, không gộp vào lifecycle state.
- **Runtime state**: snake_case theo từng trục — `active`, `inactive`, `paused`, `at_risk`, `achieved`; không gộp các trục thành một enum duy nhất
- **Event name**: past-tense fact, snake_case — `placement_completed`, `retest_completed`, `session_abandoned`
- **Event envelope SSOT**: `blueprint/03-features.md` § Event Contract; projection phải dùng `event_type`, `event_version` semver, `trace_id`, `user_id_hash`, `schema_version` và `privacy_class`.
- **Event `privacy_class`**: `account | learning | assessment | audio | billing | system | derived`.
- **Failure code**: uppercase namespace + reason — `EVAL_TIMEOUT`, `QUOTA_EXCEEDED`, `SYNC_CONFLICT`
- **Contract version**: tăng `event_version`/`failure_version` khi thay đổi schema hoặc semantics; giữ backward compatibility trong thời gian migration
- **Experiment/feature flag**: snake_case, có owner, start/end date, cohort và rollback condition

## Notification convention

- Mỗi notification phải có `reason`, `priority`, `channel`, `quiet_hours`, `frequency_cap`, `unsubscribe_action` và `expected_value`.
- Không gửi notification chỉ để tạo open/click; phải gắn với due item, result, goal hoặc comeback action.
- Không dùng guilt (“bạn đang tụt lại”, “mất streak”) hoặc giả khan hiếm.

## Performance and cost convention

- Mọi AI-backed interaction phải định nghĩa latency target, timeout, retry limit, fallback và cost budget.
- Ưu tiên cache, batch, precompute và model nhỏ; model lớn chỉ dùng khi risk/value biện minh.
- Hiển thị trạng thái chờ và kết quả trễ một cách trung thực; không block toàn bộ journey vì một AI call.
- Quality regression và cost regression đều là release blocker nếu vượt threshold đã cam kết.

## Runtime contract convention

- P0 job backend dùng Redis Streams consumer groups; đổi queue technology là Decision Artifact + migration/exit exercise, không là refactor âm thầm.
- Một mutation HTTP cần `Idempotency-Key` trừ read-only request hoặc khi contract nêu rõ lý do loại trừ.
- API phải trả correlation ID, error envelope versioned và `Retry-After` khi client có thể retry.
- Cache key/TTL/invalidation/revalidation phải được mô tả trong Cache Contract; không hard-code semantics chỉ trong implementation.
- Worker/job contract phải mô tả producer, consumer, payload classification, retry/DLQ/replay, concurrency, cancellation và idempotent effect.
- Request/response và telemetry không được chứa raw essay, recording, provider payload hoặc hidden reasoning ngoài data scope đã phê duyệt.

## Blueprint change control

| Thay đổi | Nơi ghi nhận | Approval tối thiểu | Tác động bắt buộc |
|---|---|---|---|
| Đổi invariant, scope hoặc role boundary | Blueprint + ADR nếu ảnh hưởng nhiều domain | Founder | Rà soát Artifact/roadmap liên quan |
| Thêm/đổi Capability ID | `03-features.md` | Founder | Cập nhật dependency, event, quality/cost profile |
| Đổi runtime state/event/failure semantics | Blueprint + engineering contract | Founder + engineering review | Version/migration/rollback |
| Đổi UI wording hoặc design representation | Artifact Design | Product review | Không đổi capability identity |
| Đổi implementation/provider | Artifact Decision/Contract | Engineering review | Quality/cost regression gate |

Quy tắc:

- Không sửa Blueprint chỉ để phản ánh implementation tạm thời.
- Capability ID đã published không đổi nghĩa; cần thay semantics thì tạo capability mới hoặc deprecate có migration.
- Artifact `approved` bị ảnh hưởng bởi thay đổi Blueprint phải về `review` trước khi dùng tiếp.
- Mọi change có privacy, quality hoặc legal impact phải reference decision/evidence phù hợp.

## Cross-references

- Nguyên tắc sole evaluator: `01-product.md`
- Capability id đầy đủ: `03-features.md`
- Engine (calibration, model): `06-engines.md`
