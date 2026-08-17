# HTTP/API Compatibility Policy

This file is a compatibility policy, not a second API authority. Canonical HTTP operations/access are owned by `artifacts/engineering/api/openapi.yaml`; payload semantics are owned by `schema-contract.yaml` and deterministically resolved for build/codegen.

## HTTP invariants

- Public major paths use `/v1/`; breaking semantics require an explicit compatibility migration or new major path.
- Authentication is managed-provider owned. LenBands verifies identity and enforces object ownership, roles and entitlements; knowing an identifier is never authorization.
- Durable POST/PUT/PATCH/DELETE operations require `Idempotency-Key` unless the canonical operation explicitly declares an exemption. The canonical key contract is 16–128 characters.
- Idempotency scope binds authenticated principal, method, normalized path, key and request digest; reuse with a different request is a conflict.
- Versioned mutable resources use explicit version/conditional update rather than silent last-write-wins.
- Provider credentials, stack traces, raw assessment content and provider payloads never appear in public errors.

## Error representation

RFC 9457 `application/problem+json` in the canonical OpenAPI is the only HTTP error envelope. `Problem.code` is a deterministic projection of the public failure-code registry. Internal failure classes remain server-side and may map many-to-one to a learner-safe public code.

## Webhook verification

Signed provider webhooks are verified against the exact raw request bytes before JSON normalization. Provider event IDs are the deduplication identity; delivery may be repeated or out of order, so handlers compare occurrence/version state and reconcile idempotently.

## Compatibility

Consumers tolerate additive fields but never silently reinterpret an existing field or enum value. Deprecation requires a successor/retirement disposition, migration window and reference closure before physical removal.

## Verification

Repository verification must prove that the resolved OpenAPI build projection binds every canonical operation to its semantic request/success schema, uses the canonical failure enum/idempotency policy, and contains no generic payload object on the resolved build surface. Runtime acceptance later proves cross-user isolation and duplicate-effect prevention; prose is not evidence.
