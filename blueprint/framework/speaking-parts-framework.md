---
version: 1.0.6
scope: framework
---

# Speaking Parts Framework (Part 1/2/3 + Pronunciation depth)

Status: `framework` — định nghĩa behavior từng part, depth pronunciation feedback, và examiner interaction rule. Feed `EVAL.Speaking`, `EVAL.Examiner`, `EVAL.Pronunciation`, `LEARN.Speaking`, `BAND.Map` speaking row.

## Part 1 — Interview (4-5 min)

### Cấu trúc

- Examiner hỏi **introductory questions** (ID check, hometown, work/study).
- Sau đó **3 topic** từ list quen (mỗi topic ~4 sub-questions, tổng 12 câu Part 1).
- Topic pool (rotated, AI examiner chọn tránh lặp gần đây của learner):
  `home, family, food, hobbies, weather, music, reading, sport, internet, daily routine, travel, animals, colours, flowers, noise, patience, concentration, memory, time management, punctuality`

### Examiner topic rotation rule (`EVAL.Examiner`)

AI examiner phải tuân:
- Chọn **3 topic** ngẫu nhiên từ pool mỗi session Part 1, **không trùng** topic đã hỏi trong 3 session gần nhất của learner (anti-repeat).
- ID check + work/study question luôn đầu (fixed, không rotate).
- Không hỏi 2 topic quá giống nhau trong 1 session (vd "music" + "reading" OK; "travel" + "holidays" overlap → tránh).
- Pool có thể mở rộng qua Colab review (thêm topic mới), nhưng không thu hẹp.

### Behavior kỳ vọng

| Band | Behavior |
|---|---|
| 5.0 | Câu ngắn, có extend nhẹ |
| 6.0 | Extend answer (Why? How?), một số discourse marker |
| 7.0 | Extend tự nhiên, paraphrase, less common vocab, complex grammar |
| 8.0+ | Spontaneous, idiomatic, fully coherent |

### Examiner (EVAL.Examiner) rules

- Không hỏi follow-up phức tạp (Part 1 giữ social).
- Nếu learner trả lời < 5s → follow-up nhẹ "Can you tell me more about...?"
- Nếu learner lạc đề → examiner kéo về nhẹ "I mean...".
- Examiner **không** sửa learner — chỉ evaluate.

### Error thường gặp

| error_id | Mapping |
|---|---|
| `S_fc_short_answer` | luyện extend (`S_extend_answer`) |
| `S_fc_long_pause` | luyện sustain |
| `S_lr_repetitive` | paraphrase spontaneous |
| `S_gra_tense` | tense drill |

## Part 2 — Long Turn / Cue Card (3-4 min)

### Cấu trúc

- Cue card: topic + 3-4 bullet points gợi ý + "and explain why...".
- 1 min prep (ghi note允许), 1-2 min nói liên tục.
- Examiner không interrupt (trừ khi dừng sớm → follow-up).

### Cue card anatomy

```text
Describe [a person/place/object/experience/event].

You should say:
- who/what/where it is
- how you know/learned about it
- what you do/did there
- and explain why [opinion/feeling].
```

4 sub-prompts theo genre: person / place / object / experience / event / activity.

### Behavior kỳ vọng

| Band | Behavior |
|---|---|
| 5.0 | Cover 1-2 bullet, dừng sớm, repetition |
| 6.0 | Cover most bullets, sustain 1+ min, một số structure |
| 7.0 | Cover all, coherent narrative, range vocab+grammar, **monologue sustained** |
| 8.0+ | Engaging narrative, idiomatic, sophisticated |

### Examiner rules

- 1 min prep → prompt "You have one minute... you can make notes."
- Learner dừng trước 1 min → examiner "Is there anything else you'd like to add?" hoặc follow-up 1 câu.
- Learner nói quá 2 min → examiner cắt nhẹ "Thank you."
- Examiner không hỏi follow-up dài (Part 2 là monologue).

### Error thường gặp

| error_id | Mapping |
|---|---|
| `S_fc_long_pause` | luyện sustain (`S_long_turn_sustain`) |
| `S_fc_part2_under_time` | luyện cue card structure |
| `S_fc_repetition` | paraphrase + structure |

## Part 3 — Discussion (4-5 min)

### Cấu trúc

- Abstract discussion liên quan Part 2 topic.
- Examiner hỏi **abstract question** (why, how, future prediction, comparison, evaluation).
- ~4-6 questions, có follow-up đào sâu.

### Behavior kỳ vọng

| Band | Behavior |
|---|---|
| 5.0 | Câu ngắn, khó với abstract |
| 6.0 | Cố defend, một số reasoning |
| 7.0 | Abstract reasoning, defend với evidence, hypothetical |
| 8.0+ | Sophisticated argument, speculation, nuance |

### Examiner rules (interaction depth)

- Đây là **phần interaction sâu nhất** — examiner có follow-up:
  - "Why do you think that is?"
  - "Can you give an example?"
  - "Do you think this will change in the future?"
  - "How does this compare to...?"
- Examiner có thể **challenge** nhẹ ("Some people would argue X...") để ép learner defend.
- Examiner không reveal opinion.

### Error thường gặp

| error_id | Mapping |
|---|---|
| `S_fc_part3_no_develop` | luyện abstract reasoning (`S_abstract_reasoning`) |
| `S_gra_only_simple` | luyện complex grammar nói |
| `S_lr_no_idiom` | idiomatic use |

## Pronunciation feedback depth

Pronunciation là criterion PR của Speaking nhưng được tách thành `EVAL.Pronunciation` vì depth feedback khác.

### Unit đánh giá (per utterance)

`EVAL.Pronunciation` output có 5 layer:

| Layer | Đơn vị | Output |
|---|---|---|
| Phoneme | từng âm vị | per-phoneme score (0-1) + error list |
| Word stress | từng từ content | correct/incorrect + rule violated |
| Sentence stress | mỗi câu | pattern analysis (content vs function words) |
| Rhythm | mỗi utterance | stress-timed pattern (English là stress-timed, không phải syllable-timed) — đo variation giữa stressed/unstressed syllables, phân biệt với sentence stress (rhythm = luồng, stress = vị trí) |
| Intonation | mỗi utterance | rising/falling/flat + appropriateness |
| Connected speech | mỗi phrase | linking/elision/assimilation identified |

**Phân biệt Rhythm vs Sentence Stress (quan trọng):** Sentence stress chỉ *vị trí* từ được nhấn; Rhythm đo *luồng* (flow) — khoảng cách giữa các stressed syllables có đều không, có tự nhiên không. Learner Việt Nam thường dồn đều (syllable-timed L1 transfer) → rhythm phẳng. Rhythm là yếu tố band 7+ PR phân biệt với 6.0.

### Feedback priority (cho `COACH.ErrorAnalysis`)

Không dump tất cả lỗi — prioritize theo impact:

| Priority | Issue | Action |
|---|---|---|
| High | Phoneme error làm thay meaning (ship/sheep) | drill targeted |
| High | Word stress sai → unintelligible | drill targeted |
| Medium | Sentence stress phẳng (no content emphasis) | drill pattern |
| Medium | Intonation flat → khó hiểu attitude | shadowing drill |
| Low | Connected speech (linking) thiếu | reference, không bắt buộc band <7 |

### Band correlation (PR criterion)

| Band PR | Pronunciation đặc trưng |
|---|---|
| 5.0 | Limited features, frequent mispronunciation, listener effort |
| 6.0 | Range features mixed control, occasional mispronunciation, generally clear |
| 7.0 | Easy throughout, sustained features, rare errors不影响 meaning |
| 8.0+ | Variety features, natural, effortless |

### Drill kinds (cho `REVIEW.FSRS` card pronunciation)

| kind | Mô tả | Source |
|---|---|---|
| `phoneme_minimal_pair` | Phân biệt ship/sheep | audio mẫu + record |
| `word_stress_rule` | Trọng âm theo rule (phoTOgrapher) | word list |
| `sentence_stress_pattern` | Content vs function stress | sentence + record |
| `intonation_shadowing` | Ngữ điệu shadowing | audio mẫu + record |
| `linking_drill` | Linking phrase | phrase + record |

Mỗi drill có audio mẫu + learner record lại (chấm so với mẫu).

## Examiner (EVAL.Examiner) — interaction rules tổng

| Rule | Mô tả |
|---|---|
| Adaptive follow-up | Follow-up dựa trên câu trả lời learner (không script cứng) |
| Skill-appropriate | Part 1 social, Part 3 abstract — examiner điều chỉnh depth |
| No correction | Examiner không sửa learner |
| No opinion reveal | Examiner neutral |
| Time-bounded | Part 1 4-5min, Part 2 3-4min, Part 3 4-5min |
| Recovery | Learner kẹt → examiner support nhẹ ("Take your time", "Could you rephrase?") |

Examiner là `EVAL.Examiner` capability, implement LLM với context = Part hiện tại + lịch sử câu hỏi/trả lời.

## Cách dùng

- `LEARN.Speaking` practice: learner chọn Part → Examiner interaction.
- `EVAL.Speaking` chấm 4 criterion (FC/LR/GRA/PR).
- `EVAL.Pronunciation` chấm 5 layer pronunciation (tách để depth).
- `BAND.Map` speaking row: per-part readiness, pronunciation sub-items.
- `REVIEW.SmartQueue` pronunciation queue: card từ drill kinds trên.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.

- `version: 1.0.1` — reconciled speaking error references.
- `version: 1.0.6` — normalized the per-file release record; speaking semantics are unchanged.
- Thêm Part behavior detail: minor.
- Sửa pronunciation depth: patch + research note.

## Không tự suy luận

- Examiner không tự hỏi ngoài pattern Part (vd Part 1 hỏi abstract = bug).
- Pronunciation drill không sinh từ nguồn ngoài `error_id` pronunciation.
- Band PR correlation dựa trên `band-descriptor-map.md`, không tự đặt.
