# Build Readiness Matrix

## Purpose

This operational projection states whether each closed-pilot P0 pack has enough **approved contract + executable evidence** to enter implementation/pilot promotion. It does not redefine capability identity or product semantics.

Scope: only `P0-01` → `P0-06` from `blueprint/03-features.md`.

## Rebaseline — 2026-08-20

The architecture was rebaselined around:

- evidence/outcome-first product semantics;
- deterministic-first execution;
- TargetProfile instead of one universal target-band scalar;
- staged Writing evaluation;
- function-scoped internal principals;
- split `operation_state` vs `result_validity`;
- learner-facing uncertainty without raw confidence-as-probability;
- metadata decision value / reduced taxonomy cost;
- independent/novel retest before verified improvement;
- cost per verified improvement.

This is a semantic improvement, **not readiness evidence**. All affected P0 packs remain `not ready` until canonical consumers/tests/evidence are reconciled.

## Status conventions

- `missing`: required contract/evidence absent.
- `draft`: exists but incomplete/unreviewed.
- `review`: semantically reviewable; approval/evidence pending.
- `approved`: approved input for next lifecycle step.
- `not run`: executable evidence has not run.
- `ready`: every mandatory contract/evidence gate for the pack passes.

## Current matrix

| Pack | Current semantic state | Main remaining blockers | Build state |
|---|---|---|---|
| `P0-01 Identity` | access model improved; Premium entitlement and scoped internal principals defined | provider/DPA activation, privacy/export/delete end-to-end tests, generated access matrix | **not ready** |
| `P0-02 Diagnosis` | TargetProfile + coverage/termination/insufficient-data principles exist | placement contracts/consumers still require TargetProfile reconciliation; calibration/precision policy and acceptance evidence missing | **not ready** |
| `P0-03 Daily action` | deterministic multi-objective recommendation is canonical | daily-action implementation contract must fully consume uncertainty/coverage/exposure/load semantics; acceptance/outcome run missing | **not ready** |
| `P0-04 Writing evaluation` | staged deterministic-first runtime/evaluation/data/experience contracts + canonical API schema are aligned at authority level | generated OpenAPI/validators and remaining event/failure/prompt consumers must be revalidated; scorer benchmark route, rights-approved tasks, acceptance evidence missing | **not ready** |
| `P0-05 Error-to-review` | FSRS reviewability + independent/novel retest semantics aligned; canonical save-error/fix/retest operations are now registered in OpenAPI, schema and operation ownership | generated API/access tests must be revalidated; executable reviewability/novel-retest/verified-improvement acceptance run missing | **not ready** |
| `P0-06 Quality & economics` | cost routing + deterministic/inference boundary + metadata economics + cost/verified improvement defined | real benchmark corpus/run, armed cost ceilings, provider procurement, outcome-cost measurement and rollback evidence missing | **not ready** |

## Global gates

No P0 pack can become `ready` until all applicable items below pass:

1. canonical Blueprint/API/runtime/Artifact semantics agree;
2. generated API/codegen projection regenerates cleanly from the same candidate;
3. capability manifest/operation ownership references the current canonical fields;
4. role/entitlement/function-scope negative authorization tests exist;
5. durable mutations pass idempotency/replay tests;
6. C1–C4 raw learner content is absent from general telemetry;
7. learner-visible scoring route has benchmark-approved evidence tied to exact rubric/prompt/route versions;
8. rights-approved/versioned content exists for the tested learner path;
9. failures preserve learner work and do not double-charge quota/cost;
10. release gate has explicit rollback/disable behavior;
11. no readiness/learning-effectiveness claim is inferred from prose/model confidence;
12. acceptance evidence is bound to the exact candidate commit/artifact versions.

## P0-04 Writing-specific reconciliation gate

Before Writing implementation eligibility, verify that **all** active contracts/projected schemas use the same semantics:

```text
submission / durable operation:
  submitted -> processing -> completed|delayed|unavailable

operation_state:
  accepted|processing|succeeded|delayed|unavailable|failed|cancelled

result_validity:
  accepted|limited_evidence|insufficient_evidence|invalid|integrity_review
```

Block if any active authority/consumer still:

- persists `low_confidence` as submission/workflow state;
- requires learner-facing raw model confidence;
- uses migration-only OpenAPI as build/codegen authority;
- directly maps model output to readiness/mastery;
- runs unconditional stronger-model second pass;
- treats AI-generated-text detector output as cheating proof.

## P0-05 verified-improvement gate

The Error-to-review pack must prove:

```text
confirmed evidence-backed error
  -> smallest useful intervention
  -> FSRS only if unit is retrievable
  -> sufficiently novel retest
  -> evidence admission
  -> improved or remains active
```

Canonical P0-05 mutation identities are now:

- `saveWritingError`;
- `saveWritingErrorFix`;
- `startWritingErrorRetest`;
- plus `getReviewQueue` / `rateReviewItem` for review scheduling.

These operation identities being present is **not** acceptance evidence. Generator/schema/access/idempotency tests must still prove them.

A review rating/card maturity or success on the revealed source item is not sufficient evidence of improvement/transfer.

## Cost gate

P0-06 must observe at least:

- cost per accepted evaluation;
- primary vs escalation scorer cost;
- retry/failure waste;
- optional deep-feedback cost;
- content author/reviewer metadata cost where material;
- cost per verified improvement/retest outcome for the pilot loop.

A cheaper route does not pass when benchmark/evidence quality falls below the required floor.

## Update rule

- A semantic change returns affected packs to `review/not ready` until consumers/tests are reconciled.
- `not run` is truthful; do not promote based on intended tests.
- New future-scope features do not enter this matrix without roadmap/capability-phase change.
- This matrix reports readiness only; it never overrides canonical product/runtime/API owners.