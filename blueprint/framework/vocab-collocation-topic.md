---
version: 1.0.6
scope: framework
---

# Vocabulary × Collocation × Topic Framework

Status: `framework` — versioned controlled vocabulary. Defines the **topic enum**, **collocation framework**, and vocabulary/collocation **target counts** by band. Feeds `KA.Vocabulary`, `KA.Collocation`, and the `BAND.Map` vocabulary + collocation rows.

Conventions:
- This file does NOT list individual words; those are Colab-authored assets. It defines the **framework**, **target counts**, and **metadata structure** every vocabulary/collocation asset must follow.
- Counts are **band-completion guidance** for `BAND.Map`, not hard rules. A learner may master fewer items but use them more accurately.
- Versioned; adding a topic enum value requires a minor bump.

## Topic enum (controlled vocabulary)

IELTS content is grouped into 10 broad topics, with flexible sub-topics.

| topic_id | Topic | Example sub-topics |
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

Sub-topics are flexible and may be added by Colab, but `topic_id` must be one of the 10 controlled values above. A topic outside the enum becomes `unknown_topic`.

## Vocabulary target count by band × topic

Approximate number of headwords the learner should know **actively** (can use, not merely recognize) for a target band, distributed across 10 topics:

| Band target | Total active vocab | Per topic (avg) | Typical band range of the words themselves |
|---|---|---|---|
| 5.0 | ~600 | 60 | mostly band 4-5 |
| 6.0 | ~1200 | 120 | band 5-6 |
| 7.0 | ~2500 | 250 | band 6-7 (less common + topic-specific) |
| 8.0 | ~4000 | 400 | band 7-8 (sophisticated + rare) |
| 9.0 | ~6000 | 600 | band 8-9 (idiomatic + precise) |

Notes:
- Active vocabulary usable in Writing/Speaking differs from passive vocabulary recognized in Reading/Listening; passive knowledge is typically much larger.
- The 6→7 discriminating range emphasizes **less common**, **topic-specific**, and **precise synonym** control.
- Counts are cumulative rather than replacements at each band.

The `BAND.Map` vocabulary row displays `{known_count} / {target_for_band}` per topic, for example "Health 22/70 (suggested 70 for band 6.5-7.0)".

## Vocabulary metadata schema (each `KA.Vocabulary` word)

Every headword asset must contain:

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

Required fields: `word_id, headword, phonetic, pos, band_range, topic_ref, definition_en, example, frequency`. Other fields are optional but recommended. Learner-facing localized fields such as `definition_vi` remain localization payload and are not converted merely because framework documentation is English.

## Collocation framework

A collocation is a set of words that conventionally occur together. The 6→7 boundary makes **collocation awareness** particularly important.

### Collocation categories (types)

| category_id | Type | Example |
|---|---|---|
| `c_adj_noun` | Adj + Noun | heavy rain, stark contrast |
| `c_verb_noun` | Verb + Noun (delexical) | make a decision, take a risk |
| `c_verb_prep` | Verb + Preposition | depend on, result in |
| `c_noun_noun` | Noun + Noun | business model, climate change |
| `c_verb_adverb` | Verb + Adverb | significantly improve, sharply decline |
| `c_fixed_phrase` | Fixed phrase | on the contrary, in light of |
| `c_academic_phrase` | Academic phrase | it is widely argued that, a body of evidence |

### Collocation target count by band

| Band target | Active collocations (total) | Per category (avg) |
|---|---|---|
| 5.0 | ~100 | 15 |
| 6.0 | ~300 | 45 |
| 7.0 | ~600 | 85 |
| 8.0 | ~1000 | 140 |
| 9.0 | ~1500 | 215 |

The `BAND.Map` collocation row displays `{known}/{target}` per category, e.g. "Cause/effect 5/20".

### Collocation metadata schema

```yaml
collocation_id: c_verb_noun_042
collocation: make a significant contribution
category: c_verb_noun
band_range: 6.5-7.5
topic_ref: [t_work_business, t_society_culture]
example: She has made a significant contribution to the field.
synonyms_phrases: [play a major role, contribute substantially]
common_mistake: "do a contribution" (incorrect — use make)
microskill_ref: [W_collocation_awareness]
```

## Topic coverage matrix (guidance for `BAND.Map` + Colab authoring)

Each cell is a suggested minimum word/collocation count for band 7.0; band 6.0 is roughly 50% and band 8.0 roughly 150%:

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

This matches the band-7.0 counts above. Colab should author coverage evenly rather than over-producing one topic and neglecting another.

## Idiom framework (band 7+ Speaking)

Speaking at higher bands benefits from natural idiomatic language. Controlled idiom categories include:

| idiom_category | Example |
|---|---|
| `i_simile_metaphor` | a blessing in disguise, hit the nail on the head |
| `i_phrasal_verb_idiomatic` | come up with, look forward to, get along with |
| `i_colloquial_phrase` | at the end of the day, to cut a long story short |

Suggested active idiom count for band-7.0+ Speaking: ~80. These are not required for Writing, where colloquial language is often inappropriate.

## Usage

- `KA.Vocabulary` asset: every word has the metadata schema + `word_id`.
- `KA.Collocation` asset: every collocation has the schema + `collocation_id`.
- `BAND.Map` vocabulary row: show per-topic `{known}/{target}` using target counts above.
- `BAND.Map` collocation row: show per-category `{known}/{target}`.
- `REVIEW.FSRS` `recall_meaning` card: source is `word_id` or `collocation_id`.
- `COACH.ErrorAnalysis` maps vocabulary/collocation errors such as `W_lr_wrong_collocation` and `W_lr_repetitive` to `collocation_id`/`word_id`.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — 10 topics, 7 collocation categories, 3 idiom categories; provenance/version audit completed.
- `version: 1.0.6` — normalized the per-file release record; vocabulary enums and targets are unchanged.
- Adding a topic: minor + `added_in`.
- Changing target counts: patch + note backed by research rather than guesswork.

## Do not infer

- `BAND.Map` target counts must follow this framework; do not invent claims such as "band 7 needs 5000 words".
- Topic/collocation IDs outside the enum are invalid → report `unknown_topic` / `unknown_collocation_category`.
- Actual vocabulary/collocation assets are Colab-authored; this framework does not generate them.
