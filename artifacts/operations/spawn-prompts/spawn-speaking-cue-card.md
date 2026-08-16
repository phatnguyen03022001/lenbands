# PROMPT: Spawn Speaking Cue Card (DeepSeek V4 Flash)

> Copy from `---BẮT ĐẦU---` to the end. Replace the two parameters.

---BẮT ĐẦU---

You are a content spawner for the LenBands IELTS app. Your task is to generate Speaking Part 2 cue cards from the framework. DO NOT rely on training knowledge; use only the framework in this repository.

## PARAMETERS
- part: `part2`  (only Part 2 uses cue cards; Part 1/3 use question sets and a different prompt)
- count: 5 cue cards

## STEP 1 — READ FRAMEWORK
- `blueprint/framework/speaking-parts-framework.md`  ← Part 2 structure, cue-card anatomy, genre taxonomy (person/place/object/experience/event/activity)
- `blueprint/framework/band-descriptor-map.md`  ← Speaking FC/LR/GRA/PR descriptors
- `blueprint/framework/microskill-enum.md`  ← Speaking micro-skills (S_cue_card_structure, S_long_turn_sustain...)
- `blueprint/framework/vocab-collocation-topic.md`  ← topic enum
- `blueprint/framework/README.md`

## STEP 2 — GENERATE 5 CUE CARDS
Each cue card follows the framework anatomy:
```text
Describe [a person/place/object/experience/event/activity].

You should say:
- who/what/where it is
- how you know/learned about it
- what you do/did there
- and explain why [opinion/feeling].
```

The 5 cue cards must vary by genre: 1 person, 1 place, 1 object, 1 experience, and 1 event/activity. Do not repeat a genre within the set.

## STEP 3 — CUE CARD SCHEMA

```yaml
cue_card_id: S_cc_001
part: part2
genre: person                # person | place | object | experience | event | activity
topic_ref: [t_society_culture]
band_range: 5.0-9.0
prompt_text: |
  Describe a person who has had a significant influence on your life.

  You should say:
  - who this person is
  - how you first met them
  - what they did to influence you
  and explain why their influence has been so important to you.
microskill_ref: [S_cue_card_structure, S_long_turn_sustain]
follow_up_part3:             # 3-4 Part 3 follow-up questions linked to the cue card
  - "How do role models influence young people today?"
  - "Do you think family influence is stronger than peer influence?"
  - "Has the nature of role models changed in your country?"
rights:
  origin: cambridge_pattern
  origin_ref: "original cue card, pattern follows IELTS Part 2"
status: draft
version: 0.1.0
```

## HARD RULES
1. `genre` must be one of the 6 values (person/place/object/experience/event/activity).
2. `topic_ref` must belong to the 10-topic enum.
3. `microskill_ref` must exist in `microskill-enum.md` for Speaking.
4. The cue card must follow the required anatomy: 4 bullets, with the final bullet using "and explain why".
5. `follow_up_part3` must be abstract and appropriate to Part 3, while remaining linked to the cue-card topic.
6. The 5 cards must use varied genres without repetition.
7. DO NOT copy a real Cambridge cue card.

## STOP CONDITIONS
- Genre/topic outside the enum → `unknown_*`, STOP.
- Unsure about Part 3 follow-up quality → write `needs_review`.

## SIDECAR META.YAML SCHEMA (canonical)
```yaml
type: knowledge-asset
asset_kind: speaking_cue_card
asset_id: KA-NNNNNN
status: draft
version: 0.1.0
owner: colab
derived_from: [KA.Exercise]
framework_refs:
  - file: speaking-parts-framework
    version: 1.0.6
    nodes: [S_part2_long_turn]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: S_cc_001.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-speaking-cue-card, prompt_hash: <hash>, model: <model-id>, parameters: {part: part2}}
created_at: "2026-08-07T00:00:00Z"
updated_at: "2026-08-07T00:00:00Z"
```

The sidecar is canonical metadata; `rights.origin` in the payload is only an authoring-side classification when needed and does not replace sidecar `origin`.

## OUTPUT
2 files per cue card:
- `knowledge-assets/speaking-cue-cards/S_cc_001.md`
- `knowledge-assets/speaking-cue-cards/S_cc_001.meta.yaml`

The output sidecar must follow the canonical schema above and contain the correct checksum for the `.md` payload.

Begin by reading the framework and generating 5 cue cards with varied genres.

---KẾT THÚC---
