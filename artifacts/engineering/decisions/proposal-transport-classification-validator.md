# Privileged Validator Proposal — Transport Classification Arithmetic

- **Type:** privileged-validator-proposal — does NOT modify tools/**, does NOT claim readiness.
- **Status:** `proposal` — pending privileged review + attestation + CODEOWNERS approval.
- **Created:** 2026-08-11
- **Owner:** document-convergence orchestrator (proposal author)
- **Protected path affected:** `tools/commands/validate/` (validator registration)
- **Attestation required:** per `artifacts/operations/agent-trust-policy.yaml` + external CODEOWNERS review

## Purpose

Propose a new semantic validator that enforces arithmetic and referential integrity on
`transport-classification.yaml` against the canonical lifecycle registry. Read-only. No readiness claim.

## Validator: `validate-transport-classification`

### Inputs
1. `artifacts/engineering/contracts/openapi/transport-classification.yaml`
2. `artifacts/operations/capability-lifecycle-registry.yaml`

### Invariants

1. **ID completeness:** Every capability_id in lifecycle registry appears exactly once in transport YAML. No missing IDs. No duplicate IDs.

2. **Arithmetic (two independent axes):** Lifecycle status and transport class are independent axes. Lifecycle: `active_count + planned_count + deprecated_count = total_entries`. Transport class: sum of all class_counts = total_entries. Deprecated_count is NOT added to class totals (deprecated entries already have a transport class). `active_count` matches lifecycle registry ACTIVE. `planned_count` matches lifecycle registry PLANNED.

3. **Lifecycle-consistent classification:**
   - Every PLANNED cap MUST have `class: deferred-no-runtime`.
   - DEPRECATED cap MUST have `class: deferred-no-runtime` and MUST NOT be counted in active or planned lifecycle totals.
   - ACTIVE cap with `class: deferred-no-runtime` MUST have an explicit `deferred_reason` field with a non-empty value and a `deferred_owner` field (one of: `founder`, `product`, `engineering`). Absence of `deferred_reason` on an ACTIVE deferred is a hard error. This enforces the exception pattern WITHOUT forbidding it.
   - ACTIVE cap with any other transport class is valid with no additional metadata.

4. **Class enumeration:** Every `class` value ∈ {`public-http`, `auth-bff`, `internal-command`, `async-job`, `event-projection`, `deferred-no-runtime`}.

5. **OpenAPI ref check (warning):** For `public-http`/`auth-bff` caps with non-null `openapi_file`, file exists. If `operation_id` non-null, warn if not found in referenced file.

6. **Matrix discrepancy check (warning):** Warn if lifecycle-coverage-matrix.md DISCREPANCY count ≠ 0.

### Exit codes
- `0`: All invariants pass.
- `1`: Hard invariant violated (blocks document validation).
- `0 with warnings`: Non-blocking OpenAPI ref or matrix discrepancy warnings.

### Registration
Registered in `validate documents` pipeline. NOT in `validate semantic-contracts`. NOT in `gate p0`.

## Impact

- **Adds:** One new document integrity check.
- **Does NOT:** Modify existing validators, weaken fail-closed gates, claim P0 readiness, write files, or introduce new tooling infrastructure.
- **Satisfies Tool Refactoring Governance:** knowledge dedup + drift detection + maintenance cost reduction.

## Review checklist

- [ ] CODEOWNERS review.
- [ ] Attestation per agent-trust-policy.yaml.
- [ ] Registration in `tools/commands/validate/` with explicit document scope.
- [ ] Test cases: match → pass; duplicate ID → fail; wrong arithmetic → fail; ACTIVE deferred without deferred_reason → fail; PLANNED with runtime class → fail; PLANNED counted as active → fail.
- [ ] No readiness claim in name, description, or output.

## References

- `artifacts/engineering/contracts/openapi/transport-classification.yaml`
- `artifacts/operations/capability-lifecycle-registry.yaml`
- `artifacts/engineering/contracts/runtime/lifecycle-coverage-matrix.md`
- `artifacts/operations/architecture-frozen.md` §Tool Refactoring Governance
