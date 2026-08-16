---
version: 1.0.7
scope: framework
---

# Vocabulary × Collocation × Topic Framework

Status: `framework` — LenBands-controlled vocabulary/collocation/topic taxonomy and authoring schema. Feeds `KA.Vocabulary`, `KA.Collocation`, search/recommendation tags, and curriculum coverage views.

Authority:
- Topic IDs, collocation categories, asset metadata shape, and internal content-routing labels are `lenbands-controlled`.
- Vocabulary/collocation counts, band ranges attached to words, and any relationship between item count and IELTS band are `experimental-heuristic` unless a calibration record says otherwise.
- IELTS does **not** publish a fixed number of words, collocations, or idioms required for a band. These counts must never be presented as an official band requirement or used to calculate a band.
- CEFR and IELTS are distinct scales. A vocabulary asset may carry a CEFR label only when that label has its own provenance; do not derive CEFR mechanically from an IELTS band tag.

## Topic enum (LenBands-controlled)

These 10 topic IDs are an internal content-organization scheme. They cover common broad subject areas useful for IELTS preparation but are **not** an official exhaustive IELTS topic list.

| topic_id | Topic | Example sub-topics |
|---|---|---|
| `t_environment` | Environment | climate, pollution, conservation, energy |
| `t_technology` | Technology | AI, internet, social media, automation |
| `t_education` | Education | school, university, learning methods, assessment |
| `t_health` | Health | diet, exercise, mental health, healthcare |
| `t_work_business` | Work & Business | jobs, workplace, careers, economy |
| `t_society_culture` | Society & Culture | family, tradition, urbanisation, demographics |
| `t_media_news` | Media & News | journalism, advertising, entertainment, information quality |
| `t_transport_travel` | Transport & Travel | public transport, tourism, aviation, commuting |
| `t_crime_law` | Crime & Law | justice, punishment, policing, rights |
| `t_science_arts` | Science & Arts | research, space, music, literature, museums |

Sub-topics may evolve, but `topic_id` must come from the controlled enum. Unknown topic → `unknown_topic`.

## Vocabulary coverage hypotheses

Historical LenBands planning used cumulative active-vocabulary targets such as 600 / 1200 / 2500 / 4000 / 6000 items across progressively higher curriculum buckets. These numbers are retained only as **unvalidated capacity-planning hypotheses** so existing planning artifacts remain interpretable.

```yaml
vocabulary_count_hypothesis:
  status: unvalidated
  values: [600, 1200, 2500, 4000, 6000]
  permitted_use: content_capacity_planning_only
  prohibited_use: [ielts_band_requirement, learner_band_scoring, readiness_gate]
```

Do not show a learner "2500 words = Band 7" or any equivalent claim. A learner may demonstrate strong lexical resource with a different inventory, and IELTS scores lexical performance in context rather than counting known headwords.

## Vocabulary metadata schema

```yaml
word_id: v_env_001
headword: ephemeral
phonetic: /ɪˈfɛm(ə)rəl/
pos: adjective
band_range: 6.5-7.5              # internal routing heuristic unless calibrated
calibration_status: provisional  # provisional | calibrated | retired
topic_ref: [t_environment, t_science_arts]
cefr: C1                         # optional; requires independent provenance
cefr_source_ref: <source-or-null>
definition_en: lasting for a very short time
definition_vi: ngắn ngủi, phù du
example: Fame in the modern age is often ephemeral.
collocations: [ephemeral nature, ephemeral phenomenon]
synonyms: [transient, fleeting, momentary]
antonyms: [permanent, enduring]
microskill_ref: [W_lexical_precision]
frequency: less_common
```

Core identity/content fields: `word_id, headword, phonetic, pos, topic_ref, definition_en, example, frequency`.

Rules:
- `band_range` is content-routing metadata, not proof that knowing the word produces that band.
- `cefr` must not be inferred from `band_range`; missing provenance → omit/`null`/`needs_review` according to the asset schema.
- Synonyms, antonyms, pronunciation, and collocations require linguistic review where generated confidence is insufficient.

## Collocation framework

### Controlled categories

| category_id | Type | Example |
|---|---|---|
| `c_adj_noun` | Adjective + Noun | heavy rain, stark contrast |
| `c_verb_noun` | Verb + Noun | make a decision, take a risk |
| `c_verb_prep` | Verb + Preposition | depend on, result in |
| `c_noun_noun` | Noun + Noun | business model, climate change |
| `c_verb_adverb` | Verb + Adverb | significantly improve, sharply decline |
| `c_fixed_phrase` | Fixed phrase | on the contrary, in light of |
| `c_academic_phrase` | Academic phrase | a body of evidence |

Historical target counts such as 100 / 300 / 600 / 1000 / 1500 active collocations are **unvalidated capacity-planning hypotheses** with the same prohibited uses as vocabulary counts. They are not IELTS requirements.

### Collocation metadata schema

```yaml
collocation_id: c_verb_noun_042
collocation: make a significant contribution
category: c_verb_noun
band_range: 6.5-7.5
calibration_status: provisional
topic_ref: [t_work_business, t_society_culture]
example: She has made a significant contribution to the field.
synonyms_phrases: [play a major role, contribute substantially]
common_mistake: "do a contribution"
microskill_ref: [W_collocation_awareness]
```

## Topic coverage planning

Content operations may distribute assets across the 10 topic IDs to avoid severe authoring imbalance. Any per-topic numeric quota belongs to an operational content plan, not to IELTS scoring or `BAND.Requirement`.

`BAND.Map` must not display vocabulary/collocation item counts as if they were official band thresholds. A separate **Curriculum Coverage** view may display authored/mastered inventory counts when clearly labeled as LenBands curriculum data.

## Idiomatic language

LenBands may classify idiomatic/formulaic language for Speaking practice, for example:

| idiom_category | Example |
|---|---|
| `i_simile_metaphor` | a blessing in disguise |
| `i_phrasal_verb_idiomatic` | come up with |
| `i_colloquial_phrase` | to cut a long story short |

There is no fixed "N idioms for Band 7" rule. Speaking Lexical Resource is assessed holistically. Forced or inappropriate idiom use can reduce naturalness/precision rather than improve a score.

## Usage

- `KA.Vocabulary`: each asset uses a controlled `word_id`/topic schema and preserves provenance.
- `KA.Collocation`: each asset uses a controlled category and provenance.
- Search/recommendation may use topic/category metadata.
- Curriculum coverage may count mastered/internal assets, but a count must not become an IELTS band calculation.
- `REVIEW.FSRS`: cards can reference `word_id` or `collocation_id` as learning-unit identity.
- `COACH.ErrorAnalysis`: observed lexical/collocation evidence can link to relevant assets for remediation.

## Calibration boundary

A vocabulary/collocation difficulty or band association can become `calibrated` only when a governed calibration record provides method, sample, confidence, date, and version. Calibration may improve adaptive routing; it still does not create an official IELTS vocabulary-count requirement.

## Versioning

- Current release: `1.0.7`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — audited topic/collocation/idiom controlled IDs and provenance/version metadata.
- `version: 1.0.6` — normalized the per-file release record; controlled enums were unchanged.
- `version: 1.0.7` — reclassified vocabulary/collocation count targets and item band labels as unvalidated LenBands planning/routing heuristics, removed fixed idiom-count claims, and prohibited count-based IELTS band inference.
- Adding a controlled topic/category: minor bump + `added_in`.
- Correcting authoring metadata or heuristic interpretation: patch + review note.
- Removal: deprecate rather than silently delete.

## Do not infer

- Do not invent official IELTS vocabulary, collocation, topic, or idiom-count requirements.
- Do not convert `known_count` into an IELTS band.
- Do not derive CEFR directly from IELTS band metadata.
- Unknown topic/category → `unknown_topic` / `unknown_collocation_category`.
- Concrete learner-facing word/collocation content remains governed Knowledge Asset content, not framework-owned truth.
