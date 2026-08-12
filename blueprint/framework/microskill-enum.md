---
version: 1.0.6
scope: framework
---

# Micro-skill Enumeration

Status: `framework` — versioned controlled vocabulary. Liệt kê micro-skills cần có cho mỗi question type/task. Feed `target_micro_skills` trong `learning_design_profile`, `BAND.Map` micro-skill row, và `COACH.ErrorAnalysis`.

Quy ước:
- `id` dạng `{skill}_{microskill}` snake_case, versioned (bump version khi thêm/sửa, không xóa — đánh `deprecated`).
- `applies_to`: question type/task mà skill này là điều kiện cần.
- `band_signal`: band range mà micro-skill này bắt đầu phân biệt.
- File này là **enum**; asset/lesson không tự đặt micro-skill mới.

## Node schema (mỗi micro-skill)

Mỗi micro-skill đầy đủ là **node khép kín** sở hữu quan hệ + điều kiện hoàn thành + phát biểu (inline ownership). Các bảng hiện tại là controlled inventory; row chưa có schema đầy đủ không được dùng để claim outcome đã calibrated. Graph/index toàn cục = projection, không phải SSOT.

```yaml
id: R_matching_headings
name: Matching Headings (skill)
applies_to: [R_matching_headings]      # question_type id từ skill-questiontype-band.md
band_signal: 6.0
can_statement: "Learner can identify the main idea of a paragraph and match it to the correct heading by recognizing paraphrase and discourse markers."
depends_on:
  - id: R_skim_main_idea
    strength: hard_prerequisite
    source: colab_curated
  - id: R_paraphrase_recognition
    strength: hard_prerequisite
    source: colab_curated
  - id: R_discourse_marker_tracking
    strength: recommended
    source: colab_curated
done_when:
  accuracy_pct: 80                     # micro-skill threshold thấp hơn grammar (vì câu khó khách quan)
  consecutive_sessions: 3
  no_review_regression_days: 30
  evidence_source: [practice, mock_test]
unlocks:
  - R_matching_information             # cùng cơ chế main idea + paraphrase, nâng cao
```

Quy ước:
- `can_statement`: bắt buộc, dạng "Learner can ..." (learner-facing, không phải tên kỹ thuật).
- `depends_on`: prerequisite micro-skill. `strength` và `source` giống grammar framework.
- `done_when`: hội điều kiện (AND) để ✓ ở `BAND.Map` micro-skill row.
- `done_when.accuracy_pct` micro-skill thường 80 (khó khách quan hơn grammar drill), grammar 90.

## Listening — micro-skills

| id | Micro-skill | applies_to | band_signal |
|---|---|---|---|
| `L_predict_content` | Predict content từ question trước khi nghe | all | 5.0 |
| `L_signal_word_detection` | Nhận signal word (now, however, finally) | all | 5.5 |
| `L_paraphrase_recognition` | Nhận paraphrase giữa question stem và audio | matching, multiple_choice | 6.0 |
| `L_distractor_rejection` | Loại distractor (sai gần đúng, số liệu bẫy) | multiple_choice, matching | 6.0 |
| `L_number_date_capture` | Bắt số/ngày/địa chỉ chính xác | form/note/table_completion | 4.0 |
| `L_spelling_from_audio` | Chính tả từ nghe được | form/note_completion | 4.5 |
| `L_note_concurrent` | Ghi note trong khi nghe tiếp | note/table_completion | 6.5 |
| `L_follow_direction` | Theo chỉ dẫn spatial (left/right/behind) | map_labelling | 5.5 |
| `L_stage_tracking` | Theo stage của process/diagram | flow_chart_labelling | 6.0 |
| `L_multi_speaker_distinguish` | Phân biệt speakers + quan điểm | matching (multiple speakers) | 6.5 |
| `L_abstract_inference` | Suy luận ý không nói thẳng | multiple_choice, matching | 7.5 |

## Reading — micro-skills

| id | Micro-skill | applies_to | band_signal |
|---|---|---|---|
| `R_skim_main_idea` | Skim lấy main idea của đoạn | matching_headings | 5.0 |
| `R_scan_specific_info` | Scan tìm thông tin cụ thể | matching_information, completion | 4.5 |
| `R_paraphrase_recognition` | Nhận paraphrase stem↔passage | all completion/matching | 6.0 |
| `R_synonym_substitution` | Phát hiện synonym thay thế | true_false_not_given, yes_no | 6.0 |
| `R_distractor_rejection` | Loại distractor lexical trap | multiple_choice | 6.5 |
| `R_writer_attitude_inference` | Suy luận thái độ tác giả (positive/negative) | yes_no_not_given | 7.0 |
| `R_not_given_vs_false` | Phân biệt "sai" (contradict) vs "không có" (not_given) | true_false_not_given, yes_no | 6.0 (ranh quan trọng) |
| `R_global_vs_local` | Phân biệt thông tin toàn bài vs đoạn cụ thể | matching_information, matching_headings | 6.5 |
| `R_reference_resolution` | Giải tham chiếu (this/these/such) | all | 5.5 |
| `R_discourse_marker_tracking` | Theo discourse marker (however/thus/in addition) | matching_headings, sentence_endings | 6.0 |
| `R_abstract_inference` | Suy luận ý không nói thẳng | multiple_choice, yes_no | 7.5 |
| `R_summary_gap_strategy` | Chiến thuật grammar/logic cho summary gap | summary_completion | 6.0 |

## Writing — micro-skills (Task 1 + Task 2)

| id | Micro-skill | applies_to | band_signal |
|---|---|---|---|
| `W_task_analysis` | Phân tích đề, xác định tất cả phần phải trả lời | all | 5.0 (TR) |
| `W_position_clarity` | Duy trì position xuyên suốt | task2 | 6.0 (TR) |
| `W_idea_development` | Phát triển main idea có support (ví dụ/lý lẽ) | task2 | 6.5 (TR) |
| `W_paragraph_topic_sentence` | Topic sentence rõ mỗi đoạn | all | 6.0 (CC) |
| `W_cohesive_device_range` | Dùng range cohesive devices (không mechanical) | all | 7.0 (CC) |
| `W_reference_substitution` | Tham chiếu + substitution (this/this approach/the latter) | all | 6.5 (CC) |
| `W_lexical_precision` | Chọn từ precise (band 7.0 vs adequate) | all | 7.0 (LR) |
| `W_collocation_awareness` | Dùng collocation đúng | all | 7.0 (LR) |
| `W_paraphrase_task` | Paraphrase đề mà không sai nghĩa | all | 6.5 (LR) |
| `W_complex_structure_range` | Range cấu trúc phức tạp (relative/clauses/conditional/inversion) | all | 7.0 (GRA) |
| `W_punctuation_control` | Kiểm soát punctuation (comma, semicolon) | all | 6.5 (GRA) |
| `W_data_selection_t1` | Chọn data quan trọng (trend, comparison, không liệt kê hết) | task1 | 6.0 (TR Task1) |
| `W_overview_t1` | Overview rõ (main trend/feature) | task1 | 6.0 (TR Task1) |
| `W_tone_register_letter` | Tone/register đúng loại letter | gt_letter | 6.0 (TR/LR GT) |

## Speaking — micro-skills

| id | Micro-skill | applies_to | band_signal |
|---|---|---|---|
| `S_extend_answer` | Mở rộng câu trả lời (không chỉ yes/no) | part1 | 5.5 (FC) |
| `S_cue_card_structure` | Cấu trúc monologue 1-2 min có opening/body/closing | part2 | 6.0 (FC) |
| `S_long_turn_sustain` | Duy trì nói không stop > 5s, fill không embarrassed | part2 | 6.5 (FC) |
| `S_abstract_reasoning` | Lý lẽ trừu tượng, defend viewpoint | part3 | 7.0 (FC) |
| `S_discourse_marker_use` | Dùng discourse marker (well/actually/on the other hand) | all | 6.0 (FC) |
| `S_paraphrase_spontaneous` | Paraphrase tức thì khi không nhớ từ | all | 7.0 (LR) |
| `S_idiomatic_use` | Dùng idiom/collocation tự nhiên | part2, part3 | 7.0 (LR) |
| `S_complex_grammar_speak` | Dùng complex grammar khi nói (relative/clauses) | part3 | 7.0 (GRA) |
| `S_self_correction_fluency` | Tự sửa mà không mất fluency | all | 6.5 (FC) |
| `S_intonation_meaning` | Ngữ điệu thể hiện ý (question/emphasis/attitude) | all | 7.0 (PR) |
| `S_sentence_stress_content` | Trọng âm content words rõ | all | 6.5 (PR) |
| `S_phoneme_target` | Phát âm phoneme đích (/θ/ /ð/ /æ/) | all | 6.0 (PR) |

## Pronunciation — micro-skills (subset của Speaking, tách vì feedback riêng)

| id | Micro-skill | band_signal |
|---|---|---|
| `P_phoneme_targeted` | Âm vị đích (per phoneme) | 6.0 |
| `P_minimal_pair` | Phân biệt minimal pair (ship/sheep, bit/beat) | 6.5 |
| `P_word_stress_rule` | Trọng âm từ theo rule (noun/verb, suffix) | 6.0 |
| `P_sentence_stress_pattern` | Trọng âm câu (content vs function) | 6.5 |
| `P_intonation_pattern` | Ngữ điệu (statement rising vs question rising) | 7.0 |
| `P_connected_speech_linking` | Linking (consonant-vowel), elision | 7.5 |
| `P_chunking_pauses` | Chunking, ngắt nghỉ ở đúng chỗ | 6.5 |

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.

- `version: 1.0.1` — clarified inventory-only rows versus spawn-ready nodes.
- `version: 1.0.6` — normalized the per-file release record; micro-skill enum values are unchanged.
- Thêm micro-skill: bump minor (1.1.0) + ghi `added_in`.
- Sửa mô tả không đổi nghĩa: bump patch.
- Bỏ: KHÔNG xóa, đánh `deprecated_in` + keep cho compatibility (asset cũ còn reference).

## Cách dùng

- `learning_design_profile.target_micro_skills[]` chỉ chứa id từ enum này.
- `COACH.ErrorAnalysis` map error → micro-skill bị ảnh hưởng (xem `error-taxonomy.md`).
- `BAND.Map` micro-skill row hiển thị `% đạt band X` theo micro-skill id này.
- `REVIEW.MistakeNotebook` review card có `micro_skill_ref` để FSRS ôn đúng đơn vị.

## Không tự suy luận

Lesson/asset không tự đặt micro-skill id. Nếu thiếu, báo `unknown_microskill` cho Colab → cập nhật enum + bump version.
