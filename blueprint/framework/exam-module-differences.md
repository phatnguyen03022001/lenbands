---
version: 1.0.6
scope: framework
---

# Exam Module Differences (Academic vs General Training) + Score Conversion

Status: `framework` — định nghĩa khác biệt Academic vs General Training + bảng quy đổi raw score sang band cho Listening/Reading. Feed `PRACTICE.MockTest`, `BAND.ExamReadiness`, `LEARN.Path` module routing.

## Academic vs General Training — khác biệt

IELTS có 2 module: **Academic** (du học, đăng ký chuyên môn) và **General Training** (di cư, làm việc). Khác biệt ở 3 skill:

| Skill | Academic | General Training |
|---|---|---|
| Listening | **Giống nhau** (cùng 4 section, cùng audio) | Giống Academic |
| Reading | 3 passage dài, scholarly (tạp chí, sách, journal) | 3 section: Section 1 (2-3 text ngắn everyday), Section 2 (2 text workplace), Section 3 (1 text dài general) |
| Writing | Task 1: mô tả chart/table/process/map/diagram. Task 2: essay academic | Task 1: letter (formal/semi/informal). Task 2: essay (giống AT nhưng topic đời sống hơn) |
| Speaking | **Giống nhau** | Giống Academic |

Module được learner chọn lúc setup (`GOAL.Target` phải có `exam_module: academic | general_training`). Toàn bộ path + content routing dựa vào field này.

## Module routing rule

| Capability | Academic | General Training |
|---|---|---|
| `LEARN.Reading` | passage scholarly, academic vocab | passage everyday/workplace |
| `LEARN.Writing` Task 1 | chart/table/process/map/diagram | letter (3 tone) |
| `LEARN.Writing` Task 2 | topic academic (vd education, technology, science) | topic đời sống (vd family, work, community) |
| `PRACTICE.MockTest` | full Academic | full GT |
| `KA.Vocabulary` | topic academic + all 10 topic | all 10 topic, thiên everyday |

Learner không mix module trong 1 path. Nếu chuyển module (rare), re-placement.

## Listening/Reading — raw score → band conversion

Listening và Reading chấm bằng answer key (objective). Band tính từ raw score qua **bảng quy đổi**. Bảng đổi nhẹ theo kỳ thi (curve), nhưng dùng benchmark chuẩn dưới đây làm default.

### Listening (40 câu) → band

| Band | Raw score range (approx) |
|---|---|
| 4.0 | 6-9 |
| 4.5 | 10-11 |
| 5.0 | 12-15 |
| 5.5 | 16-18 |
| 6.0 | 19-22 |
| 6.5 | 23-25 |
| 7.0 | 26-29 |
| 7.5 | 30-31 |
| 8.0 | 32-34 |
| 8.5 | 35-36 |
| 9.0 | 37-40 |

### Reading Academic (40 câu) → band

| Band | Raw score range (approx) |
|---|---|
| 4.0 | 4-5 |
| 4.5 | 6-7 |
| 5.0 | 8-11 |
| 5.5 | 12-13 |
| 6.0 | 14-18 |
| 6.5 | 19-22 |
| 7.0 | 23-25 |
| 7.5 | 26-28 |
| 8.0 | 29-31 |
| 8.5 | 32-33 |
| 9.0 | 34-40 |

### Reading General Training (40 câu) → band

GT Reading raw → band **khó hơn AT** (cùng band cần nhiều câu đúng hơn, vì passage dễ hơn).

| Band | Raw score range (approx) |
|---|---|
| 4.0 | 6-8 |
| 4.5 | 9-11 |
| 5.0 | 12-14 |
| 5.5 | 15-18 |
| 6.0 | 19-22 |
| 6.5 | 23-25 |
| 7.0 | 26-29 |
| 7.5 | 30-31 |
| 8.0 | 32-33 |
| 8.5 | 34-35 |
| 9.0 | 36-40 |

Lưu ý: đây là benchmark chuẩn (Cambridge pattern). Curve thực có thể lệch ±1 câu.

## Answer normalization rules (Listening/Reading)

Answer key matching phải normalize trước khi so:

| Rule | Mô tả |
|---|---|
| Case-insensitive | "Paris" = "paris" = "PARIS" |
| Trim whitespace | " Paris " = "Paris" |
| Article optional (if allowed) | "a book" = "book" (tùy question, theo key config) |
| Plural sensitivity | theo key: strict (book ≠ books) hoặc lenient (theo instruction) |
| Alternative spelling | British vs American (colour/color) — theo key config |
| Number format | "1,000" = "1000" = "one thousand" (tùy key) |
| Word limit | instruction "NO MORE THAN TWO WORDS" → answer > 2 từ = wrong |
| Hyphenation | "well-known" = "well known" (theo key, default yes) |

### Number/date/phone/currency normalization (Listening depth)

Listening có nhiều format number cần normalize riêng (vì learner nghe rồi viết, dễ sai format):

| Loại | Quy tắc | Ví dụ |
|---|---|---|
| Date | chấp nhận nhiều format: DD/MM/YYYY, DD Month YYYY, Month DD | "5 March 2024" = "05/03/2024" = "March 5, 2024" |
| Phone | chấp nhận spaces/dashes, leading 0 optional theo key | "020 7946 0958" = "0207-946-0958" |
| Currency | symbol (£/$/€) optional nếu key không yêu symbol; "£500" = "500 pounds" = "five hundred pounds" (tùy key config) | "£15.50" = "15.50" (nếu key lenient) |
| Decimal | "0.5" = "point five" = "nought point five" | — |
| Time | "9.30" = "9:30" = "half past nine" (tùy key) | — |
| Age | "18-year-old" = "18 years old" = "18" | — |
| Quantity + unit | "2 kilograms" = "2 kilos" = "2 kg" = "2" (nếu key chỉ cần số) | — |
| Ordinal | "3rd" = "third" = "3" (tùy key) | — |

Key config quyết định strict/lenient:
```yaml
correct_answer:
  - value: "15 March"
  - value: "March 15"
  - value: "15th March"
  normalize: [lowercase, trim, date_flexible]
```

Listening-specific error:
| error_id | Mô tả |
|---|---|
| `L_ans_number_format` | Sai format number (date/phone/currency) dù nghe đúng số | `L_number_date_capture` |
| `L_ans_unit_missing` | Thiếu đơn vị (kg, pounds) khi key yêu cầu | `L_number_date_capture` |

Key structure (trong asset `question_id`):

```yaml
question_id: R_q_482
correct_answer:
  - value: "environment"
  - value: "the environment"
  - value: "environments"
  - rule: lenient_plural
  - normalize: [lowercase, trim]
word_limit: 2
explanation_ref: ...
```

## Overall band calculation (IELTS rule)

Overall band = **average của 4 skill**, rounded to nearest 0.5 (rounding规则: .25 → .5, .75 → next whole).

| Average | Overall band |
|---|---|
| x.00-x.24 | x.0 |
| x.25-x.74 | x.5 |
| x.75-x.99 | (x+1).0 |

Ví dụ: L6.5 R6.0 W6.0 S6.5 → avg 6.25 → overall **6.5**.

## Mock test scoring (PRACTICE.MockTest)

- Listening/Reading: auto-score qua answer key + bảng quy đổi.
- Writing/Speaking: AI score qua `EVAL.Writing`/`EVAL.Speaking` + descriptor.
- Overall: tính theo rule trên.
- Output: per-skill band + overall + raw score (L/R) + criterion band (W/S).

## Band cap vs reading level

IELTS band không = CEFR 1-1 nhưng tương quan:

| IELTS Band | CEFR approx |
|---|---|
| 4.0 | A2+ |
| 4.5-5.0 | B1 |
| 5.5-6.0 | B1+ / B2 |
| 6.5-7.0 | B2 / B2+ |
| 7.5-8.0 | C1 |
| 8.5-9.0 | C1+ / C2 |

Dùng làm cross-reference cho vocab `cefr` field, không thay thế band.

## Cách dùng

- `GOAL.Target` có `exam_module`: định direction toàn path.
- `LEARN.Path` route content theo module.
- `PRACTICE.MockTest` chọn module, chấm theo bảng quy đổi + descriptor.
- `BAND.ExamReadiness` tính overall theo rule IELTS.
- `EVAL.Writing` biết task type Academic vs GT → chấm structure khác.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.

- `version: 1.0.1` — reconciled answer-normalization error references.
- `version: 1.0.6` — normalized the per-file release record; module and score rules are unchanged.
- Bảng quy đổi cập nhật khi Cambridge release pattern mới: patch + note.
- Thêm module (vd Life Skills — ngoài scope hiện tại): minor.

## Không tự suy luận

- Bảng quy đổi phải khớp file này; không tự bịa "L 30 = band 7.5".
- Module phải là `academic` hoặc `general_training`, không tự đặt module khác.
- Answer normalization theo rule trên; key ngoài rule → báo `unknown_normalization`.
