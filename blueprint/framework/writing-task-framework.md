---
version: 1.0.6
scope: framework
---

# Writing Task Framework (Task 1 Academic/General + Task 2)

Status: `framework` — định nghĩa structure, requirement, và chấm depth cho từng writing task. Feed `LEARN.Writing`, `EVAL.Writing`, `BAND.Map` writing row, `W_*` error taxonomy.

## Task 1 Academic

### Task types

| id | Type | Mô tả | Word target | Key challenge |
|---|---|---|---|---|
| `W_ac_task1_chart` | Chart/graph (`chart_variant`: `line`, `bar`, `pie`, `mixed`) | Mô tả xu hướng, nhóm hoặc proportion theo loại chart | 150+ | chọn trend/comparison vocabulary đúng variant |
| `W_ac_task1_table` | Table (static or time-series) | So sánh số liệu bảng | 150+ | comparison, grouping |
| `W_ac_task1_process` | Process | Mô tả quy trình (natural/man-made) | 150+ | passive, sequencing |
| `W_ac_task1_map` | Map | So sánh bản đồ (past/present/future) | 150+ | spatial, tense |
| `W_ac_task1_diagram` | Diagram/Object | Mô tả cấu tạo vật thể | 150+ | label, spatial |

`W_ac_task1_chart` là question type canonical trong `skill-questiontype-band.md`; `line`, `bar`, `pie` và `mixed` chỉ là `chart_variant`, không phải task ID độc lập. Các tên granular cũ không được dùng cho asset mới.

**Phân biệt static vs time-series (quan trọng cho vocab selection):**
- **Time-series (dynamic)**: data có trục thời gian → dùng **trend vocab** (rise, fall, fluctuate, peak) + tense past nếu data quá khứ.
- **Static**: data 1 thời điểm, không có trục thời gian → dùng **comparison vocab** (whereas, while, in contrast, the most significant) — KHÔNG dùng trend vocab (vì không có xu hướng).
- **Mixed**: có cả 2 → ưu tiên trend chính cho time-series, comparison cho static. `W_t1_detail_dump` risk cao ở mixed.

### Required structure

```text
1. Introduction (1-2 sentence)
   - paraphrase đề
2. Overview (2-3 sentence) — BẮT BUỘC, không có = max band 5 (TR)
   - main trend / main feature / key comparison
   - KHÔNG số liệu cụ thể
3. Body paragraphs (2 paragraphs)
   - nhóm data logic (vd theo trend, theo category)
   - số liệu specific + comparison
```

### Critical requirements (auto-cap band nếu vi phạm)

| Requirement | Hậu quả nếu thiếu | Error id |
|---|---|---|
| Overview present | max band 5 (TR) | `W_t1_no_overview` |
| No personal opinion | max band 5 (TR) | `W_t1_opinion_injected` |
| Don't list all data | max band 5 (TR) — phải select | `W_t1_detail_dump` |
| Word count ≥ 150 | auto-penalize | `W_tr_under_wordcount` |
| No conclusion (Task 1 không có conclusion) | — | (informational) |

### Task 1 Academic criterion weight (chấm)

- TR: data accuracy + overview + selection
- CC: paragraph logic + cohesive data
- LR: trend/comparison vocab (rise, fall, fluctuate, peak, account for)
- GRA: tense (past for past data), comparison structures, passive (process)

### Trend/comparison vocab checklist (band 6-7)

**Trend vocab (cho time-series / dynamic):**

| Category | Vocab |
|---|---|
| Increase | rise, climb, grow, surge, soar, upward trend |
| Decrease | fall, decline, drop, plunge, downward trend |
| Stable | remain stable, plateau, level off |
| Fluctuation | fluctuate, vary, oscillate |
| Peak/trough | peak at, reach a low of, hit a high of |

**Comparison vocab (cho static + dùng kèm time-series):**

| Category | Vocab |
|---|---|
| Contrast | whereas, while, in contrast, by contrast, conversely |
| Similarity | similarly, likewise, the same pattern, comparable |
| Superlative | by far the most, the highest/lowest, the most significant |
| Proportion | account for, make up, comprise, constitute, represent, a mere, a mere fraction |
| Approximation | approximately, roughly, just over/under, nearly, almost |

**Quy tắc chọn vocab theo chart type:**
- Line chart → chủ yếu trend vocab.
- Pie/bar/table static → chủ yếu comparison + proportion.
- Bar/table time-series → trend + comparison.
- Mixed → kết hợp, ưu tiên trend cho data có time axis.

## Task 1 General Training (Letter)

### Task types

| id | Type | Tone | Mô tả |
|---|---|---|---|
| `W_gt_task1_formal_letter` | Formal | Formal | complaint, job application, request to authority |
| `W_gt_task1_semi_formal_letter` | Semi-formal | Semi-formal | neighbor, colleague |
| `W_gt_task1_informal_letter` | Informal | Informal | friend, family |

### Required structure

```text
1. Greeting (Dear Sir/Madam, Dear Mr. X, Dear John)
2. Opening (lý do viết — paraphrase đề)
3. Body (cover 3 bullet points trong đề)
4. Closing (sign-off: Yours faithfully/formal, Yours sincerely/semi, Best regards/informal)
```

### Critical requirements

| Requirement | Hậu quả | Error id |
|---|---|---|
| Tone đúng loại letter | max band 5 (TR+LR) | `W_letter_wrong_tone` |
| Cover đủ 3 bullets | max band 5 (TR) | `W_tr_task_missed_part` |
| Word count ≥ 150 | auto-penalize | `W_tr_under_wordcount` |

### Tone/register rules

| Tone | Open | Close | Style |
|---|---|---|---|
| Formal | Dear Sir/Madam, Dear [Title+Name] | Yours faithfully, Yours sincerely | no contractions, no idioms |
| Semi-formal | Dear [First name] | Yours sincerely, Kind regards | some contractions OK |
| Informal | Dear [First name] | Best wishes, Lots of love, Cheers | contractions, idioms, casual |

## Task 2 (Academic + General Training shared)

### Task types

| id | Type | Prompt pattern | Key challenge |
|---|---|---|---|
| `W_task2_opinion` | Opinion | "To what extent do you agree/disagree?" | clear position throughout |
| `W_task2_discussion` | Discussion | "Discuss both views and give your opinion." | balance + own position |
| `W_task2_advantages_disadvantages` | Adv/Disadv | "Do advantages outweigh disadvantages?" | evaluate both + position |
| `W_task2_problem_solution` | Problem/Solution | "Causes and solutions?" | identify + propose |
| `W_task2_two_part` | Two-part | 2 sub-questions | answer both fully |

### Required structure (4 paragraphs chuẩn)

```text
1. Introduction (2-3 sentence)
   - paraphrase đề
   - thesis statement (position rõ)
2. Body 1 (main idea 1 + development + example)
3. Body 2 (main idea 2 + development + example)
4. Conclusion (1-2 sentence)
   - restate position
   - (optional) final thought
```

### Critical requirements

| Requirement | Hậu quả | Error id |
|---|---|---|
| Position clear throughout | max band 5 (TR) | `W_tr_position_unclear` |
| Answer all parts | max band 5 (TR) | `W_tr_task_missed_part` |
| Main ideas developed + support | max band 6 (TR) | `W_tr_idea_undeveloped` |
| Word count ≥ 250 | auto-penalize | `W_tr_under_wordcount` |
| 4+ paragraphs | CC suffer | `W_cc_no_paragraphing` |

### Task 2 criterion weight

- TR: position, idea development, address all parts
- CC: paragraph logic, cohesive range, progression
- LR: precision, collocation, paraphrase, less common
- GRA: complex structure range, accuracy

## Cross-cutting: word count rule

| Task | Min | Penalty if under |
|---|---|---|
| Task 1 (Acad + GT) | 150 | auto band cap (examiner trừ, không compute formal) |
| Task 2 | 250 | auto band cap |

App: `W_tr_under_wordcount` flag khi nộp, **block submit** nếu under (vd phải confirm) — hoặc allow submit nhưng flag rõ.

## Cross-cutting: time management

| Task | Time gợi ý |
|---|---|
| Task 1 | 20 min |
| Task 2 | 40 min |

Learner tự quyết, nhưng `STUDY.Session` default timer theo hint. Mock test mode: timer total 60min, không chia.

## Band descriptor reference

Band theo criterion (TR/CC/LR/GRA) — chi tiết ở `band-descriptor-map.md`. File này chỉ định nghĩa task structure + requirement, không lặp descriptor.

## Examiner (EVAL.Writing) chấm depth

`EVAL.Writing` phải output:

```yaml
evaluation:
  task_ref: ...
  task_type: W_task2_opinion
  word_count: 287
  criteria:
    task_response:
      band: 6.5
      confidence: 0.82
      evidence_refs: [sent_3_position, para_2_idea]
      issues:
        - error_id: W_tr_idea_undeveloped
          evidence_ref: para_2
    coherence_cohesion: ...
    lexical_resource: ...
    grammar: ...
  overall_band: 6.0  # average of 4, rounded to nearest 0.5 (.25→.5, .75→up) per IELTS
  overall_confidence: 0.85
  quality_status: accepted
```

Yêu cầu:
- Band per criterion + evidence (câu/đoạn cụ thể).
- Overall = average của 4 criterion, **làm tròn về 0.5 gần nhất (.25→.5, .75→up — IELTS rule)**. Bảng quy đổi đầy đủ ở `exam-module-differences.md`.
- Issue list = error_id từ `error-taxonomy.md` + evidence_ref.
- Không đoán: nếu thiếu evidence → `insufficient_evidence`.

## Cách dùng

- `LEARN.Writing` practice: learner chọn task type → workspace.
- `EVAL.Writing` chấm theo schema trên.
- `BAND.Map` writing row: per-task-type readiness (✓/⚠/✗) + per-criterion.
- `REVIEW.MistakeNotebook`: error → review card theo `review-mapping.md`.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.

- `version: 1.0.1` — reconciled Academic Task 1 IDs and enumerated Task 2 types.
- `version: 1.0.6` — normalized the per-file release record; task types and evaluation rules are unchanged.
- Thêm task subtype: minor.
- Sửa structure requirement: patch + note.

## Không tự suy luận

- Task type phải thuộc enum đã liệt kê trong bảng (`W_ac_task1_chart`, `W_gt_task1_formal_letter`, `W_gt_task1_semi_formal_letter`, `W_gt_task1_informal_letter`, hoặc năm ID Task 2); notation nhóm không phải giá trị hợp lệ.
- Critical requirement (overview Task 1, position Task 2) là hard rule, không relax.
- Band cap rule (max band 5 nếu thiếu overview/position) theo IELTS, không tự thay.
