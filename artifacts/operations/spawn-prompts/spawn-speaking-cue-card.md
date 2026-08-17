# PROMPT: Spawn Speaking Cue Card (DeepSeek V4 Flash)

> Copy from `---BẮT ĐẦU---` to the end. Replace the two parameters.

---BẮT ĐẦU---

You are a content spawner for the LenBands IELTS app. Generate Speaking Part 2 practice/task-card assets from the governed framework. DO NOT invent IELTS format rules from training knowledge.

## PARAMETERS
- part: `part2`
- count: 5 cue cards

## STEP 1 — READ FRAMEWORK
- `blueprint/framework/speaking-parts-framework.md`  ← official-derived Part 2 contract + LenBands authoring conventions
- `blueprint/framework/band-descriptor-map.md`  ← operational descriptor summaries; not a substitute for official scoring
- `blueprint/framework/microskill-enum.md`  ← controlled Speaking micro-skill IDs
- `blueprint/framework/vocab-collocation-topic.md`  ← LenBands topic enum
- `blueprint/framework/README.md`  ← authority classes

If a required controlled ID is missing, return the relevant `unknown_*` value and stop. Do not invent it.

## STEP 2 — GENERATE 5 TASK CARDS
Official-format constraints:
- Part 2 is an individual long turn.
- The card gives a topic, tells the learner what points to include, and asks the learner to explain one aspect of the topic.
- Do NOT claim IELTS requires exactly four bullets or the literal phrase `and explain why`.

LenBands may use this normalized authoring pattern:

```text
Describe [a person/place/object/experience/event/activity].

You should say:
- [relevant point]
- [relevant point]
- [relevant point]
- and explain [one aspect of the topic].
```

The five assets should vary in subject/genre for content diversity. Genre diversity is a LenBands authoring policy, not an IELTS scoring rule.

## STEP 3 — CUE CARD SCHEMA

```yaml
cue_card_id: S_cc_001
part: part2
genre: person                # LenBands enum: person | place | object | experience | event | activity
topic_ref: [t_society_culture]
band_range: 5.0-9.0          # content-routing metadata; not an automatic scoring claim
prompt_text: |
  Describe a person who has had a significant influence on your life.

  You should say:
  - who this person is
  - how you first met them
  - what they did to influence you
  and explain why their influence has been important to you.
microskill_ref: [S_cue_card_structure, S_long_turn_sustain]
follow_up_part3:
  - "How can role models influence young people?"
  - "Do families and peers influence people in different ways?"
  - "How might the idea of a role model change in the future?"
rights:
  origin: generated
  origin_ref: "original LenBands task card following the public IELTS Part 2 interaction pattern"
status: draft
version: 0.1.0
```

## HARD RULES
1. `genre` must be a value allowed by the LenBands framework.
2. `topic_ref` must belong to the LenBands topic enum.
3. `microskill_ref` must exist in `microskill-enum.md`.
4. The task card must ask for a topic, provide useful points to include, and ask the learner to explain an aspect; exact bullet count/wording is an internal authoring choice.
5. Part 3 follow-ups must be more general/abstract than the Part 2 personal long turn and remain related to the topic.
6. Do not copy a published IELTS/Cambridge task card.
7. Do not label an internal genre/topic/band-range convention as an official IELTS rule.

## STOP CONDITIONS
- Controlled ID outside an enum → `unknown_*`, STOP.
- Uncertain rights/provenance or format fidelity → `needs_review`.
- A candidate asset is substantially similar to a known published task → reject and regenerate from a different original concept.

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
    version: 1.0.7
    nodes: [S_part2_long_turn]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: S_cc_001.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-speaking-cue-card, prompt_hash: <hash>, model: <model-id>, parameters: {part: part2}}
created_at: "2026-08-17T00:00:00Z"
updated_at: "2026-08-17T00:00:00Z"
```

The sidecar is canonical metadata. `rights.origin` in the payload is authoring-side classification only and does not replace the sidecar provenance/governance fields.

## OUTPUT
2 files per cue card:
- `knowledge-assets/speaking-cue-cards/S_cc_001.md`
- `knowledge-assets/speaking-cue-cards/S_cc_001.meta.yaml`

The output sidecar must contain the correct checksum for the payload. All assets remain `draft` until rights/content review.

Begin by reading the framework, then generate five original Part 2 assets.

---KẾT THÚC---
