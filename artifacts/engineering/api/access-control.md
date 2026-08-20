# Web Persona & Access-Control Contract

## Model

LenBands has **5 web personas** but **4 authorization identities**:

| Web persona | Authenticated role | Entitlement | Purpose |
|---|---|---|---|
| `guest` | none | none | public discovery and authentication entry |
| `learner` | `learner` | base plan | study and own learning data |
| `premium_learner` | `learner` | `premium` | learner plus paid capabilities |
| `colab` | `colab` | none | content author/review/publish according to permission |
| `admin` | `admin` | none | platform operations/governance only |

Premium remains an entitlement overlay so billing state cannot accidentally change authorization hierarchy.

AI/model providers are **not roles or principals**. They are external processing adapters invoked by a scoped server-side operation.

## Internal principals

Internal execution is function-scoped rather than one blanket `service` authority. The implementation may use one underlying managed identity mechanism, but authorization must resolve to a concrete function scope before data access.

| Internal principal/function | Minimum purpose | Explicitly cannot |
|---|---|---|
| `evaluation_worker` | read one accepted submission/job, write governed evaluation artifacts/results | browse arbitrary learner data, change entitlement, publish content |
| `workflow_callback` | resume one durable operation using opaque operation references | gain general table access from callback identity alone |
| `billing_webhook` | reconcile provider events into the entitlement ledger | mutate learning, assessment, readiness, content or score state |
| `content_job` | process bounded content/tagging jobs | read learner assessment content or publish without permission/gate |
| `notification_job` | select/send allowed notifications from prepared facts/preferences | receive raw C3 assessment payload when not required |
| `research_benchmark_job` | access an explicitly approved benchmark corpus under research/evaluation policy | access arbitrary production learner submissions by default |

A generic provider/service credential does not imply these permissions. Each operation must enforce object scope, data class, purpose and state preconditions.

## Colab permission model

`colab` is one web role but content duties are separate permissions:

- `content_author` — create/edit draft content;
- `content_reviewer` — review correctness/taxonomy/rights/calibration state;
- `content_publisher` — publish/retire after required gates pass.

For a solo-founder/early-stage environment the same trusted person may hold multiple permissions, but every publish/retire action remains separately authorized and audited. The data model must not require self-review as an invariant; separation can be strengthened later without changing the web role.

## Separation-of-duty rules

- Learner owns only their account, learning state, drafts, submissions, evaluations exposed to them, learner-confirmed errors/fixes/retests, reviews and private knowledge.
- Colab owns content workflow. Colab cannot read arbitrary learner essays/audio, score learner work, change entitlements, or administer accounts.
- Admin operates accounts, configuration, release gates, billing overview and aggregate governance. Admin does not author learner scores and has no product control to manually overwrite an evaluation result.
- A support/admin workflow that needs learner-specific sensitive content requires a separately audited break-glass policy; it is not granted by the ordinary admin role.
- Evaluation workers access a submission/retest by opaque job/resource reference and minimum required scope, not by broad learner-table privileges.
- Billing webhooks may update a provider-neutral entitlement ledger only; they cannot touch learning/assessment state.
- Research/benchmark access is separate from ordinary Admin/Colab access and must use an approved corpus/data policy rather than production-table browsing.
- Model/provider credentials never confer LenBands authorization; server-side code decides what minimum payload may be sent.

## Surface matrix

| Surface | Guest | Learner | Premium | Colab | Admin |
|---|---:|---:|---:|---:|---:|
| public config/catalog/pricing | R | R | R | R | R |
| own profile/privacy | - | RW | RW | own only | own only |
| goal/placement/today/study | - | RW | RW | - | - |
| learning/practice/review/history/progress | - | own RW | own RW | - | aggregate governance only |
| Writing draft/submission/evaluation | - | own RW | own RW | - | aggregate governance only |
| learner-confirmed Writing error/fix/retest | - | own RW | own RW | - | aggregate governance only |
| advanced insights/deep feedback/mock | - | - | RW | - | aggregate governance only |
| content draft workspace | - | - | - | permission-scoped RW | audit only |
| content review/publish/retire | - | - | - | permission-scoped | audit/release policy only |
| account status/system config | - | - | - | - | RW |
| release gate/quality/usage/billing overview | - | - | - | - | RW |
| provider webhook/internal job | - | - | - | - | - |

`R/RW` means only the resource scope allowed by the operation and object policy; it is not blanket table access.

## Authorization decision

```text
authenticated principal / signed internal caller
  -> verified identity
  -> web role OR internal function scope
  -> required entitlement/permission
  -> object ownership / function permission
  -> lifecycle/state precondition
  -> data-class + purpose policy
  -> rate/quota policy
  -> allow or RFC9457 problem
```

Every step is deny-by-default.

## Learner remediation ownership rules

For `saveWritingError`, `saveWritingErrorFix` and `startWritingErrorRetest`:

1. the source evaluation/finding/error must resolve to the authenticated learner;
2. the client cannot supply a different learner ID or authoritative score/confidence/taxonomy value;
3. `saveWritingError` derives criterion/error/remediation policy from the owned normalized finding and framework, not arbitrary client fields;
4. `saveWritingErrorFix` may write learner-authored fix content only under the owned error and must not mark it `improved`;
5. `startWritingErrorRetest` chooses/validates an exposure-eligible task server-side; a requested candidate task never bypasses novelty/exposure policy;
6. retest evaluation uses the same function-scoped evaluation boundary as ordinary Writing evaluation;
7. quota/entitlement controls may limit paid evaluation depth/count but must not change score/evidence semantics.

## Database policy

Managed Postgres RLS is defense in depth, not a replacement for application authorization.

- exposed learner-owned tables require RLS;
- admin/colab tables are not made broadly client-readable;
- service-role/bypass-RLS credentials never enter browser code;
- a server path using elevated credentials must re-apply product authorization and internal function scope before data access;
- storage object paths use opaque subject/resource IDs and RLS policies;
- content/report queries return the minimum fields required for the role;
- internal jobs resolve opaque IDs to the smallest required rows/columns; a job type does not receive unrestricted database visibility merely because it runs server-side.

## Browser session and credential transport

Authentication transport is a security boundary, not a frontend implementation preference.

- Application-controlled `localStorage`, `sessionStorage`, IndexedDB, URL/query strings and rendered HTML must not contain raw access tokens, refresh tokens, service credentials or equivalent long-lived bearer material.
- Prefer a managed same-origin session whose persistent credential material is inaccessible to ordinary application JavaScript when the selected provider/runtime supports it. Any provider flow that requires browser-readable persistent bearer material needs an explicit security review before activation.
- Cookies carrying authentication state must be `Secure`, use the narrowest practical `SameSite` policy, have explicit path/domain scope, and be protected from script access when the provider/runtime permits. Cookie-authenticated state-changing requests require an origin/CSRF defense appropriate to the selected session mechanism; CORS is not a CSRF defense.
- Authorization-header bearer tokens, when used, are accepted only from the reviewed authentication boundary. The application must not copy them into telemetry, error details, analytics, cache keys or learner-visible state.
- Session fixation is prohibited: successful sign-in, privilege/role elevation and credential recovery rotate or replace the effective session identifier as supported by the provider.
- Logout/revocation invalidates or expires the effective session according to provider capability; cached UI state never proves continued authorization.
- Expired/revoked authentication returns an authentication-required state without converting a valid draft, accepted submission or server-side evidence into loss/completion.
- Re-authentication must re-run object/role/entitlement checks against current state; resuming an old route never inherits stale authorization.

The exact managed-auth cookie/token mechanics remain a sourcing/adapter choice, but an implementation must satisfy these invariants and document the chosen mechanism in implementation acceptance evidence.

## Recent-auth / step-up policy

High-impact operations require a fresh authentication assertion in addition to ordinary role/object authorization. `recent_auth` is a provider-backed challenge or equivalent proof whose maximum age is policy-configured and bounded; it is not a client timestamp.

P0 operations requiring step-up/recent-auth:

- request account deletion;
- request/download a sensitive personal-data export when the delivery mechanism exposes C1-C3 data;
- content publish or retire;
- account suspension/reactivation;
- system-configuration mutation;
- release-gate mutation/decision;
- future break-glass access to raw learner assessment content.

Rules:

- step-up failure leaves the underlying domain object unchanged;
- role/permission checks occur again after step-up;
- MFA/phishing-resistant challenge is used when required by the account/role policy and supported by the managed identity provider;
- a recent-auth proof is bound to the authenticated subject/session and cannot be supplied as an arbitrary client-authored boolean/header;
- batch/admin tooling cannot silently bypass step-up merely because it runs server-side; an internal automation needs its own function-scoped authorization contract.

## High-risk operations

The following require explicit audit events and stronger abuse/rate controls; the subset listed above additionally requires recent-auth/step-up:

- account suspension/reactivation;
- content publish/retire;
- system configuration changes;
- release-gate decisions;
- subscription/entitlement changes;
- privacy export/deletion;
- mock/evaluation/retest submission that incurs material provider cost;
- benchmark-corpus import/access/promotion;
- any future break-glass access to raw learner assessment content.

## Verification

A generated access/security test matrix must prove for every applicable OpenAPI operation:

1. every declared persona that should pass;
2. every non-declared persona receives denial;
3. learner A cannot access learner B object IDs (BOLA test);
4. role cannot call another role's function (BFLA test);
5. Premium access disappears when entitlement is inactive without changing the learner role;
6. duplicated/out-of-order billing webhooks do not grant inconsistent entitlement;
7. internal function A cannot use its credentials/path to perform internal function B's domain operation;
8. evaluation/content/billing jobs cannot enumerate unrelated learner resources;
9. Colab publish permission can be removed independently from Colab author access;
10. model/provider callbacks cannot become an authorization bypass;
11. learner A cannot save/fix/retest learner B's finding/error by guessing IDs;
12. client-provided taxonomy/score/confidence fields cannot override server-derived remediation/evidence semantics;
13. a preferred retest task that violates exposure policy is rejected even when learner-owned;
14. browser-managed session credentials are absent from application-controlled persistent storage, URLs, logs and telemetry;
15. cookie-authenticated mutations fail the chosen CSRF/origin negative cases while legitimate same-origin mutations continue to work;
16. expired/revoked sessions cannot mutate state and can re-authenticate without losing acknowledged learner work;
17. each step-up operation rejects stale/missing recent-auth and succeeds after a legitimate fresh challenge without changing role semantics;
18. session rotation/re-auth cannot preserve a stale privilege/entitlement/object authorization decision.
