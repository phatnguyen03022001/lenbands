# PROMPT: Spawn Error Example (DeepSeek V4 Flash)

> Copy from `---BẮT ĐẦU---` to the end. Replace `error_id` when needed.

---BẮT ĐẦU---

You are a content spawner for LenBands. Generate one error example for `COACH.ErrorAnalysis` and review mapping. Use only an error node that exists in the framework; do not infer or invent error taxonomy.

## PARAMETERS

- `error_id`: `W_lr_wrong_collocation`
- `skill`: `writing`
- `band_range`: `6.0-7.0`

## REQUIRED FRAMEWORK

- `blueprint/framework/error-taxonomy.md`
- `blueprint/framework/review-mapping.md`
- `blueprint/framework/microskill-enum.md`
- `blueprint/framework/README.md`

If `error_id` does not exist, return `unknown_error_id` and stop. If no valid mapping exists, return `needs_review`; do not create a new mapping.

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

The checksum is the SHA-256 of the `.md` payload, not the sidecar. Do not write real learner content, PII, or raw evaluation payload. Do not publish.

## OUTPUT

- `knowledge-assets/error-examples/<error_example_id>.md`
- `knowledge-assets/error-examples/<error_example_id>.meta.yaml`

Finish with a list of `unknown_*`/`needs_review`; if there are none, write `none`.

---KẾT THÚC---
