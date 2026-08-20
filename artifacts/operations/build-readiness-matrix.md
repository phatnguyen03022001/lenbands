# Build Readiness Matrix

## Purpose

This operational projection states whether each closed-pilot P0 pack has enough approved contract, resolved blocking-risk control, and executable evidence to enter implementation/pilot promotion. It does not redefine capability identity, product semantics, risk controls, or release policy.

Scope: only `P0-01` → `P0-06` from `blueprint/03-features.md`.

## Rebaseline — 2026-08-20

The architecture is now based on:

- evidence/outcome-first product semantics;
- deterministic-first execution;
- TargetProfile rather than one universal target-band scalar;
- staged Writing evaluation;
- function-scoped internal principals;
- split operation lifecycle vs result validity;
- learner-facing uncertainty without raw confidence-as-probability;
- metadata decision value / reduced taxonomy cost;
- independent/novel retest before verified improvement;
- cost per verified improvement;
- explicit problem/risk coverage before implementation eligibility.

`artifacts/operations/problem-risk-registry.yaml` is the canonical coverage map. A risk marked covered is not runtime evidence; an applicable blocking risk keeps the family ineligible until its control boundary is sufficient.

## Current matrix

| Pack | Current semantic state | Main remaining blockers | Build state |
|---|---|---|---|
| `P0-01 Identity` | Premium entitlement, scoped internal principals and privacy ownership are defined | provider/DPA/eligibility decisions, export/delete evidence, break-glass/restore/legal risk controls, generated access evidence | **not ready** |
| `P0-02 Diagnosis` | TargetProfile, deterministic placement, coverage/termination and missing-evidence semantics are reconciled | calibration/construct coverage evidence, content/legal/retention/DR/migration/accessibility risk controls, acceptance run | **not ready** |
| `P0-03 Daily action` | deterministic candidate intents/ranking, evidence uncertainty, coverage/load and zero-LLM routing are reconciled | acceptance run plus applicable DR/migration/incident/accessibility/device/experiment risk controls | **not ready** |
| `P0-04 Writing evaluation` | staged deterministic-first runtime/evaluation/data/experience/API contracts are aligned at authority level | benchmark/fairness slices, rights-approved tasks, support/break-glass, retention/DR/migration/accessibility/vendor/legal/reproducibility controls, acceptance evidence | **not ready** |
| `P0-05 Error-to-review` | retrievable-unit FSRS boundary + independent/novel retest semantics + save-error/fix/retest API identities are aligned | generated API/access/idempotency validation, verified-improvement run, support/DR/migration/accessibility/device risk controls | **not ready** |
| `P0-06 Quality & economics` | deterministic/inference boundary, scorer governance, metadata economics and cost/verified-improvement metrics are defined | benchmark/fairness corpus, armed cost ceilings, incident/DR/vendor/legal/support controls, outcome-cost measurement and rollback evidence | **not ready** |

## Implementation eligibility gate

A family is not implementation-eligible until all of the following hold:

1. canonical Blueprint/API/runtime/Artifact semantics agree;
2. every problem category applicable to the family has an explicit risk entry;
3. no P0 critical/high risk for the family remains `open` or `partial` with `implementation_blocking=true`;
4. required owner contracts are sufficiently resolved for code not to invent behavior;
5. generated API/schema/ownership projections validate for families that expose HTTP operations;
6. privacy/data entity coverage is complete for the family;
7. no unresolved critical/high finding remains outside the risk registry.

This gate is intentionally earlier than release readiness. Runtime benchmark, calibration, pilot outcome, cost and rollback evidence may still be missing after a family becomes implementation-eligible when those observations require code to exist.

## Release/global gates

No closed-pilot release becomes ready until all applicable items below pass:

1. role/entitlement/function-scope negative authorization tests;
2. idempotency/replay tests for durable mutations;
3. C1-C4 raw learner content absent from general telemetry;
4. benchmark-approved learner-visible scoring route tied to exact rubric/prompt/route versions;
5. rights-approved/versioned content for tested learner paths;
6. failures preserve learner work and do not double-charge quota/cost;
7. restore/rollback/disable behavior is exercised;
8. no readiness/learning-effectiveness claim is inferred from completion, prose or raw model confidence;
9. acceptance evidence is bound to the exact candidate commit/artifact versions;
10. blocking problem risks are closed or explicitly moved out of scope by a governed scope decision.

## P0-04 Writing gate

Active contracts/projected schemas must agree on:

```text
submission:
  submitted -> processing -> completed|delayed|unavailable

operation_state:
  accepted|processing|succeeded|delayed|unavailable|failed|cancelled

result_validity:
  accepted|limited_evidence|insufficient_evidence|invalid|integrity_review
```

Block any implementation that:

- persists `low_confidence` as workflow/submission state;
- requires learner-facing raw model confidence;
- uses migration-only OpenAPI as build authority;
- maps model output directly to readiness/mastery;
- performs an unconditional stronger-model second pass;
- treats AI-generated-text detection as cheating proof.

## P0-05 verified-improvement gate

```text
confirmed evidence-backed error
  -> smallest useful intervention
  -> FSRS only if unit is retrievable
  -> sufficiently novel retest
  -> evidence admission
  -> improved or remains active
```

Canonical P0-05 mutations are `saveWritingError`, `saveWritingErrorFix`, and `startWritingErrorRetest`; review uses `getReviewQueue` and `rateReviewItem`. Operation existence is not acceptance evidence.

## Cost gate

P0-06 must observe at least:

- cost per accepted evaluation;
- primary vs escalation scorer cost;
- retry/failure waste;
- optional deep-feedback cost;
- content author/reviewer metadata cost when material;
- cost per verified improvement/retest outcome.

A cheaper route fails when required benchmark/evidence quality falls below the quality floor.

## Update rule

- Semantic changes return affected packs to `review/not ready` until consumers are reconciled.
- Problem/risk coverage changes may add blockers without changing product scope.
- `not run` is truthful; intended tests do not count as evidence.
- New future-scope features do not enter this matrix without roadmap/capability-phase change.
- This matrix reports status only; canonical owners remain in `DOCS.yaml`.
