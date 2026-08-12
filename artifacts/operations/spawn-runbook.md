# Spawn Runbook — Sample Asset

## Purpose

This runbook describes one spawn from the framework to a `draft` Knowledge Asset. It does not grant publish authority and does not replace the freeze gate.

## Procedure

1. Select `prompt_template_id`, the canonical input, and an existing framework node.
2. Read the prompt artifact in `spawn-prompts/`, then confirm that the framework file has the current version `1.0.5` and that the node does not create anything outside the controlled vocabulary.
3. Create the dedup key from `prompt_template_id + prompt_hash + canonicalized_input + framework_refs`.
4. If the dedup key already has a semantically equivalent asset, `skip`; if the semantics changed, create a new version and record lineage.
5. Generate the `.md` payload and `.meta.yaml` sidecar with `asset_id`, `derived_from`, `framework_refs`, `origin`, `integrity`, `governance`, and `spawn_lineage`.
6. Compute SHA-256 over the `.md` payload, write `integrity.checksum: sha256:<hex>`, and set `payload_file` to the sibling basename.
7. Run `tools/validate-knowledge-assets.sh`; check `unknown_* = 0`, node existence, checksum correctness, and that asset status remains `draft`.
8. Write an immutable run record. Do not move the asset to `published`.

## Privacy and evidence

- Do not write learner content, sensitive raw prompts, or provider payloads to the run record.
- Record `prompt_hash`; do not record the raw prompt.
- When rights lack evidence, retain `origin.source: unknown` or `generated`, and `governance.rights_status: pending_review`.
- Founder approval/publish is a separate step after the run record.

## Output checklist

- [ ] Payload and sidecar exist alongside each other.
- [ ] `asset_id` unique.
- [ ] `framework_refs` pin a valid version/node.
- [ ] Payload checksum matches.
- [ ] `derived_from` is a capability ID.
- [ ] Status = `draft`.
- [ ] No `unknown_*`.
