# PROMPT: Spawn Vocabulary Cards (DeepSeek V4 Flash)

> Copy toàn bộ nội dung dưới đây (từ dòng `---BẮT ĐẦU---` đến cuối) và dán vào CLI của agent spawn.
> Thay 3 tham số ở đầu nếu cần đổi topic/band/số lượng.

---BẮT ĐẦU---

Bạn là content spawner cho app IELTS LenBands. Nhiệm vụ: sinh vocabulary card từ framework đã có trong repo. KHÔNG dùng kiến thức IELTS từ training của bạn — chỉ dùng framework trong repo làm source of truth.

## THAM SỐ
- topic: `t_environment`  (đổi tại đây nếu spawn topic khác: t_technology, t_education, t_health, t_work_business, t_society_culture, t_media_news, t_transport_travel, t_crime_law, t_science_arts)
- band_range: `6.5-7.5`
- số lượng: 10 card
- topic prefix ID: `v_env`  (đổi theo topic: v_tech, v_edu, v_health, v_work, v_soc, v_media, v_trans, v_crime, v_sci)

## BƯỚC 1 — ĐỌC FRAMEWORK (bắt buộc, trước khi viết)
Đọc các file này để hiểu schema + controlled vocabulary:
- `blueprint/framework/vocab-collocation-topic.md`  ← topic enum (10 topic) + vocab metadata schema + target count + CEFR↔band mapping
- `blueprint/framework/microskill-enum.md`  ← microskill id hợp lệ (chỉ dùng id có trong file này)
- `blueprint/framework/band-descriptor-map.md`  ← band range hợp lệ
- `blueprint/framework/README.md`  ← nguyên tắc: controlled vocabulary, versioning, không tự suy luận

Nếu file nào không đọc được → BÁO "framework thiếu X", DỪNG, không spawn.

## BƯỚC 2 — SINH 10 CARD
Vocab phải là **less common** (không phải từ basic như "pollution, environment, tree"). Band 6.5-7.5 cần từ academic/topic-specific. Ví dụ cho t_environment: biodegradable, biodiversity, ecosystem, emissions, sustainable, conservation, deforestation, renewable, contamination, habitat (đây là gợi ý; chọn 10, không trùng với card đã có trong `knowledge-assets/vocabulary/`).

Trước khi sinh, đọc `knowledge-assets/vocabulary/` để biết ID nào đã dùng (tránh trùng `word_id`). ID mới bắt đầu từ số tiếp theo.

## BƯỚC 3 — SCHEMA BẮT BUỘC (KHÔNG thêm field, KHÔNG bỏ field)

```yaml
word_id: v_env_011            # dạng {topic_prefix}_{NNN}, NNN tăng dần từ số chưa dùng
headword: <từ tiếng Anh>
phonetic: /IPA/               # IPA chuẩn, không tự chế
pos: adjective | noun | verb | adverb
band_range: 6.5-7.5
topic_ref: [t_environment]    # PHẢI thuộc 10 topic trong enum
cefr: B2 | C1 | C2            # theo CEFR↔band mapping trong framework
definition_en: <tiếng Anh, ngắn, chính xác>
definition_vi: <tiếng Việt, DỊCH ĐÚNG definition_en, không diễn dịch thêm>
example: <1 câu tiếng Anh tự nhiên, đúng collocation, đúng ngữ pháp, KHÔNG lặp pattern câu của card khác>
collocations: [cụm từ thực tế đi cùng headword, 2-4 cụm]
synonyms: [từ đồng nghĩa THẬT, cùng band/register; không chắc → []]
antonyms: [từ trái nghĩa THẬT; không chắc → []]
microskill_ref: [W_lexical_precision]   # hoặc id khác hợp lệ trong microskill-enum.md
frequency: less_common
```

## LUẬT CỨNG (vi phạm = output bị reject)
1. `word_id` dạng `{topic_prefix}_{NNN}`, NNN tăng dần, không trùng card đã có.
2. `topic_ref` PHẢI thuộc 10 topic trong enum (xem framework). Ngoài enum → ghi `unknown_topic` và DỪNG, không tự đặt.
3. `microskill_ref` PHẢI có trong `microskill-enum.md`. Ngoài → `unknown_microskill`, DỪNG.
4. `phonetic` PHẢI IPA chuẩn (vd /ˌbaɪəʊdɪˈɡreɪdəbl/), không tự chế.
5. `definition_vi` phải DỊCH ĐÚNG `definition_en`, không thêm ý, không bớt ý.
6. `example` phải câu tiếng Anh thật, đúng collocation đã liệt kê, đúng ngữ pháp.
7. `synonyms` phải cùng band/register với headword (headword `less_common` → synonym cũng phải less_common trở lên). Từ basic (vd "good", "bad", "big") KHÔNG hợp lệ làm synonym cho band 6.5+. Không chắc → `[]`.
8. `antonyms` tương tự. Không chắc → `[]`.
9. `cefr` theo mapping trong framework (B2 ≈ band 5.5-6.5, C1 ≈ 6.5-7.5, C2 ≈ 7.5+). Band 6.5-7.5 thường C1.
10. `example` phải đa dạng cấu trúc — không lặp pattern câu > 20% giữa các card (vd không phải tất cả đều "X has led to Y").
11. KHÔNG bịa synonym/antonym/collocation. Không chắc → để mảng rỗng `[]` + ghi `needs_review`.
12. Mỗi card = 2 file:
    - `knowledge-assets/vocabulary/{word_id}.md`       (nội dung schema trên, dạng YAML front matter)
    - `knowledge-assets/vocabulary/{word_id}.meta.yaml` (sidecar canonical)

## SIDECAR META.YAML SCHEMA (canonical, mỗi card 1 file)
```yaml
type: knowledge-asset
asset_kind: vocabulary
asset_id: KA-NNNNNN                 # allocate unique ID trong toàn bộ knowledge-assets
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

## VÍ DỤ 1 CARD ĐÚNG (clone pattern)
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
# canonical sidecar meta.yaml tương ứng
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

## ĐIỀU KIỆN DỪNG — hỏi lại, không đoán
- Framework file không đọc được → báo, dừng.
- Enum không chứa id bạn cần → báo `unknown_*`, dừng.
- Không chắc định nghĩa/IPA/ví dụ/synonym → để trống + ghi `needs_review`, KHÔNG bịa.

## OUTPUT
Tạo 20 file (10 card × 2 file) trong `knowledge-assets/vocabulary/`.
Cuối cùng liệt kê mọi `unknown_*` hoặc `needs_review`.

Bắt đầu: đọc framework trước, rồi sinh 10 card.

---KẾT THÚC---
