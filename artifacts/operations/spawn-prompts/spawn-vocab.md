# PROMPT: Spawn Vocabulary Cards (DeepSeek V4 Flash)

> Copy all content below, from `---BẮT ĐẦU---` to the end, and paste it into the spawn-agent CLI.
> Replace the three parameters at the top when changing topic/band/count.

---BẮT ĐẦU---

You are a content spawner for the LenBands IELTS app. Your task is to generate vocabulary cards from the framework already present in the repository. DO NOT use IELTS knowledge from training; use only the repository framework as the source of truth.

## PARAMETERS
- topic: `t_environment`  (change when spawning another topic: t_technology, t_education, t_health, t_work_business, t_society_culture, t_media_news, t_transport_travel, t_crime_law, t_science_arts)
- band_range: `6.5-7.5`
- count: 10 cards
- topic prefix ID: `v_env`  (change by topic: v_tech, v_edu, v_health, v_work, v_soc, v_media, v_trans, v_crime, v_sci)

## STEP 1 — READ FRAMEWORK (required before writing)
Read these files to understand the schema + controlled vocabulary:
- `blueprint/framework/vocab-collocation-topic.md`  ← topic enum (10 topics) + vocabulary metadata schema + target counts + CEFR↔band mapping
- `blueprint/framework/microskill-enum.md`  ← valid micro-skill IDs; use only IDs from this file
- `blueprint/framework/band-descriptor-map.md`  ← valid band range
- `blueprint/framework/README.md`  ← principles: controlled vocabulary, versioning, no inference

If any file cannot be read → REPORT "framework missing X" and STOP; do not spawn.

## STEP 2 — GENERATE 10 CARDS
Vocabulary must be **less common**, not basic words such as "pollution, environment, tree". Band 6.5-7.5 requires academic/topic-specific vocabulary. Examples for t_environment include biodegradable, biodiversity, ecosystem, emissions, sustainable, conservation, deforestation, renewable, contamination, habitat. These are suggestions only; choose 10 that do not duplicate existing cards in `knowledge-assets/vocabulary/`.

Before generating, read `knowledge-assets/vocabulary/` to determine which IDs already exist and avoid duplicate `word_id`. New IDs begin from the next unused number.

## STEP 3 — REQUIRED SCHEMA (DO NOT add or remove fields)

```yaml
word_id: v_env_011            # format {topic_prefix}_{NNN}; NNN increments from the next unused value
headword: <English word>
phonetic: /IPA/               # standard IPA; do not invent
pos: adjective | noun | verb | adverb
band_range: 6.5-7.5
topic_ref: [t_environment]    # MUST belong to the 10-topic enum
cefr: B2 | C1 | C2            # follow CEFR↔band mapping in the framework
definition_en: <short, precise English definition>
definition_vi: <Vietnamese translation that matches definition_en exactly; do not add interpretation>
example: <1 natural English sentence using a valid collocation and correct grammar; do NOT repeat the same sentence pattern across cards>
collocations: [2-4 genuine collocations with the headword]
synonyms: [genuine synonyms at the same band/register; if uncertain → []]
antonyms: [genuine antonyms; if uncertain → []]
microskill_ref: [W_lexical_precision]   # or another valid id from microskill-enum.md
frequency: less_common
```

## HARD RULES (violation = rejected output)
1. `word_id` format is `{topic_prefix}_{NNN}` with sequential unused NNN values; do not duplicate an existing card.
2. `topic_ref` MUST belong to the 10-topic enum. Outside the enum → write `unknown_topic` and STOP; do not invent a topic.
3. `microskill_ref` MUST exist in `microskill-enum.md`. Otherwise → `unknown_microskill`, STOP.
4. `phonetic` MUST use standard IPA, e.g. /ˌbaɪəʊdɪˈɡreɪdəbl/; do not invent phonetic notation.
5. `definition_vi` must accurately TRANSLATE `definition_en` without adding or removing meaning.
6. `example` must be genuine English, grammatically correct, and use a listed collocation appropriately.
7. `synonyms` must match the headword's band/register. A `less_common` headword should not use basic words such as "good", "bad", or "big" as supposed same-register synonyms. If uncertain → `[]`.
8. `antonyms` follow the same rule. If uncertain → `[]`.
9. `cefr` follows framework mapping (B2 ≈ band 5.5-6.5, C1 ≈ 6.5-7.5, C2 ≈ 7.5+). Band 6.5-7.5 is commonly C1 in this framework.
10. `example` structure must vary; no single sentence pattern may appear in >20% of cards.
11. DO NOT invent synonyms/antonyms/collocations. If uncertain → use an empty array `[]` + record `needs_review`.
12. Each card = 2 files:
    - `knowledge-assets/vocabulary/{word_id}.md`       (the schema above as YAML front matter)
    - `knowledge-assets/vocabulary/{word_id}.meta.yaml` (canonical sidecar)

## SIDECAR META.YAML SCHEMA (canonical, one per card)
```yaml
type: knowledge-asset
asset_kind: vocabulary
asset_id: KA-NNNNNN                 # allocate a unique ID across all knowledge-assets
status: draft
version: 0.1.0
owner: colab
derived_from: [KA.Vocabulary]
framework_refs:
  - file: vocab-collocation-topic
    version: 1.0.6
    nodes: [t_environment]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: <word_id>.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage:
  workflow_run_id: <actual-workflow-run-id>
  prompt_template_id: spawn-vocab
  prompt_hash: <prompt-template-hash>
  model: <model-id>
  parameters: {topic: t_environment, band_range: 6.5-7.5}
created_at: "2026-08-07T00:00:00Z"
updated_at: "2026-08-07T00:00:00Z"
```

## EXAMPLE OF ONE VALID CARD (clone the pattern)
```yaml
word_id: v_env_011
headword: biodegradable
phonetic: /ˌbaɪəʊdɪˈɡreɪdəbl/
pos: adjective
band_range: 6.5-7.5
topic_ref: [t_environment]
cefr: C1
definition_en: capable of being decomposed naturally by microorganisms
definition_vi: có khả năng phân hủy tự nhiên bởi vi sinh vật
example: The company switched to fully biodegradable packaging to reduce its environmental impact.
collocations: [biodegradable materials, biodegradable packaging, fully biodegradable]
synonyms: [compostable, decomposable]
antonyms: [non-biodegradable]
microskill_ref: [W_lexical_precision]
frequency: less_common
```

```yaml
# corresponding canonical sidecar meta.yaml
type: knowledge-asset
asset_kind: vocabulary
asset_id: KA-000011
status: draft
version: 0.1.0
owner: colab
derived_from: [KA.Vocabulary]
framework_refs:
  - file: vocab-collocation-topic
    version: 1.0.6
    nodes: [t_environment]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: v_env_011.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: run-001, prompt_template_id: spawn-vocab, prompt_hash: <hash>, model: <model-id>, parameters: {}}
created_at: "2026-08-07T00:00:00Z"
updated_at: "2026-08-07T00:00:00Z"
```

## STOP CONDITIONS — ask/review rather than guess
- Framework file cannot be read → report and stop.
- Enum does not contain the required ID → report `unknown_*` and stop.
- Uncertain about definition/IPA/example/synonym → leave the uncertain field empty where allowed + record `needs_review`; DO NOT invent.

## OUTPUT
Create 20 files (10 cards × 2 files) under `knowledge-assets/vocabulary/`.
Finally list every `unknown_*` or `needs_review`.

Begin by reading the framework, then generate the 10 cards.

---KẾT THÚC---
