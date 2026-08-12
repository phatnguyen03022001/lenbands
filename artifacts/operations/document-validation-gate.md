# Document Validation Gate

## Purpose

Prevents agents from creating an Artifact without metadata, referencing the wrong Capability ID, or marking an Artifact `approved` without review. The script `tools/validate-documents.sh` is the minimum static check; semantic review still requires the founder/owner.

## Automated checks

`tools/validate-documents.sh` calls specialized validators; `tools/validate-semantic-contracts.sh` checks cross-file SSOT after static metadata checks pass.

- Metadata `status` must be a valid lifecycle value.
- An `approved` Artifact has `reviewed_by` and `reviewed_at`.
- Metadata has `type`, `owner`, `version`, `representation`, `derived_from`, `purpose`, `created_at`, and `updated_at`.
- `derived_from` must contain at least one stable Capability ID from `blueprint/03-features.md` (or a declared Artifact ID when that Artifact is actually first-class).
- `derived_from` must not be a path/file name; dependency identity uses a stable Capability ID.
- An Artifact with a lifecycle in Business, Experience, Engineering, or Operations must have metadata; `README.md` is the only excluded entry point.
- Closed-pilot P0-01 → P0-06 must have coverage in the Blueprint, P0 Artifact Pack, and Build Readiness Matrix.
- Every `openapi.yaml` must parse, use OpenAPI 3.x, include a bearer security scheme, success response, path parameter, and idempotency for mutations.
- A generated catalog must record `generated_from`, `generated_at`, and `schema_version`; catalog source must not be edited manually as SSOT.
- Failure codes in a slice contract must resolve to the runtime failure registry.
- Canonical events/extensions must be in the event schema pack, and an event producer contract must exist for P0 outcome events.
- Framework `error_refs`, Knowledge Asset `band_range`, cost-boundary IDs, and projection metadata must satisfy the type/value contract.
- The P0 Capability Manifest must contain all six families `P0-01` → `P0-06`; capability IDs, event refs, artifact paths, cost boundaries, privacy class, and readiness blockers must resolve.
- `tools/compile-capability.sh <CAPABILITY_ID|P0-XX>` must read the manifest and return family context without searching folders.
- The spawn prompt registry must resolve every template, sibling metadata, framework version, output boundary, `source_sha256`, and honesty stop-rules; top-level `spawn-prompts/` is forbidden.
- The benchmark/acceptance manifest must have a schema and runner; a family is `ready` only when acceptance status is `passed`, an evidence ref exists, and the P0 evaluation family has an armed corpus/threshold.

## Manual semantic checks

- Artifact must not duplicate the Blueprint or learner-serving content.
- Scope/out-of-scope must be coherent.
- A build-ready spec has state, data, failure, cost/privacy, and acceptance tests.
- The capability manifest must not claim `ready` while a blocker remains or evidence does not exist.
- Approved status reflects real review, not automation.
- A research protocol must not be presented as a finding; desk research must state method, evidence limit, and decision status.

## Gate policy

Document validation must run before changing an Artifact to `review` or `approved`. Static errors block promotion; semantic warnings create a review task.
