---
version: 1.0.6
scope: framework
---

# Review Mapping (error type → review rule × skill)

Status: `framework` — ánh xạ từ error (`error-taxonomy.md`) sang **review rule**: loại ôn gì, tần suất, mapping FSRS. Feed `REVIEW.SmartQueue`, `REVIEW.MistakeNotebook`, `REVIEW.FSRS` card sources.

Quy ước:
- Mỗi error có `review_type` (loại nội dung ôn) + `fsrs_card_kind` (loại card) + `frequency_hint` (gợi ý tần suất ban đầu).
- `frequency_hint` là gợi ý, FSRS tự tinh chỉnh sau rating.
- Tất cả review card đều có `evidence_ref` trỏ về source error — không có card mồ côi.

## Loại review card (fsrs_card_kind)

| kind | Mô tả | Ví dụ |
|---|---|---|
| `recall_meaning` | Nhớ nghĩa từ/collocation | "ephemeral = ?" |
| `recall_form` | Nhớ word form/chính tả | "success → adj = ?" |
| `recall_grammar_rule` | Nhớ quy tắc grammar | "inversion sau negative adverb: ?" |
| `apply_distractor` | Áp dụng reject distractor | "[passage + stem + 2 options] chọn bẫy" |
| `apply_paraphrase` | Áp dụng nhận paraphrase | "[passage + question] paraphrase của X là gì" |
| `apply_grammar_correct` | Sửa lỗi grammar trong câu | "[câu lỗi] sửa lại" |
| `apply_structure` | Áp dụng cấu trúc writing/speaking | "[topic] viết topic sentence + cohesion" |
| `retest_question_type` | Làm lại question type cùng micro-skill | 1 câu Reading Matching Headings mới |

## Listening — error → review mapping

| error_id | review_type | fsrs_card_kind | frequency_hint | note |
|---|---|---|---|---|
| `L_ans_distractor_lexical` | luyện loại distractor | `apply_distractor` | 2 ngày → 7 → 21 | cùng question_type |
| `L_ans_distractor_number` | luyện bẫy số | `apply_distractor` | 2 → 7 | số liệu |
| `L_ans_paraphrase_missed` | luyện nhận paraphrase | `apply_paraphrase` | 2 → 7 → 21 | gắn `L_paraphrase_recognition` |
| `L_spelling_error` | chính tả từ đó | `recall_form` | 1 → 3 → 7 → 21 | word_id |
| `L_word_boundary` | nghe lại minimal pair | `recall_meaning` | 3 → 7 | audio ref |
| `L_abstract_inference_missed` | luyện inference | `retest_question_type` | 7 → 21 | câu mới |

## Reading — error → review mapping

| error_id | review_type | fsrs_card_kind | frequency_hint | note |
|---|---|---|---|---|
| `R_ans_paraphrase_missed` | luyện paraphrase | `apply_paraphrase` | 2 → 7 → 21 | `R_paraphrase_recognition` |
| `R_ans_distractor_lexical` | luyện loại bẫy | `apply_distractor` | 2 → 7 | cùng question_type |
| `R_tfng_false_vs_notgiven` | luyện phân biệt F vs NG | `retest_question_type` | 2 → 7 → 21 | câu mới, ranh quan trọng |
| `R_tfng_writer_vs_fact` | luyện yes/no vs T/F | `retest_question_type` | 3 → 7 | — |
| `R_heading_wrong_main_idea` | luyện main idea | `retest_question_type` | 3 → 7 → 21 | cùng matching_headings |
| `R_completion_word_form` | luyện word form | `recall_form` | 2 → 7 | word_id |
| `R_reference_misread` | luyện reference | `apply_paraphrase` | 3 → 7 | — |
| `R_ans_wrong_passage_loc` | luyện local vs global | `retest_question_type` | 7 → 21 | — |

## Writing — error → review mapping

| error_id | review_type | fsrs_card_kind | frequency_hint | note |
|---|---|---|---|---|
| `W_tr_task_missed_part` | luyện phân tích đề | `apply_structure` | 3 → 7 → 21 | rewrite outline |
| `W_tr_position_unclear` | luyện position statement | `apply_structure` | 3 → 7 | thesis writing |
| `W_tr_idea_undeveloped` | luyện idea + support | `apply_structure` | 3 → 7 → 21 | extend idea drill |
| `W_cc_mechanical_cohesive` | luyện cohesive range | `recall_grammar_rule` + rewrite | 3 → 7 | connector list |
| `W_cc_topic_sentence_unclear` | luyện topic sentence | `apply_structure` | 2 → 7 | — |
| `W_lr_wrong_collocation` | nhớ collocation | `recall_meaning` | 1 → 3 → 7 → 21 | collocation_id |
| `W_lr_repetitive` | luyện synonym replacement | `recall_meaning` | 2 → 7 | word family |
| `W_gra_complex_with_error` | sửa lỗi grammar | `apply_grammar_correct` | 1 → 3 → 7 | câu gốc |
| `W_gra_tense` | nhớ rule tense | `recall_grammar_rule` | 1 → 3 → 7 | — |
| `W_gra_article` | luyện article | `apply_grammar_correct` | 2 → 7 | — |
| `W_gra_relative_clause` | luyện relative clause | `apply_grammar_correct` + rule | 2 → 7 → 21 | — |
| `W_gra_punctuation` | sửa punctuation | `apply_grammar_correct` | 3 → 7 | comma splice |
| `W_t1_no_overview` | luyện overview | `apply_structure` | 3 → 7 | data set mới |
| `W_t1_detail_dump` | luyện chọn data | `apply_structure` | 3 → 7 | chart mới |
| `W_letter_wrong_tone` | luyện tone | `apply_structure` | 7 → 21 | letter mới |

## Speaking — error → review mapping

Speaking đặc biệt: card thường kèm **audio self-recording** (learner nghe lại mình).

| error_id | review_type | fsrs_card_kind | frequency_hint | note |
|---|---|---|---|---|
| `S_fc_short_answer` | luyện extend answer | `apply_structure` | 2 → 7 | prompt mới, record |
| `S_fc_long_pause` | luyện sustain | `retest_question_type` | 3 → 7 | cue card mới |
| `S_fc_part3_no_develop` | luyện defend | `apply_structure` | 7 → 21 | abstract topic |
| `S_lr_limited_paraphrase` | luyện paraphrase spontaneous | `apply_paraphrase` | 3 → 7 | word prompt |
| `S_gra_only_simple` | luyện complex grammar nói | `apply_grammar_correct` (oral) | 7 → 21 | record |
| `S_pr_phoneme` | luyện âm vị | `recall_meaning` + drill | 1 → 3 → 7 → 21 | audio mẫu + record |
| `S_pr_word_stress` | luyện trọng âm | `recall_form` + drill | 1 → 3 → 7 | word list |
| `S_pr_intonation_flat` | luyện intonation | `retest_question_type` (shadowing) | 7 → 21 | audio mẫu shadow |

## Strategy errors — review mapping

| error_id | review_type | fsrs_card_kind | frequency_hint |
|---|---|---|---|
| `X_time_management` | luyện pacing (timer) | `retest_question_type` | 7 → 21 |
| `X_instruction_misread` | luyện đọc instruction | `recall_grammar_rule` | 7 |
| `X_answer_transfer_wrong` | luyện answer sheet | `retest_question_type` | 21 |

## FSRS card source rules

Mỗi review card khi tạo phải có:
- `source_error_id` (từ error-taxonomy)
- `evidence_ref` (câu/passage/audio gốc)
- `micro_skill_ref` (từ microskill-enum, nếu có)
- `fsrs_card_kind` (loại card, từ bảng trên)
- `frequency_hint` (gợi ý ban đầu — FSRS override sau rating đầu)

Card mồ côi (không source) không được tạo — đó là cơ chế anti-gaming + giữ chất lượng ôn.

## Cross-link

- `BAND.Map` item ⚠/✗ → click → mở review card cùng micro-skill (nếu đã có error) hoặc mở drill (nếu chưa có error, chỉ cần học).
- `COACH.ErrorAnalysis` output list error_id → tự động sinh review card theo mapping này (learner có thể confirm/reject).
- `REVIEW.SmartQueue` group card theo `micro_skill_ref` để "weak skill queue" — ôn theo điểm yếu.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.

- `version: 1.0.1` — reconciled error-to-microskill references.
- `version: 1.0.6` — normalized the per-file release record; review mappings are unchanged.
- Thêm mapping: minor; sửa frequency: patch; bỏ mapping: deprecated_in.

## Không tự suy luận

Nếu error chưa có mapping, không tự chọn `fsrs_card_kind`. Báo `unknown_review_mapping` + flag Colab. Tạo card review mồ côi = vi phạm contract.
