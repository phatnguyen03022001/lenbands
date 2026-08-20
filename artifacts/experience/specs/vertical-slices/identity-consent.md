# Vertical Slice — Identity & Consent

## Outcome and scope

The learner can authenticate, understand and record consent, maintain a minimal profile, and request export/deletion without cross-user exposure, duplicate effects, or accidental loss of current learning work.

**In scope:** `IDENTITY.Auth`, `IDENTITY.Profile`, `IDENTITY.Privacy`; authenticated learner session, profile, consent record, export/deletion request lifecycle and recovery.

**Out of scope:** payment identity, role-admin UI, provider selection/DPA approval, support break-glass, and delivery-format details of a completed export. Provider/legal approvals are release evidence, not learner-flow semantics.

## 1. Authority boundary

This slice does not own a second persisted identity state machine.

Canonical owners are:

- `artifacts/engineering/api/openapi.yaml` + `schema-contract.yaml` — HTTP operations/payloads;
- `artifacts/engineering/api/access-control.md` — authentication, role/function/object authorization;
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
   ├─ request export -> queued/processing/completed|failed
   └─ request deletion -> account deletion_pending + governed processing/recovery
```

The learner should not need to understand provider names, token claims, data-store topology, worker topology or internal role machinery.

## 3. UX states versus persisted state

Screen states such as `authenticating`, `auth_failed`, `consent_saving`, `export_requested`, `deletion_confirming` and `retrying` are UX projections only.

Canonical API state remains compact:

- `Profile.account_status`: `active | suspended | deletion_pending`;
- `ConsentRecord.decision`: `consented | declined` with policy/version/timestamp;
- privacy `AsyncRequest.state`: `queued | processing | completed | failed`.

Do not invent provider-specific or migration-era persisted identity enums in the UI contract.

## 4. Sign-in experience

| State | UI behavior | Rule |
|---|---|---|
| default | one clear sign-in method group | no learning dashboard behind an unauthenticated shell |
| authenticating | disable duplicate submit while preserving recovery | no duplicate account/session side effect |
| invalid | concise actionable error | never expose token/provider internals |
| unavailable | retry; safe public preview only if separately supported | do not fake an authenticated session |

After successful authentication, server-side authorization derives the learner subject from validated authentication context. Client-provided user IDs, roles, entitlements or ownership claims are never trusted.

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
  -> queued
  -> processing
  -> completed | failed
```

- duplicate request/retry must not create duplicate semantic work;
- UI shows status/recovery, not raw private data inline merely because an export exists;
- delivery/download mechanics follow the governed implementation and retention policy.

### Deletion

```text
Request deletion
  -> confirm material consequences
  -> profile/account becomes deletion_pending when accepted
  -> governed deletion processing
  -> account no longer serves normal learner access when completed
```

The UI must explain effects on drafts, evaluations, review history and any legally/operationally retained records without promising an impossible instantaneous purge.

A failed/deferred deletion operation exposes a governed recovery/support path; it never silently restores ordinary processing permissions.

## 8. Canonical API

Use only canonical operations:

- `getMe`;
- `updateMe`;
- `recordConsent`;
- `requestMyExport`;
- `requestMyDeletion`.

Authentication/session establishment is handled through the selected managed-auth boundary and canonical access-control rules; this slice does not create a duplicate auth API contract.

All learner mutations are owner-scoped and idempotent where the canonical API requires it.

## 9. Recovery and integrity

| Condition | Learner behavior |
|---|---|
| duplicate sign-in/consent/privacy mutation | one semantic effect |
| auth provider unavailable | retry/unavailable state; no fake session |
| consent save fails | preserve learner choice locally only as unacknowledged input; do not claim server consent |
| profile update conflict | reload/reconcile version; do not overwrite newer state silently |
| export request fails | preserve request/error state and retry path |
| deletion processing delayed/failed | keep governed `deletion_pending`/operation state and explain recovery |
| cross-user object attempt | deny without exposing another learner's resource |

Browser/local storage is never the sole canonical copy after server acknowledgement.

## 10. Accessibility and anti-overload

- sign-in, consent and privacy controls are keyboard-operable with visible focus;
- validation/status changes have programmatic semantics;
- consent copy is concise first, detail available progressively;
- deletion confirmation is explicit but not manipulative;
- one primary CTA per state;
- account/privacy management does not interrupt the daily learning flow unless action is required.

Critical-path accessibility/network requirements remain owned by `artifacts/experience/critical-path-usability-contract.yaml`.

## 11. Acceptance evidence

- [ ] Learner A cannot read/change Learner B profile, consent or privacy request.
- [ ] Client-provided role/user/entitlement fields cannot grant ownership or access.
- [ ] Declined required consent blocks only the processing that requires it; no silent consent assumption.
- [ ] Optional consent can be changed without corrupting active draft/session state.
- [ ] Duplicate consent/export/delete requests produce one semantic effect.
- [ ] Profile timezone persists as a valid IANA timezone and does not rewrite historical instants.
- [ ] Export/delete request survives refresh/retry with truthful state.
- [ ] First Writing submission cannot invoke gated processing before required consent is effective.
- [ ] General analytics events contain no raw profile/private assessment content.
- [ ] Keyboard/screen-reader/network recovery acceptance passes for this slice.

## Readiness

The learner-flow semantics are aligned with the canonical API/access/runtime/retention owners. Release still requires provider/legal/privacy and executable acceptance evidence from the Build Readiness Matrix; missing post-code evidence does not create a second pre-code identity contract.
