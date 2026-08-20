# Build Readiness Matrix

## Purpose

This projection reports two different questions for the closed-pilot P0 packs:

1. **Implementation eligibility** — can an agent implement source without inventing unresolved behavior?
2. **Release readiness** — does the exact candidate have the runtime/legal/rights/quality evidence required to serve real learners?

It does not redefine capability identity, product semantics, risk controls or release policy.

## Rebaseline — 2026-08-20

Canonical design now includes evidence/outcome-first semantics, deterministic-first execution, TargetProfile, staged Writing evaluation, function-scoped internal principals, split operation/result validity, decision-value metadata, independent retest, cost per verified improvement, explicit risk coverage, data-migration rules, time/reproducibility semantics, and P0 accessibility/network recovery contracts.

`artifacts/operations/problem-risk-registry.yaml` owns risk classification. `artifacts/operations/implementation-eligibility.yaml` owns the lifecycle distinction.

## Current matrix

| Pack | Contract/design state | Implementation state | Release evidence still missing | Release state |
|---|---|---|---|---|
| `P0-01 Identity` | auth/access/privacy/retention/support boundaries defined | **blocked pending contract approval + verification/authorization** | provider DPA/activation, legal pilot eligibility, export/delete, access and accessibility/network acceptance | **not ready** |
| `P0-02 Diagnosis` | TargetProfile + deterministic placement + coverage/termination + time semantics defined | **blocked pending contract approval + verification/authorization** | calibration/coverage run, rights evidence, legal pilot eligibility, accessibility/network acceptance | **not ready** |
| `P0-03 Daily action` | deterministic candidate/ranking + uncertainty/coverage/load + zero-LLM + time semantics defined | **blocked pending contract approval + verification/authorization** | deterministic acceptance, timezone-boundary and accessibility/network runs | **not ready** |
| `P0-04 Writing evaluation` | staged scorer/runtime/API/data/failure/benchmark-slice/support/reproducibility semantics defined | **blocked pending contract approval + verification/authorization** | rights-approved tasks, authorized corpus, benchmark including required slices, privacy/idempotency/evidence/dispute/accessibility runs, legal pilot eligibility | **not ready** |
| `P0-05 Error-to-review` | reviewability/FSRS boundary + independent retest + canonical mutations + time semantics defined | **blocked pending contract approval + verification/authorization** | generated API/access/idempotency checks, review/retest/verified-improvement and accessibility/network runs | **not ready** |
| `P0-06 Quality & economics` | release controls + risk model + benchmark design + migration/recovery/incident/cost semantics defined | **blocked pending contract approval + verification/authorization** | real benchmark, armed cost thresholds, cost/outcome measurement, restore drill, incident tabletop, retention evidence, legal pilot eligibility, rollback evidence | **not ready** |

No row is marked implementation-eligible merely because the prose is now coherent. Canonical contracts are still in `review`, repository verification has not been observed against this exact head in this session, and implementation authorization remains a separate exact-SHA gate.

## Implementation eligibility gate

A family becomes implementation-eligible only when:

1. canonical Blueprint/API/runtime/Artifact semantics agree;
2. every applicable problem category has explicit coverage;
3. no unresolved risk for the family has `implementation_blocking: true`;
4. required owner contracts have the lifecycle state required by the eligibility policy;
5. generated API/schema/ownership checks pass when applicable;
6. every stored C1-C4 entity has retention mapping;
7. schema changes use `artifacts/engineering/data-migration-contract.yaml`;
8. no unresolved critical/high finding exists outside governed risk/finding tracking.

Runtime benchmark, calibration, cost/outcome, restore, accessibility and legal evidence that can only exist after implementation are not circular pre-code prerequisites.

## Release gates

Closed-pilot release additionally requires the applicable `release_evidence_required` risks to have real candidate-bound evidence, including:

- negative role/entitlement/function/object authorization tests;
- idempotency/replay and network-recovery tests;
- retention/export/delete evidence and telemetry privacy checks;
- authorized rights/provenance for released content and benchmark assets;
- benchmark-approved scorer route with required slice results;
- result-validity/evidence-admission tests;
- accessibility critical-path acceptance;
- timezone/day-boundary tests where applicable;
- restore/export-import drill and incident tabletop;
- migration rehearsal for material schema changes;
- armed cost/quality thresholds and rollback/disable path;
- approved closed-pilot jurisdiction/age/processing/provider decisions before real learner data.

A `covered` risk means the design/control boundary exists. It does **not** mean these release runs have passed.

## P0-04 Writing invariant

```text
submission:
  submitted -> processing -> completed|delayed|unavailable

operation_state:
  accepted|processing|succeeded|delayed|unavailable|failed|cancelled

result_validity:
  accepted|limited_evidence|insufficient_evidence|invalid|integrity_review
```

Block implementation that reintroduces `low_confidence` as workflow state, raw confidence as learner probability, migration-only OpenAPI authority, unconditional strong-model second pass, model-owned readiness/mastery or detector-as-cheating-proof.

## P0-05 verified-improvement invariant

```text
confirmed evidence-backed error
  -> smallest useful intervention
  -> FSRS only when retrievable
  -> sufficiently novel retest
  -> evidence admission
  -> improved or remains active
```

Operation existence is not improvement evidence.

## Cost invariant

P0-06 observes cost per accepted evaluation, primary/escalation cost, retry waste, optional feedback cost, material content-operation cost and cost per verified improvement. A cheaper route fails when the required quality floor fails.

## Update rule

- Semantic changes can return a family to implementation review even when prior runtime evidence exists.
- Runtime/legal/rights evidence changes release readiness without automatically changing product semantics.
- `not run` is truthful; intended tests do not count as evidence.
- Public-scale controls are separate from bounded closed-pilot release when the canonical eligibility policy permits that distinction.
- This matrix reports status only; canonical owners remain in `DOCS.yaml`.
