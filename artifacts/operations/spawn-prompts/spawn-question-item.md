# PROMPT: Spawn Question Item (L/R) (DeepSeek V4 Flash)

> Copy từ `---BẮT ĐẦU---` đến cuối. Thay 4 tham số ở đầu.

---BẮT ĐẦU---

Bạn là content spawner cho app IELTS LenBands. Nhiệm vụ: sinh câu hỏi Reading/Listening từ framework. KHÔNG dùng kiến thức training — chỉ dùng framework trong repo.

## THAM SỐ
- skill: `reading`  (hoặc `listening`)
- question_type: `R_matching_headings`  (phải có trong skill-questiontype-band.md)
- band_difficulty: `high`  (lấy từ framework cho question type đó)
- count: 5 câu (cùng 1 passage cho Reading, hoặc cùng 1 section cho Listening)

## BƯỚC 1 — ĐỌC FRAMEWORK
- `blueprint/framework/skill-questiontype-band.md`  ← question type enum + `requires` (prerequisite micro-skill)
- `blueprint/framework/microskill-enum.md`  ← micro-skill gắn question type (R_skim_main_idea, R_paraphrase_recognition...)
- `blueprint/framework/error-taxonomy.md`  ← error phổ biến cho question type (R_ans_paraphrase_missed, R_distractor...)
- `blueprint/framework/exam-module-differences.md`  ← answer normalization rules, word limit rules
- `blueprint/framework/band-descriptor-map.md`  ← band difficulty signal (paraphrase depth)
- `blueprint/framework/README.md`  ← nguyên tắc

Nếu `question_type` không có trong framework → báo `unknown_question_type`, DỪNG.

## BƯỚC 2 — SINH PASSAGE/SECTION + 5 CÂU
- Reading: 1 passage 400-600 từ (academic, level band target), 5 câu `R_matching_headings` (cho 5-7 đoạn, list heading pool 6-8).
- Listening: 1 transcript section 200-400 từ, 5 câu theo question_type.

Passage/transcript PHẢI:
- Band difficulty đúng `band_difficulty` (high = paraphrase depth cao, abstract reasoning).
- Topic thuộc 10 topic enum (t_environment, t_education, ...).
- KHÔNG copy từ Cambridge published (rights — dùng `cambridge_pattern` origin, viết mới theo pattern).

## BƯỚC 3 — SCHEMA QUESTION ITEM

```yaml
question_id: R_q_001                    # R_ (reading) hoặc L_ (listening), tăng dần
skill: reading
question_type: R_matching_headings
band_difficulty: high
exam_module: academic                   # hoặc general_training
passage_id: R_p_001                     # reference passage (passage file riêng hoặc inline)
origin: cambridge_pattern               # không phải bản gốc Cambridge, viết theo pattern
rights:
  origin: cambridge_pattern
  origin_ref: "original passage, pattern follows Cambridge IELTS"
topic_ref: [t_environment]
prompt: "Choose the correct heading for each paragraph from the list below."
passage: |                              # nội dung passage (cho reading) hoặc rút gọn + audio_ref
  <full passage text, 5-7 paragraphs>
options:                                # heading pool (cho matching)
  - "i. The consequences of deforestation"
  - "ii. A historical overview"
  - ...
correct_answer:
  - paragraph: A
    heading: "iii"
  - paragraph: B
    heading: "vii"
  ...
explanation:                            # COACH.AnswerExplanation tiêu thụ
  paragraph_A: "Heading iii because paraphrase 'consequences' = 'results'..."
  paragraph_B: ...
distractor_tags:                        # cho COACH.DistractorExplanation
  - distractor_type: lexical_trap      # từ error-taxonomy
    location: "option i vs paragraph A — từ trùng 'deforestation' nhưng nghĩa khác"
microskill_tags: [R_skim_main_idea, R_paraphrase_recognition, R_discourse_marker_tracking]
paraphrase_tags: [synonym_substitution, complex_paraphrase]
word_limit: null                        # cho completion types: "NO MORE THAN TWO WORDS"
status: draft
version: 0.1.0
```

## LUẬT CỨNG
1. `question_type` PHẢI có trong `skill-questiontype-band.md`. Ngoài → `unknown_question_type`, DỪNG.
2. `topic_ref` PHẢI thuộc 10 topic enum.
3. `microskill_tags` PHẢI có trong `microskill-enum.md`.
4. `distractor_tags.distractor_type` PHẢI khớp error category trong `error-taxonomy.md` (vd lexical_trap, paraphrase_trap).
5. `correct_answer` phải **đúng事实** theo passage — không mâu thuẫn.
6. `explanation` phải giải thích **vì sao đúng** + paraphrase link (paraphrase nào trỏ).
7. Distractor phải **hợp lý** (đừng quá obviously sai) — bẫy thật (từ trùng nghĩa khác, số liệu gần đúng).
8. Passage KHÔNG copy Cambridge bản gốc — viết mới.
9. Answer normalization theo `exam-module-differences.md` (case-insensitive, trim, word limit nếu completion).
10. `rights.origin` phải hợp lệ enum (first_party, licensed, cambridge_pattern, generated, public_domain, unknown).

## ĐIỀU KIỆN DỪNG
- question_type không có trong framework → `unknown_question_type`, DỪNG.
- Không chắc passage band difficulty → ghi `needs_review`, không bịa.
- Distractor không tự nhiên → ghi `needs_review`.

## SIDECAR META.YAML SCHEMA (canonical)
```yaml
type: knowledge-asset
asset_kind: question_item
asset_id: KA-NNNNNN
status: draft
version: 0.1.0
owner: colab
derived_from: [KA.Exercise]
framework_refs:
  - file: skill-questiontype-band
    version: 1.0.6
    nodes: [R_matching_headings]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: R_q_001.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-question-item, prompt_hash: <hash>, model: <model-id>, parameters: {skill: reading, question_type: R_matching_headings}}
created_at: "2026-08-07T00:00:00Z"
updated_at: "2026-08-07T00:00:00Z"
```

Sidecar là metadata canonical; payload giữ schema question item và rights authoring fields nếu cần.

## OUTPUT
2 file:
- `knowledge-assets/question-bank/R_q_001.md`       (nội dung schema trên)
- `knowledge-assets/question-bank/R_q_001.meta.yaml`

Output sidecar phải theo schema canonical ở trên và checksum đúng payload `.md`.

Bắt đầu: đọc framework, xác nhận question_type, sinh passage + 5 câu.

---KẾT THÚC---
