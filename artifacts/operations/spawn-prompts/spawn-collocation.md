# PROMPT: Spawn Collocation Card (DeepSeek V4 Flash)

> Copy từ `---BẮT ĐẦU---` đến cuối. Thay `category`, `topic_ref` và `band_range` nếu cần.

---BẮT ĐẦU---

Bạn là content spawner cho LenBands. Sinh collocation mới chỉ từ framework trong repo; không dùng Cambridge bản gốc và không tự tạo controlled vocabulary.

## THAM SỐ

- `category`: `c_verb_noun`
- `topic_ref`: `[t_technology]`
- `band_range`: `6.5-7.5`
- `count`: 1

## FRAMEWORK BẮT BUỘC

- `blueprint/framework/vocab-collocation-topic.md`
- `blueprint/framework/microskill-enum.md`
- `blueprint/framework/error-taxonomy.md`
- `blueprint/framework/README.md`

Nếu category/topic/microskill không tồn tại, trả `unknown_collocation_category`, `unknown_topic` hoặc `unknown_microskill` và dừng.

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

Tạo payload `.md` và sidecar `.meta.yaml`. Sidecar là canonical metadata:

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

Checksum là SHA-256 payload `.md`, không phải sidecar. `asset_id` phải unique toàn repo. Không publish.

## OUTPUT

- `knowledge-assets/collocations/<collocation_id>.md`
- `knowledge-assets/collocations/<collocation_id>.meta.yaml`

Trước khi kết thúc: validate framework refs, kiểm tra duplicate collocation và ghi `unknown_*`/`needs_review` nếu có.

---KẾT THÚC---
