# API Governance Contract — P0

## Scope

Applies to learner-facing HTTP APIs and service boundaries owned by Go. OpenAPI is the canonical representation of the HTTP interface; data/event/failure contracts remain the source for semantics outside HTTP.

## Version, auth, and correlation

- Public paths use `/v1/`. A breaking change creates `/v2/`; do not change the meaning of fields/statuses in `/v1/`.
- Every learner endpoint requires a Bearer access token, except health/explicit public preview endpoints. Ownership is always checked server-side; a guessable ID still returns `404` instead of exposing the resource.
- Request receives or generates `X-Request-Id`; the response always returns that header. Async work passes it as `trace_id`/causation context.
- Responses use `application/json; charset=utf-8`. Timestamps are RFC 3339 UTC; identifiers are opaque strings.

## Mutation, idempotency, and concurrency

- POST/PUT/PATCH/DELETE require an `Idempotency-Key` 16–128 characters long, except when the endpoint contract specifies `idempotency: n/a`.
- Idempotency scope is `authenticated_subject + method + normalized_path + key`; the same key with a different body returns `409 idempotency_key_reused`.
- Server stores the status/result reference for at least the endpoint retry window; retrying the same request returns the prior semantic result and does not run the side effect twice.
- Update versioned resources with `If-Match` or explicit `version`; conflict returns `409 version_conflict`, not last-write-wins for draft/text.

## Error envelope

Every 4xx/5xx has a standard body containing no provider payload, stack trace, or raw learner content:

```json
{
  "error": {
    "code": "EVALUATION_DELAYED",
    "message": "The result is taking longer than expected.",
    "state": "delayed",
    "recoverable": true,
    "retry_after_seconds": 120
  },
  "request_id": "opaque-id"
}
```

| HTTP | Used for | Client behavior |
|---|---|---|
| 400 | validation/input invalid | fix input, do not retry automatically |
| 401/403 | auth/entitlement | re-auth or show quota/access state |
| 404 | resource does not exist or is not owned by subject | do not retry |
| 409 | idempotency/version/state conflict | reconcile or use the old result |
| 422 | syntactically valid but violates a domain rule | action_required |
| 429 | rate/quota/concurrency limit | respect `Retry-After` |
| 500 | unclassified failure | retry under failure contract if safe |
| 503 | dependency unavailable/delayed | retry after `Retry-After`, retain user data |

Public error `code` is a learner-safe projection, not the internal failure taxonomy. Canonical P0 mapping:

| Public code | Internal class | State |
|---|---|---|
| `EVALUATION_DELAYED` | `EVAL_TIMEOUT` or retryable provider timeout | `delayed` |
| `EVALUATION_UNAVAILABLE` | `EVAL_INFERENCE_FAILED` or schema-invalid terminal result | `unavailable` |
| `QUOTA_EXCEEDED` | `QUOTA_EXCEEDED` | `action_required` |
| `SYNC_CONFLICT` | `SYNC_CONFLICT` or `DRAFT_VERSION_CONFLICT` | `action_required` |
| `DRAFT_SYNC_UNAVAILABLE` | `DRAFT_SYNC_FAILED` | `processing` |
| `SUBMISSION_UNAVAILABLE` | `SUBMISSION_NETWORK_FAILED` | `action_required` |
| `CONTENT_UNAVAILABLE` | `CONTENT_UNAVAILABLE` | `action_required` |

Internal codes must not put provider payloads, stack traces, or raw learner content into the response. The full registry is in `failure-taxonomy-contract.md`.

## Compatibility and validation

- Only additive fields/enum values in the active API version. Consumers must tolerate unknown fields; new enums need a client-safe fallback.
- Deprecation requires `Deprecation: true`, successor, migration window, and release record before removal.
- Every OpenAPI change must lint/parse, diff against the prior version, generate/compile a client or contract test in Source Code, and test auth/idempotency/error examples.

## Threat model — transport and HTTP boundary (M12)

| Asset | Threat | Control (P0) |
|---|---|---|
| Transport confidentiality/integrity | Eavesdrop or tamper on learner API traffic | HTTPS/TLS for all `/v1/*` and admin surfaces; no plaintext HTTP for authenticated endpoints; TLS termination at edge (cloud provider/TLS termination layer — provider not yet chosen) with strict cipher policy |
| Cross-user data exposure | Resource-ID guessing reveals another subject's data | Server-side ownership check; resource not owned returns `404`, not `403`, to avoid oracle; subject scoping enforced at every handler |
| Auth/token compromise | Stolen bearer token used across sessions | `sub` opaque subject; issuer/audience allowlist; clock-skew policy; no raw token in logs; short TTL + rotation per auth contract |
| Error oracle | Error differences reveal resource existence or provider detail | Unified error envelope; provider payload, stack trace and raw learner content never in response |
| Injection via API input | Malformed/enum-violating input reaches domain logic | Input validation at boundary; `error_pattern` must resolve to framework error_id or be rejected (data-contract.md); enum-violation → 422 |

This section is threat-model prose for the shared HTTP lifecycle; it complements provider-adapter and async-job-worker threat sections. It is not a security validation or evidence run.

## Acceptance conditions

- Client mutation retry after timeout does not create a duplicate domain effect.
- No endpoint accesses cross-user data using another resource ID.
- Error responses are machine-readable and learner-safe for every failure class.
- Breaking OpenAPI changes are blocked by CI before merge/release.
