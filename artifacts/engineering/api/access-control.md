# Web Persona & Access-Control Contract

## Model

LenBands has **5 web personas** but **4 authorization identities**:

| Web persona | Authenticated role | Entitlement | Purpose |
|---|---|---|---|
| `guest` | none | none | public discovery and authentication entry |
| `learner` | `learner` | base plan | study and own learning data |
| `premium_learner` | `learner` | `premium` | learner plus paid capabilities |
| `colab` | `colab` | none | content creation/review/publish only |
| `admin` | `admin` | none | platform operations/governance only |

An internal `service` principal exists for signed provider webhooks and durable workflow steps. It is not a web persona and cannot open a learner/admin UI session.

Premium remains an entitlement overlay so billing state cannot accidentally change authorization hierarchy.

## Separation-of-duty rules

- Learner owns only their account, learning state, drafts, submissions, attempts, reviews and private knowledge.
- Colab owns content workflow. Colab cannot read arbitrary learner essays/audio, score learner work, change entitlements, or administer accounts.
- Admin operates accounts, configuration, release gates, billing overview and aggregate governance. Admin does not author learner scores and has no product control to manually overwrite an evaluation result.
- A support/admin workflow that needs learner-specific sensitive content requires a separately audited break-glass policy; it is not granted by the ordinary admin role.
- Evaluation workers access a submission by opaque job reference and minimum required scope, not by broad learner-table privileges.
- Billing webhooks may update a provider-neutral entitlement ledger only; they cannot touch learning/assessment state.

## Surface matrix

| Surface | Guest | Learner | Premium | Colab | Admin |
|---|---:|---:|---:|---:|---:|
| public config/catalog/pricing | R | R | R | R | R |
| own profile/privacy | - | RW | RW | own only | own only |
| goal/placement/today/study | - | RW | RW | - | - |
| learning/practice/review/history/progress | - | RW | RW | - | aggregate governance only |
| Writing draft/submission/evaluation | - | own RW | own RW | - | aggregate governance only |
| advanced insights/deep feedback/mock | - | - | RW | - | aggregate governance only |
| content workspace/publish | - | - | - | RW | audit only |
| account status/system config | - | - | - | - | RW |
| release gate/quality/usage/billing overview | - | - | - | - | RW |
| provider webhook | - | - | - | - | - |

`R/RW` means only the resource scope allowed by the operation and object policy; it is not blanket table access.

## Authorization decision

```text
authenticated principal
  -> verified identity
  -> product role
  -> required entitlement
  -> object ownership / function permission
  -> lifecycle/state precondition
  -> data-class policy
  -> rate/quota policy
  -> allow or RFC9457 problem
```

Every step is deny-by-default.

## Database policy

Managed Postgres RLS is defense in depth, not a replacement for application authorization.

- exposed learner-owned tables require RLS;
- admin/colab tables are not made broadly client-readable;
- service-role/bypass-RLS credentials never enter browser code;
- a server path using elevated credentials must re-apply product authorization before data access;
- storage object paths use opaque subject/resource IDs and RLS policies;
- content/report queries return the minimum fields required for the role.

## High-risk operations

The following require explicit audit events and stronger abuse/rate controls:

- account suspension/reactivation;
- content publish/retire;
- system configuration changes;
- release-gate decisions;
- subscription/entitlement changes;
- privacy export/deletion;
- mock/evaluation submission that incurs material provider cost.

## Verification

A generated access test matrix must prove for every OpenAPI operation:

1. every declared persona that should pass;
2. every non-declared persona receives denial;
3. learner A cannot access learner B object IDs (BOLA test);
4. role cannot call another role's function (BFLA test);
5. Premium access disappears when entitlement is inactive without changing the learner role;
6. duplicated/out-of-order billing webhooks do not grant inconsistent entitlement.
