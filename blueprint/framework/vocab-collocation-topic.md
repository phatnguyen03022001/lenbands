---
version: 1.0.6
scope: framework
---

# Vocabulary × Collocation × Topic Framework

Status: `framework` — versioned controlled vocabulary. Định nghĩa **topic enum**, **collocation framework**, và **target count** vocabulary/collocation theo band. Feed `KA.Vocabulary`, `KA.Collocation`, `BAND.Map` vocab row + collocation row.

Quy ước:
- File này KHÔNG liệt kê từng từ (đó là asset, do Colab author). File này định nghĩa **khung** + **số lượng mục tiêu** + **cấu trúc metadata** mỗi từ/collocation phải có.
- Số lượng là **gợi ý band completion** (cho `BAND.Map`), không phải rule cứng — learner có thể master ít hơn nhưng dùng chính xác.
- Versioned; topic enum thêm = minor bump.

## Topic enum (controlled vocabulary)

IELTS topic thường chia thành 10 chủ đề lớn (theo Cambridge + British Council common topic). Mỗi topic có sub-topic.

| topic_id | Topic | Sub-topic ví dụ |
|---|---|---|
| `t_environment` | Environment | climate change, pollution, conservation, renewable energy |
| `t_technology` | Technology | AI, internet, social media, gadgets, automation |
| `t_education` | Education | school, university, learning methods, exams, teachers |
| `t_health` | Health | diet, exercise, mental health, disease, healthcare |
| `t_work_business` | Work & Business | jobs, workplace, career, management, economy |
| `t_society_culture` | Society & Culture | family, tradition, urbanization, crime, demographic |
| `t_media_news` | Media & News | journalism, advertising, fake news, entertainment |
| `t_transport_travel` | Transport & Travel | public transport, tourism, aviation, commuting |
| `t_crime_law` | Crime & Law | justice, punishment, policing, rights |
| `t_science_arts` | Science & Arts | research, space, music, literature, museums |

Sub-topic là flexible (Colab thêm), nhưng `topic_id` phải thuộc 10 trên. Topic ngoài enum → báo `unknown_topic`.

## Vocabulary target count theo band × topic

Số lượng từ (headword) learner cần **active** (dùng được, không chỉ nhận biết) cho band target, phân bổ đều 10 topic:

| Band target | Total vocab active | Per topic (avg) | Band range của chính bản thân từ |
|---|---|---|---|
| 5.0 | ~600 | 60 | most band 4-5 |
| 6.0 | ~1200 | 120 | band 5-6 |
| 7.0 | ~2500 | 250 | band 6-7 (less common + topic) |
| 8.0 | ~4000 | 400 | band 7-8 (sophisticated + rare) |
| 9.0 | ~6000 | 600 | band 8-9 (idiomatic + precise) |

Lưu ý:
- Active (dùng được Writing/Speaking) ≠ passive (nhận biết Reading/Listening). Reading/Listening cần nhiều hơn (~2x).
- Band 6→7 vùng phân biệt: vocab **less common** + **topic-specific** + **precise synonym**.
- Con số cumulative — mỗi band cộng thêm, không thay thế.

`BAND.Map` vocab row hiển thị `{known_count} / {target_for_band}` per topic, vd "Health 22/70 (band 6.5-7.0 gợi ý 70)".

## Vocabulary metadata schema (mỗi từ trong `KA.Vocabulary`)

Mỗi headword asset phải có:

```yaml
word_id: v_env_001
headword: ephemeral
phonetic: /ɪˈfɛm(ə)rəl/
pos: adjective
band_range: 6.5-7.5
topic_ref: [t_environment, t_science_arts]
cefr: C1
definition_en: lasting for a very short time
definition_vi: ngắn ngủi, phù du
example: Fame in the modern age is often ephemeral.
collocations: [ephemeral nature, ephemeral phenomenon]
synonyms: [transient, fleeting, momentary]
antonyms: [permanent, enduring]
microskill_ref: [W_lexical_precision, S_idiomatic_use]
frequency: less_common
```

Trường bắt buộc: `word_id, headword, phonetic, pos, band_range, topic_ref, definition_en, example, frequency`. Trường khác optional nhưng recommend.

## Collocation framework

Collocation = cụm từ thường đi cùng nhau. Band 6→7 phân biệt quan trọng ở **collocation awareness**.

### Collocation categories (types)

| category_id | Loại | Ví dụ |
|---|---|---|
| `c_adj_noun` | Adj + Noun | heavy rain, stark contrast |
| `c_verb_noun` | Verb + Noun (delexical) | make a decision, take a risk |
| `c_verb_prep` | Verb + Preposition | depend on, result in |
| `c_noun_noun` | Noun + Noun | business model, climate change |
| `c_verb_adverb` | Verb + Adverb | significantly improve, sharply decline |
| `c_fixed_phrase` | Fixed phrase | on the contrary, in light of |
| `c_academic_phrase` | Academic phrase | it is widely argued that, a body of evidence |

### Collocation target count theo band

| Band target | Collocations active (tổng) | Per category (avg) |
|---|---|---|
| 5.0 | ~100 | 15 |
| 6.0 | ~300 | 45 |
| 7.0 | ~600 | 85 |
| 8.0 | ~1000 | 140 |
| 9.0 | ~1500 | 215 |

`BAND.Map` collocation row: `{known}/{target}` per category, vd "Cause/effect 5/20".

### Collocation metadata schema

```yaml
collocation_id: c_verb_noun_042
collocation: make a significant contribution
category: c_verb_noun
band_range: 6.5-7.5
topic_ref: [t_work_business, t_society_culture]
example: She has made a significant contribution to the field.
synonyms_phrases: [play a major role, contribute substantially]
common_mistake: "do a contribution" (sai — phải là make)
microskill_ref: [W_collocation_awareness]
```

## Topic coverage matrix (gợi ý, cho `BAND.Map` + Colab authoring)

Mỗi cell là số từ/collocation gợi ý tối thiểu cho band 7.0 (band 6.0 ≈ 50%, band 8.0 ≈ 150%):

| Topic | Vocab band 7 | Collocation band 7 |
|---|---|---|
| t_environment | 250 | 60 |
| t_technology | 250 | 60 |
| t_education | 250 | 60 |
| t_health | 250 | 60 |
| t_work_business | 250 | 60 |
| t_society_culture | 250 | 60 |
| t_media_news | 250 | 60 |
| t_transport_travel | 250 | 60 |
| t_crime_law | 250 | 60 |
| t_science_arts | 250 | 60 |
| **Total** | **2500** | **600** |

Khớp với count band 7.0 ở bảng trên. Colab nên ưu tiên author topic đều, không lệch (nhiều environment, ít crime).

## Idiom framework (band 7+ Speaking)

Speaking band 7.0+ cần idiomatic. Idiom enum (subset):

| idiom_category | Ví dụ |
|---|---|
| `i_simile_metaphor` | a blessing in disguise, hit the nail on the head |
| `i_phrasal_verb_idiomatic` | come up with, look forward to, get along with |
| `i_colloquial_phrase` | at the end of the day, to cut a long story short |

Idiom count band 7.0+ Speaking: ~80 active. Không bắt buộc Writing (Writing tránh colloquial).

## Cách dùng

- `KA.Vocabulary` asset: mỗi từ có metadata schema + `word_id`.
- `KA.Collocation` asset: mỗi collocation có schema + `collocation_id`.
- `BAND.Map` vocab row: hiển thị per-topic `{known}/{target}` với target theo band từ bảng trên.
- `BAND.Map` collocation row: hiển thị per-category `{known}/{target}`.
- `REVIEW.FSRS` card `recall_meaning`: source `word_id` hoặc `collocation_id`.
- `COACH.ErrorAnalysis` map vocab/collocation error (`W_lr_wrong_collocation`, `W_lr_repetitive`) → `collocation_id`/`word_id`.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.

- `version: 1.0.1` — 10 topic, 7 collocation category, 3 idiom category; provenance/version audit completed.
- `version: 1.0.6` — normalized the per-file release record; vocabulary enums and targets are unchanged.
- Thêm topic: minor + `added_in`.
- Sửa target count: patch + note (research-backed, không đoán).

## Không tự suy luận

- `BAND.Map` target count phải khớp bảng này, không tự bịa "band 7 cần 5000 từ".
- Topic/collocation id ngoài enum không hợp lệ → báo `unknown_topic` / `unknown_collocation_category`.
- Asset (từ/collocation thực) là Colab author, không phải framework này sinh ra.
