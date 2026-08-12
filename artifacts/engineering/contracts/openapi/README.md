# OpenAPI Authority — LenBands (Projection)

- **Type:** projection of `openapi/transport-classification.yaml` — NOT an independent authority.
- **Status:** `review`
- **Owner:** engineering
- **Created:** 2026-08-10 · **Updated:** 2026-08-11
- **Canonical source:** `openapi/transport-classification.yaml` (machine-readable, 180 IDs, arithmetic verified)
- **Consumed by:** Go API implementation, Next.js BFF, Python evaluation worker, validators

**This README is a human-readable projection.** The machine-readable truth is `transport-classification.yaml`.
All capability counts, transport classes, and arithmetic are derived from that file. Do not maintain
parallel arithmetic here.

## Status

| Item | State |
|---|---|
| Two live specs exist | TRUE — `contracts/openapi.yaml` (5 live ops, 0.2.x draft) + `writing-task-2/openapi.yaml` (25 live ops, 0.5.0 review) |
| One canonical authority | **NOT YET** — two files; `api-ownership-bff-contract.md` declares split, marks transition incomplete |
| Transport classification | `openapi/transport-classification.yaml` — machine-readable canonical |
| Capability count | 180 (33 active + 146 planned + 1 deprecated). EVAL.AntiGaming is DEPRECATED, **not** counted as planned. Arithmetic: `33 + 146 + 1 = 180`. |
| A1 admin binding | **design-defined, implementation-pending** — scope ↔ operation mapping in this README; operations not in OpenAPI files |
| A2 deprecation transition | **design-defined, implementation-pending** — announce→sunset→remove contract defined; no deprecation metadata in OpenAPI operations |
| A3 session transport | **design-defined, implementation-pending** — BFF-mediated JWT flow contract defined; not in OpenAPI |
| Atomic unification plan | **planned, not executed** — one root + modular $refs + schema dedup + identity migration |

## Target unification structure (not created)

The atomic unification plan would produce this structure after execution. None of these
files exist yet except `README.md` and `transport-classification.yaml`. The current live
OpenAPI files remain at their historical paths (`contracts/openapi.yaml` and
`writing-task-2/openapi.yaml`).

```text
openapi/
├── README.md                     (this file — projection of transport-classification.yaml)
├── transport-classification.yaml (canonical machine-readable transport classification)
├── p0-runtime.yaml               (TARGET: unified root $ref — not created)
├── common/                       (TARGET: shared components — not created)
│   ├── headers.yaml
│   ├── parameters.yaml
│   ├── responses.yaml
│   └── schemas/
│       ├── identity.yaml
│       ├── placement.yaml
│       ├── daily-action.yaml
│       ├── writing.yaml
│       ├── review.yaml
│       └── ops.yaml
└── (current live files remain at:
    ../contracts/openapi.yaml,
    ../writing-task-2/openapi.yaml)
```

## Transport classification

**Canonical source:** `openapi/transport-classification.yaml` — machine-readable YAML with all 180
capability IDs, exact transport class per ID, arithmetic verification section, and two-file
OpenAPI state documentation. This README does not duplicate capability-by-capability tables.
All per-capability transport data lives in the YAML file.

Transport classes defined there: `public-http`, `auth-bff`, `internal-command`, `async-job`,
`event-projection`, `deferred-no-runtime`.

**Arithmetic (from canonical `transport-classification.yaml` verification section):**
- Lifecycle axis: 33 active + 146 planned + 1 deprecated = 180 (verified against lifecycle-registry snapshot)
- Transport-class axis: 14 public-http + 2 auth-bff + 11 internal-command + 1 async-job + 4 event-projection + 148 deferred-no-runtime = 180
- Lifecycle and transport class are independent axes. Deprecated is NOT added to class totals.
- 1 ACTIVE cap (OPS.ContentQuality) has class deferred-no-runtime with explicit deferred_reason — see `transport-classification.yaml` active_deferred_exception block.

### P0 ACTIVE summary

All 33 ACTIVE capabilities are transport-classified in `transport-classification.yaml`.
The 25 P0 HTTP operations are in `writing-task-2/openapi.yaml` (review, v0.5.0).
The 5 identity HTTP operations are in `contracts/openapi.yaml` (draft, v0.2.x).

### Example family (non-authoritative)

PLACEMENT.Diagnosis (7 caps) — shown here as example only. The canonical source for all 180
capability transport classifications is `transport-classification.yaml`. This table is a
non-authoritative excerpt and may be stale.

| Capability | Transport | Endpoint / Contract |
|---|---|---|
| GOAL.Target | `public-http` | `POST /v1/placement` (goal_ref) |
| PLACE.Test | `public-http` | `POST /v1/placement`, `POST /v1/placement/{id}/responses` |
| PLACE.BandEstimation | `internal-command` | Triggered by placement completion; surfaced in `GET /v1/placement/{id}` |
| PLACE.GapDetection | `internal-command` | Triggered by band estimation |
| PLACE.InitialPath | `internal-command` | Triggered by gap detection |
| PLACE.SkillDiagnosis | `internal-command` | Triggered by placement completion |
| BAND.Current | `event-projection` | Derived from placement_completed event |

*(All 180 classifications: canonical source is `transport-classification.yaml`.)*

### PLANNED (146) + DEPRECATED (1)

All 147 non-ACTIVE capabilities are `deferred-no-runtime` in `transport-classification.yaml`.
EVAL.AntiGaming is DEPRECATED (canonicalized to GOVERNANCE.AntiGaming), **not** counted as planned.
Per-family deferred reference: `artifacts/operations/deferred-families-reference.md`.

---

## A1 — Admin binding resolution

**Issue:** The admin authorization scope `admin:governance` was defined in `auth-identity-contract.md` as a single governance scope. The dashboard spec `governance-ops-dashboard.md` needs concrete permission binding — what operations may an admin perform and which require `admin:governance` vs a future separate scope?

**Resolution (design contract, not post-code):**

| Admin operation | OpenAPI endpoint | Scope required | Owner |
|---|---|---|---|
| View quality gate | `GET /v1/ops/quality-gate` | `admin:governance` | OPS.QualityEconomics |
| Evaluate release gate | `POST /v1/ops/quality-gate` | `admin:governance` | OPS.QualityEconomics |
| View audit trail | `GET /v1/ops/audit` (deferred) | `admin:governance` | OPS.QualityEconomics |
| View learner aggregate metrics | `GET /v1/ops/metrics` (deferred) | `admin:governance` | OPS.QualityEconomics |
| Inspect raw submission preview | break-glass endpoint (deferred) | `read:governance_raw_submission_preview` (separate scope, time-boxed, grant requires founder approval) | OPS.QualityEconomics |
| Admin user management | deferred (ADMIN.Governance) | `admin:users` (future scope) | ADMIN.Governance |
| Content moderation | deferred (CONTENT.Management) | `content:moderate` (future scope) | CONTENT.Management |

All `admin:governance` operations produce immutable `AuditRecord` entries. The break-glass scope `read:governance_raw_submission_preview` is defined as a separate scope requiring explicit, time-boxed founder grant — it is not bundled with `admin:governance`.

## A2 — Deprecation transition contract

**Issue:** When an API entity, endpoint, or field is deprecated, what exact process applies? This must be a design contract, not left to post-code discovery.

**Resolution (design contract):**

1. **Announce:** Deprecated item gets `Deprecation: true` header + `x-deprecated-at` timestamp + `x-sunset` date in the OpenAPI spec. The sunset date must be at least 1 active API version away (i.e., deprecated in v1, removed in v2 or later patch with explicit version bump).
2. **Migration window:** Consumers have from `x-deprecated-at` to `x-sunset` to migrate. During this window, both old and new interfaces coexist.
3. **Successor:** Every deprecated item MUST have a `x-successor` field pointing to the replacement operation/schema/field.
4. **Release record:** Deprecation is recorded in the release gate (`release-gate.md`) as a documented change with migration path.
5. **Removal:** At `x-sunset`, the item returns `410 Gone` with a body containing the successor reference. After one additional version, the endpoint/field is physically removed from the spec.
6. **Capability-level deprecation:** A deprecated capability (like `EVAL.AntiGaming`) follows the capability-lifecycle-registry state `DEPRECATED` with a `replacement` field pointing to the canonical successor ID.

## A3 — Session transport contract

**Issue:** `POST /v1/auth/session` is the authentication endpoint. It is `auth-bff` (not direct learner HTTP) because the BFF mediates token exchange. But the exact transport contract — what flows between Next.js BFF and Go API — was undefined.

**Resolution (design contract):**

1. **Flow:** Browser → Next.js BFF (Cookie session) → Go API (Bearer JWT). The learner's browser never holds a raw provider JWT.
2. **`POST /v1/auth/session` contract:**
   - **Input (from BFF):** Provider-validated `id_token` or `authorization_code` result.
   - **Output (to BFF):** LenBands internal `access_token` (opaque, short-lived), `refresh_token` (opaque, longer-lived), `subject_id` (opaque), `consent_state`.
   - **Auth:** This endpoint requires a pre-shared BFF service key OR accepts provider id_token directly (founder decision per identity provider selection).
3. **Session lifecycle:**
   - Access token TTL: 15 minutes (configurable per environment).
   - Refresh token TTL: 7 days, single-use (rotation on use).
   - BFF manages HttpOnly secure cookie; Go API never sees cookies.
4. **Public classification:** `auth-bff` — not `public-http` because raw credential flow is not learner-browser-direct. The BFF is the only permitted caller.
5. **Error contract:** Follows standard error envelope. `AUTH_UNAVAILABLE` returns `503` with `state: action_required` and `recoverable: true`. `PERMISSION_DENIED` returns `403`. Invalid credentials return `401`.

---

## OpenAPI governance

1. **Schema ownership:** Every schema in the OpenAPI has exactly one canonical definition. Duplicate or competing schemas are forbidden.
2. **Enum governance:** Enum values in OpenAPI must match framework vocabulary (e.g., `error_pattern` must resolve to `blueprint/framework/error-taxonomy.md` error_id). Non-framework values are rejected at validation.
3. **Privacy redaction:** Raw learner content fields (`text`, `essay`, `recording`) MUST never appear in analytics events, logs, or error payloads. The two transitional OpenAPI files do **not** yet carry `x-privacy-class: assessment` markers consistently; adding and validating those markers is an OpenAPI-unification requirement, not a completed claim. Event/log prohibition remains governed by the privacy and event contracts.
4. **Version policy:** Breaking changes → new major version path (`/v2/...`). Additive changes → same version. Field removal → deprecate first per A2, remove after sunset.
5. **Validation gate:** Every OpenAPI change must pass: lint/parse, diff against prior version, and semantic validator checks (enum framework resolution, privacy marking, idempotency coverage).

## References

- `artifacts/engineering/contracts/writing-task-2/openapi.yaml` (canonical P0 runtime root, v0.5.0)
- `artifacts/engineering/contracts/runtime/api-governance-contract.md`
- `artifacts/engineering/contracts/runtime/auth-identity-contract.md`
- `artifacts/operations/deferred-families-reference.md`
- `artifacts/operations/capability-lifecycle-registry.yaml`
