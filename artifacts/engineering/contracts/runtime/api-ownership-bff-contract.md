# API Ownership & BFF Contract — P0

## Purpose and classification

This is a design contract (pre-code document). It defines **one canonical ownership/version/deprecation
model for the HTTP API** and the **BFF/server-client boundary**. It is not runtime validation evidence;
it does not claim that any endpoint is running. Execution/benchmark/acceptance is a post-code evidence gate.

## 1. Canonical API ownership model

One HTTP API, two OpenAPI representation files, one logical owner:

| Surface | OpenAPI file | Owner | Status | Role |
|---|---|---|---|---|
| Identity surface (Auth/Profile/Privacy) | `artifacts/engineering/contracts/openapi.yaml` | engineering | draft | selected logical identity surface (candidate identity-only OpenAPI: Auth, Profile, consent/export/deletion) |
| P0 runtime loop surface (everything else) | `artifacts/engineering/contracts/writing-task-2/openapi.yaml` | engineering | review | selected logical candidate surface for the P0 loop (profile, placement, daily, writing, review, quota, quality-gate) |

**Ownership rules (target):**
- Each endpoint has **exactly one** owner surface. No endpoint is defined in both files.
  - Identity-only paths (`/v1/auth/session`, `/v1/me`, `/v1/me/consents`, `/v1/me/export`, `/v1/me/deletion`) → `contracts/openapi.yaml`.
  - Every other path (placement, daily, writing, review, quota, quality-gate, profile in loop) → `writing-task-2/openapi.yaml`.
- `writing-task-2/openapi.yaml` is the **selected logical candidate surface** for the P0 loop; `contracts/openapi.yaml` is the **selected logical identity surface**. A unified canonical OpenAPI authority does not yet exist — each live spec is only a candidate surface, and neither is a complete build input.
- A conflict (endpoint duplicated in both files) is a failure — resolve to one owner; do not maintain both in parallel.

**Current state (2026-08-10, after Batch 6 canonicalization):** `contracts/openapi.yaml` (v0.2.0) has been re-scoped to
identity surface only; every loop path (`/v1/writing/*`, `/v1/me/quota`, `/v1/review/cards`) is marked
`deprecated: true` + `x-canonical-owner: writing-task-2/openapi.yaml`. Logical canonical ownership has been selected:
identity paths → `contracts/openapi.yaml`; loop paths → `writing-task-2/openapi.yaml`. However, legacy operations
remain live OpenAPI path definitions, and GET feedback has no successor with the same method. Therefore the transition is not
complete until per-operation successor/retirement treatment, response-header contract, migration window,
and release-record schema are defined. Do not call ownership or deprecation runtime-verified.

### Batch B reconciliation boundary (2026-08-11)

Batch B reviewed the two live specifications against the P0 runtime contracts. This addendum deepens the ownership
boundary without creating a second owner, changing either live specification, or selecting an unresolved schema/path.

- The logical owner allocation above remains the current candidate: the five identity-only operations remain owned by
  `contracts/openapi.yaml`; the P0 loop operations remain owned by `writing-task-2/openapi.yaml`.
- The eight root loop definitions remain legacy placeholders only. Their `deprecated: true` and
  `x-canonical-owner` markers are traceability projections, not a second implementation authority. The seven exact
  duplicate path/method pairs and the orphan `GET /v1/writing/submissions/{submissionId}/feedback` keep the transition
  incomplete until migration, sunset, and retirement treatment are recorded.
- `GET /v1/me`/`AccountProfile` versus `GET|PUT /v1/me/profile`/`LearnerProfile` is an unresolved profile path/schema
  reconciliation. It is not permission to assign two canonical profile schemas. Keep the current logical owner rule,
  and require an explicit shared-schema and successor/retirement decision before live-spec convergence.
- The root `provider_token` session shape versus the BFF-mediated `id_token`/`authorization_code` alternatives is an
  unresolved transport decision. Existing founder decision D-02 remains the authority for the provider/input choice;
  this contract does not name a provider or invent a credential field.
- The placement contract paths and the daily-action contract paths do not match the P0 OpenAPI paths. Engineering must
  reconcile each path/method before adoption; this contract does not silently rename, add, or remove an operation.
- The root feedback GET has no canonical same-method successor. It remains a retirement decision or a separately
  approved read contract, not an implied owner for the P0 feedback POST.
- Shared target validation must preserve server-side ownership, provider-neutral BFF handling, safe error envelopes,
  idempotency, async status, and the prohibition on learner raw content in events, logs, queues, telemetry, and error
  payloads. The current OpenAPI files do not consistently prove privacy markers or per-operation scope expression.

**Decision boundary:** These are unresolved engineering/CODEOWNERS reconciliation items. D-02 is the existing founder
dependency for session transport. No new protected or founder item is created by this addendum, and no endpoint, schema,
event, lifecycle state, or owner is added here. The target unified root remains planned and not created.

## 2. Version / deprecation model

- Every path uses the `/v1/` prefix (locked). A breaking change creates `/v2/` (api-governance-contract.md).
- `info.version` in `writing-task-2/openapi.yaml` is the version of the **entire runtime surface** (currently `0.5.0`); increase it for additive changes.
- Deprecation: `Deprecation: true` response header + successor/retirement treatment + migration window + release-record schema (api-governance-contract.md § Compatibility). This is pre-code contract work; emitting/verifying the header and release record is post-code evidence.
- **One canonical OpenAPI version** is used as the baseline for client generation/contract tests; no parallel version exists for the same surface.

## 3. BFF / server-client boundary

| Concern | P0 decision | Rationale |
|---|---|---|
| BFF layer | **No separate BFF at P0.** FE (Next.js) calls `/v1/*` directly through server-side (SSR) or API routes. | Narrow P0 loop; BFF adds a hop without clear ownership. BFF may be added after P0 if cross-surface aggregation is needed (ADR decision). |
| Server-side vs client-side call | Endpoints requiring token/ownership (mutation, private read) must be called from the server (Next.js server action / route handler) so the token is not in the client bundle. Public/preview reads may be client-side. | Protect bearer token; reduce XSS-token-leak surface. |
| Auth/session propagation | Bearer token → Go API maps to opaque `subject_id` (auth-identity-contract). The goal is for the FE server to keep the token outside client JS; the session transport mechanism (HttpOnly cookie attributes, CSRF, lifetime/rotation, logout/invalidation) has no canonical contract yet. | `07-conventions.md` § Runtime contract + auth contract. |
| Caching | Cache contract (`cache-contract.md`): cache-aside, subject scope required for private_read, invalidation through outbox. | Do not serve stale entitlement/quota/score. |
| Query invalidation | Mutation commits canonical state and then invalidates cache through outbox; `negative_read` TTL for public 404. | `cache-contract.md` § Read/write behavior. |
| Error mapping | API-governance error envelope (code/state/recoverable/retry_after); internal codes are not exposed. | `api-governance-contract.md` § Error envelope. |
| Async status | `submitted`/`processing`/`delayed` state (EvaluationPending enum, writing-task-2/openapi.yaml) + `Retry-After`; polling via `GET /v1/writing/submissions/{submissionId}/evaluation` (operationId `getWritingEvaluation`) returns `EvaluationPending`. | writing-task-2/openapi.yaml `EvaluationPending`. |
| Compatibility | Additive-only within the active version; clients tolerate unknown fields; new enums fall back in a client-safe way. | api-governance-contract.md § Compatibility. |

## 4. Non-goals

- Do not create a new BFF/aggregation layer in P0.
- Do not define endpoints outside the two canonical OpenAPI files.
- Do not claim an endpoint is runtime-verified; that is post-code evidence.

## Acceptance (design)

- [x] Logical owner selected for each P0 endpoint (identity → contracts/openapi.yaml; loop → writing-task-2/openapi.yaml).
- [ ] Legacy transition complete: loop paths remain OpenAPI operations; GET `/feedback` has no canonical GET successor and needs clear retirement treatment.
- [ ] BFF/session boundary complete: the server-side token goal is described, but the cookie/CSRF/lifetime/rotation/logout contract is still missing.
- [ ] Version/deprecation contract complete: currently only OpenAPI `deprecated: true` + `x-canonical-owner` are used; per-operation response headers, a migration window, and the release-record schema specified by api-governance § Compatibility are missing.
- [ ] Batch B reconciliation complete: profile/session/placement/daily path and schema decisions, orphan feedback retirement, shared privacy/error annotations, and per-operation scope expression are resolved without duplicate ownership.

## References

- `artifacts/engineering/contracts/runtime/api-governance-contract.md`
- `artifacts/engineering/contracts/runtime/cache-contract.md`
- `artifacts/engineering/contracts/runtime/auth-identity-contract.md`
- `artifacts/engineering/contracts/openapi.yaml`
- `artifacts/engineering/contracts/writing-task-2/openapi.yaml`
- `blueprint/02-architecture.md` § Technology Stack / Go-Python boundary
