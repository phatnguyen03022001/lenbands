# Auth & Identity Contract — P0

This is the minimum boundary for `IDENTITY.Auth`, `IDENTITY.Profile`, and `IDENTITY.Privacy` in the closed pilot. A specific provider, DPA, and production capacity have not been selected; this contract is not provider evidence.

## Boundary

- The Go API authenticates the bearer token and maps it to an opaque `subject_id`; the service does not infer identity from client-provided fields.
- A learner may read/write only the Account, Profile, Draft, Submission, Evaluation, and ReviewCard belonging to their `subject_id`.
- Admin/governance does not read raw essay/audio by default; an exception requires a permission policy and audit record.
- A guest cannot create a submission/evaluation; a preview may be viewed if content policy permits it.

## Token, subject, and permission semantics

The provider may change, but the Go API must enforce the same token contract:

| Claim / input | Rule |
|---|---|
| `iss` | must belong to the environment issuer allowlist; do not accept an issuer selected by the client |
| `aud` | must match the environment API audience |
| `sub` | stable provider subject; map one-way to opaque `subject_id`; do not use email as identity |
| `exp` / `iat` | validate the clock-skew policy; an expired token returns `401` |
| `jti` | when issued by the provider, use it for replay/audit correlation; do not log the raw token |
| `scope` / role | use only to grant permission, not to determine ownership; ownership is always the server-side `subject_id` |

Minimum P0 permission set:

| Scope | Allowed |
|---|---|
| `learner:read` | read learner-owned resources for the subject |
| `learner:write` | write the subject's draft, submission, feedback, and review state |
| `privacy:export` | create/read the subject's export status |
| `privacy:delete` | create/read the subject's deletion status after re-authentication |
| `admin:governance` | aggregate/audit + governance mutation (block route, flag submission disposition) under policy; every mutation has an audit record; raw learner content is not readable by default |

The governance scope is **a single vocabulary defined by this table**. The dashboard spec (`governance-ops-dashboard.md`) must not create new scopes (`read:governance_dashboard`, `write:block_route`, `write:flag_submission`, `read:governance_raw_submission_preview`); those actions collapse into `admin:governance` with policy-level detail. `read:governance_raw_submission_preview` is an ungranted break-glass scope; show only opaque refs/metrics until the founder approves a separate policy and an expiring scope is added to this table.

Client-provided `user_id`, role, or plan cannot override the token subject, server-side entitlement, or consent state. A missing scope returns `403`; a resource outside the subject returns `404` to avoid a cross-user oracle.

## Minimum operations

| Operation | Permission | Result |
|---|---|---|
| `POST /v1/auth/session` | guest | authenticated session or safe failure |
| `GET /v1/me` | learner | profile for the subject |
| `POST /v1/me/consents` | learner | versioned consent record |
| `POST /v1/me/export` | learner | export job reference |
| `POST /v1/me/deletion` | learner | deletion job reference + re-authentication requirement |

These endpoints must use `X-Request-Id`, the API Governance error envelope, and idempotency for mutations. Writing Task 2 OpenAPI consumes this subject boundary and does not define separate authentication.

## State and failure

```text
guest → authenticated → consent_pending → active
                         ├→ auth_failed → guest
                         └→ deletion_requested → deletion_processing → deleted
```

- `consent_pending` cannot submit Writing.
- Required Writing processing consent must be checked server-side at the submission boundary; UI state is not sufficient evidence of consent.
- An expired token returns `401`; provider details are not exposed.
- Export/delete failure preserves job state and permits safe retry; it does not silently perform a partial deletion.
- Deletion must require re-authentication or a fresh-auth signal within the policy window; retrying with the same idempotency key does not create a second deletion job.

## Missing acceptance evidence

- Provider/DPA boundary and end-to-end permission test.
- Export/delete cascade test across all learner-owned entities.
- Re-authentication and token-expiry exercise.
- Cross-user authorization matrix for Account, Draft, Submission, Evaluation, ReviewCard, and PrivacyRequest.

Until these runs have real evidence, the artifact remains `review` and P0-01 is not `ready`.

## References

- `blueprint/02-architecture.md` § Permission Boundary and Runtime Entity Ownership.
- `artifacts/engineering/contracts/runtime/api-governance-contract.md`.
- `artifacts/experience/specs/vertical-slices/identity-consent.md`.
