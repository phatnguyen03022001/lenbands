# 05 — Content & Knowledge System

File này mô tả toàn bộ **Knowledge Layer**: Knowledge Assets (tri thức hệ thống), Taxonomy, Tagging schema, Question Bank, Colab Workflow, Versioning, Publishing. Đây là nền cho mọi feature AI (`REVIEW.FSRS`, `PRACTICE.Adaptive`, `PERSONAL.Insights`, `COACH.ErrorAnalysis`) — metadata nông = garbage in, garbage out.

> **IELTS Knowledge Framework**: bộ khung domain (band descriptor, question type, micro-skill, error taxonomy, grammar/vocab band, speaking parts, writing task, exam module) nằm ở `blueprint/framework/`. Mọi `learning_design_profile`, `KA.*` asset, `BAND.Map` checklist, `EVAL.*` và `REVIEW.*` phải trace về id trong framework. Xem `framework/README.md`.

## Knowledge Assets

Tri thức hệ thống do Colab publish, tiêu thụ bởi learner.

| Asset | Mô tả |
|---|---|
| Lesson | Bài học cấu trúc (theo skill, band, dạng bài) |
| Grammar | Điểm ngữ pháp |
| Vocabulary | Từ vựng (có phonetic, definition, example, collocation, band tag) |
| Collocation | Collocation |
| Template | Mẫu câu Writing / Speaking |
| Strategy | Chiến thuật làm bài theo dạng |
| Example | Ví dụ minh họa (essay sample, speaking transcript mẫu) |
| Exercise | Bài tập gắn với lesson/knowledge |

Mỗi asset có metadata schema (xem Taxonomy dưới).

## Taxonomy & Tagging (core IP)

Đây là phần **quyết định** chất lượng toàn bộ hệ thống AI. Mỗi content item (question, passage, lesson, asset, sample) **bắt buộc** tag theo các chiều:

### Tag dimensions

| Dimension | Ví dụ | Dùng cho |
|---|---|---|
| `skill` | listening / reading / writing / speaking / pronunciation | Routing, filter |
| `band` | 3.0 → 9.0 (step 0.5) | `BAND.*`, `PRACTICE.Adaptive` |
| `question_type` | ID đã có trong framework tương ứng; thiếu registry → `unknown_question_type` | `LEARN.QuestionTypes`, `PERSONAL.Insights` |
| `micro_skill` | ID đã có trong framework tương ứng; thiếu registry → `unknown_microskill` | `PERSONAL.Insights`, `COACH.ErrorAnalysis` |
| `distractor_type` | Registry v1 chưa được định nghĩa → `unknown_distractor_type` | `COACH.DistractorExplanation` |
| `paraphrase_pattern` | Registry v1 chưa được định nghĩa → `unknown_paraphrase_pattern` | `COACH.DistractorExplanation`, `PERSONAL.Insights` |
| `grammar_point` | Grammar ID trong `grammar-band-framework.md`; thiếu → `unknown_grammar_point` | `COACH.ErrorAnalysis`, FSRS card nguồn |
| `ielts_topic` | environment, technology, education, health... | `SEARCH.*`, recommendation |
| `difficulty` | `unknown_difficulty` cho tới khi có calibration run; không claim thang 1–5 | `PRACTICE.Adaptive` |
| `cefr` | A2/B1/B2/C1/C2 | cross-reference band |
| `estimated_time` | phút | `STUDY.DailyPlan` |
| `practice_unit` | Pronunciation unit (`P_*`); bắt buộc khi `skill=pronunciation` | `LEARN.Pronunciation`, `EVAL.Pronunciation`, `REVIEW.FSRS` |

### Tại sao tagging depth quan trọng
   
- `REVIEW.FSRS` chỉ tối ưu nếu card gắn đúng `grammar_point` / `micro_skill` — không thì ôn sai đơn vị.
- `PRACTICE.Adaptive` chọn câu dựa trên `difficulty` + `question_type` + `micro_skill` — thiếu = chọn ngẫu nhiên.
- `PERSONAL.Insights` ("bạn sai Matching Headings vì thiếu paraphrase") cần `question_type` + `micro_skill` + `paraphrase_pattern` — thiếu = không giải thích được.
- `COACH.ErrorAnalysis` cần `grammar_point` để gợi ý đúng bài học.

**Đây là hidden cost của Colab:** khối lượng metadata khổng lồ. Phải có tooling hỗ trợ (auto-tag đề xuất, Colab duyệt). Những dimension chưa có framework registry không được dùng làm build input; phải giữ `unknown_*` và mở decision/evidence riêng.

### Auto-tagging hỗ trợ

Vì tagging thủ công đắt, hệ thống có auto-tag đề xuất (AI-assisted), Colab duyệt lại:

| Capability | Mô tả |
|---|---|
| `CONTENT.AutoTag` | AI đề xuất tag cho content mới (skill, question_type, micro_skill, topic) |
| `CONTENT.TagReview` | Colab duyệt/chỉnh tag trước publish |

## Question Bank

Kho câu hỏi cho L/R (câu hỏi khách quan) và prompt cho W/S.

| Trường | Mô tả |
|---|---|
| `question_id` | duy nhất |
| `skill`, `question_type`, `band`, `difficulty` | taxonomy |
| `passage_id` / `audio_id` | gắn stimulus (L/R) |
| `prompt` | câu hỏi / task |
| `options` | (nếu MCQ) |
| `correct_answer` | key |
| `explanation` | `COACH.AnswerExplanation` dùng |
| `distractor_tags` | cho `COACH.DistractorExplanation` |
| `micro_skill_tags`, `paraphrase_tags` | cho `PERSONAL.Insights` |
| `version`, `status` | versioning (xem dưới) |

## Colab Workflow

```text
Create content
   ↓
Auto-tag (AI đề xuất)          ← CONTENT.AutoTag
   ↓
Tag review (Colab duyệt)       ← CONTENT.TagReview
   ↓
Content review                 ← CONTENT.Moderation
   ↓
Publish                        ← CONTENT.Publish
   ↓
Monitor (feedback, performance)← CONTENT.Feedback
   ↓
Update / Retire                ← CONTENT.BlueprintUpdate
```

### Moderation checklist

- Kiểm lỗi nội dung (factual, chính tả, key sai)
- Kiểm tag (skill, band, question_type, distractor, micro_skill)
- Kiểm difficulty calibration
- Kiểm paraphrase/distractor hợp lệ
- Unpublish nội dung có vấn đề

### Content Feedback loop

Learner báo lỗi → Colab xử lý → fix → republish:

```text
Learner Report Content / Suggest Fix / Report Wrong Answer
   ↓                          ← CONTENT.Feedback
Colab xem (Moderation Queue)
   ↓
Fix (nếu đúng) / Reject (nếu sai)
   ↓
Republish (tăng version)
   ↓
Notify learner (optional)
```

## Versioning

Mỗi content item có `version` và `status`:

| Status | Ý nghĩa |
|---|---|
| `draft` | Colab đang soạn |
| `in_review` | Đang moderation |
| `published` | Live cho learner |
| `deprecated` | Cũ, vẫn truy cập được link cũ nhưng không gợi ý |
| `retired` | Bỏ, không hiển thị |

Khi sửa content đã published → tạo version mới, giữ version cũ để:
- Assessment History không vỡ (learner đã làm version cũ vẫn thấy kết quả đúng)
- FSRS card gắn version không bị orphan

## Publishing policy

- Chỉ `published` mới hiển thị cho learner.
- `deprecated` vẫn truy cập được qua direct link (vd learner đã bookmark) nhưng không vào recommendation/search kết quả chính.
- `retired` ẩn hoàn toàn.
- Khi IELTS blueprint thay đổi → `CONTENT.BlueprintUpdate` cập nhật hàng loạt + tăng version.

## Scope reminder

- Colab **không bao giờ chấm** Writing/Speaking/Pronunciation (`01-product.md` Role boundaries).
- Colab chỉ owns content layer, không owns evaluation layer.
- Auto-tag là AI-assisted, nhưng quyết định cuối cùng do Colab (human-in-the-loop ở **content**, không phải evaluation).

## Taxonomy governance

Tag không chỉ là text tự do; phải dùng controlled vocabulary, version và provenance.

| Quy tắc | Yêu cầu |
|---|---|
| Controlled values | `skill`, `question_type`, `micro_skill`, `distractor_type`, `paraphrase_pattern`, `grammar_point`, `topic` có enum/version |
| Required by asset | Question bắt buộc có answer/explanation; L/R bắt buộc stimulus/segment; W/S bắt buộc prompt/rubric; asset học bắt buộc objective/estimated time |
| Provenance | Mỗi item có source, license, author, reviewer, created_at, updated_at và rationale cho answer/tag khó |
| Calibration | Difficulty, band và estimated_time có method, sample size, confidence và ngày calibration |
| Change impact | Đổi tag/answer phải báo ảnh hưởng tới FSRS, recommendation, attempts, search và published version |
| Quality status | `draft → tagged → reviewed → calibrated → published`; thiếu gate thì không live |

### Content type schemas

Question Bank không đủ để đại diện toàn bộ Knowledge Layer. Cần schema riêng cho:

- **Passage/Audio**: section/part, transcript, segment timestamps, speaker, media codec, duration, accessibility transcript và rights.
- **Lesson/Asset**: objective, prerequisite, explanation, examples, practice links, target band, estimated time và mastery evidence.
- **Writing/Speaking prompt**: task type, official-like constraints, rubric version, allowed context, sample answers và scoring notes.
- **Question**: answer normalization, alternate accepted answers, option order, stimulus version, distractor rationale và exposure limits.

### Controlled coverage matrix — skill, module, question type và band

Đây là **coverage contract**, không phải content inventory và không phải mô tả Band Descriptor chính thức. Nó khóa vocabulary mà Blueprint, Artifact và agent được phép dùng khi mô tả một learning design profile. Asset thực tế, prompt, rubric chi tiết và calibration evidence chỉ xuất hiện sau này.

#### Exam module và band range

| Field | Controlled values | Quy tắc |
|---|---|---|
| `exam_module` | `academic`, `general_training`, `shared` | Writing/Reading phải chỉ rõ module; Listening/Speaking thường dùng `shared`. |
| `learning_band_bucket` | `3.0-4.5`, `5.0-5.5`, `6.0-6.5`, `7.0-7.5`, `8.0-9.0` | Bucket scaffold cho learning design, không là hard gate hay kết quả chấm. |
| `learning_stage` | `foundation`, `developing`, `target`, `advanced`, `precision` | Mapping lần lượt theo năm band range ở trên. |
| `calibration_status` | `provisional`, `calibrated`, `retired` | Không gọi item là calibrated nếu chưa có evidence về method, sample và ngày calibration. |

#### Question-type vocabulary theo skill

| Skill | Controlled `question_type` | Nhóm micro-skill tối thiểu cần map |
|---|---|---|
| Listening | `L_form_completion`, `L_note_completion`, `L_table_completion`, `L_sentence_completion`, `L_flow_chart_completion`, `L_map_plan_labelling`, `L_diagram_labelling`, `L_multiple_choice`, `L_matching`, `L_short_answer` | `L_predict_content`, `L_number_date_capture`, `L_signal_word_detection`, `L_distractor_rejection`, `L_spelling_from_audio`, `L_note_concurrent`, `L_follow_direction`, `L_stage_tracking` |
| Reading | `R_multiple_choice`, `R_multiple_choice_multi`, `R_true_false_not_given`, `R_yes_no_not_given`, `R_matching_headings`, `R_matching_information_paragraph`, `R_matching_information_section`, `R_matching_features`, `R_matching_sentence_endings`, `R_sentence_completion`, `R_summary_completion`, `R_note_completion`, `R_table_completion`, `R_flow_chart_completion`, `R_diagram_labelling`, `R_short_answer` | `R_skim_main_idea`, `R_scan_specific_info`, `R_paraphrase_recognition`, `R_abstract_inference`, `R_reference_resolution`, `R_distractor_rejection` |
| Writing | `W_ac_task1_chart`, `W_ac_task1_table`, `W_ac_task1_process`, `W_ac_task1_map`, `W_ac_task1_diagram`, `W_gt_task1_formal_letter`, `W_gt_task1_semi_formal_letter`, `W_gt_task1_informal_letter`, `W_task2_opinion`, `W_task2_discussion`, `W_task2_advantages_disadvantages`, `W_task2_problem_solution`, `W_task2_two_part` | `W_task_analysis`, `W_position_clarity`, `W_idea_development`, `W_overview_t1`, `W_paragraph_topic_sentence`, `W_cohesive_device_range`, `W_lexical_precision`, `W_complex_structure_range`, `W_punctuation_control` |
| Speaking | `S_part1_interview`, `S_part2_long_turn`, `S_part3_discussion` | `S_extend_answer`, `S_cue_card_structure`, `S_abstract_reasoning`, `S_discourse_marker_use`, `S_paraphrase_spontaneous`, `S_self_correction_fluency`, `S_complex_grammar_speak`, `S_intonation_meaning`, `S_phoneme_target` |

#### Band progression behavior

Mỗi `learning_design_profile` phải chọn **một** band range và mô tả behavior tương ứng; không được dùng nhãn “Band 7+” chung chung.

| Band range / stage | Thiết kế học | Feedback và practice | Bằng chứng tiến bộ tối thiểu |
|---|---|---|---|
| `3.0-4.5` / foundation | Chia nhỏ task, vocabulary hướng dẫn, một mục tiêu quan sát được | Feedback ngắn, một lỗi ưu tiên, practice có scaffold | Hoàn tất task đơn vị + recall/retest có hỗ trợ |
| `5.0-5.5` / developing | Kết nối micro-skill với question type, giảm hint từng bước | Chỉ rõ vì sao sai và một strategy thay thế | Retest cùng error pattern với hint giảm |
| `6.0-6.5` / target | Timed practice vừa phải, trade-off giữa tiêu chí | Evidence trong câu trả lời/bài viết, ưu tiên lỗi ảnh hưởng outcome | Performance ổn định qua nhiều prompt/item tương đương |
| `7.0-7.5` / advanced | Task phức hợp, paraphrase/inference/precision cao hơn | So sánh lựa chọn, chỉ ra nuance và consistency | Retest không scaffold; recurrence lỗi giảm |
| `8.0-9.0` / precision | Tối ưu accuracy, flexibility, kiểm soát rủi ro | Feedback ít nhưng sâu, không khuyến khích overfit template | Evidence đa bối cảnh và kiểm tra anti-gaming |

#### Completeness rule

Một Artifact mô tả lesson, practice, evaluation hoặc review phải khai báo ít nhất: `skill`, `exam_module`, `learning_band_bucket`, `learning_stage`, `target_micro_skills`, `evaluation_rule`, `review_mapping` và `calibration_status`. `question_type` bắt buộc cho Listening/Reading/Writing/Speaking; `practice_unit` bắt buộc cho Pronunciation. Thiếu field theo skill thì artifact chỉ là concept, không được chuyển thành build-ready spec.

## Skill × Question Type × Band Framework

Blueprint chưa cần liệt kê từng asset hay từng bài học, nhưng mọi learning design phải mô tả được tổ hợp `skill × question_type × learning_band_bucket`. Đây là đơn vị chuẩn để sau này tạo Vertical Slice Spec, rubric, practice và review rule.

```yaml
learning_design_profile:
  skill: writing | reading | listening | speaking | pronunciation
  exam_module: academic | general_training | shared
  question_type: <controlled value; required except pronunciation>
  practice_unit: []              # required for pronunciation; P_* from framework
  learning_band_bucket: <one controlled bucket, e.g. 5.0-5.5>
  learning_stage: foundation | developing | target | advanced | precision
  calibration_status: provisional | calibrated | retired
  learner_outcome: <observable outcome>
  prerequisite: []
  target_micro_skills: []
  difficulty_signals: []
  practice_mode: []
  evaluation_rule: <rubric/answer rule reference>
  feedback_priority: []
  review_mapping: <error/review rule reference>
  progressive_disclosure: <what is shown/hidden>
  acceptance_evidence: <how improvement is verified>
```

Quy tắc bất biến:

- `skill`, `question_type`, `learning_band_bucket` dùng controlled vocabulary/version; không dùng text tự do.
- Knowledge Asset payload dùng `band_range` cho target range của asset theo format `N.N-N.N` (ví dụ `6.5-7.5`). Authoring contract dùng `target_band_range: [min, max]`; hai field không được trộn.
- Band là range hướng dẫn độ khó, feedback depth và progressive disclosure; không khóa người học khỏi nội dung có ích.
- Mỗi profile phải có outcome và evidence kiểm chứng, không chỉ có "lesson" hoặc "practice".
- Một Vertical Slice Spec có thể cover nhiều profile cùng behavior, nhưng phải liệt kê rõ profile nào trong scope.
- Thiếu profile không được agent tự suy luận thành content, rubric hoặc band requirement.

### Content quality gates

Trước publish, Colab phải đạt:

1. correctness và answer key đã kiểm tra độc lập;
2. taxonomy completeness và không dùng tag ngoài controlled vocabulary;
3. difficulty/band có calibration evidence hoặc được đánh dấu `provisional`;
4. explanation dẫn tới một action học cụ thể;
5. accessibility, licensing, media integrity và version relationship hợp lệ;
6. không tạo duplicate exposure hoặc leakage cho exam simulation.

### Cost-aware content operations

- Auto-tag theo batch, cache theo content hash và chỉ re-tag phần thay đổi.
- Dùng rule/lookup trước model; model nhỏ đề xuất tag, chỉ escalate item mơ hồ.
- Precompute explanation/embedding khi publish; không tạo lại cho từng learner nếu context không đổi.
- Theo dõi chi phí trên mỗi published item, mỗi explanation và mỗi learner outcome; content có cost cao nhưng outcome thấp phải bị review.

## Cross-references

- Capability id liên quan: `CONTENT.*`, `KA.*` → `03-features.md`
- Tagging feed vào: `PRACTICE.Adaptive`, `PERSONAL.Insights`, `COACH.*`, `REVIEW.FSRS` → `03-features.md`, `06-engines.md`
- Workflow UI cảm xúc → `04-experience.md` (Colab journey nằm ngoài 8 learner journey, là operator journey)
