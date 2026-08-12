# PROMPT: Spawn Speaking Cue Card (DeepSeek V4 Flash)

> Copy từ `---BẮT ĐẦU---` đến cuối. Thay 2 tham số.

---BẮT ĐẦU---

Bạn là content spawner cho app IELTS LenBands. Nhiệm vụ: sinh Speaking Part 2 cue card từ framework. KHÔNG dùng kiến thức training — chỉ dùng framework trong repo.

## THAM SỐ
- part: `part2`  (chỉ Part 2 có cue card; Part 1/3 là question set, prompt khác)
- count: 5 cue card

## BƯỚC 1 — ĐỌC FRAMEWORK
- `blueprint/framework/speaking-parts-framework.md`  ← Part 2 structure, cue card anatomy, genre taxonomy (person/place/object/experience/event/activity)
- `blueprint/framework/band-descriptor-map.md`  ← Speaking FC/LR/GRA/PR descriptor
- `blueprint/framework/microskill-enum.md`  ← Speaking micro-skill (S_cue_card_structure, S_long_turn_sustain...)
- `blueprint/framework/vocab-collocation-topic.md`  ← topic enum
- `blueprint/framework/README.md`

## BƯỚC 2 — SINH 5 CUE CARD
Mỗi cue card theo anatomy chuẩn (framework):
```text
Describe [a person/place/object/experience/event/activity].

You should say:
- who/what/where it is
- how you know/learned about it
- what you do/did there
- and explain why [opinion/feeling].
```

5 cue card phải đa dạng genre: 1 person, 1 place, 1 object, 1 experience, 1 event/activity. KHÔNG lặp genre.

## BƯỚC 3 — SCHEMA CUE CARD

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
follow_up_part3:             # 3-4 câu Part 3 follow-up gắn cue card
  - "How do role models influence young people today?"
  - "Do you think family influence is stronger than peer influence?"
  - "Has the nature of role models changed in your country?"
rights:
  origin: cambridge_pattern
  origin_ref: "original cue card, pattern follows IELTS Part 2"
status: draft
version: 0.1.0
```

## LUẬT CỨNG
1. `genre` phải thuộc 6 loại (person/place/object/experience/event/activity).
2. `topic_ref` phải thuộc 10 topic enum.
3. `microskill_ref` phải có trong `microskill-enum.md` (Speaking skill).
4. Cue card phải đúng anatomy: 4 bullet, bullet cuối "and explain why".
5. `follow_up_part3` phải abstract (Part 3 = abstract reasoning), gắn cue card topic.
6. 5 card phải đa dạng genre (không lặp).
7. KHÔNG copy Cambridge cue card thật.

## ĐIỀU KIỆN DỪNG
- genre/topic ngoài enum → `unknown_*`, DỪNG.
- Không chắc follow-up Part 3 quality → ghi `needs_review`.

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

Sidecar là metadata canonical; `rights.origin` trong payload chỉ là authoring-side classification nếu cần, không thay thế sidecar `origin`.

## OUTPUT
2 file mỗi cue card:
- `knowledge-assets/speaking-cue-cards/S_cc_001.md`
- `knowledge-assets/speaking-cue-cards/S_cc_001.meta.yaml`

Output sidecar phải theo schema canonical ở trên và checksum đúng payload `.md`.

Bắt đầu: đọc framework, sinh 5 cue card đa dạng genre.

---KẾT THÚC---
