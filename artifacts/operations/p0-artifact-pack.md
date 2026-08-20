# P0 Artifact Pack — Closed Pilot

## Purpose

This is the contract portfolio for the closed pilot. It answers: **which Artifacts does a P0 capability pack need so an agent can code without inferring product behavior, privacy, quality, cost or evidence rules?**

It does not replace the Capability Catalog or Build Readiness Matrix. It defines the minimum contract/evidence set required before implementation or pilot promotion.

## Usage rules

1. Capability IDs in `blueprint/03-features.md` remain canonical identities.
2. One Artifact may cover multiple packs when semantics are shared; avoid one-file-per-row bureaucracy.
3. A wireframe or model prompt alone never makes a pack ready.
4. Build/buy/provider artifacts appear only when the owning sourcing/runtime contract needs them.
5. Do not invent benchmark/legal/user-research/acceptance evidence.
6. Every inference-using pack must first prove why deterministic/library/SQL/precomputed mechanisms are insufficient for that specific judgment.
7. Model output is a candidate judgment; domain validation/evidence admission remains authoritative.
8. Cost is evaluated against required quality and verified learner outcome, not tokens/request count alone.

## Required artifact classes

| Class | Purpose | When required |
|---|---|---|
| Interaction / experience | entry, intent, states, recovery, trust copy | learner-facing pack |
| Vertical slice | complete outcome loop + cross-domain handoffs | pack with new learner workflow |
| API / data / event / failure | typed runtime semantics, idempotency, privacy, recovery | runtime reads/writes |
| Evidence/result policy | separates observation, result validity, evidence admission, readiness | diagnosis/evaluation/retest |
| Evaluation contract | staged judgment, evidence validation, scorer routing, uncertainty | learner-visible subjective scoring |
| Deterministic/inference decision | proves rule/library/precompute vs model boundary | every inference-using capability |
| Operations gate | quota, cost, observability, rollout/rollback | every P0 pack |
| Runtime foundation | authz, durable operation, provider adapter, outbox, privacy | code with durable/external work |
| Capability manifest | typed family inputs/outputs/states/events/cost/privacy/blockers | every P0 pack |
| Rights/content evidence | provenance/license/published version | every learner-visible task/content dependency |
| Benchmark | authorized corpus + protocol + run + candidate binding | learner-visible scorer route |
| Acceptance evidence | executable functional/privacy/idempotency/outcome tests | every pack before ready |

Do not require a separate LLM-specific architecture layer when the canonical evaluation/runtime contracts already define the inference boundary. Provider/prompt artifacts remain scoped implementation evidence, not product authority.

## Definition of done by P0 pack

| Pack | Outcome proof | Minimum contract set before code | Additional gate before pilot |
|---|---|---|---|
| P0-01 Identity | learner authenticates/consents; ownership/export/delete are safe | experience + auth/access/privacy/retention + provider decision | destructive/privacy acceptance + provider/legal activation evidence |
| P0-02 Diagnosis | learner gets a useful baseline without false precision | placement/target profile + coverage/termination + evidence/result validity + deterministic scoring rules | calibrated/provisional policy + placement acceptance evidence |
| P0-03 Daily action | learner gets one reasoned useful action with fallback | TargetProfile + learner evidence snapshot + deterministic multi-objective action policy + events/failures | no-plan/stale/overload/retry acceptance + outcome measurement |
| P0-04 Writing evaluation | task-scoped evidence-backed feedback + priority fix | Writing vertical slice + staged runtime + canonical API/schema + data/evaluation/event/failure + scorer route/benchmark + deterministic precheck/inference decision + quota/cost | benchmark route approval + evidence-validation/idempotency/privacy/escalation tests |
| P0-05 Error-to-review | confirmed error receives smallest useful intervention and independent retest | error/remediation/retest data policy + FSRS suitability boundary + exposure/novelty policy + shared runtime | scheduling + no-card-for-complex-skill + novel-retest + verified-improvement acceptance |
| P0-06 Quality & economics | quality/privacy/outcome floor survives cost pressure | benchmark + cost budget + model routing + release gate + observability + content rights + metadata economics | real benchmark + cost projection + rollback + cost-per-verified-improvement evidence |

## P0 Writing-specific non-negotiables

The Writing pack must prove this execution shape:

```text
deterministic eligibility
  -> primary approved scorer
  -> evidence/schema validation
  -> hard-case escalation only when governed
  -> result_validity admission
  -> one actionable finding
  -> smallest useful fix
  -> optional retrievable review
  -> independent/novel retest
```

The pack is not ready if any implementation contract still:

- treats `low_confidence` as a submission/workflow state;
- exposes raw model confidence as learner correctness probability;
- references a migration-only OpenAPI as build authority;
- performs unconditional second-pass scoring;
- lets model output directly set mastery/readiness;
- uses AI-generated-text detection as sole anti-gaming proof;
- creates FSRS cards for complex Writing criteria solely because a score was low.

## Shared artifact rule

Writing evaluation and error-to-review form one outcome loop and should share contracts when that reduces duplication. Expansion to another skill creates only the delta needed for its new semantics; do not copy the entire Writing contract pack.

## Documentation-cost rule

Before spawning a new Artifact, ask:

1. Does a canonical owner already cover the semantic field?
2. Is the new file needed for an executable implementation/review boundary?
3. Will it reduce ambiguity more than it increases context/maintenance cost?

If not, update the existing canonical owner instead.

## References

- Capability scope: `blueprint/03-features.md`.
- Roadmap: `blueprint/08-roadmap.md`.
- Runtime: `artifacts/engineering/runtime-contract.yaml`.
- Canonical web API: `artifacts/engineering/api/`.
- Writing runtime/evaluation: `artifacts/engineering/contracts/writing-task-2/` scoped contracts.
- Current readiness: `artifacts/operations/build-readiness-matrix.md`.
- Artifact lifecycle: `artifacts/CONVENTION.md`.