# Vertical Slice — Identity & Consent

## Outcome and scope

The learner can authenticate, understand and record consent, maintain a minimal profile, and request export/deletion without cross-user exposure, duplicate effects, or accidental loss of current learning work.

**In scope:** `IDENTITY.Auth`, `IDENTITY.Profile`, `IDENTITY.Privacy`; authenticated learner session, profile, consent record, export/deletion request lifecycle and recovery.

**Out of scope:** payment identity, role-admin UI, provider selection/DPA approval, support break-glass, and delivery-format details of a completed export. Provider/legal approvals are release evidence, not learner-flow semantics.

## 1. Authority boundary

This slice does not own a second persisted identity state machine.

Canonical owners are:

- `artifacts/engineering/api/openapi.yaml` + `schema-contract.yaml` — HTTP operations/payloads;
- `artifacts/engineering/api/access-control.md` — authentication transport, role/function/object authorization and recent-auth/step-up policy;
- `artifacts/engineering/runtime-contract.yaml` — idempotency, durable operation and failure/recovery semantics;
- `artifacts/operations/data-retention-registry.yaml` — purpose, retention, export and deletion behavior.

Managed-auth provider state is an adapter concern. Provider subject/claims do not become the canonical learner identity or authorization truth.

## 2. Primary learner flow

```text
Unauthenticated
   ↓
Sign in / sign up
   ↓
Authenticated learner
   ↓
Required consent decision when applicable
   ├─ declined -> only scopes/features that remain permitted
   └─ consented -> continue
   ↓
Minimal profile
   ↓
Target / placement flow
```

Privacy management is an account-side branch, not a competing primary onboarding journey:

```text
Account & privacy
   ├─ review/change optional consent
   ├─ request export -> recent-auth when required -> queued/processing/completed|failed
   └─ request deletion -> recent-auth -> account deletion_pending + governed processing/recovery
```

The learner should not need to understand provider names, token claims, data-store topology, worker topology or internal role machinery.

## 3. UX states versus persisted state

Screen states such as `authenticating`, `auth_failed`, `reauth_required`, `reauthenticating`, `consent_saving`, `export_requested`, `deletion_confirming` and `retrying` are UX projections only.

Canonical API state remains compact:

- `Profile.account_status`: `active | suspended | deletion_pending`;
- `ConsentRecord.decision`: `consented | declined` with policy/version/timestamp;
- privacy `AsyncRequest.state`: `queued | processing | completed | failed`.

Do not invent provider-specific or migration-era persisted identity enums in the UI contract.

## 4. Sign-in and re-auth experience

| State | UI behavior | Rule |
|---|---|---|
| default | one clear sign-in method group | no learning dashboard behind an unauthenticated shell |
| authenticating | disable duplicate submit while preserving recovery | no duplicate account/session side effect |
| invalid | concise actionable error | never expose token/provider internals |
| unavailable | retry; safe public preview only if separately supported | do not fake an authenticated session |
| reauth_required | preserve safe local unacknowledged work and explain that sign-in is needed to continue | do not mark active learning work completed/abandoned merely because auth expired |
| reauthenticating | challenge through the managed auth boundary | never trust a client-authored `recent_auth=true` signal |
| reauth_failed | remain on recoverable auth-required state | do not lose acknowledged server work or submit hidden mutations |

After successful authentication, server-side authorization derives the learner subject from validated authentication context. Client-provided user IDs, roles, entitlements or ownership claims are never trusted.

When an authenticated session expires or is revoked during an active learner flow:

```text
current acknowledged learner state
  + safe local unacknowledged work when present
  -> authentication required
  -> managed re-authentication
  -> re-run ownership/role/entitlement/current-resource checks
  -> resume current valid state OR replace stale/ineligible state with one recovery action
```

Re-authentication does not replay a prior mutation automatically. An accepted Writing submission remains accepted and immutable; an unsent draft remains a draft.

## 5. Consent experience

Before first processing that requires a governed consent scope, show:

- purpose;
- relevant data class;
- whether the choice is required for that feature or optional;
- applicable retention/data-use reference;
- ability to change an optional choice later where policy permits.

Behavior:

| State | UI behavior | Side effect |
|---|---|---|
| required | one clear consent decision before gated processing | none until submitted |
| optional | optional choices default according to canonical policy, never dark-patterned | none until submitted |
| declined | continue only where permitted | immutable/versioned `consent_recorded` fact |
| saved | show effective decision and timestamp | one idempotent `consent_recorded` effect |

Consent never changes score semantics, recommendation truth or ownership.

## 6. Profile experience

Profile remains intentionally small in P0.

Learner-facing editable values may include display name, locale and IANA timezone according to canonical schema. `TargetProfile` is owned by `GOAL.Target`, not `IDENTITY.Profile`.

Changing locale/timezone must not rewrite historical evidence timestamps, prior results or TargetProfile truth.

## 7. Privacy request experience

### Export

```text
Request export
  -> recent-auth when the governed delivery exposes sensitive data
  -> queued
  -> processing
  -> completed | failed
```

- duplicate request/retry must not create duplicate semantic work;
- UI shows status/recovery, not raw private data inline merely because an export exists;
- delivery/download mechanics follow the governed implementation and retention policy;
- stale/missing recent-auth returns to the same export intent without creating the export until the challenge succeeds.

### Deletion

```text
Request deletion
  -> explain material consequences
  -> fresh recent-auth challenge
  -> final bounded confirmation
  -> profile/account becomes deletion_pending when accepted
  -> governed deletion processing
  -> account no longer serves normal learner access when completed
```

The UI must explain effects on drafts, evaluations, review history and any legally/operationally retained records without promising an impossible instantaneous purge.

A failed/deferred deletion operation exposes a governed recovery/support path; it never silently restores ordinary processing permissions. Failed recent-auth leaves account state unchanged.

## 8. Canonical API

Use only canonical operations:

- `getMe`;
- `updateMe`;
- `recordConsent`;
- `requestMyExport`;
- `requestMyDeletion`.

Authentication/session establishment is handled through the selected managed-auth boundary and canonical access-control rules; this slice does not create a duplicate auth API contract.

All learner mutations are owner-scoped and idempotent where the canonical API requires it. Recent-auth is an authorization precondition for the applicable privacy operation, not a request-body truth field.

## 9. Recovery and integrity

| Condition | Learner behavior |
|---|---|
| duplicate sign-in/consent/privacy mutation | one semantic effect |
| auth provider unavailable | retry/unavailable state; no fake session |
| auth expires during draft/session | preserve acknowledged state + safe local unacknowledged work; require re-auth; resume only after fresh authorization |
| auth expires after accepted submit | show durable submission/evaluation state after re-auth; never restore editable pre-submit state |
| consent save fails | preserve learner choice locally only as unacknowledged input; do not claim server consent |
| profile update conflict | reload/reconcile version; do not overwrite newer state silently |
| export request recent-auth missing/stale | challenge; create no export side effect until fresh auth succeeds |
| export request fails | preserve request/error state and retry path |
| deletion recent-auth missing/stale | challenge; account remains unchanged |
| deletion processing delayed/failed | keep governed `deletion_pending`/operation state and explain recovery |
| cross-user object attempt | deny without exposing another learner's resource |

Browser/local storage is never the sole canonical copy after server acknowledgement, and application-controlled browser storage never becomes a repository for raw persistent credentials.

## 10. Accessibility and anti-overload

- sign-in, re-auth, consent and privacy controls are keyboard-operable with visible focus;
- validation/status changes have programmatic semantics;
- consent copy is concise first, detail available progressively;
- deletion confirmation is explicit but not manipulative;
- one primary CTA per state;
- re-auth returns the learner to the valid prior intent/state rather than a dashboard reset;
- account/privacy management does not interrupt the daily learning flow unless action is required.

Critical-path accessibility/network/navigation requirements remain owned by `artifacts/experience/critical-path-usability-contract.yaml`.

## 11. Acceptance evidence

- [ ] Learner A cannot read/change Learner B profile, consent or privacy request.
- [ ] Client-provided role/user/entitlement/recent-auth fields cannot grant ownership, access or step-up status.
- [ ] Declined required consent blocks only the processing that requires it; no silent consent assumption.
- [ ] Optional consent can be changed without corrupting active draft/session state.
- [ ] Duplicate consent/export/delete requests produce one semantic effect.
- [ ] Profile timezone persists as a valid IANA timezone and does not rewrite historical instants.
- [ ] Export/delete request survives refresh/retry with truthful state.
- [ ] Expired/revoked session during an active draft/session requires re-auth and preserves acknowledged work plus safe local unacknowledged work.
- [ ] Re-auth after an accepted Writing submit returns to the durable submission/result projection, not editable pre-submit state.
- [ ] Account deletion rejects stale/missing recent-auth and leaves account state unchanged until a legitimate challenge succeeds.
- [ ] Sensitive export delivery/request step-up follows the canonical recent-auth policy.
- [ ] First Writing submission cannot invoke gated processing before required consent is effective.
- [ ] General analytics events contain no raw profile/private assessment content or bearer/session credential material.
- [ ] Keyboard/screen-reader/network/re-auth recovery acceptance passes for this slice.

## Readiness

The learner-flow semantics are aligned with the canonical API/access/runtime/retention owners. Release still requires provider/legal/privacy and executable acceptance evidence from the Build Readiness Matrix; missing post-code evidence does not create a second pre-code identity contract.
