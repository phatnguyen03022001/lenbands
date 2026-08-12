# Exit Exercise Specification

## Purpose

Turn Build/Buy exit strategy into repeatable, testable exercises. An exit strategy is not accepted because it sounds portable; it must prove data export, restore and provider replacement at least at pilot scale.

## Exercise A — Identity and platform export

| Step | Pass condition | Evidence produced |
|---|---|---|
| Export user/profile/entitlement mapping | Export contains stable internal user ID, auth-provider subject mapping and consent state | encrypted export checksum + schema version |
| Export runtime relational data | Postgres dump restores to isolated environment | restore log + migration version |
| Validate access model | Re-linked test user can access only own records | authorization test report |
| Delete source test records | Deletion request is propagated per policy | deletion audit record |

**Exit criterion:** a second standards-compatible auth provider can be connected without changing `user_id` semantics or learner data ownership.

## Exercise B — Writing evaluation provider replacement

| Step | Pass condition | Evidence produced |
|---|---|---|
| Run canonical input through provider adapter A and B | Both outputs map to Evaluation Contract | contract validation report |
| Compare quality | Benchmark produces comparable rubric/evidence/confidence metrics | benchmark run record |
| Switch route | Feature flag changes adapter without API/UI/event semantic change | rollout/rollback record |
| Preserve history | Existing evaluation audit remains attributable to original provider version | audit query result |

**Exit criterion:** provider B can be introduced or provider A disabled without losing submissions, changing event semantics or exposing provider payload to learner UI.

## Frequency and gate

- Run Exercise A before closed pilot and after auth/database boundary changes.
- Run Exercise B before any evaluation provider/model promotion and every material provider contract change.
- Failure blocks `approved` status for the relevant Build/Buy decision.

## Status

No exercise has been run. This file is a test specification, not evidence. Exercise results belong in immutable `artifacts/operations/evidence/` only after real execution.
