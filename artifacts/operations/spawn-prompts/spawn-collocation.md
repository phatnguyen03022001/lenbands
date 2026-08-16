# PROMPT: Spawn Collocation Card (DeepSeek V4 Flash)

> Copy from `---BẮT ĐẦU---` to the end. Replace `category`, `topic_ref`, and `band_range` when needed.

---BẮT ĐẦU---

You are a content spawner for LenBands. Generate a new collocation only from the framework in this repository; do not use original Cambridge material and do not invent controlled vocabulary.

## PARAMETERS

- `category`: `c_verb_noun`
- `topic_ref`: `[t_technology]`
- `band_range`: `6.5-7.5`
- `count`: 1

## REQUIRED FRAMEWORK

- `blueprint/framework/vocab-collocation-topic.md`
- `blueprint/framework/microskill-enum.md`
- `blueprint/framework/error-taxonomy.md`
- `blueprint/framework/README.md`

If the category/topic/microskill does not exist, return `unknown_collocation_category`, `unknown_topic`, or `unknown_microskill` and stop.

## PAYLOAD SCHEMA

```yaml
collocation_id: c_verb_noun_001
collocation: make a significant contribution
category: c_verb_noun
band_range: 6.5-7.5
topic_ref: [t_technology]
example: The research team made a significant contribution to safer battery design.
synonyms_phrases: [play a major role, contribute substantially]
common_mistake: do a contribution
microskill_ref: [W_collocation_awareness]
status: draft
version: 0.1.0
```

## SIDECAR OUTPUT

Create a `.md` payload and a `.meta.yaml` sidecar. The sidecar is canonical metadata:

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
    version: 1.0.6
    nodes: [c_verb_noun, t_technology]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: <collocation_id>.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-collocation, prompt_hash: <hash>, model: <model-id>, parameters: {}}
created_at: "2026-08-07T00:00:00Z"
updated_at: "2026-08-07T00:00:00Z"
```

The checksum is the SHA-256 of the `.md` payload, not the sidecar. `asset_id` must be unique across the repository. Do not publish.

## OUTPUT

- `knowledge-assets/collocations/<collocation_id>.md`
- `knowledge-assets/collocations/<collocation_id>.meta.yaml`

Before finishing: validate framework refs, check for duplicate collocations, and record `unknown_*`/`needs_review` when applicable.

---KẾT THÚC---
