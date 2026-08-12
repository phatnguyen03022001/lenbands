# Asset Spawn Freeze Gate

## Purpose

Freeze the framework and artifact contract before mass-spawning Knowledge Assets. This gate is an operational policy; it does not itself grant rights, calibration, or content approval.

## Canonical inputs

- Framework domain files must have frontmatter at the current version, currently `1.0.5`, `scope: framework`.
- Every asset must have `framework_refs` pointing to specific nodes and pinned to the current frontmatter version; a node outside the controlled vocabulary must stop with `unknown_*`.
- A framework node is spawn-ready only when its schema is complete; an inventory summary missing `can_statement`/`done_when`/dependency provenance must keep the asset `draft` + `needs_review` and must not publish/calibrate it.
- An artifact contract required by the workflow must be `approved`; an artifact still in `review` may be used only for a recorded validation exception.
- An asset sidecar must have a unique `asset_id`, `derived_from` capability ID, provenance, integrity checksum, and spawn lineage.
- Rights not confirmed by the founder/evidence must remain `pending_review`; do not publish.

## Unlock rule

Mass spawn may be unlocked only when:

1. The framework is frozen at umbrella `framework_version: 1.0.5` and every file has a matching version; `1.0.0`–`1.0.4` remain only as historical snapshots of earlier validation runs.
2. This freeze gate is `approved` with a founder approval record.
3. Required contracts, cost ceiling, idempotency rule, and validation tool have been reviewed/approved within scope.
4. There are no unresolved `unknown_*`, checksum mismatches, or missing framework nodes.
5. The rights/content quality gate is applied before every promotion to `published`.

The gate's `status: review` does not unlock mass spawn.

## Validation spawn exception

Before the founder approves the gate, an agent may run exactly one validation run of at most 7 assets under these conditions:

- The gate is in `review` and this exception is recorded in the workflow.
- Assets remain `draft`; do not publish, serve learners, or mass-spawn.
- The run record records path, payload checksum, framework refs, prompt hash, model/parameters, validator result, and `unknown_*` count.
- The run record is immutable; founder endorsement is recorded in a separate approval record.

## Idempotency and deduplication

The spawn key is the tuple:

```text
prompt_template_id + prompt_hash + canonicalized_input + framework_refs
```

The same key must `skip` when the semantic asset already exists; to change semantics, create a new version with clear lineage. Do not create a duplicate asset merely by rerunning a batch.

## Framework bump

An existing asset remains valid after a minor framework bump if the referenced node/version remains valid. A new asset must pin the new framework version. A patch bump changes only metadata/clarification without changing node semantics; a semantic change requires a new version/review.

## References

- `blueprint/framework/README.md` — framework SSOT.
- `artifacts/CONVENTION.md` — artifact/evidence lifecycle.
- `artifacts/operations/founder-agent-governance-workflow.md` — agent/founder authority.
