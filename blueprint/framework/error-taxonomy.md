---
version: 1.0.6
scope: framework
---

# Error Taxonomy (per skill)

Status: `framework` — versioned controlled vocabulary. Phân loại lỗi learner mắc phải, theo skill. Feed `COACH.ErrorAnalysis`, `REVIEW.MistakeNotebook` tag, `BAND.Map` item ⚠/✗.

Quy ước:
- `error_id` dạng `{skill}_{category}_{specific}` snake_case, versioned.
- Mỗi error có: `criterion_impact` (criterion bị ảnh hưởng), `band_signal` (band range thường mắc), `microskill_ref` (micro-skill liên quan, nếu có).
- `criterion_impact` là controlled enum: `TR`, `CC`, `LR`, `GRA`, `FC`, `PR`, `answer-key`, `strategy`, `TR_TASK1`, `TR_LR`.
- `band_signal` là số IELTS one-decimal (`5.0`) hoặc `all_bands`; không dùng prose/free-form trong cell.
- Đây là **taxonomy lỗi**, không phải chữa lỗi (chữa = `review-mapping.md`).

## Node schema (mỗi error)

Mỗi error là node sở hữu điều kiện "đã resolve" inline. Không có "error mastery file" trung tâm.

```yaml
error_id: W_gra_relative_clause
category: grammar
description: Relative clause sai (who/which/that)
criterion_impact: GRA
band_signal: 6.5
microskill_ref: [W_complex_structure_range]
resolve_when:
  no_recurrence_in_recent_n_submissions: 3    # 3 bài Writing gần nhất không mắc lại lỗi này
  retest_accuracy_pct: 90                      # retest cùng error pattern đạt 90%
  review_card_state: review                    # FSRS card gắn error đã graduate (không còn Learning/Relearning)
```

Quy ước:
- `resolve_when` hội điều kiện (AND) để error chuyển từ `open` → `improved` ở `REVIEW.MistakeNotebook`.
- `no_recurrence_in_recent_n_submissions`: số bài/lần làm gần nhất không lặp lỗi (mặc định 3).
- `review_card_state: review` nghĩa là FSRS card đã qua giai đoạn Learning, đang ở Review ổn định.

## Listening — error taxonomy

| error_id | Category | Mô tả | criterion_impact | band_signal | microskill_ref |
|---|---|---|---|---|---|
| `L_ans_wrong_content` | content | Nghe sai ý, chọn đáp án sai事实 | answer-key | 4.0 | `L_signal_word_detection` |
| `L_ans_distractor_lexical` | distractor | Bị distractor lexical trap (từ trùng, nghĩa khác) | answer-key | 6.0 | `L_distractor_rejection` |
| `L_ans_distractor_number` | distractor | Bị bẫy số liệu (số gần đúng, đổi đơn vị) | answer-key | 5.5 | `L_distractor_rejection` |
| `L_ans_paraphrase_missed` | comprehension | Không nhận paraphrase stem↔audio | answer-key | 6.0 | `L_paraphrase_recognition` |
| `L_spelling_error` | spelling | Chính tả sai từ nghe được | answer-key | 4.5 | `L_spelling_from_audio` |
| `L_word_boundary` | listening | Không phân biệt ranh giới từ (an apple vs a napple) | answer-key | 5.0 | `unknown_microskill` (framework chưa có node segmentation riêng) |
| `L_ans_number_format` | normalization | Sai format number/date/phone/currency dù nghe đúng số | answer-key | 5.0 | `L_number_date_capture` |
| `L_ans_unit_missing` | normalization | Thiếu đơn vị (kg, pounds) khi key yêu cầu | answer-key | 5.0 | `L_number_date_capture` |
| `L_note_incomplete` | note-taking | Ghi thiếu vì kịp nghe | answer-key | 6.5 | `L_note_concurrent` |
| `L_direction_lost` | spatial | Mất phương hướng trong map task | answer-key | 5.5 | `L_follow_direction` |
| `L_abstract_inference_missed` | inference | Không suy luận ý ngụ ý | answer-key | 7.5 | `L_abstract_inference` |
| `L_overtime_spent` | strategy | Quá lâu 1 câu, miss câu sau | strategy | 5.5 | — |

## Reading — error taxonomy

| error_id | Category | Mô tả | criterion_impact | band_signal | microskill_ref |
|---|---|---|---|---|---|
| `R_ans_wrong_passage_loc` | location | Nhìn sai đoạn (local vs global) | answer-key | 6.5 | `R_global_vs_local` |
| `R_ans_distractor_lexical` | distractor | Lexical trap (từ trùng) | answer-key | 6.0 | `R_distractor_rejection` |
| `R_ans_paraphrase_missed` | comprehension | Không nhận paraphrase | answer-key | 6.0 | `R_paraphrase_recognition` |
| `R_tfng_false_vs_notgiven` | classification | Lẫn false (contradict) với not_given (không có) | answer-key | 6.0 | `R_not_given_vs_false` |
| `R_tfng_writer_vs_fact` | classification | Lẫn ý tác giả (yes/no) với fact đúng (true/false) | answer-key | 6.5 | `R_writer_attitude_inference` |
| `R_heading_wrong_main_idea` | comprehension | Chọn heading không phải main idea (detail trap) | answer-key | 6.5 | `R_skim_main_idea` |
| `R_completion_word_form` | grammar | Sai word form (noun vs verb) | answer-key | 5.5 | `R_summary_gap_strategy` |
| `R_completion_over_limit` | instruction | Viết quá số từ cho phép | answer-key | 5.0 | — |
| `R_completion_not_in_passage` | fact | Viết ý không có trong bài | answer-key | 5.5 | — |
| `R_reference_misread` | reference | Hiểu sai tham chiếu (this/these) | answer-key | 5.5 | `R_reference_resolution` |
| `R_overtime_spent` | strategy | Quá lâu 1 câu | strategy | 5.5 | — |

## Writing — error taxonomy

| error_id | Category | Mô tả | criterion_impact | band_signal | microskill_ref |
|---|---|---|---|---|---|
| `W_tr_task_missed_part` | task response | Bỏ qua 1 phần đề (vd "discuss both views" — chỉ làm 1) | TR | 5.0 | `W_task_analysis` |
| `W_tr_position_unclear` | task response | Position không rõ, thay đổi | TR | 6.0 | `W_position_clarity` |
| `W_tr_idea_undeveloped` | task response | Main idea không support, chỉ nêu | TR | 6.5 | `W_idea_development` |
| `W_tr_off_topic` | task response | Off-topic, lạc đề | TR | 4.0 | `W_task_analysis` |
| `W_tr_under_wordcount` | task response | Dưới 250 (Task 2) / 150 (Task 1) tự động trừ | TR | all_bands | — |
| `W_cc_no_paragraphing` | coherence | Không chia đoạn hoặc sai logic đoạn | CC | 5.0 | `W_paragraph_topic_sentence` |
| `W_cc_mechanical_cohesive` | coherence | Cohesive devices mechanical (this/however lặp) | CC | 6.0 | `W_cohesive_device_range` |
| `W_cc_topic_sentence_unclear` | coherence | Topic sentence không rõ | CC | 6.0 | `W_paragraph_topic_sentence` |
| `W_cc_progression_unclear` | coherence | Không có overall progression logic | CC | 5.5 | — |
| `W_lr_repetitive` | lexical | Lặp từ (good/important/bad) | LR | 5.0 | `W_lexical_precision` |
| `W_lr_wrong_collocation` | lexical | Collocation sai (do a mistake vs make) | LR | 6.5 | `W_collocation_awareness` |
| `W_lr_word_form_error` | lexical | Sai word form (success vs successful) | LR | 5.5 | — |
| `W_lr_spelling` | lexical | Chính tả sai | LR | 5.0 | — |
| `W_lr_paraphrase_task_mis` | lexical | Paraphrase đề sai nghĩa | LR | 6.5 | `W_paraphrase_task` |
| `W_gra_only_simple` | grammar | Chỉ simple sentences, không complex | GRA | 5.0 | `W_complex_structure_range` |
| `W_gra_complex_with_error` | grammar | Có complex nhưng nhiều lỗi | GRA | 6.0 | `W_complex_structure_range` |
| `W_gra_tense` | grammar | Tense sai (present cho quá khứ) | GRA | 4.5 | — |
| `W_gra_subject_verb` | grammar | Subject-verb agreement | GRA | 5.0 | — |
| `W_gra_article` | grammar | Article (a/an/the) sai/missing | GRA | 5.5 | — |
| `W_gra_punctuation` | grammar | Punctuation sai (comma splice, run-on) | GRA | 6.5 | `W_punctuation_control` |
| `W_gra_relative_clause` | grammar | Relative clause sai (who/which/that) | GRA | 6.5 | `W_complex_structure_range` |
| `W_t1_no_overview` | task1 | Thiếu overview (yếu tố bắt buộc) | TR_TASK1 | 5.0 | `W_overview_t1` |
| `W_t1_detail_dump` | task1 | Liệt kê mọi số, không chọn trend | TR_TASK1 | 6.0 | `W_data_selection_t1` |
| `W_t1_opinion_injected` | task1 | Đưa ý kiến cá nhân vào (Task 1 phải neutral) | TR_TASK1 | 5.0 | — |
| `W_letter_wrong_tone` | gt_letter | Tone sai loại (formal cho bạn bè) | TR_LR | 6.0 | `W_tone_register_letter` |

## Speaking — error taxonomy

| error_id | Category | Mô tả | criterion_impact | band_signal | microskill_ref |
|---|---|---|---|---|---|
| `S_fc_short_answer` | fluency | Câu trả lời ngắn (yes/no), không extend | FC | 5.0 | `S_extend_answer` |
| `S_fc_long_pause` | fluency | Pause dài (>5s), mất flow | FC | 5.5 | `S_long_turn_sustain` |
| `S_fc_repetition` | fluency | Lặp từ/câu nhiều | FC | 5.5 | — |
| `S_fc_off_topic` | fluency | Lạc đề | FC | 5.5 | — |
| `S_fc_part2_under_time` | fluency | Part 2 dừng trước 1 min | FC | 6.0 | `S_cue_card_structure` |
| `S_fc_part3_no_develop` | fluency | Part 3 không defend, câu ngắn | FC | 6.5 | `S_abstract_reasoning` |
| `S_fc_no_discourse_marker` | fluency | Không dùng connector | FC | 6.0 | `S_discourse_marker_use` |
| `S_lr_repetitive` | lexical | Lặp từ | LR | 5.5 | `S_paraphrase_spontaneous` |
| `S_lr_limited_paraphrase` | lexical | Không paraphrase được khi quên từ | LR | 6.5 | `S_paraphrase_spontaneous` |
| `S_lr_wrong_collocation` | lexical | Collocation sai | LR | 6.5 | `S_idiomatic_use` |
| `S_lr_no_idiom` | lexical | Không dùng idiom (band 7.0+ cần) | LR | 7.0 | `S_idiomatic_use` |
| `S_gra_only_simple` | grammar | Chỉ simple | GRA | 5.5 | `S_complex_grammar_speak` |
| `S_gra_tense` | grammar | Tense sai | GRA | 5.0 | — |
| `S_gra_subject_verb` | grammar | Agreement | GRA | 5.5 | — |
| `S_pr_phoneme` | pronunciation | Âm vị sai (/θ/ /ð/ /æ/) | PR | 6.0 | `S_phoneme_target` / `P_phoneme_targeted` |
| `S_pr_word_stress` | pronunciation | Trọng âm từ sai | PR | 6.0 | `P_word_stress_rule` |
| `S_pr_sentence_stress` | pronunciation | Trọng âm câu phẳng, không phân content | PR | 6.5 | `S_sentence_stress_content` |
| `S_pr_intonation_flat` | pronunciation | Ngữ điệu phẳng, không thể hiện ý | PR | 7.0 | `S_intonation_meaning` |
| `S_pr_fast_unintelligible` | pronunciation | Nói quá nhanh → không rõ | PR | 5.5 | — |

## Strategy errors (cross-skill, không thuộc criterion)

| error_id | Mô tả |
|---|---|
| `X_time_management` | Quá lâu 1 câu/section, không kịp |
| `X_instruction_misread` | Đọc sai instruction (số từ, chọn mấy cái) |
| `X_answer_transfer_wrong` | Sai answer sheet (Listening/Reading) |
| `X_skip_and_not_return` | Bỏ câu rồi không quay lại |

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.

- `version: 1.0.1` — audited error IDs and microskill references; no untracked taxonomy ID is silently introduced.
- `version: 1.0.5` — converted `criterion_impact` and `band_signal` cells to controlled values; no new error node added.
- `version: 1.0.6` — normalized the per-file release record; taxonomy nodes are unchanged.
- Thêm: bump minor; sửa mô tả: patch; bỏ: deprecated_in (không xóa).

## Không tự suy luận

Mistake Notebook tag, Error Graph node, và `COACH.ErrorAnalysis` output phải dùng `error_id` từ taxonomy này. Lỗi chưa phân loại → `unknown_error` + flag Colab bổ sung.
