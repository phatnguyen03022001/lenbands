# PROMPT: Spawn Error Example (DeepSeek V4 Flash)

> Copy từ `---BẮT ĐẦU---` đến cuối. Thay `error_id` nếu cần.

---BẮT ĐẦU---

Bạn là content spawner cho LenBands. Sinh một error example phục vụ `COACH.ErrorAnalysis` và review mapping. Chỉ dùng error node tồn tại trong framework; không tự suy luận error taxonomy.

## THAM SỐ

- `error_id`: `W_lr_wrong_collocation`
- `skill`: `writing`
- `band_range`: `6.0-7.0`

## FRAMEWORK BẮT BUỘC

- `blueprint/framework/error-taxonomy.md`
- `blueprint/framework/review-mapping.md`
- `blueprint/framework/microskill-enum.md`
- `blueprint/framework/README.md`

Nếu `error_id` không tồn tại, trả `unknown_error_id` và dừng. Nếu chưa có mapping hợp lệ, trả `needs_review`; không tạo mapping mới.

## PAYLOAD SCHEMA

```yaml
error_example_id: ex_w_lr_wrong_collocation_001
error_id: W_lr_wrong_collocation
skill: writing
band_range: 6.0-7.0
incorrect: The policy did a significant contribution to society.
corrected: The policy made a significant contribution to society.
explanation: Use make, not do, with contribution in this collocation.
evidence_type: learner_like_minimal_pair
review_rule_ref: <lookup from review-mapping.md>
status: draft
version: 0.1.0
```

## SIDECAR OUTPUT

```yaml
type: knowledge-asset
asset_kind: error_example
asset_id: KA-NNNNNN
status: draft
version: 0.1.0
owner: colab
derived_from: [KA.Example]
framework_refs:
  - file: error-taxonomy
    version: 1.0.6
    nodes: [W_lr_wrong_collocation]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: <error_example_id>.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-error-example, prompt_hash: <hash>, model: <model-id>, parameters: {error_id: W_lr_wrong_collocation}}
created_at: "2026-08-07T00:00:00Z"
updated_at: "2026-08-07T00:00:00Z"
```

Checksum là SHA-256 payload `.md`, không phải sidecar. Không ghi learner content thật, PII hoặc raw evaluation payload. Không publish.

## OUTPUT

- `knowledge-assets/error-examples/<error_example_id>.md`
- `knowledge-assets/error-examples/<error_example_id>.meta.yaml`

Kết thúc bằng danh sách `unknown_*`/`needs_review`; nếu không có thì ghi `none`.

---KẾT THÚC---
