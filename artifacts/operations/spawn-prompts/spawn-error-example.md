# PROMPT: Spawn Error Example (DeepSeek V4 Flash)

> Copy from `---BẮT ĐẦU---` to the end. Replace `error_id` when needed.

---BẮT ĐẦU---

You are a content spawner for LenBands. Generate an original minimal error example for `COACH.ErrorAnalysis` and review mapping using only controlled framework IDs.

## PARAMETERS
- `error_id`: `W_lr_wrong_collocation`
- `skill`: `writing`

## REQUIRED FRAMEWORK
- `blueprint/framework/error-taxonomy.md`
- `blueprint/framework/review-mapping.md`
- `blueprint/framework/microskill-enum.md`
- `blueprint/framework/README.md`

If `error_id` does not exist, return `unknown_error_id` and stop. If no valid review mapping exists, return `needs_review`. Do not create a new mapping.

Deprecated error IDs must not be generated for new evidence. In particular, do not generate `S_lr_no_idiom`.

## PAYLOAD SCHEMA

```yaml
error_example_id: ex_w_lr_wrong_collocation_001
error_id: W_lr_wrong_collocation
skill: writing
incorrect: The policy did a significant contribution to society.
corrected: The policy made a significant contribution to society.
explanation: Use make, not do, with contribution in this collocation.
evidence_type: synthetic_minimal_example
review_rule_ref: <lookup from review-mapping.md>
status: draft
version: 0.1.0
```

## HARD RULES
1. `error_id` must be an exact non-deprecated controlled ID.
2. The example must isolate the intended error rather than introduce unrelated errors.
3. `criterion_impact`/`band_signal` from the taxonomy are diagnostic metadata; do not turn this example into a band cap or score claim.
4. Do not use real learner content, PII, raw evaluation payload, or copied published material.
5. Missing/ambiguous mapping or linguistic uncertainty → `needs_review`.

## SIDECAR META.YAML

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
    version: 1.0.7
    nodes: [W_lr_wrong_collocation]
  - file: review-mapping
    version: 1.0.6
    nodes: [W_lr_wrong_collocation]
  - file: microskill-enum
    version: 1.0.7
    nodes: [W_collocation_awareness]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: <error_example_id>.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-error-example, prompt_hash: <hash>, model: <model-id>, parameters: {error_id: W_lr_wrong_collocation}}
created_at: "2026-08-17T00:00:00Z"
updated_at: "2026-08-17T00:00:00Z"
```

## STOP CONDITIONS
- Unknown/deprecated error ID → `unknown_error_id` or `needs_review`, STOP.
- Missing valid review mapping → `needs_review`.

## OUTPUT
- `knowledge-assets/error-examples/<error_example_id>.md`
- `knowledge-assets/error-examples/<error_example_id>.meta.yaml`

Validate framework refs, example isolation, provenance, and checksum. Finish with the `unknown_*`/`needs_review` list.

---KẾT THÚC---
