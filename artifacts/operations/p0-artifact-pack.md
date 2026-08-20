# P0 Artifact Pack — Closed Pilot

## Purpose

This is the contract portfolio for the closed pilot. It answers: **which inputs must exist so an agent can code without inventing product behavior, privacy, quality, cost, evidence or unresolved-risk policy?**

It does not replace the Capability Catalog, Problem/Risk Registry, Implementation Eligibility contract, or Build Readiness Matrix.

## Usage rules

1. Capability IDs in `blueprint/03-features.md` remain canonical identities.
2. One Artifact may cover multiple packs when semantics are shared; avoid one-file-per-row bureaucracy.
3. Before implementation planning, filter `artifacts/operations/problem-risk-registry.yaml` to the target family.
4. A P0 critical/high risk marked `open` or `partial` with `implementation_blocking=true` blocks implementation eligibility; do not hide it with local code or prose.
5. A wireframe or model prompt alone never makes a pack ready.
6. Build/buy/provider artifacts appear only when the owning sourcing/runtime contract needs them.
7. Do not invent benchmark/legal/user-research/acceptance evidence.
8. Every inference-using pack must first prove why deterministic/library/SQL/precomputed mechanisms are insufficient for that specific judgment.
9. Model output is a candidate judgment; domain validation/evidence admission remains authoritative.
10. Cost is evaluated against required quality and verified learner outcome, not tokens/request count alone.

## Required artifact/input classes

| Class | Purpose | When required |
|---|---|---|
| Problem/risk coverage | classify applicable failure classes, owner, control, acceptance boundary and blockers | every P0 family before implementation eligibility |
| Interaction / experience | entry, intent, states, recovery, trust copy | learner-facing pack |
| Vertical slice | complete outcome loop + cross-domain handoffs | pack with new learner workflow |
| API / data / event / failure | typed runtime semantics, idempotency, privacy, recovery | runtime reads/writes |
| Evidence/result policy | separates observation, result validity, evidence admission, readiness | diagnosis/evaluation/retest |
| Evaluation contract | staged judgment, evidence validation, scorer routing, uncertainty | learner-visible subjective scoring |
| Deterministic/inference decision | proves rule/library/precompute vs model boundary | inference-using capability |
| Operations gate | quota, cost, observability, rollout/rollback | every P0 pack |
| Runtime foundation | authz, durable operation, provider adapter, privacy | durable/external work |
| Capability manifest | typed family inputs/outputs/states/events/cost/privacy/blockers | every P0 pack |
| Rights/content evidence | provenance/license/published version | learner-visible task/content dependency |
| Benchmark | authorized corpus + protocol + run + candidate binding | learner-visible scorer route |
| Acceptance evidence | executable functional/privacy/idempotency/outcome tests | every pack before release readiness; some controls also block implementation when code need not exist to resolve them |

Do not create a second LLM architecture layer when canonical evaluation/runtime contracts already own inference semantics. Do not create one risk document per problem: the registry owns classification; the referenced contract owns the control.

## Definition of done by P0 pack

| Pack | Outcome proof | Minimum contract set before code | Additional gate before pilot |
|---|---|---|---|
| P0-01 Identity | learner authenticates/consents; ownership/export/delete are safe | risk coverage + experience + auth/access/privacy/retention + provider/legal decision | destructive/privacy/access acceptance + provider activation evidence |
| P0-02 Diagnosis | learner gets a useful baseline without false precision | risk coverage + TargetProfile placement/coverage/termination + evidence/result validity + deterministic scoring rules | calibration/construct-coverage + placement acceptance evidence |
| P0-03 Daily action | learner gets one reasoned useful action with fallback | risk coverage + TargetProfile/evidence snapshot + deterministic candidate/ranking policy + session/API/failure semantics | no-plan/stale/overload/retry/outcome acceptance |
| P0-04 Writing evaluation | task-scoped evidence-backed feedback + priority fix | risk coverage + Writing vertical slice + staged runtime + canonical API/schema + evaluation/event/failure + scorer route + deterministic precheck/inference boundary | benchmark/fairness + rights + evidence/idempotency/privacy/escalation acceptance |
| P0-05 Error-to-review | confirmed error receives smallest useful intervention and independent retest | risk coverage + error/remediation/retest policy + FSRS suitability + exposure/novelty + canonical mutations | scheduling + no-card-for-complex-skill + novel-retest + verified-improvement acceptance |
| P0-06 Quality & economics | quality/privacy/outcome floor survives cost pressure | risk coverage + benchmark + cost budget + routing + release gate + observability + rights + metadata economics | real benchmark + armed cost + incident/restore/rollback + cost-per-verified-improvement evidence |

## P0 Writing non-negotiables

```text
deterministic eligibility
  -> primary approved scorer
  -> evidence/schema validation
  -> governed hard-case escalation only
  -> result_validity admission
  -> one actionable finding
  -> smallest useful fix
  -> optional retrievable review
  -> independent/novel retest
```

The pack is blocked if active implementation semantics still:

- treat `low_confidence` as submission/workflow state;
- expose raw model confidence as learner correctness probability;
- use migration-only OpenAPI as build authority;
- perform unconditional second-pass scoring;
- let model output directly set mastery/readiness;
- use AI-generated-text detection as cheating proof;
- create FSRS cards for complex Writing criteria solely because a score was low.

## Documentation-cost rule

Before spawning a new Artifact:

1. Does a canonical owner already own the semantic field?
2. Is this a new semantic owner or an executable/evidence boundary rather than another explanation?
3. Can an existing canonical owner be updated instead?
4. Does the file reduce agent inference more than it increases context and maintenance cost?

If not, do not create it.

## References

- Authority registry: `DOCS.yaml`.
- Risk coverage: `artifacts/operations/problem-risk-registry.yaml`.
- Implementation eligibility: `artifacts/operations/implementation-eligibility.yaml`.
- Capability scope: `blueprint/03-features.md`.
- Runtime: `artifacts/engineering/runtime-contract.yaml`.
- Canonical web API: `artifacts/engineering/api/`.
- Current readiness: `artifacts/operations/build-readiness-matrix.md`.
- Artifact lifecycle: `artifacts/CONVENTION.md`.
