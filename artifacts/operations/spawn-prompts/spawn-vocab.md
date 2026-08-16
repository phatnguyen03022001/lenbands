# PROMPT: Spawn Vocabulary Cards (DeepSeek V4 Flash)

> Copy from `---BẮT ĐẦU---` to the end. Replace the parameters when needed.

---BẮT ĐẦU---

You are a content spawner for the LenBands IELTS app. Generate original vocabulary assets from the governed LenBands curriculum. Do not invent official IELTS vocabulary requirements or CEFR↔IELTS conversions.

## PARAMETERS
- topic: `t_environment`
- routing_band_range: `6.5-7.5`
- count: 10
- topic_prefix: `v_env`

## REQUIRED FRAMEWORK
- `blueprint/framework/vocab-collocation-topic.md`
- `blueprint/framework/microskill-enum.md`
- `blueprint/framework/band-descriptor-map.md`
- `blueprint/framework/README.md`

`routing_band_range` is provisional LenBands metadata for content routing. It is not an IELTS score requirement. CEFR is optional and must have independent provenance; do not derive it mechanically from an IELTS band.

If a topic or micro-skill ID is missing, return `unknown_topic` or `unknown_microskill` and stop.

## PAYLOAD SCHEMA

```yaml
word_id: v_env_011
headword: biodegradable
phonetic: /ˌbaɪəʊdɪˈɡreɪdəbl/
pos: adjective
band_range: 6.5-7.5
calibration_status: provisional
topic_ref: [t_environment]
cefr: null
cefr_source_ref: null
definition_en: capable of being decomposed naturally by microorganisms
definition_vi: có khả năng phân hủy tự nhiên bởi vi sinh vật
example: The company switched to biodegradable packaging to reduce waste.
collocations: [biodegradable materials, biodegradable packaging]
synonyms: [compostable, decomposable]
antonyms: [non-biodegradable]
microskill_ref: [W_lexical_precision]
frequency: less_common
status: draft
version: 0.1.0
```

## HARD RULES
1. Allocate a unique `word_id`; check existing assets first.
2. `topic_ref` and `microskill_ref` must use controlled IDs.
3. `band_range` is provisional routing metadata; never claim knowing this word earns or is required for that band.
4. Do not derive `cefr` from `band_range`. If no reviewed CEFR source exists, keep `cefr` and `cefr_source_ref` null.
5. IPA, definition, collocations, synonyms, antonyms, and examples must be linguistically defensible. Uncertain field → leave empty/null where allowed + `needs_review`; do not fabricate.
6. `definition_vi` is learner localization and must faithfully translate `definition_en`.
7. Avoid duplicate headwords and near-duplicate cards.
8. Generated content remains `draft`; it is not publishable until rights/content review.
9. Do not infer an IELTS band from vocabulary count, frequency label, topic, or item metadata.

## SIDECAR META.YAML

```yaml
type: knowledge-asset
asset_kind: vocabulary
asset_id: KA-NNNNNN
status: draft
version: 0.1.0
owner: colab
derived_from: [KA.Vocabulary]
framework_refs:
  - file: vocab-collocation-topic
    version: 1.0.7
    nodes: [t_environment]
  - file: microskill-enum
    version: 1.0.7
    nodes: [W_lexical_precision]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: <word_id>.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-vocab, prompt_hash: <hash>, model: <model-id>, parameters: {topic: t_environment, routing_band_range: 6.5-7.5}}
created_at: "2026-08-17T00:00:00Z"
updated_at: "2026-08-17T00:00:00Z"
```

## STOP CONDITIONS
- Unknown controlled ID → `unknown_*`, STOP.
- Uncertain linguistic/provenance field → `needs_review`.
- Candidate duplicates or closely copies governed/published content → reject and generate a different original item.

## OUTPUT
Create payload + sidecar pairs under `knowledge-assets/vocabulary/`. Validate framework refs, duplicate risk, provenance, and checksum. List all `unknown_*`/`needs_review`.

---KẾT THÚC---
