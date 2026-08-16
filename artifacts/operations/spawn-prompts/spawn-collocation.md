# PROMPT: Spawn Collocation Card (DeepSeek V4 Flash)

> Copy from `---BẮT ĐẦU---` to the end. Replace parameters when needed.

---BẮT ĐẦU---

You are a content spawner for LenBands. Generate an original collocation asset from the governed LenBands taxonomy. Do not invent official IELTS collocation-count or band requirements.

## PARAMETERS
- `category`: `c_verb_noun`
- `topic_ref`: `[t_technology]`
- `routing_band_range`: `6.5-7.5`
- `count`: 1

## REQUIRED FRAMEWORK
- `blueprint/framework/vocab-collocation-topic.md`
- `blueprint/framework/microskill-enum.md`
- `blueprint/framework/README.md`

If category/topic/micro-skill is missing, return `unknown_collocation_category`, `unknown_topic`, or `unknown_microskill` and stop.

## PAYLOAD SCHEMA

```yaml
collocation_id: c_verb_noun_001
collocation: make a significant contribution
category: c_verb_noun
band_range: 6.5-7.5
calibration_status: provisional
topic_ref: [t_technology]
example: The research team made a significant contribution to safer battery design.
synonyms_phrases: [play a major role, contribute substantially]
common_mistake: do a contribution
microskill_ref: [W_collocation_awareness]
status: draft
version: 0.1.0
```

## HARD RULES
1. Controlled category/topic/micro-skill IDs only.
2. `band_range` is provisional routing metadata, not an IELTS requirement or score.
3. Collocation, example, alternatives, and common mistake must be linguistically defensible; uncertainty → `needs_review`.
4. Check duplicates/near-duplicates before assigning an ID.
5. Generated content remains `draft` until rights/content review.
6. Do not infer an IELTS band from collocation count or presence of one phrase.

## SIDECAR META.YAML

```yaml
type: knowledge-asset
asset_kind: collocation
asset_id: KA-NNNNNN
status: draft
version: 0.1.0
owner: colab
derived_from: [KA.Collocation]
framework_refs:
  - file: vocab-collocation-topic
    version: 1.0.7
    nodes: [c_verb_noun, t_technology]
  - file: microskill-enum
    version: 1.0.7
    nodes: [W_collocation_awareness]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: <collocation_id>.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-collocation, prompt_hash: <hash>, model: <model-id>, parameters: {category: c_verb_noun, topic_ref: [t_technology]}}
created_at: "2026-08-17T00:00:00Z"
updated_at: "2026-08-17T00:00:00Z"
```

## STOP CONDITIONS
- Unknown controlled ID → `unknown_*`, STOP.
- Uncertain linguistic/provenance claim → `needs_review`.

## OUTPUT
- `knowledge-assets/collocations/<collocation_id>.md`
- `knowledge-assets/collocations/<collocation_id>.meta.yaml`

Validate framework refs, duplicate risk, provenance, and checksum before completion.

---KẾT THÚC---
