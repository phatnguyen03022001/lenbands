# LenBands Web API

The web API uses **non-overlapping semantic owners that compile into one build contract**:

- `openapi.yaml` — HTTP paths/methods, operation IDs, persona/role/entitlement/data-class annotations and HTTP error surface.
- `schema-contract.yaml` — request and success-response field semantics for every canonical `operationId`.
- `type-system.yaml` — closed type aliases plus transport policies such as idempotency-key shape, public failure codes and webhook signature ordering.
- `operation-ownership.yaml` — exactly one implementation-family owner for every canonical operation.
- `access-control.md` — five web personas, three authenticated product roles, Premium entitlement and separation of duties.

`DOCS.yaml` registers these owners. None may redefine another concern.

## Deterministic build projection

`tools/commands/generate/canonical-web-api.rb` compiles the semantic inputs above into a resolved OpenAPI 3.1.2 projection. `tools/commands/generate/all.sh --check` proves the projection can be regenerated without unknown type tokens or generic build payloads.

Rules:

- source `openapi.yaml` may retain generic authoring placeholders while operation/access metadata is edited;
- **generated/resolved OpenAPI is the only codegen/build input**;
- resolved operations bind request/response bodies to the exact schemas registered by `operationId`;
- `JsonObject`, `ObjectOK`, `ListOK`, `ObjectCreated` and `ObjectAccepted` are forbidden in the resolved build surface;
- unknown schema/type tokens fail CI;
- generated output is a projection and never becomes an additional SSOT.

## Identity model

Web personas: `guest`, `learner`, `premium_learner`, `colab`, `admin`.

Authenticated product roles: `learner`, `colab`, `admin`.

`premium_learner = learner + premium entitlement`; it is not a separate security role. `guest` has no authenticated role. Signed webhook/workflow principals are internal service identities, not web personas.

## Contract rules

- Resolved OpenAPI target: **3.1.2** with JSON Schema 2020-12 semantics.
- Error bodies use RFC 9457 `application/problem+json`; public `Problem.code` values are compiled from the controlled failure projection.
- Every operation declares persona, role, entitlement, data class and idempotency policy.
- Every operation has exactly one typed request/success-response registry entry and exactly one implementation-family owner.
- `none` request means no JSON request body.
- Managed identity verifies authentication; LenBands server/data policy owns object/role/entitlement authorization.
- Client claims and opaque IDs are never sufficient authorization.
- Durable mutations require the controlled `Idempotency-Key` contract (16–128 characters in the resolved transport policy).
- Raw C1–C4 assessment/security content never enters general analytics, logs, error details, or billing webhooks.
- Signed billing webhooks verify the **raw request body before parsing/normalization**, deduplicate by provider event ID, and then update only the provider-neutral billing/entitlement ledger.
- Provider responses are validated and normalized at adapter boundaries before entering domain state.

## Score identity and scorer isolation

These identities remain distinct: `official_ielts_score`, `exam_simulation_estimate`, `diagnostic_estimate`, `learning_mastery`. One Writing task result is task-scoped diagnostic evidence, not a complete official-equivalent Writing section score.

General generation/coaching may use policy-approved provider fallback. Learner-visible scoring may route only among benchmark-approved model/provider combinations inside the same scorer-route version. If no approved route is available, return `delayed`/`unavailable`; never silently substitute an unbenchmarked scorer.

## Versioning and deprecation

- URI major version: `/v1`.
- Compatible payload additions follow the schema/API version policy.
- Breaking semantics require an explicit compatibility migration or new major API version.
- Legacy specs under `artifacts/engineering/contracts/**/openapi.yaml` are migration-only aliases and are never validation/codegen authorities.
- Removal requires successor/retirement, migration window, usage/reference evidence and zero unresolved canonical consumers.

## Application boundary

The browser talks to the reviewed same-origin managed application boundary selected by the sourcing decision. The API contract does not require Next.js, Go, Python, a standalone BFF, or a dedicated service topology.

Direct browser-to-managed-data access is allowed only for explicitly reviewed public/subject-owned surfaces with server/data-layer authorization such as RLS. Sensitive assessment, Admin and Colab mutations default to the governed application API so authorization, idempotency, audit and evidence rules remain centralized.
