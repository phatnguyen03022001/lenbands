# IELTS Knowledge Framework

Bộ khung kiến thức IELTS (invariant) — **không chứa asset**, chỉ chứa framework. Đây là "bộ gen" của product; mọi asset, lesson, evaluation, review card phải trace về framework này.

## Mục đích

Trước khi có bộ này, blueprint có capability + coverage contract nhưng thiếu **IELTS domain depth**. Agent spawn Listening/Reading/Speaking slice phải tự suy luận grammar point, error type, micro-skill, review rule → hallucinate. Bộ này chặn: mọi thực thể IELTS (grammar point, error, micro-skill, topic, question type, band requirement) phải có id trong framework.

## Files (10)

| File | Nội dung | Feed |
|---|---|---|
| `band-descriptor-map.md` | 4 criterion × 9 band × Writing/Speaking descriptor chính thức | `EVAL.Writing/Speaking`, `BAND.Requirement`, `BAND.Map` |
| `skill-questiontype-band.md` | Matrix skill × question/task type × band difficulty | `05-content.md`, `BAND.Map`, `LEARN.QuestionTypes` |
| `microskill-enum.md` | Micro-skill enum versioned theo question type | `learning_design_profile.target_micro_skills`, `BAND.Map` micro-skill row, `COACH.ErrorAnalysis` |
| `error-taxonomy.md` | Error id theo skill + criterion impact + band signal | `COACH.ErrorAnalysis`, `REVIEW.MistakeNotebook` tag, `BAND.Map` ⚠/✗ |
| `review-mapping.md` | Error → review rule (loại ôn + tần suất + FSRS card kind) | `REVIEW.SmartQueue`, `REVIEW.MistakeNotebook`, `REVIEW.FSRS` |
| `grammar-band-framework.md` | 47 grammar point × band introduce/master | `KA.Grammar`, `BAND.Map` grammar row, FSRS card source |
| `vocab-collocation-topic.md` | 10 topic + collocation framework + target count theo band | `KA.Vocabulary/Collocation`, `BAND.Map` vocab/collocation row |
| `speaking-parts-framework.md` | Part 1/2/3 behavior + pronunciation depth + examiner rules | `EVAL.Speaking`, `EVAL.Examiner`, `EVAL.Pronunciation`, `LEARN.Speaking` |
| `writing-task-framework.md` | Task 1 Academic/General + Task 2 structure + requirement | `LEARN.Writing`, `EVAL.Writing`, `BAND.Map` writing row |
| `exam-module-differences.md` | Academic vs General + raw score → band conversion + normalization | `PRACTICE.MockTest`, `BAND.ExamReadiness`, `GOAL.Target` module routing |

## Nguyên tắc dùng

1. **Controlled vocabulary**: id trong framework là hợp lệ duy nhất. Ngoài enum → `unknown_*`, không tự đặt tên.
2. **Versioned**: mỗi file có `version`. Thêm = minor, sửa = patch, bỏ = deprecated (không xóa).
3. **Không tự suy luận**: nếu framework thiếu, báo + flag Colab bổ sung. Không bịa band requirement, grammar point, error id.
4. **Source of truth**: descriptor/band/quy đổi theo public IELTS oficial. Nếu mâu thuẫn, oficial thắng.
5. **Không chứa asset**: file này định nghĩa khung; từ/collocation/lesson cụ thể là `KA.*` asset do Colab author.
6. **Inline ownership — graph/outcome thuộc về node, không thuộc về file trung tâm**:
   - Mỗi node có schema riêng; `depends_on`, `done_when`, `can_statement` chỉ được claim khi node đã khai báo đủ. Bảng summary không được coi là node hoàn chỉnh.
   - KHÔNG có `dependency-graph.md` hay `learning-outcome.md` làm SSOT. Đó là God file và vi phạm separation of concerns.
   - Graph/index toàn cục sẽ là projection sinh tự động ở `artifacts/operations/catalogs/dependency-graph.yaml` và `learning-outcome-index.yaml` khi generator được implement. Các file hiện tại là sample `draft`, không phải build input; quyền **viết** nằm ở node.
   - Quy tắc: sửa edge/threshold = sửa node trong framework → regenerate projection. Không sửa projection trực tiếp.

## Cách agent dùng

- Spawn Listening/Reading slice: dùng `skill-questiontype-band.md` + `microskill-enum.md` + `error-taxonomy.md` + `review-mapping.md`.
- Spawn Writing slice: + `writing-task-framework.md` + `band-descriptor-map.md`.
- Spawn Speaking slice: + `speaking-parts-framework.md` + pronunciation depth.
- Spawn Band Map data: dùng `grammar-band-framework.md` (grammar row) + `vocab-collocation-topic.md` (vocab/collocation row) + `skill-questiontype-band.md` (question type row) + `microskill-enum.md` (micro-skill row).
- Spawn Evaluation: dùng `band-descriptor-map.md` (criterion) + `writing-task-framework.md` (Task 1/2 requirement) + `speaking-parts-framework.md` (Part behavior).
- Spawn Mock Test: dùng `exam-module-differences.md` (quy đổi + normalization).

## Version

- `framework_version: 1.0.6` — metadata-governance hardening release; all 10 domain files expose an ordered, validator-enforced version record without changing controlled vocabulary.
- Bump version file cụ thể khi sửa file đó; bump framework_version khi thêm file.
- 2026-08-07: standardized per-file frontmatter, reconciled controlled vocabulary/event references, and released `1.0.1`; this is a semantic patch before spawn freeze, not evidence of calibration.
- 2026-08-07: clarified grammar `error_refs` versus prerequisite `depends_on` in the inventory projection and released `1.0.2`; this remains a framework correction, not calibration evidence.
- 2026-08-07: corrected Listening/Reading question-type inventory counts and released `1.0.3`; this remains a vocabulary correction, not calibration evidence.
- 2026-08-07: separated grammar prerequisites from `error_refs`, removed a duplicate band summary row, and released `1.0.4`; this remains a framework semantics correction, not calibration evidence.
- 2026-08-07: corrected `g_participle_clauses` taxonomy reference, converted Writing Task 1/combined criterion cells and `all_bands` into controlled values, and released `1.0.5`; this remains a validator/typing correction, not calibration evidence.
- 2026-08-07: completed per-file version records and made changelog ordering machine-verifiable in `1.0.6`; no IELTS node, threshold, calibration claim, or runtime evidence changed.
