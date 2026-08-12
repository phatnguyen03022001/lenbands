# PROMPT: Spawn Grammar Lesson (DeepSeek V4 Flash)

> Copy từ `---BẮT ĐẦU---` đến cuối. Thay `grammar_id` nếu cần.

---BẮT ĐẦU---

Bạn là content spawner cho app IELTS LenBands. Nhiệm vụ: sinh 1 grammar lesson từ framework. KHÔNG dùng kiến thức training — chỉ dùng framework trong repo.

## THAM SỐ
- grammar_id: `g_second_conditional`  (đổi tại đây nếu spawn grammar point khác — phải có trong grammar-band-framework.md)
- band_master: 7.0  (lấy từ framework, không tự đặt)

## BƯỚC 1 — ĐỌC FRAMEWORK
- `blueprint/framework/grammar-band-framework.md`  ← 47 grammar point + node schema (band_introduce, band_master, depends_on, done_when, can_statement)
- `blueprint/framework/error-taxonomy.md`  ← error gắn grammar (vd W_gra_complex_with_error)
- `blueprint/framework/review-mapping.md`  ← review rule cho grammar error
- `blueprint/framework/microskill-enum.md`  ← microskill gắn grammar (vd W_complex_structure_range)
- `blueprint/framework/README.md`  ← nguyên tắc controlled vocabulary

Nếu `grammar_id` không có trong framework → báo `unknown_grammar_id`, DỪNG.

## BƯỚC 2 — SINH LESSON
Lesson phải dạy grammar point đó ở độ sâu band_master. Bao gồm: rule, form, usage, band signal (khi nào dùng để lên band), ví dụ đúng, ví dụ sai (error phổ biến), exercise gợi ý.

## BƯỚC 3 — SCHEMA LESSON FILE

```markdown
---
grammar_id: g_second_conditional
lesson_id: gl_second_conditional_01
band_master: 7.0
band_introduce: 6.0
can_statement: <lấy từ framework node, nguyên văn>
depends_on: [<lấy từ framework node>]
microskill_ref: [W_complex_structure_range]
status: draft
version: 0.1.0
owner: colab
derived_from:
  - KA.Grammar
  - g_second_conditional
---

# Second Conditional

## Rule
<nội dung: định nghĩa, dạng form, cách dùng>

## Form
<if + past simple, would + bare infinitive; câu ví dụ form>

## Usage
<khi nào dùng: hypothetical present/future, advice, imagination>

## Band signal (6.0 → 7.0)
<vì sao dùng second conditional giúp lên band 7: complex structure, hypothetical reasoning>

## Examples (đúng)
<3-5 câu đúng, tự nhiên, gắn topic IELTS nếu được>

## Common errors (liên kết error-taxonomy)
<2-3 lỗi phổ biến, dạng sai → sửa, gắn error_id từ error-taxonomy.md>

## Practice gợi ý
<2-3 bài tập: sentence transformation, gap fill, writing task ứng dụng>

## Review mapping
<nhắc review rule từ review-mapping.md cho error gắn grammar này>
```

## LUẬT CỨNG
1. `grammar_id` PHẢI có trong `grammar-band-framework.md`. Ngoài → `unknown_grammar_id`, DỪNG.
2. `band_master`, `band_introduce`, `can_statement`, `depends_on` lấy **nguyên văn** từ framework node — không tự sửa.
3. `error_id` trong "Common errors" PHẢI có trong `error-taxonomy.md`.
4. `microskill_ref` PHẢI có trong `microskill-enum.md`.
5. Ví dụ đúng phải câu tiếng Anh thật, đúng form second conditional.
6. Ví dụ sai phải là lỗi thật learner mắc (vd "If I will have money, I would travel" → sai "will" trong if-clause).
7. KHÔNG bịa error_id/microskill_id ngoài enum.
8. Nếu framework chỉ có summary table và thiếu `can_statement` hoặc edge provenance, ghi `null`/`needs_review`; không tự viết field như thể đã lấy từ framework.

## ĐIỀU KIỆN DỪNG
- grammar_id không có trong framework → `unknown_grammar_id`, DỪNG.
- Framework file không đọc được → báo, DỪNG.
- Không chắc ví dụ/form → ghi `needs_review`, KHÔNG bịa.

## SIDECAR META.YAML SCHEMA (canonical)
```yaml
type: knowledge-asset
asset_kind: grammar_lesson
asset_id: KA-NNNNNN
status: draft
version: 0.1.0
owner: colab
derived_from: [KA.Grammar]
framework_refs:
  - file: grammar-band-framework
    version: 1.0.6
    nodes: [g_second_conditional]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: gl_second_conditional_01.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-grammar-lesson, prompt_hash: <hash>, model: <model-id>, parameters: {grammar_id: g_second_conditional}}
created_at: "2026-08-07T00:00:00Z"
updated_at: "2026-08-07T00:00:00Z"
```

Sidecar là metadata canonical; không lặp `grammar_id`, `band_master` hoặc lesson content vào sidecar ngoài các field lineage/framework cần audit.

## OUTPUT
2 file:
- `knowledge-assets/grammar/gl_second_conditional_01.md`       (nội dung lesson)
- `knowledge-assets/grammar/gl_second_conditional_01.meta.yaml`

Output sidecar phải theo schema canonical ở trên và checksum đúng payload `.md`.

Bắt đầu: đọc framework, xác nhận grammar_id có, rồi sinh lesson.

---KẾT THÚC---
