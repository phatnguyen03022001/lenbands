# Owner Runtime Spec — IDENTITY.Core

## Identity

- `family_id`: `IDENTITY.Core`
- `family_version`: `1.0.0`
- `lifecycle`: `ACTIVE`
- `build_status`: `candidate`
- `owner`: product + engineering

## Purpose and non-goals

Provide account authentication, consent, learner profile ownership, and privacy request boundaries for the closed pilot. Billing, social identity administration, and full account recovery remain outside this slice unless promoted.

## Actors and permissions

- Learner: owns and reads their account, consent, and profile.
- Identity provider: authenticates; does not own learner content.
- Runtime: validates provider assertions and records consent facts.
- Operations: may inspect redacted audit records only.

## Commands and interaction

`Authenticate`, `RecordConsent`, `UpdateProfile`, `RequestExport`, `RequestDeletion`.

Path: user action → identity command → provider/runtime validation → persisted identity state → session/profile response → audit evidence.

## Runtime boundary and state

Canonical persisted identity state (auth-identity-contract.md): `guest → authenticated → consent_pending → active`; deletion: `deletion_requested → deletion_processing → deleted`. `authenticating`, `auth_failed` are UX-only transitions, not persisted identity states.

Privacy requests use a separate state (canonical PrivacyRequest.state, openapi.yaml): `requested → processing → ready | completed | failed | cancelled`. `ready` means export is available; deletion uses `completed` after the recovery window. Do not use `retryable` as a persisted state (retry is an action, not a state).

## Entities and ownership

`Account`, `ConsentRecord`, `LearnerProfile`, `PrivacyRequest`. Identity owns all entities; no learner essay/audio/content is stored in identity records.

## API/contract references

- `artifacts/engineering/contracts/runtime/auth-identity-contract.md`
- `artifacts/engineering/contracts/runtime/api-governance-contract.md`

Operations are idempotent by provider subject or request id. Consent changes require a new immutable record, not an overwrite.

## Events

`account_created`, `consent_recorded`, `privacy_export_requested`, `privacy_deletion_requested`.

Events contain references and hashes only; never learner content or raw provider tokens. Canonical schema is in the shared event contract; allowed producers are the Identity runtime and privacy worker.

## Failure and recovery

`AUTH_UNAVAILABLE` preserves anonymous state and offers retry. `PERMISSION_DENIED` fails closed. `PRIVACY_EXPORT_FAILED` preserves the request and exposes retry without duplicating the request.

## Acceptance

- repeated provider callback does not create duplicate Account;
- consent is required before learner runtime access;
- export/delete request is idempotent;
- raw provider token and learner content never enter events/logs;
- provider outage has a user-visible retry state.

## Executor dossier — permission, data, UI, observability, adapter

- **Permission**: `learner:read`, `learner:write`, `privacy:export`, `privacy:delete` (learner); `admin:governance` (admin audit scope). Ownership always server-side `subject_id`; no client-provided identity override.
- **Data read/write**: learner owns `Account`, `ConsentRecord`, `LearnerProfile`, `PrivacyRequest`; writes consent as immutable new record (no overwrite). No essay/audio/content stored in identity records.
- **API**: `POST /v1/auth/session`, `GET /v1/me`, `POST /v1/me/consents`, `POST /v1/me/export`, `POST /v1/me/deletion` (all require `X-Request-Id`, idempotency for mutation, error envelope per api-governance-contract.md).
- **Events**: producer `account_created`, `consent_recorded`, `privacy_export_requested`, `privacy_deletion_requested`; refs/hashes only.
- **UI/UX states**: per `identity-consent.md` — sign-in (loading/invalid/unavailable), consent (required/declined/saved), account & privacy (export_requested/export_ready, deletion_pending/deleted). `consent_pending` blocks Writing submission. WCAG AA, keyboard, focus-visible.
- **Observability**: auth failure/failure states redacted; provider token and raw learner content excluded from logs/events per observability-slo-contract.md.
- **Rollback/kill-switch**: provider swap via adapter/feature-flag (no domain change); deletion requires re-auth within policy window; retry idempotent, never creates duplicate deletion job.
- **Provider adapter boundary**: auth provider is replaceable adapter (issuer allowlist, audience, opaque subject); provider-neutral semantics; DPA/provider selection is a Decision Artifact, not this contract.
- **Non-goals**: billing, social identity administration, full account recovery (deferred/P1).
- **Deferred**: `IDENTITY.Recovery` (P1), `IDENTITY.DeleteAccount` beyond privacy-request state (deferred).

## Evidence and dependencies

Evidence: provider DPA, export/delete acceptance run. Dependencies: managed auth boundary, `ADR-0003`.
