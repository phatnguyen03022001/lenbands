# Vertical Slice — Identity & Consent

## Outcome and scope

The learner creates/restores a session, understands what the consent grants, and can request export/delete without unintended exposure or loss of data.

**In scope:** `IDENTITY.Auth`, `IDENTITY.Profile`, `IDENTITY.Privacy`; authenticated session, consent record, minimal account profile, export/delete request state. **Out of scope:** payment identity, role admin UI, provider selection/DPA approval, actual data export file delivery.

## Roles, entry and state

| Role | Permission |
|---|---|
| Guest | start sign-in, view disclosure before consent |
| Learner | read/edit their profile, consent, request export/delete |
| Service | write immutable consent request/state; do not open private data cross-user automatically |

The canonical persisted identity state is defined in `auth-identity-contract.md`:
`guest → authenticated → consent_pending → active`, plus `deletion_requested → deletion_processing → deleted`.

The states below are a UX-flow view; `authenticating`, `export_requested`, `export_ready`, and `deletion_cancelled` are UX/screen states, not persisted identity states:

```text
guest → authenticating (UX only) → consent_pending → active
guest ← auth_failed (UX only)
consent_pending → active (after consent)
active → export_requested (UX only) → export_ready (UX only)
active → deletion_requested → deletion_processing → deleted | deletion_cancelled (UX only)
```

- `authenticating`, `auth_failed`, `export_requested`, `export_ready`, and `deletion_cancelled` are UX/screen states; persisted state uses the canonical values from `auth-identity-contract.md`.
- Auth failure returns to `guest` with retry; do not expose provider technical details.
- If consent is declined, serve only features that do not require that scope; do not silently assume consent.
- Delete is always a request with state/recovery window under the privacy policy, not an instant hard-delete UI action.

## Experience inventory

| Surface | Primary action | Required states |
|---|---|---|
| Sign in | Continue | loading, invalid, unavailable |
| Consent disclosure | Agree / Manage | required, declined, saved |
| Account & privacy | Export or request deletion | processing, ready, failed |

## Screen behavior detail

### Sign in

| State | UI behavior | Copy rule | Event/side effect |
|---|---|---|---|
| default | One sign-in method group, no dashboard behind it | Explain that sign-in saves the learning path and writing | none |
| loading | Disable duplicate submit, keep provider choice visible | "Connecting..." | none |
| invalid | Inline error after submit/blur only | Do not state the provider's technical reason | none |
| unavailable | Offer retry and guest preview if available | Explain that the system is not ready | log safe failure |

### Consent disclosure

| State | UI behavior | Copy rule | Event/side effect |
|---|---|---|---|
| required | Show required processing for Writing evaluation before first submission | purpose, data class, retention reference | none |
| optional | Optional toggles default off | "You can change this later" | none |
| declined | Continue only with features not requiring that scope | No guilt/persuasion | `consent_recorded` with declined scope |
| saved | Show effective scopes and timestamp | "Choice saved" | `consent_recorded` |

### Account & privacy

| State | UI behavior | Copy rule | Event/side effect |
|---|---|---|---|
| default | Profile, consent, export/delete entry | Separate account settings from learning task | none |
| export_requested | Show request status, not raw private data inline | expected processing state | `privacy_export_requested` |
| deletion_requested | Confirmation + recovery window | Explain impact on drafts/evaluations/reviews | `privacy_deletion_requested` |
| failed | Retry/contact path | Do not blame the user | safe failure event |

## Runtime boundary and contracts

| Entity | Write authority | Privacy | Event |
|---|---|---|---|
| AccountProfile | learner/service | account | `account_created` |
| ConsentRecord | service, learner request | account | `consent_recorded` |
| PrivacyRequest | learner request/service state | account | `privacy_export_requested`, `privacy_deletion_requested` |

- HTTP mutation follows API Governance: authenticated ownership, idempotency, correlation ID and user-safe errors.
- Authenticated means a validated issuer/audience/expiry token mapped to an opaque server-side subject; client-provided user IDs, roles or plans are never trusted for ownership.
- P0 permission scopes are `learner:read`, `learner:write`, `privacy:export` and `privacy:delete` (learner-facing; `admin:governance` is in the auth contract for the founder/admin governance surface). Missing scope is `403`, cross-subject resource lookup is `404`.
- Export/delete work uses async job/outbox only after a dedicated privacy worker contract exists; this spec does not authorize raw data movement.
- Auth provider subject is mapping data, never the canonical learner identity.

## Quality, privacy and acceptance

- Default deny for optional processing; disclosure explains purpose, data class and retention reference before first Writing submission.
- Duplicate request/retry creates one active privacy request.
- [ ] Learner A cannot read/change Learner B profile/consent/request by opaque ID.
- [ ] Declined consent does not silently enable scoped processing.
- [ ] Export/delete request survives refresh/retry and exposes progress safely.
- [ ] Account creation/consent events contain no raw profile content.
- [ ] First Writing submit cannot proceed until required consent is recorded.
- [ ] User can change optional consent without losing active draft/session.

## Readiness

The auth/provider boundary contract exists at `runtime/auth-identity-contract.md` but remains in `review`; the permission/data-retention API and privacy-worker failure/recovery contract/evidence are still missing. **Ready for Source Code: no.**
