---
version: 1.0.6
scope: framework
---

# Skill × Question Type × Band Matrix

Status: `framework` — invariant vocabulary. Liệt kê đầy đủ question type/task type theo skill + band range phổ biến. Controlled vocabulary cho `05-content.md` và `BAND.Map`.

## Node schema (mỗi question type)

Mỗi question type đầy đủ là node sở hữu `requires` và `done_when` inline. Các bảng inventory chỉ khóa ID; khi thiếu node schema chi tiết, asset phải giữ `needs_review` và không được claim calibrated.

```yaml
question_type_id: R_matching_headings
name: Matching Headings
skill: reading
band_difficulty: high
requires:                              # micro-skill cần có để làm dạng này (từ microskill-enum.md)
  - R_skim_main_idea                   # hard mặc định nếu không ghi strength
  - id: R_paraphrase_recognition
    strength: hard_prerequisite
  - id: R_discourse_marker_tracking
    strength: recommended
done_when:
  accuracy_pct: 75                     # question type completion threshold
  recent_mock_pass: true               # ≥1 mock test gần nhất pass dạng này
```

Quy ước: `requires` tham chiếu micro-skill id từ `microskill-enum.md`. Question type không depend trực tiếp vào question type khác (độ độc lập cao), chỉ depend qua micro-skill chung.

## Listening — 10 question types

| id | Question type | Mô tả | Band range phổ biến |
|---|---|---|---|
| `L_form_completion` | Form Completion | Điền form (tên, số, địa chỉ) | 3.0–6.0 (Section 1) |
| `L_note_completion` | Note Completion | Điền note gap | 4.0–7.5 |
| `L_table_completion` | Table Completion | Điền bảng | 4.5–7.0 |
| `L_sentence_completion` | Sentence Completion | Điền cuối câu | 4.5–7.0 |
| `L_flow_chart_completion` | Flow-chart Completion | Điền flow-chart (process steps) | 4.5–7.0 |
| `L_map_plan_labelling` | Map / Plan Labelling | Nhãn bản đồ/mặt bằng (spatial) | 4.5–7.0 |
| `L_diagram_labelling` | Diagram Labelling | Nhãn sơ đồ (object/process) | 5.0–7.0 |
| `L_multiple_choice` | Multiple Choice (1 from 3, multi-select) | Chọn 1 hoặc nhiều | 4.5–8.5 |
| `L_matching` | Matching | Khớp item | 5.5–8.5 |
| `L_short_answer` | Short Answer | Trả lời ngắn | 4.5–7.5 |

Listening có 10 dạng controlled vocabulary (tách diagram/flow-chart/map vì cơ chế differ: map cần spatial follow, diagram cần part label, flow-chart cần process tracking). Đây là SSOT; `05-content.md` đồng bộ với enum này.

Section khó tăng dần: S1 (easiest, social) → S4 (hardest, academic). Band difficulty signal qua section.

## Reading — 16 question types (Academic + General Training shared vocabulary)

| id | Question type | Mô tả | Band difficulty |
|---|---|---|---|
| `R_multiple_choice` | Multiple Choice (1 from 4) | Chọn đáp án | medium |
| `R_multiple_choice_multi` | Multiple Choice (multi-select, choose 2+) | Chọn nhiều từ list | high |
| `R_true_false_not_given` | True/False/Not Given | Phát biểu có đúng/sai/không có trong bài | medium |
| `R_yes_no_not_given` | Yes/No/Not Given | Tác giả đồng ý/không/không rõ | medium-high (yếu paraphrase) |
| `R_matching_headings` | Matching Headings | Tiêu đề cho đoạn | high (paraphrase + main idea) |
| `R_matching_information_paragraph` | Matching Information (which paragraph) | Thông tin ở **đoạn nào** (paragraph-level) | high (scan + paraphrase, local) |
| `R_matching_information_section` | Matching Information (which section) | Thông tin ở **phần nào** (section-level, nhóm đoạn) | high (global grouping, khó hơn paragraph) |
| `R_matching_features` | Matching Features | Khớp đặc điểm (người/tên/lý thuyết) | high |
| `R_matching_sentence_endings` | Matching Sentence Endings | Nối nửa câu | medium |
| `R_sentence_completion` | Sentence Completion | Điền cuối câu | medium |
| `R_summary_completion` | Summary Completion (with/without box) | Điền tóm tắt | medium-high |
| `R_note_completion` | Note Completion | Điền note | medium |
| `R_table_completion` | Table Completion | Điền bảng | medium |
| `R_flow_chart_completion` | Flow-chart Completion | Điền flow-chart | medium |
| `R_diagram_labelling` | Diagram Labelling | Nhãn sơ đồ | medium |
| `R_short_answer` | Short Answer | Trả lời ngắn | medium |

**Ghi chú Academic vs General Training:** vocabulary giống nhau, khác passage (Academic: scholarly; GT: everyday/workplace). Xem `exam-module-differences.md`.

## Writing — task types

### Academic

| id | Task type | Band range | Mô tả |
|---|---|---|---|
| `W_ac_task1_chart` | Task 1 Academic — Chart/Graph | 5.0–9.0 | Mô tả biểu đồ (line/bar/pie) |
| `W_ac_task1_table` | Task 1 Academic — Table | 5.0–9.0 | Mô tả bảng số liệu |
| `W_ac_task1_process` | Task 1 Academic — Process | 5.5–9.0 | Mô tả quy trình |
| `W_ac_task1_map` | Task 1 Academic — Map | 5.5–9.0 | So sánh bản đồ |
| `W_ac_task1_diagram` | Task 1 Academic — Diagram/Object | 5.5–9.0 | Mô tả sơ đồ vật thể |
| `W_task2_opinion` | Task 2 — Opinion | 5.0–9.0 | "Do you agree/disagree" |
| `W_task2_discussion` | Task 2 — Discussion | 5.0–9.0 | "Discuss both views" |
| `W_task2_advantages_disadvantages` | Task 2 — Advantages/Disadvantages | 5.0–9.0 | Outweigh / pros cons |
| `W_task2_problem_solution` | Task 2 — Problem/Solution | 5.0–9.0 | Causes+solutions |
| `W_task2_two_part` | Task 2 — Two-part question | 5.5–9.0 | 2 sub-questions |

### General Training

| id | Task type | Band range | Mô tả |
|---|---|---|---|
| `W_gt_task1_formal_letter` | Task 1 GT — Formal Letter | 5.0–9.0 | Formal complaint/request |
| `W_gt_task1_semi_formal_letter` | Task 1 GT — Semi-formal Letter | 5.0–9.0 | Người quen, context formal |
| `W_gt_task1_informal_letter` | Task 1 GT — Informal Letter | 5.0–9.0 | Bạn bè |
| `W_task2_opinion`, `W_task2_discussion`, `W_task2_advantages_disadvantages`, `W_task2_problem_solution`, `W_task2_two_part` | Task 2 GT — (giống Academic Task 2) | 5.0–9.0 | (xem Academic) |

## Speaking — parts

| id | Part | Band range | Mô tả | Duration |
|---|---|---|---|---|
| `S_part1_interview` | Part 1 — Interview | 4.0–9.0 | Q&A cá nhân + topic quen (home/work/study, family) | 4-5 min |
| `S_part2_long_turn` | Part 2 — Long Turn (Cue Card) | 4.5–9.0 | Monologue 1-2 min theo cue card | 3-4 min (1 prep + 2 nói) |
| `S_part3_discussion` | Part 3 — Discussion | 5.5–9.0 | Q&A trừu tượng liên quan Part 2 | 4-5 min |

Part 3 khó nhất — yêu cầu abstract reasoning, paraphrase sâu.

## Pronunciation — không có "question type" riêng

Pronunciation là criterion của Speaking (PR) nhưng được tách thành domain `EVAL.Pronunciation` vì cơ chế feedback khác. Đơn vị đánh giá:

| id | Đơn vị | Mô tả |
|---|---|---|
| `P_phoneme` | Phoneme | Âm vị (vd /θ/, /ð/) |
| `P_word_stress` | Word Stress | Trọng âm từ (vd phoTOgrapher) |
| `P_sentence_stress` | Sentence Stress | Trọng âm câu (content vs function words) |
| `P_intonation` | Intonation | Ngữ điệu (rising/falling) |
| `P_linking` | Connected speech | Linking, elision, assimilation |

## Band difficulty (chung cho L/R)

IELTS không gắn band vào từng question type — difficulty đến từ **paraphrase depth**, **abstract reasoning**, **synonym density**. Nguyên tắc:

| Difficulty signal | Tăng band target cần |
|---|---|
| Keyword match (trùng từ) | 3.0–5.0 |
| Synonym paraphrase (1 bước) | 5.0–6.0 |
| Complex paraphrase (2+ bước, cả câu) | 6.5–7.5 |
| Abstract/inference (ý ngụ ý, không nói thẳng) | 7.5–9.0 |

Difficulty signal này là `difficulty_signals` trong `learning_design_profile` (05-content.md) và feed `PRACTICE.Adaptive`.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.

- `version: 1.0.3` — corrected Listening/Reading inventory counts to match the enumerated nodes.
- `version: 1.0.6` — normalized the per-file release record; question-type enums are unchanged.

## Không tự suy luận

Nếu một question type không nằm ở bảng trên, agent phải báo `unknown_question_type` chứ không tự đặt tên. Thêm dạng mới (rare) phải qua Colab review + cập nhật version file này.
